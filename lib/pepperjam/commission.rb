module Pepperjam
  class Commission < Base
    class << self
      def service_url
        base_url
      end
      
      def find(params = {})
        validate_params!(params, %w{startDate endDate website})
        website = ",website" if params.include?("website")
        headers = "program_name,date,sid,epc,impressions,clicks,merchant_revenue,total_commission,creative_id,creative_type#{website}"
        get_service(service_url, params, headers)
      end
      
    end # << self
  end # class
end # module