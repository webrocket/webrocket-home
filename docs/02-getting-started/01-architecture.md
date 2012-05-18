Architecture
---

## Understanding the architecture

WebRocket is a hybrid server, composed from two endpoints: **WebSockets server**
and **Backend endpoint**. Such design allows to bidirectionally communicate
between browsers supporting WebSockets and any kind of backend application
or daemon.

### WebSockets endpoint

WebSockets server is a very fast, high performance HTTP server supporting
latest version of the WebSockets specification. It communicates with browsers
using [custom frontend protocol](/docs/specs/frontend-protocol/). 
This protocol is the most important part of the WebRocket. It has been 
designed as open standard and is optimized for speed and reliability.

### Backend endpoint

Backend's dispatcher distinguishes two kinds of sockets: **Worker (subscriber)**
and **Client (requester)**. The idea behind them is very well descirbed in [the concept of Kosmonaut](/docs/backends/kosmonaut-concept/)
document. Backend API also has comprehensive [specification](/docs/specs/backend-api/). 

### How it fits together?

It's quite simple to understand how it works. The flow can be described
in three bullet points:

* Browsers are connected to WebSockets endpoints. Each one can subscribe
  many channel and listen to, and trigger events.
  
* Clients are used to manage channels, trigger events and provide 
  authentication.
  
* Workers are used to provide hooks for specified events. Each worker's
  hook grabs data sent from Browsers and handles it in user-defined way.
  
Backend Clients are **reliable and safe** - operations performed within need to get
acknowledge from the server to process. Workers on the other hand are **fault 
tollerant** - in case of worker's death there will be no damage for the system.

### Vhosts, channels, subscriptions and events

WebRocket environment is made up from **vhosts** and **channels**. Communication
between server and clients goes through channels and it's based on **subscriptions**.
Communication within the channel is made using **events**. Here are all the terms
better explained:

* **Vhost** is an encapsulated, standalone placeholder for the channels and
  user specicif configuration. One WebRocket cluster can contain many unrelated
  vhosts with totally unrelated channels, subscribers, backends and 
  configuration.

* **Channel** is a publish-subscribe construct on which whole the idea of
  WebRocket is based. Clients can subscribe specified channels and get updates
  from it whenever new event will be triggered there. WebRocket supports
  three types of channels - **open**, **private**, and **presence** (private 
  channels which track list of subscribers).

* **Subscription** is a relation between client and channels. Each connection 
  can subscribe to many channels of any type.
  
* **Event** is a single operation performed on the channel. More precisely, it's
  a message sent to all the subscribers. Event can has extra payload attached.

### Bidirectional communication

This architecture makes WebRocket very reliable broker providing real, bidirectional
communication between Browsers and any kind of backend application. It can also 
work as a standalone WebSockets server if communication with backend is not needed.

### Scalability

WebRocket has been designed to make horizontal scalability easy and harmless.
Setting up your own WebSockets server is costful and difficult, it requires
knowledge about messaging, setting external broker (eg. RabbitMQ) to communicate
between instances and so on. WebRocket has ben designed for this - to make
WebSockets server scallable, easy to configure and maintainable for everyone.
