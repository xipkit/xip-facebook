# frozen_string_literal: true

require 'xip/services/facebook/client'

module Xip
  module Services
    module Facebook

      class Setup

        class << self
          def trigger
            reply_handler = Xip::Services::Facebook::ReplyHandler.new
            reply = reply_handler.messenger_profile
            client = Xip::Services::Facebook::Client.new(reply: reply, endpoint: 'messenger_profile')
            client.transmit
          end
        end

      end

    end
  end
end
