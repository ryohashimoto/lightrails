# frozen_string_literal: true

require_relative "../test_helper"
require_relative "./test_app"

USER_DATA = [{ id: 1, name: "john" }, { id: 2, name: "bob" }]

module Home; end

class Home::IndexFacade < ActionFacade::Base
  def all_users
    USER_DATA
  end
end

class HomeController < ActionController::Base
  include Rails.application.routes.url_helpers
  include ActionFacade::Retrieval

  def index
    retrieve_from({}, :all_users)
    render plain: @all_users
  end
end

require "rack/test"

module RailsApp; end

class RailsApp::RetrievalTest < Test::Unit::TestCase
  include Rack::Test::Methods

  test "@all_users is set after retrieve_from({}, :all_users)" do
    get "/"
    assert_equal(last_response.body, USER_DATA.to_s)
  end

  private

  def app
    Rails.application
  end
end
