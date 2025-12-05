# ArtifactBuilder - Quick Start Guide

## 🚀 Getting Started (30 seconds)

```bash
# 1. Start the application
docker-compose up -d

# 2. Set up the database (first time only)
docker-compose exec artifact-demo-web bin/rails db:migrate
docker-compose exec artifact-demo-web bin/rails db:seed

# 3. Open in your browser
open http://localhost:3001
```

That's it! You now have a fully functional no-code platform demo with sample projects.

## 📖 What You'll See

### Homepage (Projects Dashboard)
- **3 Sample Projects**: E-commerce Platform, Task Management App, Social Media Dashboard
- **Quick Actions**: Create new project, view existing projects
- **Project Cards**: Show document count, status, and last update time

### Project View
- **Document List**: All specification documents for the project
- **Document Types**: Features, Pages, Components, APIs, Database schemas
- **Actions**: View, Edit, Preview each document

### Document Editor
- **Notion-like Interface**: Clean, distraction-free editor
- **Markdown Support**: Structure your specifications with markdown
- **Version Control**: Commit changes with messages
- **Version History**: See all past versions in the sidebar

### Version Management
- **Commit**: Save snapshots of your document
- **Deploy**: Push a version to "production"
- **Rollback**: Revert to a previous version
- **Status Tracking**: draft → committed → deployed

## 🎯 Common Tasks

### Creating a New Project

1. Click **"New Project"** in the navigation
2. Fill in:
   - **Name**: e.g., "Blog Platform"
   - **Description**: What you're building
   - **Status**: Draft, Active, or Archived
3. Click **"Create Project"**

### Adding a Document

1. Open a project
2. Click **"New Document"**
3. Choose:
   - **Title**: e.g., "User Authentication"
   - **Type**: Feature, Page, Component, API, Database, or Specification
   - **Content**: Describe what you want to build (use markdown)
4. Click **"Create Document"**

### Editing a Document

1. Navigate to the document
2. Click **"Edit"**
3. Make your changes
4. Click **"Save Changes"**
5. Go back to the document view
6. Add a commit message in the "Commit New Version" box
7. Click **"Commit Version"**

### Deploying a Version

1. View a document
2. In the **Version History** sidebar, find the version you want to deploy
3. Click the rocket icon (🚀)
4. The version is now marked as "deployed"

### Previewing Generated Output

1. Navigate to any document
2. Click **"Preview"**
3. See what the AI would generate based on your specification
4. Return to edit if needed

## 💡 Tips for Writing Good Specifications

### Structure Your Documents

```markdown
# Feature Name

## Overview
Brief description of what this feature does

## Requirements
- List specific requirements
- Be clear about functionality
- Include edge cases

## User Stories
- As a [user type], I want to [action] so that [benefit]
- As a customer, I want to filter products so that I can find what I need

## Technical Details (optional)
- API endpoints needed
- Database tables
- Third-party integrations
```

### Be Specific

❌ Bad: "Users can search"
✅ Good: "Users can search products by name, with real-time suggestions appearing after 3 characters"

❌ Bad: "Add authentication"
✅ Good: "Implement user authentication with email/password, including password reset via email and 'remember me' functionality"

### Include Examples

When describing forms, tables, or interfaces, show examples:

```markdown
## Product Form Fields
- Name (text, required, max 100 chars)
- Price (decimal, required, min 0.01)
- Category (dropdown: Electronics, Clothing, Books, Other)
- Description (textarea, optional, max 1000 chars)
- In Stock (checkbox, default: true)
```

## 🔧 Development Commands

### Database

```bash
# Create a new model
docker-compose exec artifact-demo-web bin/rails generate model ModelName field:type

# Run migrations
docker-compose exec artifact-demo-web bin/rails db:migrate

# Reset database (careful!)
docker-compose exec artifact-demo-web bin/rails db:reset

# Open Rails console
docker-compose exec artifact-demo-web bin/rails console
```

### Generators

```bash
# Generate controller
docker-compose exec artifact-demo-web bin/rails generate controller ControllerName action1 action2

# Generate scaffold (full CRUD)
docker-compose exec artifact-demo-web bin/rails generate scaffold ModelName field:type

# Generate migration
docker-compose exec artifact-demo-web bin/rails generate migration MigrationName
```

### Assets

```bash
# Compile assets
docker-compose exec artifact-demo-web bin/rails assets:precompile

# Clean compiled assets
docker-compose exec artifact-demo-web bin/rails assets:clobber
```

### Logs

```bash
# View Rails logs
docker-compose logs -f artifact-demo-web

# View last 100 lines
docker-compose logs --tail=100 artifact-demo-web
```

## 🎨 Customization

### Adding New Document Types

Edit `app/models/document.rb`:

```ruby
validates :document_type, presence: true, inclusion: { 
  in: %w[specification feature component page api database YOUR_NEW_TYPE] 
}
```

And update the form dropdowns in:
- `app/views/documents/new.html.erb`
- `app/views/documents/edit.html.erb`

### Changing Project Statuses

Edit `app/models/project.rb`:

```ruby
validates :status, presence: true, inclusion: { 
  in: %w[draft active archived YOUR_NEW_STATUS] 
}
```

### Custom Styling

Edit `app/assets/stylesheets/theme/_custom.scss` to add your own styles.

## 📊 Sample Data

The seed file creates:

**E-commerce Platform** (2 documents, 5 versions)
- Product Catalog feature
- Shopping Cart feature

**Task Management App** (2 documents, 3 versions)
- Boards & Lists feature
- Task Cards feature

**Social Media Dashboard** (2 documents, 2 versions)
- Analytics Overview page
- Database Schema document

## 🐛 Troubleshooting

### Container won't start
```bash
docker-compose down
docker-compose up -d --build
```

### Database issues
```bash
docker-compose exec artifact-demo-web bin/rails db:reset
```

### Asset problems
```bash
docker-compose exec artifact-demo-web bin/rails assets:clobber
docker-compose exec artifact-demo-web bin/rails assets:precompile
docker-compose restart artifact-demo-web
```

### View changes not showing
```bash
# Restart the server
docker-compose restart artifact-demo-web
```

## 🚢 Production Deployment

This project is configured for Fly.io deployment:

```bash
# Deploy to production
fly deploy

# View logs
fly logs

# Open production app
fly open
```

See `DEPLOY.md` for detailed deployment instructions.

## 📚 Learn More

- **Full Architecture**: See `DEMO_ARCHITECTURE.md`
- **Rails Guides**: https://guides.rubyonrails.org/
- **Bootstrap Docs**: https://getbootstrap.com/docs/5.3/
- **Stimulus JS**: https://stimulus.hotwired.dev/

## 🎥 Demo Flow for Presentations

1. **Show the dashboard** - "Here we have three sample projects"
2. **Open a project** - "Each project contains specification documents"
3. **View a document** - "Documents use a Notion-like interface with version control"
4. **Edit content** - "Users describe what they want in plain language"
5. **Commit a version** - "Like Git, but friendly for non-technical users"
6. **Preview** - "See what the AI would generate"
7. **Deploy** - "Push to production with one click"

---

**Need Help?** Check the full documentation in `DEMO_ARCHITECTURE.md`

