---
title: PHP Web App
weight: 30
---

# PHP Web App

## Overview

The PHP Web App project type allows you to make a simple web application with a PHP backend
and HTML5 frontend. PHP scripts are executed in a backend process and generate HTML, which
is displayed in a browser on Pip's screen.

## Getting Started

Serving files is taken care of behind the scenes (see [Hosting Environment](#hosting-environment), below)
so creating a web application is simply a matter of writing PHP scripts and saving them in the project
folder.

To get started, save the following code in `index.php`:

```html
<!doctype html>

<html>
  <head>
    <title>PHP Application</title>
  </head>
  <body>
    <h1>Hello World!</h2>
    Today's date is <?php echo date("d/m/Y"); ?>
  </body>
</html>
```

## Project Layout

  `index.php` - application entry point

Other files (PHP scripts, images, CSS, JavaScript, and more) may be added anywhere to the project's
folder structure. The project root folder is also the document root; for example, a file called `cat.jpg`
placed in the `images` folder is accessible at the URL path `/images/cat.jpg`.

## Integrating with Pip's hardware from HTML5

It's possible to control Pip's LEDs and GPIOs from the browser by including `pipkit.js`. See [In-browser JavaScript](/docs/reference/browser-javascript) for more information.

## Hosting Environment

The PHP application in run as a FastCGI application using `lighttpd`, PHP version 7.4. The `lighttpd` configuration
can be viewed [here](pip-lighttpd.conf).
