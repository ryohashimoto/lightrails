# Lightrails

![](https://github.com/ryohashimoto/lightrails/workflows/Ruby/badge.svg)

Lightrails is a utility library including Action Interactor, Active Representer etc.
It aims to provide more modular structures for Ruby on Rails applications.

## Getting Started

Add `lightrails` to your Rails project's Gemfile and `bundle install`.

```ruby
gem "lightrails"
```

Run the generator.

```
$ bin/rails generate lightrails:install
```

## Action Facade

Add a simple interface for obtaining multiple data used in a view.

```ruby
class Mypage::IndexFacade < ApplicationFacade
  attr_reader :current_user

  def initialize(payload)
    @current_user = payload[:current_user]
  end

  def active_users
    @active_users ||= User.active.order(login_at: :desc).limit(10)
  end

  def messages
    @messages ||= current_user.messages.order(created_at: :desc).limit(10)
  end
end

class MypageController < ApplicationController
  # for using #retrieve method
  include ActionFacade::Retrieval

  def index
    facade = Mypage::IndexFacade.new(current_user: current_user)
    # assign instance variables
    retrieve(facade, :active_users, :messages)
  end
end
```

```erb
<%# in View %>

<% @active_users.each do |user| %>
  ...
<% end %>

<% @messages.each do |user| %>
  ...
<% end %>
```

To create an facade, you can use the generator.

```
$ bin/rails generate facade mypage/index
```

## Action Interactor

Add standarized data processing units to your Rails application.

```ruby
class User
  attr_accessor :name

  def initialize(payload)
    @name = payload[:name]
  end
end

class RegistrationInteractor < ApplicationInteractor
  def execute
    return fail! unless payload[:name]
    # complicated business logic
    # set results
    results.add(:user, User.new(name: payload[:name]))
    success!
  end
end

interactor = RegistrationInteractor.execute(name: "John")
interactor.success?   # => true
interactor.finished?  # => true
user = interactor.results[:user]
user.name # => 'John'
```

To create an interactor, you can use the generator.

```
$ bin/rails generate interactor registration
```

## Active Representer

Add 'represented' models to your Rails application.
It can be used with API responses.
You can wrap hash-like objects (OpenStruct, Hashie::Mash etc.) like below.

```ruby
class ActivityRepresenter < ApplicationRepresenter
  def created_on
    created_at.to_date
  end
end

class UserRepresenter < ApplicationRepresenter
  attr_field :first_name, :string
  attr_field :last_name, :string
  attr_collection :activities

  def full_name
    "#{first_name} #{last_name}"
  end
end

user = OpenStruct.new(
  first_name: 'John',
  last_name: 'Appleseed',
  activities: [OpenStruct.new(created_at: Time.now)]
)

representer = UserRepresenter.wrap(user)
representer.full_name # => 'John Appleseed'
activity = representer.activities.first
activity.class # => ActivityRepresenter
activity.created_on # => returns current date
```

To create a representer, you can use the generator.

```
$ bin/rails generate representer user
$ bin/rails g representer activity
```

## License

MIT License. Copyright 2018-2019 Ryo Hashimoto.
