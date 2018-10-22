# Lightrails

Lightrailsは、Action InteractorやActiveRepresenterを含む便利なライブラリで、  
Ruby on Railsアプリケーションにより細分化されたレイヤーを追加します。

## 始める

`lightrails`をRailsプロジェクトのGemfileに追加し`bundle install`を実行します。

```ruby
gem "lightrails"
```

ジェネレーターを実行します。

```
$ bin/rails generate lightrails:install
```

## Action Facade

コントローラで複数のデータを取得するためのシンプルなインターフェース（ファサード）を提供します。

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

class MypageController < ApplicationController
  # #retrieveメソッドを使用するために必要
  include ActionFacade::Retrieval

  def index
    facade = Mypage::IndexFacade.new(current_user: current_user)
    # インスタンス変数をアサインする
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

ファサードを作成するには、ジェネレーターを使用することができます。

```
$ bin/rails generate facade mypage/index
```

## Action Interactor

Railsアプリケーションに標準化されたサービスレイヤー（インタラクター）を追加します。

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
    # 複雑なビジネスロジックを記述
    # 結果をセットする
    results(user: User.new(name: params[:name]))
    success!
  end
end

interactor = RegistrationInteractor.execute(name: "John")
interactor.success?   # => true
interactor.finished?  # => true
user = interactor.result[:user]
user.name # => 'John'
```

インタラクターを作成するには、ジェネレーターを使用することができます。

```
$ bin/rails generate interactor registration
```

## Active Representer

Railsアプリケーションに、'代わりとなる'モデルレイヤー(リプレゼンター)を追加します。
ハッシュのようなオブジェクト（OpenStruct, Hashie::Mashなど）を以下のようにラップすることができます。

```ruby
class ActivityRepresenter < ApplicationRepresenter
  def created_on
    created_at.to_date
  end
end

class UserRepresenter < ApplicationRepresenter
  attribute :first_name, :string
  attribute :last_name, :string
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

リプレゼンターを作成するために、ジェネレーターを使用することができます。

```
$ bin/rails generate representer user
$ bin/rails g representer activity
```

## ライセンス

MIT License. Copyright 2018 Ryo Hashimoto.
