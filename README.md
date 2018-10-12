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

  def active_user
    @all_user ||= User.active.order(login_at: :desc).limit(10)
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

Add an API model layer to your Rails application.

```ruby
class UserRepresenter < ApplicationRepresenter
  def full_name
    "#{first_name} #{last_name}"
  end
end

user = OpenStruct.new(first_name: "John", last_name: "Appleseed")
representer = UserRepresenter.new(user)
representer.full_name # => 'John Appleseed'
```

To create a representer, you can use the generator.

```
$ bin/rails generate representer user
```

## License

MIT License. Copyright 2018 Ryo Hashimoto.
