require 'kupong_integration/service'
require 'rest-client'

describe KupongIntegration::Service do 
  let(:settings) { { authorization: 'abcd', coupon_id: '1'} }
  let(:phone)    { '81531415926' }
  
  let(:service) do
    KupongIntegration::Service.new(settings: settings, phone: phone)
  end
  
  let(:create_api_url) { KupongIntegration::Service::DEFAULT_API_URL }
  let(:send_api_url)   { create_api_url + KupongIntegration::Service::SEND_API_PATH }
  
  before { KupongIntegration::Service.config } 
  
  describe '#call' do 
    let(:created_response) { double }
    let(:created_code)     { KupongIntegration::Service::CREATED_CODE }
    
    let(:send_response) { double }
    let(:send_code)     { KupongIntegration::Service::SUCCESS_CODE }
        
    context 'creating a coupon was not successful' do 
      before do 
        allow(created_response).to receive(:code).and_return(500)
        allow(RestClient).to receive(:post).and_return(created_response)
        allow(service).to receive(:retrieve_coupon_code).and_return(nil)
      end
      
      it { expect(service.call.code).to eq 500 }
    end

    context 'creating a coupon was successful' do 
      before do         
        allow(created_response).to receive(:code).and_return(created_code)
        allow(RestClient)
          .to receive(:post)
          .with(create_api_url, anything, anything)
          .and_return(created_response)
          
        allow(service).to receive(:retrieve_coupon_code).and_return('abc')
      end
      
      context 'sending a coupon was successful' do 
        before do
          allow(send_response).to receive(:code).and_return(send_code)
          allow(RestClient)
            .to receive(:post)
            .with(send_api_url, anything, anything)
            .and_return(send_response)
        end
        
        it { expect(service.call.code).to eq send_code }
      end
      
      context 'sending a coupon was not successful' do
        before do 
          allow(send_response).to receive(:code).and_return(500)
          allow(RestClient)
            .to receive(:post)
            .with(send_api_url, anything, anything)
            .and_return(send_response)
        end
        
        it { expect(service.call.code).to eq 500 }
      end
    end
  end
end