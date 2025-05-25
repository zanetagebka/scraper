class ScraperResult
  attr_reader :data, :error
  
  def initialize
    @data = {}
    @error = nil
    @success = false
  end
  
  def set_data(extracted_data)
    @data = extracted_data
    @success = true
  end
  
  def add_error(error_message)
    @error = error_message
    @success = false
  end
  
  def success?
    @success
  end
end 