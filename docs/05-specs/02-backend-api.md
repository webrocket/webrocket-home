Backend API
---

## Backend API specification

The **WebRocket Backend API** is a RESTful interface build for performing 
operations from the backend apps, and to provide bidirectional connection 
between backends and WebRocket server. Backend API listens on the same
port as Frotnend Server does, namely by default on port `8080`.

### Authentication

Server authenticates backend connections using simple HTTP authentication.
HTTP user name is always the same, namely it's `wr` user. Passphrase used 
to authenticate the connection is a **token for vhost we want to connect 
to**. Here's how URI is composed:

    http://wr:[token]@webrocket.io:8080/[vhost]

### Resources

Here's the list of resources supported by WebRocket backend API, or those
which is willing to support in the future. Not implemented yet resources
are properly marked.

#### HTTP Open Channel

Creates new channel within connected vhost. _This feature is implemented since WebRocket 0.3.0_.

##### Request

    POST /:vhost/channels/:name
    
<small>URI parameters:</small>

`:vhost` - A path to the parent VHost.<br />
`:name` - A name of the channel which shall be created.

There's no query parameters required.

##### Response

<small>Normal response:</small>

Status code: `202 Accepted`

<small>Error responses:</small>

Status code: `400 Bad Request`<br />
Status code: `404 Not Found`

If vhost doesn't exist then Not Found error will be returned. A Bad Request
error will be returned if channel name is invalid. When opetation succeeds, 
then Accepted status will be returned.

##### Examples

    $ curl -v -X POST http://wr:37383acee7109d3136e87fe4af9cf3deb2dc8fef@127.0.0.1:8080/moon/channels/asteroids
    * About to connect() to 127.0.0.1 port 8081 (#0)
    *   Trying 127.0.0.1...
    * connected
    * Connected to 127.0.0.1 (127.0.0.1) port 8081 (#0)
    > POST /moon/channels/asteroids HTTP/1.1
    > User-Agent: curl/7.24.0 (x86_64-redhat-linux-gnu) libcurl/7.24.0 NSS/3.13.3.0 zlib/1.2.5 libidn/1.24 libssh2/1.4.1
    > Host: 127.0.0.1:8081
    > Accept: */*
    > 
    < HTTP/1.1 202 Accepted
    < Date: Tue, 18 May 2012 15:29:26 GMT
    < Location: /moon/channels/asteroids
    < Transfer-Encoding: chunked
    < 
    * Connection #0 to host 127.0.0.1 left intact
    * Closing connection #0

#### HTTP Close Channel

Deletes requested channel from connected vhost. _This feature is implemented since WebRocket 0.3.0_.

##### Request

    DELETE /:vhost/channels/:name
    
<small>URI parameters:</small>

`:vhost` - A path to the parent VHost.<br />
`:name` - A name of the channel which shall be deleted.

There's no query parameters required.

##### Response

<small>Normal response:</small>

Status code: `202 Accepted`

<small>Error responses:</small>

Status code: `404 Not Found`

If vhost or requested channel doesn't exist then Not Found error will be 
returned. An Accepted status will be returned when opetation succeeds.

##### Examples

    $ curl -v -X DELETE http://wr:37383acee7109d3136e87fe4af9cf3deb2dc8fef@127.0.0.1:8080/moon/channels/asteroids
    * About to connect() to 127.0.0.1 port 8081 (#0)
    *   Trying 127.0.0.1...
    * connected
    * Connected to 127.0.0.1 (127.0.0.1) port 8081 (#0)
    > DELETE /moon/channels/asteroids HTTP/1.1
    > User-Agent: curl/7.24.0 (x86_64-redhat-linux-gnu) libcurl/7.24.0 NSS/3.13.3.0 zlib/1.2.5 libidn/1.24 libssh2/1.4.1
    > Host: 127.0.0.1:8081
    > Accept: */*
    > 
    < HTTP/1.1 202 Accepted
    < Date: Tue, 18 May 2012 15:35:11 GMT
    < Location: /moon/channels/asteroids
    < Transfer-Encoding: chunked
    < 
    * Connection #0 to host 127.0.0.1 left intact
    * Closing connection #0

#### HTTP Fire Event

Triggers requested event with attached payload. _This feature is implemented since WebRocket 0.3.0_.

##### Request

    POST /:vhost/channels/:channel/events
    
<small>URI parameters:</small>

`:vhost` - A path to the parent VHost.<br />
`:channel` - A name of the channel within which event shall be fired.

There's no query parameters required.

##### Response

<small>Normal response:</small>

Status code: `202 Accepted`

<small>Error responses:</small>

Status code: `400 Bad Request`<br />
Status code: `404 Not Found`

If vhost or channel doesn't exist then Not Found error will be 
returned. A Bad Reuqest error will be returned if event's payload
is invalid. An Accepted status will be returned when opetation 
succeeds.

##### Examples

    $ curl -v -H "Content-Type: application/json" -X POST \
    -d '{"trigger":{"event":"hello","data":{"from":"nu7hatch"}}}' \
    http://wr:37383acee7109d3136e87fe4af9cf3deb2dc8fef@127.0.0.1:8080/moon/channels/asteroids/events
    TODO: output

#### HTTP Get Single Access Token

Gets single access token authorized to join requested channel. _This feature is implemented since WebRocket 0.3.0_.

##### Request

    GET /:vhost/token?uid=[...]&channels=[...]

<small>URI parameters:</small>

`:vhost` - A path to the VHost.<br />

<small>Query parameters:</small>

`uid` - An unique (within the channel) user identifier.<br />
`channels` - Channels permission regexp.

##### Response

<small>Normal response:</small>

Status code: `200 OK`

<small>Error responses:</small>

Status code: `400 Bad Request`<br />
Status code: `404 Not Found`

If vhost doesn't exist then Not Found error will be returned. 
A Bad Reuqest error will be returned if user identifier or channels
pattern is invalid. If operation succeeds, then `token` JSON object
in response will contain string with access token.

##### Examples

    $ curl -i http://wr:37383acee7109d3136e87fe4af9cf3deb2dc8fef@127.0.0.1:8080/moon/token?uid=nu7&channels=asteroids|greetings
    TODO: output

#### HTTP Events

Backend API servers one special resource ment to provide real-time connection
between WebRocket and backend workers. This resource is an [event source](http://www.w3.org/TR/eventsource/),
keep alive connection which supplies all events to registered backend workers.
_This feature is implemented since WebRocket 0.3.0_.

##### Request

    GET /:vhost/events?filter=[...]

<small>URI parameters:</small>

`:vhost` - A path to the VHost.<br />

<small>Query parameters:</small>

`filter` - A regexp with event's backends to be registered in WebRocket.

##### Response

<small>Normal response:</small>

Status code: `200 OK`
Connection: `keep-alive`

<small>Error responses:</small>

Status code: `400 Bad Request`<br />
Status code: `404 Not Found`

If vhost doesn't exist then Not Found error will be returned. 
A Bad Reuqest error will be returned specified filter is invalid. 
If operation succeeds, then server sent events will contain
channel and event name under `event` key, and attached payload under
`data` key.

##### Example

    $ curl -i http://wr:37383acee7109d3136e87fe4af9cf3deb2dc8fef@127.0.0.1:8080/moon/events?filter=greetings/(hello|bye)
    TODO: output
