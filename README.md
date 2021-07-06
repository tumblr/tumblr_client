# Tumblr Ruby Gem

[![Gem Version](https://badge.fury.io/rb/tumblr_client.png)](https://badge.fury.io/rb/tumblr_client) [![Build Status](https://secure.travis-ci.org/tumblr/tumblr_client.png)](https://travis-ci.org/tumblr/tumblr_client)

This is the official Ruby wrapper for the Tumblr v2 API. It supports all endpoints currently available on the [Tumblr API](https://www.tumblr.com/docs/en/api/v2).

## Installation

```
gem install tumblr_client
```

## Usage

First and foremost, this gem will *not* do a three legged oauth request for you. It is just a wrapper to help make your life easier when using the v2 api. If you need to do the full oauth workflow, then please check out the [Ruby OAuth Gem](http://oauth.rubyforge.org/).

### Configuration

Configuration for the gem is actually pretty easy:

```ruby
Tumblr.configure do |config|
  config.consumer_key = "consumer_key"
  config.consumer_secret = "consumer_secret"
  config.oauth_token = "access_token"
  config.oauth_token_secret = "access_token_secret"
end
```

Once you have your configuration squared away it's time to make some requests!

```ruby
>> client = Tumblr::Client.new
```

That's it! You now have a client that can make any request to the Tumblr API.

Also since the client is created with the amazing library [Faraday](https://github.com/lostisland/faraday), you can configure it to use any HTTP Client it supports.

```ruby
>> client = Tumblr::Client.new(:client => :httpclient)
```

### Some quick examples

Getting user information:

```ruby
>> client.info
```

Getting a specific blog's posts and type:

```ruby
# Grabbing a specific blogs posts
>> client.posts("codingjester.tumblr.com")

# Grabbing only the last 10 photos off the blog
>> client.posts("codingjester.tumblr.com", :type => "photo", :limit => 10)
```

Posting some photos to Tumblr:

```ruby
# Uploads a great photoset
>> client.photo("codingjester.tumblr.com", {:data => ['/path/to/pic.jpg', '/path/to/pic.jpg']})
```

### The irb Console

Finally, there is an irb console packaged with the gem that should help you test any calls you want to make. The magic here is that you have a `.tumblr` file in your home directory. Inside this file it's just a basic YAML layout with four lines:

```yaml
consumer_key: "your_consumer_key"
consumer_secret: "your_consumer_secret"
oauth_token: "your_access_token"
oauth_token_secret: "your_access_token_secret"
```

From there, you should be able to run any of the above commands, with no problem! Just fire off the command `tumblr` from the terminal and you should be dropped into a console.

---

The first time that you go to use the irb console, if you have no `.tumblr` file, it will walk you through the process of generating one. You will be prompted for your `consumer_key` and `consumer_secret` (which you can get here: https://www.tumblr.com/oauth/register) and then sent out to the site to verify your account. Once you verify, you will be redirected to your redirect URL (localhost by default) and copy the `oauth_verifier` back into the console. Then you're all set!

### Contributions and Pull Requests

No request is too small and I encourage everyone to get involved. As you can see, we're sorely lacking in tests! So please if you would like to contribute, let me know and throw me a pull request!

### Requirements

* Ruby 1.9.x to 3.x.x

---

Copyright 2013 Tumblr, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this work except in compliance with the License. You may obtain a copy of
the License in the LICENSE file, or at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations.
