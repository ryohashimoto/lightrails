# 0.2.7
- Relax RubyGems version to >= 1.8.11
- Bugfix: Fix dependencies in gemspec files
- GitHub Actions Matrix tests with Ruby and Rails versions

# 0.2.6
- Support Ruby on Rails 7.0
- Drop support Ruby on Rails 5.2
- Require Ruby >= 2.7.0, RubyGems >= 3.3.13

# 0.2.5

- Set interactor default payload to `{}`
- Set facade default payload to `{}`
- kaminari version in Gemfile.lock is now platform independent

# 0.2.4

- Support Ruby on Rails 6.1
- Allow multi type first variable to `#retrieve` method
- Bugfix: set class attributes when inherited

# 0.2.3

## Active Representer

- Add `attr_one` for single associated object and `attr_collection` is renamed to `attr_many`.
  [pull request](https://github.com/ryohashimoto/lightrails/pull/33)

# 0.2.2

## Action Facade

- Add `ActionFacade#retrieve_from` for retrieve data from given payload (without initializing facades in controller) ([pull request](https://github.com/ryohashimoto/lightrails/pull/30))

# 0.2.1

- Generate documents by `rake rdoc` / Remove documents by `rake clean_doc` ([pull request](https://github.com/ryohashimoto/lightrails/pull/29))

## Active Representer

- Update READMEs and comments

# 0.2.0

## Action Interactor

- Add `ActionInteractor::Composite` for executing multiple interactors. ([pull request](https://github.com/ryohashimoto/lightrails/pull/28))
- Add `ActionInteractor::State` and `ActionInteractor::ExecutionState`, state machines for operation status. ([pull request](https://github.com/ryohashimoto/lightrails/pull/26))
- Rename to `successful?` and `failure!` methods (You can also use previous `success?` and `fail!` method names as aliases.) ([commit](https://github.com/ryohashimoto/lightrails/commit/e5a8dd0e4537fd734cb01574cca8fda82f53d433))

# 0.1.0.1

Security update for dependent libraries.

# 0.1.0

## Action Interactor

- Add `to_hash` and `messages` methods to `ActionInteractor::Base` ([commit](https://github.com/ryohashimoto/lightrails/commit/c26aef577754c656295c67cc98ca3a7dd33389a5))
- Add `ActionInteractor::Errors` tests ([commit](https://github.com/ryohashimoto/lightrails/commit/36d12fbcc5af96373c67463f50cede78c08bc937))
- Check if the errors are empty in `ActionInteractor::Base` ([commit](https://github.com/ryohashimoto/lightrails/commit/7f995f7757bea6150ffd5954bc066c778829d677))
- Add `ActionInteractor::Errors` ([commit](https://github.com/ryohashimoto/lightrails/commit/c51618ec42531b5b12fd7719da841a834730834c))
- Get result by key name's shortcut method. ([commit](https://github.com/ryohashimoto/lightrails/commit/22a1041bec745b1ecdc06b98c486b6a1b329343e))
- Implement `add`, `delete` and `each` methods. ([commit](https://github.com/ryohashimoto/lightrails/commit/650a9d4129c6f2f08afaf82b7807e578b7597e04))

## 0.0.1 - 0.0.17.3

- Prototyping Release
  Use your own risk.
