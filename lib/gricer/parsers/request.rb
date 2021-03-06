module Gricer
  module Parsers
    class Request
      def self.get_info(request)  
        info = {}
        
        info[:ip_address]   = request.remote_ip
        info[:agent_header] = request.headers['HTTP_USER_AGENT']
        info[:referer]      = request.headers['HTTP_X_FORWARDED_REFERER'] || request.headers['HTTP_REFERER']

        info[:host]         = request.host
        info[:path]         = request.path
        info[:method]       = request.request_method
        info[:protocol]     = request.protocol.sub(/[:\/]*$/, '').upcase
        info[:locale]       = I18n.locale

        info[:req_locale]   = " #{request.headers['HTTP_ACCEPT_LANGUAGE']} "
                              .match(/[^A-Za-z1-9]([A-Za-z]{2}(-[A-Za-z]{2})?)[^A-Za-z1-9]/)
                              .to_a[1]

        return info
      end
    end
  end
end