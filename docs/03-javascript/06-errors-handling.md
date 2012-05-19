Errors handling
---

## Errors handling

WebRocket comes with very liberal policy of errors handling. The main idea
of error handling in frontend client is to not handle them at all. Connection
or protocol errors should not happen in healthy application, and should
not appear in production application. Errors handling mechanism provided
by WebRocket **shall be used only during development**.

### Custom error handlers

There are two kind of errors to distinguish: **errors caused by bugs in
the code**, and **errors caused by interrupted connection or data loss**.
WebRocket server and client design encoureges to use bugs related errors
only for development purposes and don't realy on them in the production
code. WebRocket provides even way to disable error notifications in
production environment. Here's an example of error handling.

    $wr.on('error', function(err) {
        // do something with error...
    });

By default all the errors are logged in the DOM console. 

### Server logs

WebRocket server is the place where all the errors are handled and logged.
If you need to get detailed information about what wrong happend in the
system you can easily get it from WebRocket access logs.
