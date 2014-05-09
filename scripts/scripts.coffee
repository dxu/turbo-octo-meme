popup_div = undefined
browser_div = undefined

save_url = ->
  # Passing message to the background script
  tag_value = document.getElementById('octo-meme-tags').value
  des_value = document.getElementById('octo-meme-description').value
  msg =
    type: 'upload'
    data:
      tag: tag_value
      description: des_value

  chrome.runtime.sendMessage(msg, (response) ->
    console.log("response.farewell"))

create_save_popup = ->
  ###
  # '<div id="octo-meme-save">
  #   <input id="octo-meme-tags" type="text" />
  # </div>'
  ###
  bg_div = document.createElement 'div'
  bg_div.id = 'octo-meme-save-bg'
  save_div = document.createElement 'div'
  save_div.id = 'octo-meme-save'

  # Input wrapper for tag and description
  wrapper_div = document.createElement 'div'
  wrapper_div.id = 'octo-meme-wrapper'

  # input of tag
  input_div = document.createElement 'input'
  input_div.id = 'octo-meme-tags'
  input_div.setAttribute 'type', 'text'

  # input of description
  description_div = document.createElement 'input'
  description_div.id = 'octo-meme-description'
  description_div.setAttribute 'type', 'text'

  wrapper_div.appendChild input_div
  wrapper_div.appendChild description_div

  save_div.appendChild wrapper_div
  bg_div.appendChild save_div
  input_div.addEventListener 'keyup', (evt) ->

    console.log evt
    switch evt.keyCode
      when 13
        console.log 'Submit for saving.'
        save_url()
      when 27
        # hide
        console.log 'Hide the popup'
        bg_div.classList.add('octo-meme-save-hidden')
        bg_div.classList.remove('octo-meme-save-shown')
  return bg_div


###
# Checks for any existing tab with the same url and switches to it, or opens a new tab
###
navigate_to = (url) ->
  # pass message to runtime
  chrome.runtime.sendMessage(
    type: 'redirect'
    data: url
    , (response) ->
      console.log "Should be redirected"
  )




###
#  generates a search item template
#  <li class="octo-meme-browser-search-item"></li>
#  Takes in data
###
create_browser_search_item = (data) ->
  list_div = document.createElement 'li'
  list_div.classList.add('octo-meme-browser-search-item')
  list_div.innerHTML =
    "#{data.url} #{data.tags.join(' ')} #{data.description}"
  list_div.dataset.url = data.url
  return list_div

###
#
# <div id="octo-meme-browser">
#   <input id="octo-meme-browser-search" type="text" />
#   <ul id="octo-meme-browser-search-list" >
#     <!--  programatically generated
#       <li class="octo-meme-browser-search-item"></li>
#     -->
#   </ul>
# </div>
#
###
create_browser_popup = ->
  bg_div = document.createElement 'div'
  bg_div.id = 'octo-meme-browser-bg'
  browser_div = document.createElement 'div'
  browser_div.id = 'octo-meme-browser'
  input_div = document.createElement 'input'
  input_div.id = 'octo-meme-browser-search'
  input_div.setAttribute 'type', 'text'
  browser_div.appendChild input_div
  search_list = document.createElement 'ul'
  search_list.id = 'octo-meme-browser-search-list'
  browser_div.appendChild search_list
  bg_div.appendChild browser_div
  search_port = undefined

  input_div.addEventListener 'focus', (evt) ->
    search_port = chrome.runtime.connect name: 'search'
    search_port.onMessage.addListener (msg) ->
      # gets search results under `msg.results`
      # clear all children
      while search_list.firstChild
        search_list.removeChild search_list.firstChild
      console.log 'browser got message', msg
      for item in msg.results
        list_item = create_browser_search_item item
        search_list.appendChild list_item
      # highlight the first item
      search_list.firstChild.classList.add('octo-meme-search-highlight')


  input_div.addEventListener 'blur', (evt) ->
    search_port.disconnect()

  input_div.addEventListener 'keyup', (evt) ->
    console.log evt
    switch evt.keyCode
      when 13
        console.log 'Open new link.'
        search_list_children = search_list.childNodes
        if search_list_children.length
          # find highlighted link and navigate to it
          for child in search_list_children
            if child.classList.contains('octo-meme-search-highlight')
              console.log('this is the node')
              navigate_to(child.dataset.url)







      when 27
        # hide
        console.log 'Hide the browser'
        bg_div.classList.add('octo-meme-browser-hidden')
        bg_div.classList.remove('octo-meme-browser-shown')
      when 9
      else
        # debounce search event
        if search_port then search_port.postMessage query: input_div.value

  # specifically for tabs to prevent the event from propagating
  input_div.addEventListener 'keydown', (evt) ->
    switch evt.keyCode
      when 9
        # select through the children
        evt.preventDefault()
        console.log 'hits tab'
        search_list_children = search_list.childNodes
        next_highlight = 0
        for child, index in search_list_children
          # check if highlight, if so, remove it
          if child.classList.contains('octo-meme-search-highlight')
            child.classList.remove('octo-meme-search-highlight')
            next_highlight =
              if index + 1 >= search_list_children.length then 0 else index + 1


        search_list_children[next_highlight].classList.add('octo-meme-search-highlight')
  return bg_div




document.addEventListener 'keyup', (evt) ->
  if evt.keyCode == 83 and evt.ctrlKey == true
    # Ctrl+ s
    console.log 'Generate the popup.'
    if popup_div
      # show the popup div
      popup_div.classList.add('octo-meme-save-shown')
      popup_div.classList.remove('octo-meme-hidden')
    else
      # show popup
      popup_div = create_save_popup()
      document.body.appendChild popup_div
      popup_div.classList.add('octo-meme-save-shown')
  else if evt.keyCode == 79 and evt.ctrlKey == true
    # Ctrl+ o
    console.log 'Open link browser'
    if browser_div
      # show browser div
      browser_div.classList.add('octo-meme-browse-shown')
      browser_div.classList.remove('octo-meme-browse-hidden')
    else
      # create browser div and show it
      browser_div = create_browser_popup()
      document.body.appendChild browser_div
      browser_div.classList.add('octo-meme-browser-shown')
  else if evt.keyCode == 27
    if popup_div
      popup_div.classList.add('octo-meme-save-hidden')
      popup_div.classList.remove('octo-meme-save-shown')
    else if browser_div
      browser_div.classList.add('octo-meme-browser-hidden')
      browser_div.classList.remove('octo-meme-browser-shown')



chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
  unless sender.tab
    console.log 'message received in tab'
    switch request.type
      when 'upload'
        console.log 'do something'
      # when 'search'
      #   console.log 'search results', sender



