turbo-octo-meme
===============

A chrome extension that allows user to save url


Build Instructions
===============
Navigate to `chrome://extensions` in your browser. Click "Load Unpacked Extensions" after enabling developer mode, and choose this folder.

Usage Intstructions
===============
Our extension is easy and intuitive. Below are steps outlining how to use the extensions

  1. Load the chrome extension into the chrome web browser (See. Build Instructions)
  2. To save to ur: press ctrl-s and the blue popup window will popup. Users can specify tags and description associated with the saved url.
  3. To open saved url: press ctrl-o and the blue search window will popup. Users can then type search terms whcih can be either the word in the url, tags, or description. Results will then populated in the box and users can navigate to them using tab key. By press enter when particular url is highlighted, the url will be opened in new tab. IF the ur l is laready open, the plugin will simply navigate users to the opened tab.

##Proposal:
Team members: Kanchalai Tanglertsampan, David Xu

#### 1. What kind of project do you propose?

  We want to build a chrome extension that allows you to quickly save links for you to come back to, similar to a bookmarks bar, but with a more tightly integrated management and navigation into the browser navigation itself. Features will include search and tags for faster navigation. There are some services currently that do this (delicious), but most of them do not allow a very quick way of adding and viewing links. We will start off with just building the chrome extension, and extend it to saving on the server if there is enough time.

#### 2. What do you hope to learn from the project?

  How to write Javascript, build chrome extensions.

#### 3. What are some concrete goals, i.e. how will we judge the success of your project?

  We want to be able to have a functional chrome extension by the end of the semester. We should be able to save and view our links. Bonus features would include managing links in different folders, saving your data on a server.

### The Plan

We will be building a chrome extension, so we will be utilizing all of the [developer API's](https://developer.chrome.com/extensions/index) google provides. We will be using LESS.js, coffeescript during development. If necessary. Depending on how complicated the UI will be, we will consider using require.js/bower/grunt, and backbone.js or ember.js as a front-end MVC framework.
