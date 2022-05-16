---
weight: 20
title: node.js Web App
---

# node.js Web App

## Overview

The node.js Web App project type allows you to make a simple web application with a node.js backend
and HTML5 frontend. The node.js process should launch a web server; Pip starts a browser in parallel
which communicates with the web server and displays the generated HTML on Pip's screen.

## Getting Started

node.js projects allow complete customisation of backend behaviour; the only requirement is that
your code starts an HTTP server on port 3000 so that the browser process can reach it.

To get started, save the following code in `index.js`:

```javascript
const http = require('http')

const html = `
<!doctype html>

<html>
  <head>
    <title></title>
  </head>
  <body>
    <h1>Hello world!</h1>
  </body>
</html>
`

const requestListener = function (req, res) {
  res.writeHead(200)
  res.end(html)
}

const server = http.createServer(requestListener)
server.listen(3000)
```

## Project Layout

  `index.js` - application entry point

Other files (e.g. JavaScript code, static assets) may be added anywhere to the project's
folder structure and accessed as normal from node.js. If you wish to host static
assets such as CSS and images, this must be configured manually in code.

## Integrating with Pip's hardware from HTML5

It's possible to control Pip's LEDs and GPIOs from the browser by including `pipkit.js`. See [In-browser JavaScript](/docs/reference/browser-javascript) for more information.

