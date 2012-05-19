Events
---

## Events

Communication on the [channels](/docs/javascript/channels/) is made up with
events - sort of messages passed around and broadcasted to all the subscibers.
Unlike in similar projects, WebRocket library requires to define event
accessors, eg.

    var dioneChan = $wr.join('dione');
    var greetingsEvent = dioneChan.event('greetings');

The `greetingsEvent` in second line of this example is our event accessor.
It provides set of tools to listen for events, or fire them.

<blockquote>
  Why to define such accessors when you can simply bind specific event
  handler directly on the channel, and specify event name in channel's
  <code>fire</code> operation.
</blockquote>

Well, answer is simple - this approach significally reduces amount of
repetitions in the code, and amount of possible bugs. It's way more
reliable to define an event once, and use a variable as an entry point
for it, instead of repeating event name every time we want to handle
or trigger it. It also gives programmers cleaner perspective to look
at handled events. 

### Handling incoming events

Like it was mentioned, defined accessor provides way to handle incoming
data, here's an example:

    greetingsEvent.on('received', function(data) {
        // do something with the data...
    });

#### Multiple events handler

WebRocket architecture encourages programmer to be explicit and avoid
magic, there's an use case where multiple events handler may be useful.
By multiple events handler we understand a callback used to handle
many types of events on the same channel. To achieve something like this
channel's `received` event can be used. Naming may be confusing, so
let's explain it with this snippet:

    dioneChan.on('received', function(event, data) {
        if (!!data.message) {
            console.log(event + ':' + data.message);
        } else if (!!data.operation) {
            console.log(event + ':' + data.operation);
        }
    });

The example above may look a bit silly, however gives you picture of
how WebRocket is able to handle events apart from its accessors.

### Triggering events

Accessors of course provides a funtion to trigger events. While `trigger()`
is reserved by internal event emitter, the `fire()` function is used to
trigger events with payloads:

    greetingsEvent.fire({
        message: 'Hello World!', 
        author:  'nu7'
    });

This will fire event with attached data and broadcast it to everyone,
or handle it in appropriate way defined in backend hooks.
