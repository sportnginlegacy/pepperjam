module Pepperjam
  class Base
    include HTTParty
    format :xml 
    
    @@credentials = {}
    @@default_params = {}
    
    def initialize(params)
      raise ArgumentError, "Init with a Hash; got #{params.class} instead" unless params.is_a?(Hash)

      params.each do |key, val|
        instance_variable_set("@#{key}".intern, val)
        instance_eval " class << self ; attr_reader #{key.intern.inspect} ; end "
      end
    end
    
    def user_id=(id)
      @@credentials['user_id'] = id.to_s
    end
    
    def pass=(pass)
      @@credentials['pass'] = pass.to_s
    end
    
    
    class << self
      def base_url
        "https://webservices.pepperjamnetwork.com/"
      end
      
      def validate_params!(provided_params, available_params, default_params = {})
        params = default_params.merge(provided_params)
        invalid_params = params.select{|k,v| !available_params.include?(k.to_s)}.map{|k,v| k}
        raise ArgumentError.new("Invalid parameters: #{invalid_params.join(', ')}") if invalid_params.length > 0
      end
      
      def get_service(path, query, headers)
        query.keys.each{|k| query[k.to_s] = query.delete(k)}
        query.merge!({'target' => 'reports.sid', 'format' => 'csv', 'username' => credentials['username'], 'password' => credentials['password']})

        results = []
        
        begin
          response = get(path, :query => query, :timeout => 30)
        rescue Timeout::Error
          nil
        end

        unless validate_response(response) or response.response.body.blank?
          debugger
          str = response.response.body
          str = headers + "\n" + str
          
          results = FasterCSV.parse(str, {:col_sep => ",", :row_sep => "\n", :headers => true})
        end

        results.map{|r| self.new(r.to_hash)}
      end # get
      
      def credentials
        unless @@credentials && @@credentials.length > 0
          # there is no offline or test mode for Pepperjam - so I won't include any credentials in this gem
          config_file = ["config/pepperjam.yml", File.join(ENV['HOME'], '.pepperjam.yaml')].select{|f| File.exist?(f)}.first

          unless File.exist?(config_file)
            warn "Warning: config/pepperjam.yml does not exist. Put your PepperJam username and password in ~/.pepperjam.yml to enable live testing."
          else
            @@credentials = YAML.load(File.read(config_file))
          end
        end
        @@credentials
      end # credentails
      
      def validate_response(response)
        raise ArgumentError, "There was an error connecting to PepperJam's reporting server." if response.response.body.include?("error")
      end
      
      def first(params)
        find(params).first
      end
    
    end # self
  end # Base
end # Pepperjam