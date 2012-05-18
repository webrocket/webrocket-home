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
    wr.on('connected', function() {
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
