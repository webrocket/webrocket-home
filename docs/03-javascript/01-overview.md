Overview
---

## JavaScript client overview

WebRocket JavaScript client is baked in to the websockets server and
has some sort of super powers. Each vhost serves its own, configured
version of the client library.

### Basis usage

Assuming that we have a vhost called `moon`, we can use its configured
JavaScript library in our application just like this:

    <script src="http://webrocket.io:8080/moon/webrocket.js"></script>
    
Configured WebRocket connection object will be associated with the `$wr`
global variable.

### Debug mode

To switch our library into debug mode you can either modify `WebRocket.debug`
variable, or load script with `debug` query parameter. Here's the programatic
version:

    <script>
      WebRocket.debug = true
    </script>
    
And here's how to load it in debug mode without extra scripting:

    <script src="http://webrocket.io:8080/moon/webrocket.js?debug=1"></script>
    
Enabled debug mode increases verbocity of the log messages.
