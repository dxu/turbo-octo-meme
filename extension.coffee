message = (msg) ->

chrome.runtime.onMessage.addListener (request, sender, send_response) ->
  if sender.tab
    console.log 'Sender', sender
    console.log 'message received on extension end', sender, request
    console.log("From a content script tab url: " + sender.tab.url)


    switch request.type
      when 'upload'
        # Process download message
        console.log 'Get download message'
        # Parsing tags
        tags_list = request.data.tag.split(" ")
        # Parsing keywords from the url
        keywords_list = sender.tab.url.split(/[^0-9A-Za-z]/)
        obj = {}
        obj[sender.tab.url] =
          tags : tags_list
          keywords : keywords_list
          description : request.data.description
          url : sender.tab.url
        # Store the object into the local storage
        chrome.storage.local.set obj, ->
          console.log("Saved the obj")
          success = if chrome.runtime.lastError then 'error' else 'success'
          chrome.tabs.sendMessage sender.tab.id,
            type: 'upload'
            data: success
            , ->
              console.log "Response sent: #{success}"
      when 'redirect'
        navigate_to request.data, (tab) ->
          console.log 'hitttttttt'
          chrome.tabs.sendMessage sender.tab.id,
            type: 'redirect'
            data: tab.id
            , ->
              console.log "Response sent: #{success} tab created"



###
# takes in a query string
###
search = (query, port) ->
  chrome.storage.local.get null, (result) ->
    console.log 'Searching'
    tokens = query.split(/[^0-9A-Za-z]/)
    # pluck the keywords and tags attributes, and match the tokens
    console.log(result)
    search_results = _.foldl _.values(result),
      (memo, item) ->
        # check if any of the keywords match, if any of the tags match
        matches = _.intersection(item.keywords, tokens).length +
          _.intersection(item.tags, tokens).length
        if matches then memo.push item
        return memo
      , []
    # search_results now holds the objects that match the search.
    # Pass a message to the front end
    port.postMessage results: search_results


###
# Use chrome extension "ports" for search
###

chrome.runtime.onConnect.addListener (port) ->
  console.assert(port.name == 'search')
  port.onMessage.addListener (msg) ->
    # msg contains the data
    search msg.query, port
  port.onDisconnect.addListener (m) ->
    console.log 'Search port disconnected.'


###
# Checks for any existing tab with the same url and switches to it, or opens a new tab
###
navigate_to = (url, cb) ->
  # pass message to runtime
  chrome.tabs.getAllInWindow null, (tabs) ->
    for tab in tabs
      if tab.url == url
        # switch active tab to it
        chrome.tabs.update(tab.id, {active: true})
        return
    # otherwise, open a new tab with it
    chrome.tabs.create url:url, cb

