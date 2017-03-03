require 'json'
require 'pry'

module KupongIntegration  
  class Service
    DEFAULT_API_URL = 'https://api.kupong.se/v1.5/coupons'.freeze
    
    DEFAULT_SETTINGS = {}.freeze
    DEFAULT_PARAMS   = {}.freeze
    DEFAULT_API_PATH = ''.freeze
    
    SETTINGS_ATTRIBUTES = %i(
      authorization
      coupon_id
    )
    
    SUCCESS_CODE = 200
    CREATED_CODE = 201
    
    attr_reader :settings, :params, :timestamp 
    
    def self.config(api_url: nil)
      @@api_url = api_url || DEFAULT_API_URL
    end
      
    def initialize(settings: DEFAULT_SETTINGS, params: DEFAULT_PARAMS)
      @settings  = settings
      @params    = params
      @timestamp = Time.now.to_i.to_s
    end
    
    def call 
      response = create_coupon
      created?(response) ? send_coupon(response) : response
    end
    
    private
    
    def api_url 
      @@api_url
    end
    
    def create_coupon
      api_call(payload: create_payload)
    end
    
    def send_coupon(response)
      coupon_code = response['coupon_code']
      api_call(api_path: '/send', payload: send_payload(coupon_code))
    end
    
    def api_call(api_path: DEFAULT_API_PATH, payload:) 
      RestClient.post(api_url + api_path, payload.to_json, headers)
    rescue RestClient::Exception => error
      error
    end
    
    def created?(response)
      response.code == CREATED_CODE
    end
    
    def headers 
      {
        content_type:  :json,
        accept:        :json,
        authorization: authorization
      }
    end
    
    def create_payload 
      {
        msisdn:     msisdn,
        couponID:   coupon_id, 
        identifier: identifier
      }
    end 
    
    def send_payload(coupon_code)      
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
    
    def send_on
      DateTime.now
    end
  end
end