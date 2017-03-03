require 'kupong_integration/service'
require 'rest-client'

describe KupongIntegration::Service do 
  let(:settings) { { authorization: 'abcd', coupon_id: '1'} }
  let(:phone)    { '4681531415926' }
  
  let(:service) do
    KupongIntegration::Service.new(settings: settings, phone: phone)
  end
   
  before { KupongIntegration::Service.config } 
  
  describe '#call' do 
    let(:created_response) { double }
    let(:created_code)     { KupongIntegration::Service::CREATED_CODE }
    
    let(:send_response) { double }
    let(:sent_code)     { KupongIntegration::Service::SUCCESS_CODE }
        
    context 'creating a coupon was successful' do 
      before do 
        allow(created_response).to receive(:code).and_return(created_code)
        allow(RestClient).to receive(:post).and_return(created_response)
      end
      
      it 'calls send_coupon' do 
        expect(service).to receive(:send_coupon)
        service.call
      end
    end
    
    context 'creating a coupon was not successful' do 
      before do 
        allow(created_response).to receive(:code).and_return(500)
        allow(RestClient).to receive(:post).and_return(created_response)
      end
      
      it 'does not call send_coupon' do 
        expect(service).not_to receive(:send_coupon)
        service.call
      end
    end
    
    context 'after a successfully created coupon' do     
      before do 
        allow(created_response).to receive(:code).and_return(created_code)
        allow(created_response).to receive(:[]).and_return({ 'coupon_code': '42' })
        allow(service).to receive(:create_coupon).and_return(created_response)
      end
      
      context 'sending the coupon was successful' do 
        before do 
          allow(send_response).to receive(:code).and_return(sent_code)
          allow(RestClient).to receive(:post).and_return(send_response)
        end

        it 'returns the success code' do 
          expect(service.call.code).to eq sent_code
        end
      end
      
      context 'sending the coupon was not successfull' do 
        before do 
          allow(send_response).to receive(:code).and_return(500)
          allow(RestClient).to receive(:post).and_return(send_response)
        end

        it 'returns 500' do 
          expect(service.call.code).to eq 500
        end
      end
    end
  end
end