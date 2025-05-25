require 'rails_helper'

RSpec.describe ScraperController, type: :controller do
  describe 'GET #extract' do
    let(:valid_params) do
      {
        url: 'https://example.com/product',
        fields: {
          price: '.price',
          title: '.title'
        }
      }
    end
    
    context 'with valid parameters' do
      before do
        allow(WebScraperService).to receive(:new).and_return(
          instance_double(WebScraperService, call: successful_result)
        )
      end
      
      it 'returns scraped data as JSON' do
        get :extract, params: valid_params, format: :json
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
          'price' => '$99.99',
          'title' => 'Sample Product'
        })
      end
    end
    
    context 'with missing URL parameter' do
      it 'returns bad request error' do
        get :extract, params: { fields: { price: '.price' } }, format: :json
        
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to include('required')
      end
    end
    
    context 'with invalid URL format' do
      it 'returns bad request error' do
        get :extract, params: {
          url: 'invalid-url',
          fields: { price: '.price' }
        }, format: :json
        
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to include('Invalid URL')
      end
    end
    
    context 'when scraping fails' do
      before do
        allow(WebScraperService).to receive(:new).and_return(
          instance_double(WebScraperService, call: failed_result)
        )
      end
      
      it 'returns error response' do
        get :extract, params: valid_params, format: :json
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to be_present
      end
    end
  end
  
  private
  
  def successful_result
    result = ScraperResult.new
    result.set_data({ price: '$99.99', title: 'Sample Product' })
    result
  end
  
  def failed_result
    result = ScraperResult.new
    result.add_error('Connection timeout')
    result
  end
end 