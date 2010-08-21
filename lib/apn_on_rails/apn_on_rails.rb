require 'socket'
require 'openssl'
require 'configatron'

module ApnOnRails
  class Railtie < Rails::Railtie
    initializer 'configuration' do |app|
      configatron.apn.set_default(:passphrase, '')
      configatron.apn.set_default(:port, 2195)

      configatron.apn.feedback.set_default(:passphrase, configatron.apn.passphrase)
      configatron.apn.feedback.set_default(:port, 2196)

      if Rails.env.production?
        configatron.apn.set_default(:host, 'gateway.push.apple.com')
        configatron.apn.set_default(:cert, File.join(Rails.root, 'config', 'apple_push_notification_production.pem'))

        configatron.apn.feedback.set_default(:host, 'feedback.push.apple.com')
        configatron.apn.feedback.set_default(:cert, configatron.apn.cert)
      else
        configatron.apn.set_default(:host, 'gateway.sandbox.push.apple.com')
        configatron.apn.set_default(:cert, File.join(Rails.root, 'config', 'apple_push_notification_development.pem'))

        configatron.apn.feedback.set_default(:host, 'feedback.sandbox.push.apple.com')
        configatron.apn.feedback.set_default(:cert, configatron.apn.cert)
      end
    end
  end
end

module APN # :nodoc:

  module Errors # :nodoc:

    # Raised when a notification message to Apple is longer than 256 bytes.
    class ExceededMessageSizeError < StandardError

      def initialize(message) # :nodoc:
        super("The maximum size allowed for a notification payload is 256 bytes: '#{message}'")
      end

    end

  end # Errors

end # APN
