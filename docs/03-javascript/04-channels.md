Channels
---

## Channels

Channels are the core element of WebRocket infrastructure. They are pipes
over which all the communication goes around. To participate in events,
we have to join (subscribe) a channel first. The easiest way to do it is
to use `join()` function from WebRocket object.

    var dioneChan = $wr.join('dione');

This one line of code will manage to subscribe `moon` channel. When needed,
we can unsubscribe this channel with `leave()` function:

    dioneChan.leave();

### Base events

There are two default events happening on the channel - confirmations of
subscription or unsubscription. You can handle both of them:

    dioneChan.on('subscribed', function() {
        alert("We're on Dione!");
    });
    dioneChan.on('unsubscribed', function() {
        alert("We left Dione!");
    });

### Private channels

Private channels doesn't need any extra operations to be subscribed.
They of course require connection to be [authenticated](/docs/javascript/authentication/),
but joining the channel looks the same as with normal ones:

    var mimasChan = $wr.join('priv-mimas');

### Presence tracking

Channels with presence tracking allows to specify custom payload attached
to each subscription. Such attachment can be specified as a second argument
of the `join()` function:

    var tethysChan = $wr.join('presence-tethys', {
        name: 'Chris',
        rase: 'human'
    });

The `leave()` function accepts extra payload as well, eg:

    thetysChan.leave({ message: 'Bye bye!' });

This payload will be passed around together with a subscription to all the 
subscribers on the channel. Each time, when someone joins the channel an 
`online` event is triggered, likewise an `offline` event is triggered when 
someone leaves the channel. Those events can be handled like following:

    tethysChan.on('online', function(info) {
        alert('A ' + info.rase + ' called ' + info.name + ' is here!');
    });
    tethysChan.on('offline', function(info) {
        alert(info.name + ' leaves us saying: ' + info.message);
    });

#### Subscribers listing

At any time you can access list of subscribers of particular channel. Full
list of active subscribers is stored in `subscribers` object - each subscriber
is referred by his unique user identifier.

    var srs = thetysChan.subscribers;
    for (var uid in srs) {
        var info = srs[uid];
        // *snip*
    }

List of subscribers is also passed to `subscribed` event handler, however
in most of cases you will not need it, while `online` event is triggered
for each of those subscribers.

    thetysChan.on('subscribed', function(srs) {
        var n = parseInt(srs.length);
        alert("There's " + n + "people in here!");
    });

