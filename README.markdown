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
YandexApiDirect.config = {
  locale: "en"
  application_id: "YOUR APPLICATION ID"
  login: "FILL LOGIN OF USER"
  access_token: "FILL ACCESS TOKEN FOR USER"
}
```

Get application_id by registering your application at https://oauth.yandex.com/client/new
(full doc at: http://api.yandex.com/oauth/doc/dg/tasks/register-client.xml)

If you need to get Oauth token you will also need application password (also listed on registration page).

## Working with Gem

You can access Main classes: Client, Campaign, CampaignParam, CampaignStats

### How one class works

Main classes are inherited from [Hashr](https://github.com/svenfuchs/hashr) and includes [YandexObject](https://github.com/Ataxo/yandex-api-direct/blob/master/lib/yandex-api-direct/yandex_object.rb)
This combination will provide very easy acces to all returned values from API.

``` ruby
# Find some objects:
campaigns = YandexApiDirect::Campaign.find
# you got [ <Campaign:..>, ... ] and choose first one
campaign = campaigns.first
# then you can ask for something
campaign.name #=> "Campaign"
campaign.campaign_id #=> 123456
campaign.clicks #=> 123
```

Arguments from api is hash, this hash is saved by hashr directly into instance.
Keys from API are underscored for using as normal methods not `campaign.Name` instead of this use: `campaign.name`
**Instance is still Hash, you can do all stuf like with normal hash.**

### Find
``` ruby
#you can pass arguments to find as hash: [GetClientsList](http://api.yandex.com/direct/doc/reference/GetClientsList.xml)
YandexApiDirect::Client.find
#=> [ <Client:..>, ... ]

#you can pass argument as array of logins (optional for agencies): [GetCampaignsList](http://api.yandex.com/direct/doc/reference/GetCampaignsList.xml)
YandexApiDirect::Campaign.find
#=> [ <Campaign:..>, ... ]

#you can pass arguments to find as hash: [GetCampaignParams](http://api.yandex.com/direct/doc/reference/GetCampaignParams.xml)
YandexApiDirect::CampaignParams.find
#=> [ <CampaignParams:..>, ... ]

#you can pass arguments to find as hash: [GetSummaryStat](http://api.yandex.com/direct/doc/reference/GetSummaryStat.xml)
YandexApiDirect::CampaignStats.find
#=> [ <CampaignStats:..>, ... ]
```

### Arguments for methods

All arguments you will pass into params are automatically camelized, because Yandex API takes only Camelcased attribute names:
``` ruby
# Example: 
campaign.campaign_stats start_date: Date.today
# will transform inside of method into
{ :"StartDate" => Date.today }
```
If you will implement your own methods, you can use built in method in YandexObject `camelize_keys(hash)`

### Hierarchy

Yandex uses this hierarchy and gem follows it
* Client
 * Campaign
  * CampaignParams
  * CampaignStats

``` ruby
#get first Client
client = Client.find.first

#get all client campaign
campaigns = client.campaigns

campaign = campaigns.first

#get campaign statistics
campaign.campaign_stats start_date: Date.today-8, end_date: Date.today-1
#=> [<CampaingStats:..>, ...]
#get campaign params
campaign.campaign_params
#=> <CampaingParams:... > - not array but directly one object (campaign can have only one params!)
```

### Flexibility

There is a class YandexApiDirect::Generic which provides class method get 
has two parameters 
* method name - underscored
* args (optional) - should be hash or array

``` ruby
YandexApiDirect::Generic.get "get_clients_info"
#=> will return hash containing client info (Only one item returned)

YandexApiDirect::Generic.get "get_clients_list"
#=> will return array containing hashes of client info (More items returned)
``` 
By this you can call all methods without writing more code.

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