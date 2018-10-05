# Lightrails

Utility library for Ruby on Rails

## Getting Started

Add `lightrails` to your Rails project's Gemfile and `bundle install`.

```ruby
gem "lightrails"
```

Run generators.

```
$ bin/rails generate action_interactor:install
$ bin/rails generate active_representer:install
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

class RegistrationInteractor < ActionInteractor::Base
  def execute
    return unless params[:name]
    add_result(:user, User.new(name: params[:name]))
    # complicated business logic
    finish!
  end
end

interactor = RegistrationInteractor.execute(name: "John")
interactor.success?   # => true
interactor.completed? # => true
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
class UserRepresenter < ActiveRepresenter::Base
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

MIT Licence. Copyright 2018 Ryo Hashimoto.
