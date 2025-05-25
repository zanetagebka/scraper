require 'selenium-webdriver'
require 'nokogiri'

class WebScraperService
  def initialize(url:, fields:)
    @url = url
    @meta = (fields.delete('meta') || fields.delete(:meta) || [])
    @meta = @meta.split(',') if @meta.is_a?(String)
    @meta = @meta.map(&:strip) if @meta.is_a?(Array)
    @fields = fields
    @result = ScraperResult.new
  end

  def call
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--window-size=1400,900')
    options.add_argument('--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')

    driver = Selenium::WebDriver.for :chrome, options: options
    driver.navigate.to @url
    sleep 2

    doc = Nokogiri::HTML(driver.page_source)
    data = {}

    if @meta.present?
      meta_data = {}
      Array(@meta).each do |meta_name|
        meta_tag = doc.css('meta').find do |meta|
          %w[name property id].any? { |attr| meta[attr].to_s.strip.downcase == meta_name.to_s.strip.downcase }
        end
        meta_data[meta_name] = meta_tag&.[]('content')
      end
      data['meta'] = meta_data
    end

    @fields.each do |key, selector|
      el = doc.css(selector).first
      data[key] = el&.text&.strip
    end
    @result.set_data(data)
    driver.quit
    @result
  rescue => e
    driver&.quit
    @result.add_error("Failed to scrape data: #{e.message}")
    @result
  end

  private

  attr_reader :url, :fields, :meta, :result
end 