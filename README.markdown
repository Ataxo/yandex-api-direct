# Yandex-API-Direct

Accessing Yandex API and work with campaigns and statistics

## Instalation

Just in console

``` ruby
gem install yandex-api-direct
```

Or put into Gemfile

``` ruby
gem "yandex-api-direct"
```

and somewhere before use (not rails - they will require gem automaticaly)
``` ruby
require "yandex-api-direct"
```

## Initialization

Setup your config values by calling YandexApiDirect.config = {}

``` ruby
YandexApiDirect.config = {}
```

Get application_id by registering your application at https://oauth.yandex.com/client/new
(full doc at: http://api.yandex.com/oauth/doc/dg/tasks/register-client.xml)

If you need to get Oauth token you will also need application password (also listed on registration page).


## Sandbox/Production enviroments

Yandex api allows you to use sandbox for testing purposes: [Yandex Sandbox](http://api.yandex.com/direct/doc/concepts/sandbox.xml)

In your test helper write down
``` ruby
YandexApiDirect.url "sandbox" #or if you like symbols :sandbox  :-)
#or for directly saying to use production
YandexApiDirect.url "production" #or if you like symbols :production  :-)
```
This will set url of Yandex to sandbox or production.
If you will not set url it will use ENV['RACK_ENV'] or ENV['RAILS_ENV'] == "test" it will use "sandbox" as default, all other environments (including development) will have sa default setted "production"

## Usage

## Contributing to redis-model-extension
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Ondrej Bartas. See LICENSE.txt for
further details.