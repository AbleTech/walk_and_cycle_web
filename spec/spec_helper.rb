require 'rubygems'
require 'middleman/rack'
require 'rspec/expectations'
require 'capybara/rspec'

Capybara.save_and_open_page_path = File.join("tmp", "capybara")
Capybara.ignore_hidden_elements = false
Capybara.app = Middleman.server
