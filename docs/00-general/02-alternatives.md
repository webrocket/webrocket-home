Alternatives
---

## Alternatives comparison

There's already few systems similar to WebRocket so we would like to compare
them with our project here. It shall give you quick overview about the
differences and innovations brought by WebRocket.

### [Pusher](http://pusherapp.com)

Pusher is the most well known websockets platform. It's got great support with libraries in many languages. They've been around for a while and have served billions of notifications.  It differs from Webrocket in two major ways.

*   <b>It's one way</b>, meaning it only supports sending messages over the websocket and not receiving them.
*   <b>It's not open source</b>. Webrocket offers a hosting on our [cloud platform](/cloud/), just like pusher, but if you want you can download and run the server yourself. 

### [Socket.IO](http://socket.io)

Socket.IO is a node.js server and client for 2 way real time communication. Socket works hard to provide backward compatibility with browsers and goes through many technologies to make it work including: WebSocket, Adobe® Flash® Socket, AJAX long polling, AJAX multipart streaming, Forever Iframe, JSONP Polling

Like Webrocket, Socket is an open source project where you can host your own servers and contribute back to the community. Socket.io does scale, to between [3k and 5k simultaneous connections per server](http://drewww.github.com/socket.io-benchmarking/) and then it's possible to use redis or 

### [PubNub](http://www.pubnub.com)

PubNub is a real time notification startup for web and mobile applications. They support many platforms, two way communication, and provide extensive sdk's including using Socket.IO's client libraries. PubNub's servers are not open source. 

### [Socky](https://github.com/socky/)

TODO

### [Firehose](http://firehose.io/)

Ruby gem to provide a websocket server as a rack application. It's <a href="https://github.com/polleverywhere/firehose">open source</a> and works with backbone.js and ember.js.

### [Firebase](http://www.cubeia.com/index.php/component/content/article/13-firebase/33-firebase)

Dual licensed Open Source / Commercial, Firebase was built to provide a platform for real time communication in gaming. Firebase is written in java and provides client libraries in javascript, flash, and C++. 

### Mongrel2 (WebSockets)

TODO

