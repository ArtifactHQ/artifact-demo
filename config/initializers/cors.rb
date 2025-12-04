# Configure CORS for cross-origin requests from marketing site
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Allow localhost for development and artifact.new for production
    origins 'http://localhost:3000', 
            'https://localhost:3000',
            'https://artifact.new', 
            'http://artifact.new'
    
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end

