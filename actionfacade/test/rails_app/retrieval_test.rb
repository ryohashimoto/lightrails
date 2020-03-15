# frozen_string_literal: true

require_relative "../test_helper"
require_relative "./test_app"

module RailsApp
  USER_DATA = [{ id: 1, name: "john" }, { id: 2, name: "bob" }]
end

module Home; end

class Home::IndexFacade < ActionFacade::Base
  def all_users
    RailsApp::USER_DATA
  end
end

class HomeController < ActionController::Base
  include Rails.application.routes.url_helpers
  include ActionFacade::Retrieval

  def index
    case params[:retrieve]
    when "facade"
      facade = Home::IndexFacade.new
      retrieve(facade, :all_users)
    when "string"
      retrieve("all_users")
    when "symbol"
      retrieve(:all_users)
    when "hash"
      retrieve({}, :all_users)
    else
      retrieve_from({}, :all_users)
    end
    render plain: @all_users
  end
end

require "rack/test"

module RailsApp; end

class RailsApp::RetrievalTest < Test::Unit::TestCase
  include Rack::Test::Methods

  test "@all_users is set after retrieve_from({}, :all_users)" do
    get "/"
    assert_equal(last_response.body, RailsApp::USER_DATA.to_s)
  end

  test "@all_users is set after retrieve(facade, :all_users)" do
    get "/", params: { retrieve: "facade" }
    assert_equal(last_response.body, RailsApp::USER_DATA.to_s)
  end

  test "@all_users is set after retrieve(:all_users)" do
    get "/", params: { retrieve: "symbol" }
    assert_equal(last_response.body, RailsApp::USER_DATA.to_s)
  end

  test "@all_users is set after retrieve(\"all_users\")" do
    get "/", params: { retrieve: "string" }
    assert_equal(last_response.body, RailsApp::USER_DATA.to_s)
  end

  test "@all_users is set after retrieve({}, :all_users)" do
    get "/", params: { retrieve: "hash" }
    assert_equal(last_response.body, RailsApp::USER_DATA.to_s)
  end

  private

  def app
    Rails.application
  end
end
