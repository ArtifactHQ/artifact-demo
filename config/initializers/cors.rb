# Configure CORS for cross-origin requests from marketing site and Fly.io deployments
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Allow localhost for development, artifact.new, and Fly.io deployments for production
    origins 'http://localhost:3000', 
            'https://localhost:3000',
            'https://artifact.new', 
            'http://artifact.new',
            'https://artifact-demo.fly.dev',
            'https://artifactmarketingwebsite.fly.dev'
    
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end

