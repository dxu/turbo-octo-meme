popup_div = undefined
browser_div = undefined

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
  input_div = document.createElement 'input'
  input_div.id = 'octo-meme-tags'
  input_div.setAttribute 'type', 'text'
  save_div.appendChild input_div
  bg_div.appendChild save_div
  input_div.addEventListener 'keyup', (evt) ->
    console.log evt
    switch evt.keyCode
      when 13
        chrome.runtime.sendMessage({greeting: "Hello"}, (response) ->
          console.log("response.farewell"))

        console.log 'Submit for saving.'
      when 27
        # hide
        console.log 'Hide the popup'
        bg_div.classList.add('octo-meme-save-hidden')
        bg_div.classList.remove('octo-meme-save-shown')
  return bg_div

create_browser_popup = ->
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

  input_div.addEventListener 'keyup', (evt) ->
    console.log evt
    switch evt.keyCode
      when 13
        console.log 'Open new link.'
      when 27
        # hide
        console.log 'Hide the browser'
        bg_div.classList.add('octo-meme-browser-hidden')
        bg_div.classList.remove('octo-meme-browser-shown')
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
  console.log 'message received'
  switch request.type
    when 'download'
      console.log 'do something'
    when 'search'
      console.log 'search results', sender



