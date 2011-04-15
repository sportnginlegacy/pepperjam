module Pepperjam
  class Commission < Base
    class << self
      def service_url
        base_url
      end
      
      def find(params = {})
        validate_params!(params, %w{startDate endDate website})
        get_service(service_url, params)
      end
      
    end # << self
  end # class
end # module