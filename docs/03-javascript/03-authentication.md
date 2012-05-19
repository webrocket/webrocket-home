Authentication
---

## Authentication

JavaScript client has an authentication mechanism built in. Authentication
is required if we want to join private channels, or those with presence
tracking.

### Requesting Single Access Token

To perform authentication we have to request for a **single access token**.
We have to do this from our backend application - that's the only safe
and trusted way. Backend clients should have a way to request such an, 
access token, i.a. in Ruby language we can do this using `Kosmonaut::Client#single_access_token`
method or shorter alias `Kosmonaut::Client#sat`. Here's an example in
Sinatra web framework:

    get '/webrocket/auth.json' do
      content_type 'application/json'
      @token = $kosmonaut.sat(@current_user.id, "priv-moon|presence-earth")
      return { token: @token }.to_json
    end

#### Unique User Identifier

To obtain an access token we have to provide a way to distinguish a user (connection)
requesting for an authentication. Identifier required by WebRocket must
be **unique within assigned channels** - it can be unique user name, ID from
the database, etc.

#### Permissions

Channels must be explicitly assigned with single access token - it means that
generated access token **grants access only to specified channels**. We can
specify granted channels as a regexp, eg. `priv-.*|presence-foo`. This example
will grant access to all the private channels and to presence `foo`.

#### Security

Remember, unique user identifier and permissions hash **should not be
specified in the frontend application**. Those can be easily swaped and
used to perform an attack on your system. 

### Frontend authentication

Authentication in WebRocket is optional, so we have to do an extra step to 
enable it. We can request authentication by calling `authenticate()` function
on WebRocket connection object:

    $wr.authenticate();

It will ensure that we need to wait for an access token before we join any
channel.
    
#### Custom settings

Authentication mechanism can be customized. By default WebRocket asks for
access token from `GET /webrocket/auth.json` resource. We can change
requested URL to our own, by specifying it in second parameter.

    $wr.authenticate({}, '/custom-auth.json');
    
What's the first argument then? It's an object with query parameters.
These parameters will be passed to authentication request, eg:

    $wr.authenticate({ foo: 'bar' });
    
Request performed by the example above will go to `/webrocket/auth.json?foo=bar`.
