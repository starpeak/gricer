module Gricer
  # Gricer's ActionController enhancements
  module ActionController 
    # Gricer's ActionController base enhancements
    module Base

      # Include the helper functions into controllers.
      def self.included(base)
        base.module_eval do
          helper_attr :gricer_user_id
        end
      end

      # This function is a stub for the mechanism to include the current
      # users id into the statistics of gricer.
      # @example The most common case would be to pass the current_user's id. So this is the code you should add to your appliction_controller
      #   def gricer_user_id
      #     current_user.try(:id)
      #   end
      # @return [Integer] 
      def gricer_user_id
        nil
      end
    end
  end
end

ActionController::Base.send :include, Gricer::ActionController::Base
