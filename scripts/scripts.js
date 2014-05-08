// Generated by CoffeeScript 1.7.1
(function() {
  var browser_div, create_browser_popup, create_save_popup, popup_div;

  popup_div = void 0;

  browser_div = void 0;

  create_save_popup = function() {

    /*
     * '<div id="octo-meme-save">
     *   <input id="octo-meme-tags" type="text" />
     * </div>'
     */
    var bg_div, input_div, save_div;
    bg_div = document.createElement('div');
    bg_div.id = 'octo-meme-save-bg';
    save_div = document.createElement('div');
    save_div.id = 'octo-meme-save';
    input_div = document.createElement('input');
    input_div.id = 'octo-meme-tags';
    input_div.setAttribute('type', 'text');
    save_div.appendChild(input_div);
    bg_div.appendChild(save_div);
    input_div.addEventListener('keyup', function(evt) {
      console.log(evt);
      switch (evt.keyCode) {
        case 13:
          chrome.runtime.sendMessage({
            greeting: "Hello"
          }, function(response) {
            return console.log("response.farewell");
          });
          return console.log('Submit for saving.');
        case 27:
          console.log('Hide the popup');
          bg_div.classList.add('octo-meme-save-hidden');
          return bg_div.classList.remove('octo-meme-save-shown');
      }
    });
    return bg_div;
  };

  create_browser_popup = function() {

    /*
     *
     * <div id="octo-meme-browser">
     *   <input id="octo-meme-browser-search" type="text" />
     *   <ul id="octo-meme-browser-search-list" >
     *     <!--  programatically generated
     *       <li class="octo-meme-browser-search-item"></li>
     *     -->
     *   </ul>
     * </div>
     *
     */
    var bg_div, input_div, search_list;
    bg_div = document.createElement('div');
    bg_div.id = 'octo-meme-browser-bg';
    browser_div = document.createElement('div');
    browser_div.id = 'octo-meme-browser';
    input_div = document.createElement('input');
    input_div.id = 'octo-meme-browser-search';
    input_div.setAttribute('type', 'text');
    browser_div.appendChild(input_div);
    search_list = document.createElement('ul');
    search_list.id = 'octo-meme-browser-search-list';
    browser_div.appendChild(search_list);
    bg_div.appendChild(browser_div);
    input_div.addEventListener('keyup', function(evt) {
      console.log(evt);
      switch (evt.keyCode) {
        case 13:
          return console.log('Open new link.');
        case 27:
          console.log('Hide the browser');
          bg_div.classList.add('octo-meme-browser-hidden');
          return bg_div.classList.remove('octo-meme-browser-shown');
      }
    });
    return bg_div;
  };

  document.addEventListener('keyup', function(evt) {
    if (evt.keyCode === 83 && evt.ctrlKey === true) {
      console.log('Generate the popup.');
      if (popup_div) {
        popup_div.classList.add('octo-meme-save-shown');
        return popup_div.classList.remove('octo-meme-hidden');
      } else {
        popup_div = create_save_popup();
        document.body.appendChild(popup_div);
        return popup_div.classList.add('octo-meme-save-shown');
      }
    } else if (evt.keyCode === 79 && evt.ctrlKey === true) {
      console.log('Open link browser');
      if (browser_div) {
        browser_div.classList.add('octo-meme-browse-shown');
        return browser_div.classList.remove('octo-meme-browse-hidden');
      } else {
        browser_div = create_browser_popup();
        document.body.appendChild(browser_div);
        return browser_div.classList.add('octo-meme-browser-shown');
      }
    } else if (evt.keyCode === 27) {
      if (popup_div) {
        popup_div.classList.add('octo-meme-browser-hidden');
        return popup_div.classList.remove('octo-meme-browser-shown');
      } else if (browser_div) {
        browser_div.classList.add('octo-meme-browser-hidden');
        return browser_div.classList.remove('octo-meme-browser-shown');
      }
    }
  });

}).call(this);
