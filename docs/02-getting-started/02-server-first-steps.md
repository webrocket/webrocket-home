First steps with the Server
---

## First steps with the Server

The most important binary delivered with WebRocket is `webrocket-server`.
To use it in the simplest possible way, it's enough to execute it without
any arguments:

    $ webrocket-server
    
It will start the server with default configuration. It may require `sudo` 
on some operating systems while it needs access to `/var/lib/*` directory.

### Configuring endpoints

WebRocket server tool brings up three kinds of endpoints:

* **Main server** (_-addr_) - by default served on port
  8080, serves WebSockets and provides all JavaScript assets (ia. 
  configured JavaScript client library). Also, provides backend RESTful 
  interface for managing channels, triggering events and dealing with access 
  control, and runs EventSource powered, keep alive resources consumed by
  backend workers as well.

* **Admin REST interface** (_-admin-addr_) - endpoint provides REST
  interface used to remotely manage WebRocket nodes and clusters. 

### Storage configuration

Server needs to store the information about vhosts, channels and access 
tokens, so it needs to have local storage directory specified. By default
data is stored under the `/var/lib/webrocket` directory. This location
can be changed with _-storage-dir_ switch.

### Node configuration

Further node configuration is made with [`webrocket-admin` tool](/docs/getting-started/administration/).
Check its documentation to get know more how to use it.

### Advanced usage

To get more information about possible usage and options of `webrocket-server`
tool check its documentation, help screen or manual pages.
