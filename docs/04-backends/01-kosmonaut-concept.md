The concept of Kosmonaut
---

## The concept of Kosmonaut

WebRocket is a broker server, providing bidirectional connection support.
To enable such a support in easy and reliable way we designed the concept
of a backend library which we called fancy - Kosmonaut.

### How it works?

Kosmonaut is divided into two different kinds of sockets. The **Client (requester)**
is responsible for access control, channels management and broadcasting
data to the WebSockets. The **Worker (subscriber)** is responsible for 
handling events incoming from the server (more precisely, from the browsers). 

<blockquote>
Why are those sockets separated?
</blockquote>

Simply, because they do different things. You may want to use Client 
in your backend application, and only for triggering events or providing
authentication when you will not need bidirectional features of WebRocket, 
etc. This layout allows for more flexibility and is very efficient in usage.

### Client

Client uses simple HTTP, request-response connection. It requests operation to 
be done on the WebRocket server and waits for the response. There are 4 types of
operations supported by the client:

* **Opening new channel** - Client can request to open new channel on the
  fly. Channel types are distinguished by its name (`channeltype-name`, eg.
  `presence-foo`). Allowed channel types are `private` and `presence` - all
  other names will be treated as normal channels.
  
* **Closing existing channel** - All channels within the vhost can be
  deleted on the fly as well.
  
* **Triggering events** - Client can trigger any event on through the 
  existing channel. Events triggeren via not-existing channel will be
  ignored.
  
* **Requesting for single access token** - Single access token is a security
  mechanism to protect frontend connection against hijacking or corruption.
  Frontend connection must issue a single access token to get authenticated.

<blockquote>
  Why channel must exist to trigger an event on it? Isn't enough to create it
  automatically when needed?
</blockquote>  

This decision has been made due to security reasons. That mechanism protects 
the server from being flooded by unauthorized clients, automatically opening 
high number of channels. Though channels are cheap in WebRocket, high number 
of them opened at the time may cause denial of service problem.

### Worker

Worker uses EventSource HTTP connection (kind of keep-alive connection) to
instantly pop events from the server. It subscribes to the vhost's stream
and waits for the the events. Each new event coming from the server is
parsed and processed in appropriate way, defined by the user in his own
custom backends.

<blockquote>
  What's the benefit of having worker instance running instead of implementing
  own WebSockets server?
</blockquote>

WebSockets server is very expensive in load, memory footprint and other
resources usage. Besides it forces maintainer to keep up with specification
changes and security updates. The concept of Kosmonaut's workers allows
you to use bidirectional connections and all the features of WebSockets
without worrying about all these problems. Kosmonaut is very easy
to implement and cheap in execution - all the dirty work is done here
by WebRocket server. WebRocket is designed to be fast and reliable, and
it's optimized for high load by horizontal scalling.

### Specification

You may want to check out the [Backend API specification](/docs/specs/backend-api/) 
to get more information how it works under the hood.
