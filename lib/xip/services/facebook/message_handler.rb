# frozen_string_literal: true

require 'xip/services/facebook/events/message_event'
require 'xip/services/facebook/events/postback_event'
require 'xip/services/facebook/events/message_reads_event'
require 'xip/services/facebook/events/messaging_referral_event'

module Xip
  module Services
    module Facebook

      class MessageHandler < Xip::Services::BaseMessageHandler

        attr_reader :service_message, :params, :headers, :facebook_message

        def initialize(params:, headers:)
          @params = params
          @headers = headers
        end

        def coordinate
          if facebook_is_validating_webhook?
            respond_with_validation
          else
            # Queue the request processing so we can respond quickly to FB
            # and also keep track of this message
            Xip::Services::HandleMessageJob.perform_async(
              'facebook',
              params,
              headers
            )

            # Relay our acceptance
            [200, 'OK']
          end
        end

        def process
          @service_message = ServiceMessage.new(service: 'facebook')
          @facebook_message = params['entry'].first['messaging'].first
          service_message.sender_id = get_sender_id
          service_message.target_id = get_target_id
          service_message.timestamp = get_timestamp
          process_facebook_event

          service_message
        end

        private

          def facebook_is_validating_webhook?
            params['hub.verify_token'].present?
          end

          def respond_with_validation
            if params['hub.verify_token'] == Xip.config.facebook.verify_token
              [200, params['hub.challenge']]
            else
              [401, "Verify token did not match environment variable."]
            end
          end

          def get_sender_id
            facebook_message['sender']['id']
          end

          def get_target_id
            facebook_message['recipient']['id']
          end

          def get_timestamp
            Time.at(facebook_message['timestamp']/1000).to_datetime
          end

          def process_facebook_event
            if facebook_message['message'].present?
              message_event = Xip::Services::Facebook::MessageEvent.new(
                service_message: service_message,
                params: facebook_message
              )
            elsif facebook_message['postback'].present?
              message_event = Xip::Services::Facebook::PostbackEvent.new(
                service_message: service_message,
                params: facebook_message
              )
            elsif facebook_message['read'].present?
              message_event = Xip::Services::Facebook::MessageReadsEvent.new(
                service_message: service_message,
                params: facebook_message
              )
            elsif facebook_message['referral'].present?
              message_event = Xip::Services::Facebook::MessagingReferralEvent.new(
                service_message: service_message,
                params: facebook_message
              )
            end

            message_event.process
          end
      end

    end
  end
end
