# Lightrails

![](https://github.com/ryohashimoto/lightrails/workflows/Ruby/badge.svg)

Lightrails aims to provide more modular structures for Ruby on Rails applications.

It is a utility library including Action Facade, Action Interactor and Active Representer classes.

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

It uses Facade design pattern and takes responsibility for preparing data outside of the controller.

In the example below, by using `MyPage::IndexFacade` and `MyPage::NotificationsFacade`, Active Record methods will be called outside of the `MyPageController`.

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

class MyPage::NotificationsFacade < ApplicationFacade
  attr_reader :current_user

  def initialize(payload)
    @current_user = payload[:current_user]
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

  def notifications
    # You can retrieve data from the guessed facade
    # MyPageController#notifications => MyPage::NotificationsFacade
    payload = { current_user: current_user }
    retrieve_from(payload, :messages)
  end
end
```

```erb
<%# in View (index.html.erb) %>

<% @active_users.each do |user| %>
  ...
<% end %>

<% @messages.each do |user| %>
  ...
<% end %>

<%# in View (messages.html.erb) %>

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

It uses Command design pattern and will be usable for various business logic (ex: user registration) in Rails applications.

In the example, by using `RegistrationInteractor`, user registration process will be executed outside of model and controller.

```ruby
class User
  attr_accessor :name

  def initialize(payload)
    @name = payload[:name]
  end
end

class RegistrationInteractor < ApplicationInteractor
  def execute
    return failure! unless payload[:name]
    # complicated business logic
    # set results
    results.add(:user, User.new(name: payload[:name]))
    successful!
  end
end

interactor.successful?   # => true
interactor.finished?  # => true
user = interactor.results[:user]
user.name # => 'John'
```

To create an interactor, you can use the generator.

```
$ bin/rails generate interactor registration
```

## Active Representer

It provides a class for wrapping a object and used like Model.
You can add custom methods to the class (using the decorator pattern).
It can be used with API responses or simple decorators.

In addition, `attr_field` / `attr_one` / `attr_many` can be used for attributes.

### `attr_field`

Declare additional field and type to the objects.
You can get / set field's value (converted to corresponding).
It uses `ActiveModel::Attributes` internally.

### `attr_one`

Declare an associated object like has one association.
If a representer for the object is found, the object will be wrapped by the representer.

### `attr_mamy`

Declare associated objects like has many association.
If a representer for the objects is found, the objects will be wrapped by the representer.

You can wrap hash-like objects (`OpenStruct`, `Hashie::Mash` etc.) like below.

```ruby
class ActivityRepresenter < ApplicationRepresenter
  def created_on
    created_at.to_date
  end
end

class UserRepresenter < ApplicationRepresenter
  attr_field :first_name, :string
  attr_field :last_name, :string
  attr_many :activities

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

To create a representer, you can use the Rails generator.

```
$ bin/rails generate representer user
$ bin/rails g representer activity
```

## License

MIT License. Copyright 2018-2020 Ryo Hashimoto.
