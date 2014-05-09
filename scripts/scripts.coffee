popup_div = undefined
popup_input_div = undefined
browser_div = undefined
browser_input_div = undefined

save_url = ->
  # Passing message to the background script
  tag_value = document.getElementById('octo-meme-tags').value
  des_value = document.getElementById('octo-meme-description').value
  msg =
    type: 'upload'
    data:
      tag: tag_value
      description: des_value

  chrome.runtime.sendMessage msg, (response) ->
    console.log("Sent save request.")

hide_popup_browser = ->
  if popup_div
    popup_div.classList.add('octo-meme-save-hidden')
    popup_div.classList.remove('octo-meme-save-shown')
  else if browser_div
    browser_div.classList.add('octo-meme-browser-hidden')
    browser_div.classList.remove('octo-meme-browser-shown')

create_save_popup = ->
  ###
  # <div id="octo-meme-save">
  #   <div id="octo-meme-wrapper">
  #     <img src="" />
  #     <p> TAGS </p>
  #     <input id="octo-meme-tags" type="text" />
  #     <img src="" />
  #     <p> Description </p>
  #     <input id="octo-meme-description" type="text" />
  #   </div>
  # </div>
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

  # paragraph tag for TAGS
  tags_p_div = document.createElement 'p'
  tags_p_div.innerHTML = 'TAGS'
  # paragraph tag for DESCRIPTION
  desc_p_div = document.createElement 'p'
  desc_p_div.innerHTML = 'DESCRIPTION'

  wrapper_div.appendChild tags_p_div
  wrapper_div.appendChild input_div
  wrapper_div.appendChild desc_p_div
  wrapper_div.appendChild description_div

  save_div.appendChild wrapper_div
  bg_div.appendChild save_div
  input_div.addEventListener 'keyup', (evt) ->
    switch evt.keyCode
      when 13
        save_url()
  # TODO: remove
  popup_input_div = input_div
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
      console.log "Redirect request sent."
  )




###
#  generates a search item template
#  <li class="octo-meme-browser-search-item">
#    <p class="octo-meme-browser-search-item-domain"> DOMAIN </p>
#    <p class="octo-meme-browser-search-item-desc"> description </p>
#  </li>
#  Takes in data
###
create_browser_search_item = (data) ->
  list_div = document.createElement 'li'
  list_div.classList.add('octo-meme-browser-search-item')

  domain_div = document.createElement 'p'
  domain_div.innerHTML = data.url
  desc_div = document.createElement 'p'
  desc_div.innerHTML = data.description
  list_div.dataset.url = data.url
  list_div.appendChild domain_div
  list_div.appendChild desc_div
  return list_div

###
#
# <div id="octo-meme-browser">
#   <p> SEARCH </p>
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
  search_text_div = document.createElement 'p'
  search_text_div.innerHTML = 'SEARCH'
  input_div = document.createElement 'input'
  input_div.id = 'octo-meme-browser-search'
  input_div.setAttribute 'type', 'text'
  browser_div.appendChild search_text_div
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
      for item in msg.results
        list_item = create_browser_search_item item
        search_list.appendChild list_item
      # highlight the first item
      search_list.firstChild?.classList.add('octo-meme-search-highlight')


  input_div.addEventListener 'blur', (evt) ->
    search_port.disconnect()

  input_div.addEventListener 'keyup', (evt) ->
    switch evt.keyCode
      when 13
        search_list_children = search_list.childNodes
        if search_list_children.length
          # find highlighted link and navigate to it
          for child in search_list_children
            if child.classList.contains('octo-meme-search-highlight')
              navigate_to(child.dataset.url)
      when 9  # do nothing, because keydown should have proc'ed
      else
        # debounce search event
        if search_port then search_port.postMessage query: input_div.value

  # specifically for tabs to prevent the event from propagating
  input_div.addEventListener 'keydown', (evt) ->
    switch evt.keyCode
      when 9
        # select through the children
        evt.preventDefault()
        search_list_children = search_list.childNodes
        next_highlight = 0
        for child, index in search_list_children
          # check if highlight, if so, remove it
          if child.classList.contains('octo-meme-search-highlight')
            child.classList.remove('octo-meme-search-highlight')
            next_highlight =
              if index + 1 >= search_list_children.length then 0 else index + 1
        search_list_children[next_highlight].classList.add('octo-meme-search-highlight')

  # TODO: remove
  browser_input_div = input_div
  return bg_div




document.addEventListener 'keyup', (evt) ->
  if evt.keyCode == 83 and evt.ctrlKey == true
    # Ctrl+ s
    if popup_div
      # show the popup div
      popup_div.classList.remove('octo-meme-save-hidden')
      popup_div.classList.add('octo-meme-save-shown')
    else
      # show popup
      popup_div = create_save_popup()
      document.body.appendChild popup_div
      popup_div.classList.add('octo-meme-save-shown')
    # give focus to input div
    popup_input_div.focus()
  else if evt.keyCode == 79 and evt.ctrlKey == true
    # Ctrl+ o
    if browser_div
      # show browser div
      browser_div.classList.remove('octo-meme-browser-hidden')
      browser_div.classList.add('octo-meme-browser-shown')
    else
      # create browser div and show it
      browser_div = create_browser_popup()

      document.body.appendChild browser_div
      browser_div.classList.add('octo-meme-browser-shown')
    # give focus to input div
    browser_input_div.focus()
  else if evt.keyCode == 27
    hide_popup_browser()



chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
  unless sender.tab
    switch request.type
      when 'upload'
        console.log 'Finished uploading'
        if request.data == 'success'
          hide_popup_browser()
      when 'redirect'
        console.log 'Finished redirecting'
        if request.data
          hide_popup_browser()


