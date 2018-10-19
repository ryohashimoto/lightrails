# Lightrails

Lightrails is a utility library including Action Interactor, Active Representer etc.  
It aims to provide more modular layers for Ruby on Rails applications.

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

Add a simple interface for obtaining multiple data in controller.

```ruby
class Mypage::IndexFacade < ApplicationFacade
  attr_reader :current_user

  def initialize(params)
    @current_user = params[:current_user]
  end

  def active_users
    @active_users ||= User.active.order(login_at: :desc).limit(10)
  end

  def messages
    @messages ||= current_user.messages.order(created_at: :desc).limit(10)
  end
end

# in MypageController
def index
  @facade = Mypage::IndexFacade.new(current_user: current_user)
end
```

```erb
<%# in View %>

<% @facade.active_users.each do |user| %>
  ...
<% end %>

<% @facade.messages.each do |user| %>
  ...
<% end %>
```

To create an facade, you can use the generator.

```
$ bin/rails generate facade mypage/index
```

## Action Interactor

Add a standarized service layer to your Rails application.

```ruby
class User
  attr_accessor :name

  def initialize(params)
    @name = params[:name]
  end
end

class RegistrationInteractor < ApplicationInteractor
  def execute
    return fail! unless params[:name]
    add_result(:user, User.new(name: params[:name]))
    # complicated business logic
    success!
  end
end

interactor = RegistrationInteractor.execute(name: "John")
interactor.success?   # => true
interactor.finished?  # => true
user = interactor.result[:user]
user.name # => 'John'
```

To create an interactor, you can use the generator.

```
$ bin/rails generate interactor registration
```

## Active Representer

Add 'represented' model layer to your Rails application.  
You can wrap hash-like (OpenStruct, Hashie::Mash etc.) objects like below.

```ruby
class ActivityRepresenter < ActiveRepresenter::Base
  def created_on
    created_at.to_date
  end
end

class UserRepresenter < ApplicationRepresenter
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

representer = UserRepresenter.new(user)
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

MIT License. Copyright 2018 Ryo Hashimoto.
