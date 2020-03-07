# Lightrails

![](https://github.com/ryohashimoto/lightrails/workflows/Ruby/badge.svg)

LightrailsはRuby on Railsアプリケーションにより細分化された構造を提供するクラス（Action Facade、Action InteractorやActive Representer）を含む便利なライブラリです。

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
  # #retrieveメソッドを使用するために必要
  include ActionFacade::Retrieval

  def index
    facade = Mypage::IndexFacade.new(current_user: current_user)
    # インスタンス変数をアサインする
    retrieve(facade, :active_users, :messages)
  end

  def messages
    # コントローラとアクション名前から推測されたFacadeからデータを取得することが可能
    # MyPageController#notifications => MyPage::NotificationsFacade
    payload = { current_user: current_user }
    retrieve_from(payload, :messages)
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

  def initialize(payload)
    @name = payload[:name]
  end
end

class RegistrationInteractor < ApplicationInteractor
  def execute
    return failure! unless payload[:name]
    # 複雑なビジネスロジックを記述
    # 結果をセットする
    results.add(:user, User.new(name: payload[:name]))
    successful!
  end
end

interactor = RegistrationInteractor.execute(name: "John")
interactor.successful?   # => true
interactor.finished?  # => true
user = interactor.results[:user]
user.name # => 'John'
```

インタラクターを作成するには、ジェネレーターを使用することができます。

```
$ bin/rails generate interactor registration
```

## Active Representer

オブジェクトを包んで、モデルのように使用できるクラスを提供します。
クラスに（デコレータパターンを使用して）独自のメソッドを追加することができます。
APIのレスポンスに対してや、単純なデコレータとして使用することができるでしょう。

これに加えて、属性として、`attr_field / attr_collection`を使用することができます。

### `attr_field`

追加のフィールドと型を宣言することができます。フィールドの値を取得したり、設定することができます。（宣言した型に変換されます。）内部的には、`ActiveModel::Attributes`を使用しています。

### `attr_collection`

has manyの関連のように、下位のオブジェクトの配列を宣言することができます。
もし、下位のオブジェクトに対応するRepresenterが見つかった場合は、配列内の要素は、そのRepresenterでラップされます。

以下は、ハッシュのようなオブジェクト（`OpenStruct`, `Hashie::Mash`など）をラップする例です。

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

Representerを作成するために、Railsのジェネレーターを使用することができます。

```
$ bin/rails generate representer user
$ bin/rails g representer activity
```

## ライセンス

MIT License. Copyright 2018-2020 Ryo Hashimoto.
