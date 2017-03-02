module KupongIntegration
  class Service
    DEFAULT_API_URL = 'https://api.kupong.se/v1.5/coupons'.freeze
    
    DEFAULT_SETTINGS = {}.freeze
    DEFAULT_PARAMS   = {}.freeze
    DEFAULT_APU_PATH = ''.freeze
    
    SUCCESS_CODE = 200
    CREATED_CODE = 201
    
    attr_reader :settings, :params, :timestamp 
    
    def self.config(api_url: nil)
      @@api_url = api_url || DEFAULT_API_URL
    end
      
    def initialize(settings: DEFAULT_SETTINGS, params: DEFAULT_PARAMS)
      @settings  = settings.with_indifferent_access
      @params    = params.with_indifferent_access
      @timestamp = DateTime.now.to_i.to_s
    end
    
    def call 
      response = create_coupon
      created?(response) ? send_coupon : response
    end
    
    private
    
    def api_url 
      @@api_url
    end
    
    def create_coupon
      api_call(payload: create_payload)
    end
    
    def send_coupon
      api_call(api_path: '/send', payload: send_payload)
    end
    
    def api_call(api_path: DEFAULT_APU_PATH, payload:) 
      RestClient.post(api_url + api_path, payload.to_json, headers)
    rescue RestClient::Exception => error
      error.http_code
    end
    
    def created?(response)
      response == CREATED
    end
    
    def headers 
      {
        content_type:  :json,
        accept:        :json,
        authorization: authorisation
      }
    end
    
    def create_payload 
      {
        msisdn:     msisdn,
        couponID:   coupon_id, 
        identifier: identifier
      }
    end 
    
    def send_payload
      {
        couponCode: coupon_code,
        identifier: identifier, 
        sendOn:     send_on
      }
    end
    
    def authorization
      settings[:authorization]
    end
    
    def msisdn
      params[:phone]
    end
      
    def coupon_id
      settings[:coupon_id]
    end
    
    def identifier
      @id ||= Digest::SHA1.hexdigest(msisdn + timestamp)
    end
  end
end