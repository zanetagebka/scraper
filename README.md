# Scraper App

A Ruby on Rails web scraping service that extracts data from web pages using CSS selectors and meta tag names. It uses Selenium and Nokogiri to support JavaScript-rendered content and provides a simple API and web UI for scraping.

## Features
- Extracts data using CSS selectors
- Extracts meta tag content (e.g., keywords, twitter:image)
- Supports dynamic (JavaScript) pages via Selenium
- Caches page downloads for optimization
- Simple web UI and JSON API

## Requirements
- Ruby 3.x
- Rails 7.x
- Chrome browser (for Selenium)
- ChromeDriver (compatible with your Chrome version)
- Redis (recommended for Rails cache in production)

## Setup
1. **Clone the repository:**
   ```sh
   git clone git@github.com:zanetagebka/scraper.git
   cd scraper
   ```
2. **Install dependencies:**
   ```sh
   bundle install
   ```
3. **Set up the database (if needed):**
   ```sh
   rails db:setup
   ```
4. **Start the Rails server:**
   ```sh
   rails server
   ```

## Usage

### Web UI
- Visit `http://localhost:3000/` to use the web interface.
- Enter the URL to scrape and a JSON object for fields, e.g.:
  ```json
  {
    "price": ".price-box__price",
    "rating_count": ".ratingCount",
    "rating_value": ".ratingValue",
    "meta": ["keywords", "twitter:image"]
  }
  ```
- The result will show extracted data and meta tags.

### API
- **Endpoint:** `/data`
- **Method:** `GET` or `POST`
- **Parameters:**
  - `url`: The URL to scrape
  - `fields`: Hash of field names to CSS selectors (as JSON or query params)
    - You can include a `meta` key as an array or comma-separated string for meta tags

**Example GET request:**
```
/data?url=https://example.com&fields[price]=.price&fields[meta][]=keywords&fields[meta][]=description
```

**Example POST request:**
```json
{
  "url": "https://example.com",
  "fields": {
    "price": ".price",
    "meta": ["keywords", "description"]
  }
}
```

**Response:**
```json
{
  "price": "$99.99",
  "meta": {
    "keywords": "...",
    "description": "..."
  }
}
```

## Development
- Tests can be added in the `spec/` directory (RSpec recommended).
- Selenium and ChromeDriver must be installed and available in your PATH.
- For caching, configure `Rails.cache` (Redis recommended for production).

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
MIT
