# Scraper Configuration
SCRAPER_CONFIG = {
  # Proxy rotation (add your proxy services here)
  proxies: [
    # Example proxy configurations:
    # { host: 'proxy1.example.com', port: 8080, user: 'username', password: 'password' },
    # { host: 'proxy2.example.com', port: 3128, user: nil, password: nil },
  ],
  
  # Rate limiting
  request_delays: {
    min: 2,
    max: 6,
    blocked_delay_min: 5,
    blocked_delay_max: 12
  },
  
  # Retry configuration
  max_retries: 3,
  timeout: 15,
  
  # User agent rotation
  rotate_user_agents: true,
  
  # Session persistence
  maintain_cookies: true,
  
  # Anti-detection features
  randomize_headers: true,
  simulate_human_behavior: true
}.freeze 