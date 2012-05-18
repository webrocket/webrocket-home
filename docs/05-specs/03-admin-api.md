Admin API
---

## Admin API specification

The **WebRocket Admin API** is a RESTful interface built for managing
server cluster and nodes, and their configuration settings (vhosts, 
channels, etc.). Admin API listens on separate port, by default on
port `8081`.

### Authentication

Server's authentication is solved by **exchanging a cookie** - a pseudo random
hash assigned to the server or cluster. Cookie can be read when `webrocket-server`
first instance starts - it shall be displayed on the screen. It can be also
read from the server's cookie file: 

    cat /var/lib/webrocket/{node-name}.cookie 

Where `node-name` is a configured name of the node, usually it's a full name
of the host where a server is running. You can get the value by executing
this command: 

    hostname -f

Cookie exchange goes via custom header supported by WebRocket Admin API.
Valid cookie value must be set in `X-WebRocket-Cookie` HTTP header. 

### Resources

Here's the list of resources supported by WebRocket Admin API, or those which 
is willing to support in the future. Not implemented yet resources are properly
 marked.

#### HTTP List VHosts

List all known vhosts. _This feature is implemented since WebRocket 0.3.0_.

##### Request

    GET /
    
There's no query parameters required.

##### Response

<small>Normal response:</small>

Status code: `200 OK`<br />
Content-Type: `application/json`

The `vhosts` JSON object in the response will contain an array of known
vhosts.

##### Example

    $ curl -i -H "X-WebRocket-Cookie: ..." http://127.0.0.1:8081/
    HTTP/1.1 200 OK
    Content-Type: application/json
    Date: Tue, 15 May 2012 13:31:39 GMT
    X-Webrocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef

    {
        vhosts: [
            {
                "path": "/moon",
                "accessToken": "b444aa042e176fe65be600a92fc71f926ee71ee6"
                "links": [
                    { "rel": "self", "href": "/moon" }
                ],
            },
            {
                "path": "/earth",
                // *snip*
            }
        ]
    }

#### HTTP Create a VHost

Creates new vhost under requested path. _This feature is implemented since WebRocket 0.3.0_.

##### Request

    POST /:path

<small>URI parameters:</small>

`:path` - A path to VHost which shall be created.

There's no query parameters required.

##### Response

<small>Normal response:</small>

Status code: `302 Found`<br />
Location: `/path/to/created/vhost`

<small>Error responses:</small>

Status code: `400 Bad Request`

When operation succeeds response redirects to created VHost information.
If VHost path is invalid or requested VHost already exist, then Bad Request
error is returned.

##### Example

    $ curl -v -H "X-WebRocket-Cookie: ..." -X POST http://127.0.0.1:8081/mars
    * About to connect() to 127.0.0.1 port 8081 (#0)
    *   Trying 127.0.0.1...
    * connected
    * Connected to 127.0.0.1 (127.0.0.1) port 8081 (#0)
    > POST /mars HTTP/1.1
    > User-Agent: curl/7.24.0 (x86_64-redhat-linux-gnu) libcurl/7.24.0 NSS/3.13.3.0 zlib/1.2.5 libidn/1.24 libssh2/1.4.1
    > Host: 127.0.0.1:8081
    > Accept: */*
    > X-WebRocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    > 
    < HTTP/1.1 302 Found
    < Content-Type: application/json
    < Date: Tue, 15 May 2012 13:49:04 GMT
    < Location: /mars
    < X-Webrocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    <
    * Connection #0 to host 127.0.0.1 left intact
    * Closing connection #0

#### HTTP Get VHost Information

Displays all the information about requested VHost. _This feature is implemented since WebRocket 0.3.0_.

##### Request

    GET /:path

<small>URI parameters:</small>

`:path` - A path to VHost which shall be fetched.

There's no query parameters required.

##### Response

<small>Normal response:</small>

Status code: `200 OK`<br />
Content-Type: `application/json`

<small>Error responses:</small>

Status code: `404 Not Found`

If VHost exists, then `vhost` JSON object in response contains all the
VHost information. Otherwise, when VHost doesn't exist, then Not Found
error is returned.  

##### Example

    $ curl -i -H "X-WebRocket-Cookie: ..." http://127.0.0.1:8081/mars
    HTTP/1.1 200 OK
    Content-Type: application/json
    Date: Tue, 15 May 2012 14:04:38 GMT
    X-Webrocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    
    {
        "vhost": {
            "path": "/mars",
            "accessToken": "59cd81dc40aea9ed5085591cd2f4ff9633956d1c",
            "channels": { 
                "size": 2
            },
            "links": [
                { "rel": "self", "href": "/mars" },
                { "rel": "channels", "href": "/mars/channels" }
            ]
        }
    }

#### HTTP Regenerate VHost Token

Regenerates access token for request vhost. _This feature is implemented since WebRocket 0.3.0_.

##### Request

    PUT /:path/token
    
<small>URI parameters:</small>

`:path` - A path to VHost which shall be removed.

There's no query parameters required.

##### Response

<small>Normal response:</small>

Status code: `302 Found`<br />
Location: `/path/to/vhost`

<small>Error responses:</small>

Status code: `404 Not Found`

When requested vhost doesn't exist, then Not Found error will be returned.
If operation succeeds, then response is being redirected to the vhost
information resource.

##### Example

    $ curl -v -H "X-WebRocket-Cookie: ..." -X PUT http://127.0.0.1:8081/moon/token
    * About to connect() to 127.0.0.1 port 8081 (#0)
    *   Trying 127.0.0.1...
    * connected
    * Connected to 127.0.0.1 (127.0.0.1) port 8081 (#0)
    > PUT /moon/token HTTP/1.1
    > User-Agent: curl/7.24.0 (x86_64-redhat-linux-gnu) libcurl/7.24.0 NSS/3.13.3.0 zlib/1.2.5 libidn/1.24 libssh2/1.4.1
    > Host: 127.0.0.1:8081
    > Accept: */*
    > X-WebRocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    > 
    < HTTP/1.1 302 Found
    < Date: Tue, 15 May 2012 16:12:39 GMT
    < Location: /moon
    < X-Webrocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    < 
    * Connection #0 to host 127.0.0.1 left intact
    * Closing connection #0
    
#### HTTP Delete VHost

Removes requested VHost if exists. _This feature is implemented since WebRocket 0.3.0_.

##### Request

    DELETE /:path

<small>URI parameters:</small>

`:path` - A path to VHost which shall be removed.

There's no query parameters required.

##### Response

<small>Normal response:</small>

Status code: `202 Accepted`

<small>Error responses:</small>

Status code: `404 Not Found`

If VHost exists, then gets removed from the server and Accepted response
is returned. Otherwise, when VHost doesn't exist, then Not Found error 
is returned.  

##### Example

    $ curl -v -H "X-WebRocket-Cookie: ..." -X DELETE http://127.0.0.1:8081/mars
    * About to connect() to 127.0.0.1 port 8081 (#0)
    *   Trying 127.0.0.1...
    * connected
    * Connected to 127.0.0.1 (127.0.0.1) port 8081 (#0)
    > DELETE /mars HTTP/1.1
    > User-Agent: curl/7.24.0 (x86_64-redhat-linux-gnu) libcurl/7.24.0 NSS/3.13.3.0 zlib/1.2.5 libidn/1.24 libssh2/1.4.1
    > Host: 127.0.0.1:8081
    > Accept: */*
    > X-WebRocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    > 
    < HTTP/1.1 202 Accepted
    < Date: Tue, 15 May 2012 14:17:28 GMT
    < X-Webrocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    < 
    * Connection #0 to host 127.0.0.1 left intact
    * Closing connection #0

#### HTTP Delete All VHosts

Removes all known vhosts. _This feature is implemented since WebRocket 0.3.0_. 

##### Request

    DELETE /
    
There's no query params required.

##### Response

<small>Normal response</small>

Status code: `202 Accepted`

An Accepted status is returned after all vhosts will be deleted.

##### Example

    $ curl -v -H "X-WebRocket-Cookie: ..." -X DELETE http://127.0.0.1:8081/
    * About to connect() to 127.0.0.1 port 8081 (#0)
    *   Trying 127.0.0.1...
    * connected
    * Connected to 127.0.0.1 (127.0.0.1) port 8081 (#0)
    > DELETE / HTTP/1.1
    > User-Agent: curl/7.24.0 (x86_64-redhat-linux-gnu) libcurl/7.24.0 NSS/3.13.3.0 zlib/1.2.5 libidn/1.24 libssh2/1.4.1
    > Host: 127.0.0.1:8081
    > Accept: */*
    > X-WebRocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    > 
    < HTTP/1.1 202 Accepted
    < Date: Tue, 15 May 2012 14:17:28 GMT
    < X-Webrocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    < 
    * Connection #0 to host 127.0.0.1 left intact
    * Closing connection #0

#### HTTP List Channels

List all channels opened within requested vhost. _This feature is implemented since WebRocket 0.3.0_.

##### Request

    GET /:vhost/channels

<small>URI parameters:</small>

`:vhost` - A path to the parent VHost.

There's no query parameters required.

##### Response

<small>Normal response:</small>

Status code: `200 OK`<br />
Content-Type: `application/json`

<small>Error responses:</small>

Status code: `404 Not Found`

If requested vhost exists then `channels` JSON object in response contains
list of channels known within this vhost. When vhost doesn't exist, then
Not Found error will be returned.

##### Example

    $ curl -i -H "X-WebRocket-Cookie: ..." http://127.0.0.1:8081/moon/channels
    HTTP/1.1 200 OK
    Content-Type: application/json
    Date: Tue, 15 May 2012 13:59:22 GMT
    X-Webrocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef

    {
        channels: [
            {
                "name": "greetings",
                "links": [
                    { "rel": "self", "href": "/moon/channels/greetings" },
                    { "rel": "vhost", "href": "/moon" }
                ],
            },
            {
                "name": "astronauts",
                // *snip*
            }
        ]
    }

#### HTTP Open Channel

Creates new channel within requested vhost. _This feature is implemented since WebRocket 0.3.0_.

##### Request

    POST /:vhost/channels/:name

<small>URI parameters:</small>

`:vhost` - A path to the parent VHost.<br />
`:name` - A name of the channel which shall be created.

There's no query parameters required.

##### Response

<small>Normal response:</small>

Status code: `302 Found`<br />
Location: `/vhost/channels/channel-name`

<small>Error responses:</small>

Status code: `400 Bad Request`<br />
Status code: `404 Not Found`

If parent vhost doesn't exist then Not Found error will be returned.
A Bad Request error will be returned if channel name is invalid or
such a channel already exists. When opetation succeeds, then response
will redirect to created channel.

##### Examples

    $ curl -v -H "X-WebRocket-Cookie: ..." -X POST http://127.0.0.1:8081/moon/channels/asteroids
    * About to connect() to 127.0.0.1 port 8081 (#0)
    *   Trying 127.0.0.1...
    * connected
    * Connected to 127.0.0.1 (127.0.0.1) port 8081 (#0)
    > POST /moon/channels/asteroids HTTP/1.1
    > User-Agent: curl/7.24.0 (x86_64-redhat-linux-gnu) libcurl/7.24.0 NSS/3.13.3.0 zlib/1.2.5 libidn/1.24 libssh2/1.4.1
    > Host: 127.0.0.1:8081
    > Accept: */*
    > X-WebRocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    > 
    < HTTP/1.1 302 Found
    < Content-Type: application/json
    < Date: Tue, 15 May 2012 15:10:26 GMT
    < Location: /moon/channels/asteroids
    < Transfer-Encoding: chunked
    < X-Webrocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    < 
    * Connection #0 to host 127.0.0.1 left intact
    * Closing connection #0
    
#### HTTP Get Channel Information

Displays all the information about requested channel. _This feature is implemented since WebRocket 0.3.0_.

##### Request

    GET /:vhost/channels/:name

<small>URI parameters:</small>

`:vhost` - A path to the parent VHost.<br />
`:name` - A name of the channel which shall be fetched.

There's no query parameters required.

##### Response

<small>Normal response:</small>

Status code: `200 OK`

<small>Error responses:</small>

Status code: `404 Not Found`

Responds with Not Found error when either parent vhost or requested channels
doesn't exist. If succeed, then `channel` JSON object contains all the 
channel information.

##### Example

    $ curl -i -H "X-WebRocket-Cookie: ..." http://127.0.0.1:8081/moon/channels/asteroids
    HTTP/1.1 200 OK
    Content-Type: application/json
    Date: Tue, 15 May 2012 15:35:36 GMT
    X-Webrocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    
    {
        "channel": {
            "name": "asteroids",
            "subscribers": {
                "size": 0
            },
            "links": [
                { "rel": "self", "href": "/moon/channels/asteroids" },
                { "rel": "vhost", "href": "/moon" },
                { "rel": "subscribers", "href": "/moon/channels/asteroids/subscribers" }
            ]
        }
    }
    
#### HTTP Delete Channel

Removes specified channel from requested vhost. _This feature is implemented since WebRocket 0.3.0_.

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

Responds with Not Found error when either parent vhost or requested channels
doesn't exist. An Accepted status is returned when operation succeeds.

##### Example

    $ curl -v -H "X-WebRocket-Cookie: ..." -X DELETE http://127.0.0.1:8081/mars/channels/asteroids
    * About to connect() to 127.0.0.1 port 8081 (#0)
    *   Trying 127.0.0.1...
    * connected
    * Connected to 127.0.0.1 (127.0.0.1) port 8081 (#0)
    > DELETE /mars/channels/asteroids HTTP/1.1
    > User-Agent: curl/7.24.0 (x86_64-redhat-linux-gnu) libcurl/7.24.0 NSS/3.13.3.0 zlib/1.2.5 libidn/1.24 libssh2/1.4.1
    > Host: 127.0.0.1:8081
    > Accept: */*
    > X-WebRocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    > 
    < HTTP/1.1 202 Accepted
    < Date: Tue, 15 May 2012 14:17:28 GMT
    < X-Webrocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    < 
    * Connection #0 to host 127.0.0.1 left intact
    * Closing connection #0

#### HTTP Delete All Channels

Removes all known channels from requested vhost. _This feature is implemented since WebRocket 0.3.0_.

##### Request

    DELETE /:vhost/channels

<small>URI parameters:</small>

`:vhost` - A path to the parent VHost.

There's no query parameters required.

##### Response

<small>Normal response:</small>

Status code: `202 Accepted`

<small>Error responses:</small>

Status code: `404 Not Found`

When parent vhost doesn't exist, then Not Found error is returned.
An Accepted status is returned after all channels will be deleted.

##### Example

    $ curl -v -H "X-WebRocket-Cookie: ..." -X DELETE http://127.0.0.1:8081/moon/channels
    * About to connect() to 127.0.0.1 port 8081 (#0)
    *   Trying 127.0.0.1...
    * connected
    * Connected to 127.0.0.1 (127.0.0.1) port 8081 (#0)
    > DELETE /moon/channels HTTP/1.1
    > User-Agent: curl/7.24.0 (x86_64-redhat-linux-gnu) libcurl/7.24.0 NSS/3.13.3.0 zlib/1.2.5 libidn/1.24 libssh2/1.4.1
    > Host: 127.0.0.1:8081
    > Accept: */*
    > X-WebRocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    > 
    < HTTP/1.1 202 Accepted
    < Date: Tue, 15 May 2012 14:17:28 GMT
    < X-Webrocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef
    < 
    * Connection #0 to host 127.0.0.1 left intact
    * Closing connection #0

#### HTTP List Subscribers

List all known subscribers of requested channel. _This feature is not yet implemented_.

##### Request

    GET /:vhost/channels/:channel/subscribers
    
<small>URI parameters:</small>

`:vhost` - A path to the parent VHost.
`:channel` - A name of the parent Channel.

There's no query parameters required.

##### Response

<small>Normal response:</small>

Status code: `200 OK`

<small>Error responses:</small>

Status code: `404 Not Found`

If parent vhost or requested channel doesn't exist, then Not Found error
is returned. Otherwise, when operation succeeds, then `subscribers` JSON
object contains list of channel subscribers information.

##### Example

_Not yet implemented_

#### HTTP List Backend Workers

List all known backend workers connected to requested vhost. _This feature is implemented since WebRocket 0.3.0_.

##### Request

    GET /:vhost/workers
    
<small>URI parameters:</small>

`:vhost` - A path to the parent VHost.

There's no query parameters required.

##### Response

<small>Normal response:</small>

Status code: `200 OK`

<small>Error responses:</small>

Status code: `404 Not Found`

A Not Found response is returned when requested vhost doesn't exist.
Otherwise, if operation succeeds, then `workers` JSON object contains
list of information about backend workers connected to the vhost.

##### Example

    $ curl -i -H "X-WebRocket-Cookie: ..." http://127.0.0.1:8081/moon/workers
    HTTP/1.1 200 OK
    Content-Type: application/json
    Date: Tue, 15 May 2012 14:30:22 GMT
    X-Webrocket-Cookie: 37383acee7109d3136e87fe4af9cf3deb2dc8fef

    {
        workers: [
            {
                "id": "59cd81dc40aea9ed5085591cd2f4ff9633956d1c",
                "links": [
                    { "rel": "self", "href": "/moon/workers" },
                    { "rel": "vhost", "href": "/moon" }
                ],
            },
            {
                // *snip*
            }
        ]
    }

### Admin Command Line Tool

Currently, all the implemented resources are supported by `webrocket-admin`
command line tool. To get more information on how to use it, read document
about [administration basics](/docs/getting-started/administration).
