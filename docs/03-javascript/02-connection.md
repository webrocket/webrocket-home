Connection
---

## Connection

As you know from the [overview](/docs/javascript/overview/) document,
default preconfigured connection is associated with `$wr` global variable.
However you can configure a connection by yourself whenever you want.
You can do it aside of the existing, default connection, or use your
custom connection only.

### Bare bones script

If you don't want to load library preconfigured for specific vhost, then
you can include bare bones script instead:

    <script src="http://webrocket.io:8080/webrocket.js"></script>

As you can notice, there's no vhost specified in the path, so loaded script
will not be preconfigured for any of them.

### Establishing connection

New connection can be established using the `WebRocket()` constructor function:

    var moon = new WebRocket('ws://webrocket.io:8080/moon');
    moon.on('connected', function() {
        alert('Yay! We're on the Moon!');
    });

Function takes full URL to requested vhost as an argument. Custom configuration
can be passed to the constructor in object as a second parameter:

    var moon = new WebRocket('ws://webrocket.io:8080/moon', {
        debug:   true,
        authURL: '/webrocket/auth.json'
    });

### Closing connection

Each connection can be safely, manually closed by the user, here's an example:

    $('#abandon_moon').live('click', function() {
        moon.disconnect();
    });

During the disconnection all the subscribed channels will be safely
unsubscribed. Also all the events fired before disconnection will try to
be delivered properly.

### Connection problems

It may happen, and for sure it will that WebSockets connection will be
broken or client will just get disconnected from the server. In that
situation `disconnected` event will be triggered, and it's programmer's
responsibility to handle it properly. Here's an example:

    $wr.on('connected', function() {
       $('#disconnected_alert').hide();
    });

    $wr.on('disconnected', function() {
        $alert = $('#disconnected_alert');
        $alert.html('System is offline! Reconnecting...');
        $alert.show();
        $wr.reconnectAfter(5000);
    });

In this example, if we will get disconnected from the server then our handler
will display information about it in some HTML box, and will try to
reconnect with WebRocket after 5 seconds.

This way more sophisticated handlers can be written. We can display
interactive counter indicating how much time left to next reconnect or
link to perform it immediately. To perform immediate reconnection
`$wr.reconnect()` function can be used instead of `$wr.reconnectAfter()`.
