// Generated by CoffeeScript 1.7.1
(function() {
  var browser_div, create_browser_popup, create_browser_search_item, create_save_popup, popup_div, save_url;

  popup_div = void 0;

  browser_div = void 0;

  save_url = function() {
    var des_value, msg, tag_value;
    tag_value = document.getElementById('octo-meme-tags').value;
    des_value = document.getElementById('octo-meme-description').value;
    msg = {
      type: 'download',
      data: {
        tag: tag_value,
        description: des_value
      }
    };
    return chrome.runtime.sendMessage(msg, function(response) {
      return console.log("response.farewell");
    });
  };

  create_save_popup = function() {

    /*
     * '<div id="octo-meme-save">
     *   <input id="octo-meme-tags" type="text" />
     * </div>'
     */
    var bg_div, description_div, input_div, save_div, wrapper_div;
    bg_div = document.createElement('div');
    bg_div.id = 'octo-meme-save-bg';
    save_div = document.createElement('div');
    save_div.id = 'octo-meme-save';
    wrapper_div = document.createElement('div');
    wrapper_div.id = 'octo-meme-wrapper';
    input_div = document.createElement('input');
    input_div.id = 'octo-meme-tags';
    input_div.setAttribute('type', 'text');
    description_div = document.createElement('input');
    description_div.id = 'octo-meme-description';
    description_div.setAttribute('type', 'text');
    wrapper_div.appendChild(input_div);
    wrapper_div.appendChild(description_div);
    save_div.appendChild(wrapper_div);
    bg_div.appendChild(save_div);
    input_div.addEventListener('keyup', function(evt) {
      console.log(evt);
      switch (evt.keyCode) {
        case 13:
          console.log('Submit for saving.');
          return save_url();
        case 27:
          console.log('Hide the popup');
          bg_div.classList.add('octo-meme-save-hidden');
          return bg_div.classList.remove('octo-meme-save-shown');
      }
    });
    return bg_div;
  };


  /*
   *  generates a search item template
   *  <li class="octo-meme-browser-search-item"></li>
   *  Takes in data
   */

  create_browser_search_item = function(data) {
    var list_div;
    list_div = document.createElement('li');
    list_div.classList.add('octo-meme-browser-search-item');
    list_div.innerHTML = data.url + ' this is a test' + Math.random();
    return list_div;
  };


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

  create_browser_popup = function() {
    var bg_div, input_div, search_list, search_port;
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
    search_port = void 0;
    input_div.addEventListener('focus', function(evt) {
      search_port = chrome.runtime.connect({
        name: 'search'
      });
      return search_port.onMessage.addListener(function(msg) {
        var item, list_item, _i, _len, _ref, _results;
        while (search_list.firstChild) {
          search_list.removeChild(search_list.firstChild);
        }
        console.log('browser got message', msg);
        msg.results = [
          {
            url: 'one'
          }, {
            url: 'two'
          }, {
            url: 'three'
          }
        ];
        _ref = msg.results;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          list_item = create_browser_search_item(msg.results);
          _results.push(search_list.appendChild(list_item));
        }
        return _results;
      });
    });
    input_div.addEventListener('blur', function(evt) {
      return search_port.disconnect();
    });
    input_div.addEventListener('keyup', function(evt) {
      console.log(evt);
      switch (evt.keyCode) {
        case 13:
          return console.log('Open new link.');
        case 27:
          console.log('Hide the browser');
          bg_div.classList.add('octo-meme-browser-hidden');
          return bg_div.classList.remove('octo-meme-browser-shown');
        default:
          if (search_port) {
            return search_port.postMessage({
              query: input_div.value
            });
          }
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
        popup_div.classList.add('octo-meme-save-hidden');
        return popup_div.classList.remove('octo-meme-save-shown');
      } else if (browser_div) {
        browser_div.classList.add('octo-meme-browser-hidden');
        return browser_div.classList.remove('octo-meme-browser-shown');
      }
    }
  });

  chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
    if (!sender.tab) {
      console.log('message received in tab');
      switch (request.type) {
        case 'upload':
          return console.log('do something');
      }
    }
  });

}).call(this);
