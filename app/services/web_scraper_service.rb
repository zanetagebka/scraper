require 'selenium-webdriver'
require 'nokogiri'

class WebScraperService
  def initialize(url:, fields:)
    @url = url
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

  attr_reader :url, :fields, :result
end 