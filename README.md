# Lightrails

Utility library for Ruby on Rails

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

interactor = RegistrationInteractor.execute(params)
interactor.success?   # => true
interactor.completed? # => true
user = interactor.result[:user]
user.name # => 'John'
```

## Active Representer

Add an API model layer to your Rails application.

```ruby
class UserRepresenter < ActiveRepresenter::Base
  def full_name
    "#{first_name} #{last_name}"
  end
end

user = OpenStruct.new(first_name: 'John', last_name: 'Appleseed')
representer = UserRepresenter.new(user)
representer.full_name # => 'John Appleseed'
```
