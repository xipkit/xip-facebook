# frozen_string_literal: true

module Xip
  module Services
    module Facebook
      module Version
        def self.version
          File.read(File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'VERSION')).strip
        end
      end

      VERSION = Version.version
    end
  end
end
