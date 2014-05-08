message = (msg) ->

chrome.runtime.onMessage.addListener (request, sender, send_response) ->

  if sender.tab
    console.log 'Sender', sender
    console.log 'message received on extension end', sender, request
    console.log("From a content script tab url: " + sender.tab.url)

    chrome.storage.sync.get 'url', (result) ->
      # Get result
      console.log("Get back from storage :" + result.url)

    switch request.type
      when 'upload'
        chrome.storage.sync.set {'url': sender.tab.url}, () ->
          # Save result
          message("URL SAVED")
        send_response({farewell: "goodbye"})
        console.log 'do something'
      when 'search'
        console.log 'call search'


  ###
  # test messages
  ###
  chrome.tabs.sendMessage sender.tab.id,
    type: 'test'
    data:
      one: 'two'
    , (response) ->
      console.log "Finished Search Results"



###
# takes in a query string
###
search = (query, tab_id) ->
  chrome.storage.sync.get null, (result) ->
    console.log 'Searching'
    tokens = query.split(/[^0-9A-Za-z]/)
    # pluck the keywords and tags attributes, and match the tokens
    search_results = _.foldl result,
      (memo, item) ->
        # check if any of the keywords match, if any of the tags match
        matches = _.intersection(result.keywords, result.tags, tokens).length
        if matches then memo.push result
        return memo
      , []
    # search_results now holds the objects that match the search.
    # Pass a message to the front end
    chrome.tabs.sendMessage tab_id, search_results: search_results,
      (response) ->
        console.log "Finished Search Results"

