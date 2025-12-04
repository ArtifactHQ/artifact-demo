# Rails 8 Template - AI-Ready Development Environment

A clean, containerized Rails 8.0.2 template optimized for AI-assisted development with Claude Agents SDK. Spin up fresh development environments in seconds, perfect for rapid prototyping and AI-driven coding sessions.

## 🎯 Purpose

This template provides:
- ✅ **Pre-configured Rails 8** with modern defaults
- ✅ **Containerized development** via Docker
- ✅ **AI-optimized** for Claude Agents SDK workflows
- ✅ **Zero configuration** - ready to code immediately
- ✅ **Bootstrap 5.3** pre-integrated
- ✅ **Hotwire** (Turbo + Stimulus) for modern JavaScript
- ✅ **Solid gems** for production-ready caching, queues, and WebSockets

## 🚀 Quick Start

### Option 1: Docker (Recommended for AI Development)

```bash
# Build the development image (one time)
./bin/docker-build

# Start a development container
./bin/docker-start

# Access at http://localhost:3000
```

### Option 2: Docker Compose (For full development environment)

```bash
# Start Rails server + CSS watcher
./bin/docker-compose-up

# Access at http://localhost:3000
```

### Option 3: Native (Traditional Rails development)

```bash
# Install dependencies
bin/setup

# Start development server (includes CSS watcher)
# This starts automatically after bin/setup
# Or manually: bin/dev
```

## 📦 What's Included

### Core Stack
- **Ruby:** 3.3.0
- **Rails:** 8.0.2
- **Database:** SQLite3 (development), configured for PostgreSQL/MySQL switch
- **Server:** Puma with automatic reloading
- **Assets:** Propshaft + Importmap (no Node.js required)
- **CSS:** DartSass + Bootstrap 5.3.3
- **JavaScript:** Hotwire (Turbo + Stimulus)

### Production Ready
- **solid_cache** - Database-backed caching (replaces Redis)
- **solid_queue** - Database-backed job processing (replaces Sidekiq)
- **solid_cable** - Database-backed Action Cable (WebSockets)
- **Kamal** - Docker deployment orchestration
- **Thruster** - HTTP caching and X-Sendfile acceleration

### Development Tools
- **Brakeman** - Security vulnerability scanning
- **RuboCop Rails Omakase** - Ruby style guide enforcement
- **System Tests** - Capybara + Selenium for browser testing
- **Debug gem** - Modern Ruby debugging

## 🐳 Docker Development (AI-Optimized)

### Building the Image

```bash
./bin/docker-build
```

This creates a ~1.4GB development image with:
- All gems pre-installed
- Database initialized
- Development tools ready
- Bootstrap configured
- Fast boot times

### Container Management Scripts

#### `./bin/docker-start [name] [port]`
Start a development container.
```bash
./bin/docker-start                    # Default: rails8-dev on port 3000
./bin/docker-start my-app 3001       # Custom name and port
```

#### `./bin/docker-stop [name] [remove]`
Stop a container (optionally remove it).
```bash
./bin/docker-stop rails8-dev          # Stop container
./bin/docker-stop rails8-dev remove   # Stop and remove
```

#### `./bin/docker-compose-up`
Start the full development environment (Rails + CSS watcher).
```bash
./bin/docker-compose-up

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

#### `./bin/docker-new-session [name] [port]`
Create an isolated AI coding session.
```bash
./bin/docker-new-session user-123-app
./bin/docker-new-session prototype-v1 3001
```

This is perfect for:
- Spinning up multiple isolated environments
- AI agent-driven development
- Rapid prototyping without conflicts
- Client-specific development sessions

### Working Inside Containers

```bash
# Access container shell
docker exec -it rails8-dev bash

# Run Rails console
docker exec -it rails8-dev bin/rails console

# Run tests
docker exec -it rails8-dev bin/rails test

# View logs
docker logs -f rails8-dev
```

## 🎨 Frontend Development

### Bootstrap 5.3.3
Bootstrap is pre-configured and ready to use:

```erb
<!-- app/views/pages/home.html.erb -->
<div class="container">
  <h1 class="display-4">Welcome to Rails 8</h1>
  <div class="alert alert-primary">
    Bootstrap is working!
  </div>
  <button class="btn btn-success">Click Me</button>
</div>
```

### Custom Styles
Add your styles in `app/assets/stylesheets/application.scss`:

```scss
// Override Bootstrap variables
$primary: #ff6b6b;
$secondary: #4ecdc4;

@import "bootstrap";

// Your custom styles
.my-custom-class {
  background: $primary;
}
```

### JavaScript with Stimulus
Create controllers in `app/javascript/controllers/`:

```javascript
// app/javascript/controllers/greeting_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["name", "output"]
  
  greet() {
    this.outputTarget.textContent = 
      `Hello, ${this.nameTarget.value}!`
  }
}
```

Use in views:
```erb
<div data-controller="greeting">
  <input data-greeting-target="name" type="text">
  <button data-action="click->greeting#greet">Greet</button>
  <p data-greeting-target="output"></p>
</div>
```

## 🗄️ Database

### Development Database
SQLite3 is used by default:
- **Location:** `storage/development.sqlite3`
- **Advantages:** Zero configuration, fast, portable
- **Perfect for:** Development, prototyping, small apps

### Switching to PostgreSQL/MySQL

1. Update `Gemfile`:
```ruby
# gem "sqlite3", ">= 2.1"
gem "pg", "~> 1.5"  # PostgreSQL
# or
gem "mysql2", "~> 0.5"  # MySQL
```

2. Update `config/database.yml`:
```yaml
default: &default
  adapter: postgresql
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV['DB_USER'] %>
  password: <%= ENV['DB_PASSWORD'] %>
  host: <%= ENV['DB_HOST'] %>

development:
  <<: *default
  database: myapp_development
```

3. Rebuild container:
```bash
./bin/docker-build
```

## 🧪 Testing

### Run Tests
```bash
# In container
docker exec -it rails8-dev bin/rails test

# All tests
bin/rails test

# Specific file
bin/rails test test/models/user_test.rb

# System tests (browser)
bin/rails test:system
```

### Example Test
```ruby
# test/models/user_test.rb
require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should be valid with name and email" do
    user = User.new(name: "John", email: "john@example.com")
    assert user.valid?
  end
end
```

## 🔧 Common Tasks

### Generate a Scaffold
```bash
docker exec -it rails8-dev bin/rails generate scaffold Post title:string body:text
docker exec -it rails8-dev bin/rails db:migrate
```

### Add Authentication
```bash
# Add bcrypt to Gemfile (already uncommented)
# Add has_secure_password to User model

docker exec -it rails8-dev bin/rails generate model User email:string password_digest:string
docker exec -it rails8-dev bin/rails db:migrate
```

### Background Jobs
```bash
docker exec -it rails8-dev bin/rails generate job ProcessData

# Jobs automatically use Solid Queue (no Redis needed!)
```

### Add a New Gem
1. Add to `Gemfile`
2. Rebuild container: `./bin/docker-build`

## 📊 Container Architecture

### Image Layers (Optimized for Caching)
```
1. Base Ruby image (slim)
2. System dependencies
3. Ruby gems (cached until Gemfile changes)
4. Application code
5. Database initialization
6. Bootsnap precompilation
```

### Performance Characteristics
- **Build time:** ~2-4 minutes (first time)
- **Rebuild time:** ~10-30 seconds (with cache)
- **Container start:** ~3-5 seconds
- **Rails boot:** ~2-3 seconds
- **Hot reload:** Instant (volume mounted)

### Volume Mounts
```yaml
volumes:
  - .:/rails              # Live code editing
  - bundle_cache          # Preserve gems across rebuilds
  - rails_tmp             # Preserve temp files
```

## 🤖 AI Development Workflow

### For Claude Agents SDK

This template is optimized for AI-driven development:

1. **Quick spin-up:** Pre-built image ready in seconds
2. **Isolated sessions:** Each user/project gets own container
3. **Stateless containers:** No configuration drift
4. **Full Rails environment:** All tools available
5. **LLM instructions:** See `LLM_INSTRUCTIONS.md` for AI agent guidance

### Typical Workflow
```bash
# User requests new app
./bin/docker-new-session user-123-blog-app

# AI agent connects to container
docker exec -it rails-ai-user-123-blog-app bash

# AI agent codes, tests, iterates...
bin/rails generate scaffold Article title:string content:text
bin/rails db:migrate
bin/rails test

# Export final result
docker commit rails-ai-user-123-blog-app final-blog-app:v1

# Clean up
docker stop rails-ai-user-123-blog-app
docker rm rails-ai-user-123-blog-app
```

## 🔒 Security

### Container Security
- ✅ Runs as non-root user (`rails:rails`)
- ✅ Minimal base image (Ruby slim)
- ✅ No unnecessary packages
- ✅ Health checks enabled
- ✅ Brakeman security scanning included

### Application Security
```bash
# Run security scan
docker exec -it rails8-dev bin/brakeman

# Check code style
docker exec -it rails8-dev bin/rubocop
```

## 📈 Image Optimization

Current image: **~1.52GB** (development with all tools)

### Available Dockerfiles

1. **`Dockerfile.dev`** - Standard development image (1.52GB)
   - All development tools
   - Fast rebuilds with good caching
   - Recommended for most use cases

2. **`Dockerfile.dev-optimized`** - Advanced caching (1.52GB)
   - Multi-stage build with aggressive layer caching
   - BuildKit cache mounts for faster rebuilds
   - Best for CI/CD pipelines
   - Includes minimal runtime variant (~800MB)

3. **`Dockerfile`** - Production image (~200-300MB)
   - Minimal runtime dependencies
   - Optimized for deployment
   - No development tools

### Further Optimization Options

To optimize further:
1. Use multi-stage builds (production)
2. Remove development dependencies
3. Use Alpine Linux base (saves ~100MB)
4. Precompile all assets
5. Use `.dockerignore` to exclude unnecessary files

### Build with Optimized Dockerfile

```bash
# Build optimized version
docker build -f Dockerfile.dev-optimized --target development -t rails8-template-dev:latest .

# Or build minimal runtime
docker build -f Dockerfile.dev-optimized --target runtime-minimal -t rails8-template-runtime:latest .
```

## 🚢 Deployment

### With Kamal (Docker-based)
```bash
# Configure config/deploy.yml
kamal setup
kamal deploy
```

### Traditional Deployment
The app works with any Rails hosting:
- Heroku
- Render
- Fly.io
- AWS/GCP/Azure
- VPS with Capistrano

## 📝 Project Structure

```
.
├── app/
│   ├── assets/stylesheets/    # SCSS files
│   ├── controllers/           # Controllers
│   ├── javascript/            # Stimulus controllers
│   ├── models/                # Models
│   └── views/                 # ERB templates
├── bin/
│   ├── docker-*               # Docker helper scripts
│   ├── rails                  # Rails CLI
│   └── setup                  # Initial setup script
├── config/
│   ├── routes.rb              # Routes
│   └── database.yml           # Database config
├── db/
│   ├── schema.rb              # Database schema
│   └── seeds.rb               # Seed data
├── test/                      # Test suite
├── Dockerfile.dev             # Development Dockerfile
├── docker-compose.yml         # Compose configuration
├── LLM_INSTRUCTIONS.md        # AI agent instructions
└── README.md                  # This file
```

## 🆘 Troubleshooting

### Container won't start
```bash
# Check logs
docker logs rails8-dev

# Rebuild image
./bin/docker-build

# Remove all containers and start fresh
docker-compose down -v
./bin/docker-compose-up
```

### Port already in use
```bash
# Use different port
./bin/docker-start rails8-dev 3001
```

### Database locked
```bash
docker exec -it rails8-dev bin/rails db:reset
```

### Changes not reflected
Make sure code is mounted as volume:
```bash
docker inspect rails8-dev | grep -A 10 Mounts
```

## 📚 Documentation

- **[LLM_INSTRUCTIONS.md](./LLM_INSTRUCTIONS.md)** - Comprehensive guide for AI agents
- **[Rails Guides](https://guides.rubyonrails.org/)** - Official Rails documentation
- **[Bootstrap Docs](https://getbootstrap.com/docs/5.3/)** - Bootstrap components
- **[Hotwire](https://hotwired.dev/)** - Turbo + Stimulus documentation

## 🤝 Contributing

This is a template repository. Fork it and customize for your needs!

## 📄 License

This template is available as open source under the terms of the MIT License.

---

**Built with ❤️ for rapid Rails development and AI-assisted coding.**

Ready to build something amazing? 🚀

```bash
./bin/docker-build && ./bin/docker-start
# Visit http://localhost:3000
```
