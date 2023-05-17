# Cornerback

Cornerback is a HTTP/S request interceptor that allow developers to apply modification over an `URLRequest` based on rules.

Those rules could be the following:

* scheme
* domain
* resource
* query
* header

## Server

To test the whole solution you will need a mock server installed on your computer. 

For this purpouse, install NodeJS and use the Express framework. Below you will find the command line to install Express in your server folder.


```zsh
npm install express --save
```

The code snippet below shows how to create a server a print all request data.

```javascript
const express = require('express')
const app = express()
const port = 3000

app.get('/', (request, response) => {
      let details = {
        "scheme" : request.protocol,
        "domain" : request.hostname,
        "resource" : request.path,
        "query" : request.query,
        "headers" : request.headers
      }

    let result = JSON.stringify(details, null, 4)

      response.send(`<pre>${result}</pre>`)
})

app.listen(port, (err) => {
      if (err) {
        return console.log('something bad happened', err)
      }

      console.log(`server is listening on ${port}`)
})
```

## What is a Cornerback?

> A cornerback (CB) is a member of the defensive backfield or secondary in american football. Cornerbacks cover receivers most of the time, but also blitz and defend against such offensive running plays as sweeps and reverses. They create turnovers through hard tackles, interceptions, and deflecting forward passes.


