message = (msg) ->

chrome.runtime.onMessage.addListener (request, sender, send_response) ->
  if (sender.tab)
    console.log("From a content script tab url: " + sender.tab.url)

    chrome.storage.sync.set {'url': sender.tab.url}, () ->
      # Save result
      message("URL SAVED")

    chrome.storage.sync.get 'url', (result) ->
      # Get result
      console.log("Get back from storage :" + result.url)
  else
    console.log("From the extension")
  if (request.greeting == "hello")
    sendResponse({farewell: "goodbye"})

