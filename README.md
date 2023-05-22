# Cornerback

Cornerback is a HTTP/S request interceptor that allow developers to apply modification over an `URLRequest` based on rules.

Those rules could be the following:

* scheme
* domain
* resource
* query
* header

## Usage

Here is a simple example showing how to add custom headers when a developer perform a request to specified URL.

In this case we have two different rules:

1. Applies when domain name is `localhost` and the requested resource is `/cornerback`
2. The last one applies when the domain name is `localhost`


```swift
let cornerback = Cornerback.shared

let cornerbackConstraints: [Constraint] = [
    Domain(named: "localhost"),
    Resource(path: "/cornerback")
]

let localConstraints: [Constraint] = [
    Domain(named: "localhost")
]

cornerback.newRuleWith(constraints: cornerbackConstraints) { urlRequest in
    print("🏈 \(urlRequest)")
    urlRequest.setValue("Cornerback v1.0.0", forHTTPHeaderField: "X-Globant")
}

cornerback.newRuleWith(constraints: localConstraints) { urlRequest in
    print("🏠 \(urlRequest)")
    urlRequest.setValue("Gluon", forHTTPHeaderField: "X-Secret-Project")
}

if let localURL = URL(string: "http://localhost:3000/cornerback") {
    let (data, response) = try await URLSession.shared.data(from: localURL)
    print(response)
}
```

The `newRuleWith(constraints:, performaAction:)` function returns an `Actionable` object type that allow developer work with the new created rule. 

* Check rule availability
* Disable or enable this rule
* Add a new constraint
* Remove an existing constraint

Below is an example where we create a rule with two contraints and after that we remove one of the constraints.

```swift
let cornerback = Cornerback.shared

let cornerbackConstraints: [Constraint] = [
    Domain(named: "localhost"),
    Resource(path: "/cornerback")
]

let cornerbackRule = cornerback.newRuleWith(constraints: cornerbackConstraints) { urlRequest in
    print("🏈 \(urlRequest)")
    urlRequest.setValue("Cornerback v1.0.0", forHTTPHeaderField: "X-Globant")
}

cornerbackRule.removeConstraint(Domain(named: "localhost"))
```

Enabling and disabling operations will be helpful in conjuntion with the Feature Flag system.

## Creating custom constraints

Cornerback allow developers create new constraints. This can be done implementing the `Constraint` protocol, and the `Equatable` protocol too, that is mandatory by `Constraint` definition.

We also recommend provide an implementation for the `CustomStringConvertible` protocol to bring a human readable (and developer friendly) `Cornerback` object current state.

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


