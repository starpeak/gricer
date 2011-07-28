module Gricer
  module ActionController #:nodoc:
    module Base #:nodoc:

      def self.included(base)
        base.module_eval do
          helper_attr :gricer_user
        end
      end

      def gricer_user_id
        nil
      end
    end
  end
end

ActionController::Base.send :include, Gricer::ActionController::Base
