# frozen_string_literal: true

module ActionFacade
  # == Action \Facade \Base
  #
  # This is only a base class for extract data from input (payload).
  # This can be inherited to another class and you can implement
  # some mothods for obtaining data.
  # In Ruby on Rails, you can implemented Active Record query methods
  # to the inherited class.
  # For example
  #
  #   class Mypage::IndexFacade < ActionFacade::Base
  #     attr_reader :current_user
  #
  #     def initialize(payload)
  #       @current_user = payload[:current_user]
  #     end
  #
  #     def active_users
  #       @active_users ||= User.active.order(login_at: :desc).limit(10)
  #     end
  #
  #     def messages
  #       @messages ||= current_user.messages.order(created_at: :desc).limit(10)
  #     end
  #   end
  #
  class Base
    attr_reader :payload

    # Initialize with payload
    def initialize(payload)
      @payload = payload
    end
  end
end
