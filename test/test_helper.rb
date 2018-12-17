require 'simplecov'
SimpleCov.start

ENV['RACK_ENV'] = 'test'
ENV['JUNO_PROBE_DISABLE_REGISTRATION'] = 'true'

require 'test/spec'
require 'rack/test'
require 'minitest/autorun'
require 'rack-minitest/test'
require 'mocha/minitest'

require_relative '../app'
