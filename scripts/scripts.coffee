popup_div = undefined
document.addEventListener 'keyup', (evt) ->
  if evt.keyCode == 83 and evt.ctrlKey == true
    ###
    # '<div id="octo-meme-save">
    #   <input id="octo-meme-tags" type="text" />
    # </div>'
    ###
    console.log 'Generate the popup.'

    if popup_div
      # show the popup div
    else
      # show popup
      popup_div = document.createElement 'div'
      popup_div.id = 'octo-meme-bg'
      save_div = document.createElement 'div'
      save_div.id = 'octo-meme-save'
      input_div = document.createElement 'input'
      input_div.id = 'octo-meme-tags'
      input_div.setAttribute 'type', 'text'
      save_div.appendChild input_div
      popup_div.appendChild save_div
      document.body.appendChild popup_div
      input_div.addEventListener 'keyup', (evt) ->
        console.log evt.keyCode


