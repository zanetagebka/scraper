class ScraperController < ApplicationController
  before_action :validate_params, only: [:extract]
  
  def index; end
  
  def extract
    result = WebScraperService.new(**scraper_params).call
    
    if result.success?
      render json: result.data, status: :ok
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end
  
  private
  
  def scraper_params
    {
      url: params[:url],
      fields: params[:fields] || {}
    }
  end
  
  def validate_params
    unless params[:url].present? && params[:fields].present?
      render json: { error: 'URL and fields parameters are required' }, 
             status: :bad_request
      return
    end
    
    unless valid_url?(params[:url])
      render json: { error: 'Invalid URL format' }, 
             status: :bad_request
      return
    end
  end
  
  def valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end
end 