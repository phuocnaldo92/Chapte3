require File.expand_path("../boot", __FILE__)
require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module Chapter3
  class Application < Rails::Application
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
