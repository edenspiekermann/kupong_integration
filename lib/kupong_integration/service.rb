require 'json'

module KupongIntegration  
  class Service
    DEFAULT_API_URL = 'https://api.kupong.se/v1.5/coupons'.freeze
    SEND_PATH = '/send'.freeze
    
    PLUS = '+'.freeze
    CODE = '46'.freeze
    COUNTRY_CODE = (PLUS + CODE).freeze
    EMPTY_STRING = ''.freeze
    
    DEFAULT_SETTINGS = {}.freeze
    DEFAULT_API_PATH = ''.freeze
    EMPTY_HASH       = {}.freeze
    
    SETTINGS_ATTRIBUTES = %i(
      authorization
      coupon_id
    )
    
    SUCCESS_CODE = 200
    CREATED_CODE = 201
    
    SANITIZE = '+ -'.freeze
    
    attr_reader :settings, :msisdn, :timestamp
    
    def self.config(api_url: nil)
      @@api_url = api_url || DEFAULT_API_URL
    end
      
    def initialize(settings: DEFAULT_SETTINGS, phone:)
      @settings  = settings
      @msisdn    = sanitize(phone)
      @timestamp = Time.now.to_i.to_s
    end
    
    def call 
      response = create_coupon
      send_coupon(response)
    end
    
    private
    
    def api_url 
      @@api_url ||= DEFAULT_API_URL
    end
    
    def create_coupon
      api_call(payload: create_payload)
    end
    
    def send_coupon(response)
      coupon_code = retrieve_coupon_code(response)
      return response if coupon_code.nil?
      
      api_call(api_path: SEND_PATH, payload: send_payload(coupon_code))
    end
    
    def api_call(api_path: DEFAULT_API_PATH, payload:)
      RestClient.post(api_url + api_path, payload.to_json, headers)
    rescue RestClient::Exception => error
      error.response
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
        couponId:   coupon_id,
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
    
    # remove the '+' sign & add '49' in case it's not there
    def sanitize(phone)
      phone = phone.tr(SANITIZE, EMPTY_STRING)
      phone.start_with?(CODE) ? phone : CODE + phone
    end

    def authorization
      settings[:authorization]
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
    
    def retrieve_coupon_code(response)
      parsed_response = 
      begin 
        JSON.parse(response)
      rescue JSON::ParserError => e
        EMPTY_HASH
      end
      
      parsed_response['couponCode']
    end
  end
end