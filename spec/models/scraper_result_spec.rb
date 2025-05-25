require 'rails_helper'

RSpec.describe ScraperResult do
  subject(:result) { described_class.new }
  
  describe '#success?' do
    it 'returns false by default' do
      expect(result.success?).to be false
    end
    
    it 'returns true after setting data' do
      result.set_data({ key: 'value' })
      expect(result.success?).to be true
    end
    
    it 'returns false after adding error' do
      result.add_error('Something went wrong')
      expect(result.success?).to be false
    end
  end
  
  describe '#set_data' do
    it 'stores the provided data' do
      data = { price: '$10', title: 'Product' }
      result.set_data(data)
      
      expect(result.data).to eq(data)
    end
  end
  
  describe '#add_error' do
    it 'stores the error message' do
      error_message = 'Network error'
      result.add_error(error_message)
      
      expect(result.error).to eq(error_message)
    end
  end
end 