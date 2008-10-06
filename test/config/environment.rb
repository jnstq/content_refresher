RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.load_paths += ['../lib']
  # config.plugin_paths += ["#{Rails.root}/.."]
  config.time_zone = 'UTC'
  # config.reload_plugins = true
  config.gem 'rspec-rails', :lib => 'spec'
  config.action_controller.session = {
    :session_key => '_test_session',
    :secret      => '76907ea1acc5a555d7dd14001b852cb4e39cb8dea23154cedcdb1a87413438e82314feee305c470d8cc2de165e1343826ba1d7941854343dbf53cd99216f8024'
  }
end
