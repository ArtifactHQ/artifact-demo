# ArtifactBuilder Demo - Architecture Overview

## Project Overview

ArtifactBuilder is a no-code development platform with a Notion-like document interface. Users can edit "documents" to specify what they want to build, and the AI uses these specifications to generate production-grade applications. The platform includes version control similar to Git, but designed for non-technical users.

## Core Concepts

### Projects
Top-level containers representing applications being built. Each project can have:
- Name and description
- Status (draft, active, archived)
- Multiple documents that define different aspects of the application

### Documents
Specification documents that describe what to build. Types include:
- **Specification**: General requirements and specifications
- **Feature**: Specific features and functionality
- **Component**: UI components and their behavior
- **Page**: Individual pages/screens
- **API**: API endpoints and integrations
- **Database**: Database schema and data models

### Versions
Version control system for documents, similar to Git commits:
- Each document change can be committed as a new version
- Version statuses: draft, committed, deployed, rolled_back
- Track commit messages and timestamps
- Deploy specific versions to production

## Database Schema

### Projects Table
```ruby
create_table :projects do |t|
  t.string :name, null: false
  t.text :description
  t.string :status, default: 'draft'
  t.timestamps
end
```

### Documents Table
```ruby
create_table :documents do |t|
  t.references :project, null: false, foreign_key: true
  t.string :title, null: false
  t.text :content
  t.string :document_type, default: 'specification'
  t.timestamps
end
```

### Versions Table
```ruby
create_table :versions do |t|
  t.references :document, null: false, foreign_key: true
  t.integer :version_number, null: false
  t.text :content
  t.string :commit_message
  t.datetime :committed_at
  t.string :status, default: 'draft'
  t.timestamps
end
```

## Model Relationships

```
Project
  ├── has_many :documents
  │
  └── Document
        ├── belongs_to :project
        └── has_many :versions
              └── Version
                    └── belongs_to :document
```

## Routes Structure

```
/projects                    # List all projects
/projects/:id               # View project and its documents
/projects/:id/edit          # Edit project details

/projects/:project_id/documents/:id              # View document with versions
/projects/:project_id/documents/:id/edit         # Edit document content
/projects/:project_id/documents/:id/preview      # Preview AI-generated output
/projects/:project_id/documents/:id/commit_version  # Commit new version

/projects/:project_id/documents/:document_id/versions/:id         # View specific version
/projects/:project_id/documents/:document_id/versions/:id/deploy  # Deploy version
/projects/:project_id/documents/:document_id/versions/:id/rollback # Rollback version
```

## Key Features

### 1. Document Editor (Notion-like Interface)
- Rich text editing with markdown support
- Real-time content editing
- Document type categorization
- Version history sidebar

### 2. Version Control (Git-like, User-Friendly)
- Commit changes with messages
- View version history
- Deploy specific versions
- Rollback to previous versions
- Status tracking (draft → committed → deployed)

### 3. AI Preview System
- Preview what the AI would generate from specifications
- Visual representation of the output
- Based on document content analysis

### 4. Project Management
- Organize documents by project
- Track project status
- View document counts and activity
- Quick access to recent updates

## Technology Stack

- **Backend**: Ruby on Rails 8.0
- **Database**: SQLite (development)
- **Frontend**: Bootstrap 5, Stimulus.js, Turbo
- **Styling**: SCSS with custom theme
- **Icons**: Font Awesome
- **Deployment**: Docker containers

## Development Setup

### Starting the Application

```bash
# Start Docker containers
docker-compose up -d

# Run migrations
docker-compose exec artifact-demo-web bin/rails db:migrate

# Seed demo data
docker-compose exec artifact-demo-web bin/rails db:seed

# Access the application
open http://localhost:3001
```

### Database Commands

```bash
# Create new migration
docker-compose exec artifact-demo-web bin/rails generate migration MigrationName

# Run migrations
docker-compose exec artifact-demo-web bin/rails db:migrate

# Reset database (caution!)
docker-compose exec artifact-demo-web bin/rails db:reset

# Rails console
docker-compose exec artifact-demo-web bin/rails console
```

### Asset Management

```bash
# Precompile assets
docker-compose exec artifact-demo-web bin/rails assets:precompile

# Clean assets
docker-compose exec artifact-demo-web bin/rails assets:clobber
```

## Demo Data

The seed file creates 3 sample projects:

1. **E-commerce Platform**
   - Product Catalog feature
   - Shopping Cart feature
   - Multiple versions demonstrating iteration

2. **Task Management App**
   - Boards & Lists feature
   - Task Cards feature
   - Demonstrates component organization

3. **Social Media Dashboard**
   - Analytics Overview page
   - Database Schema document
   - Shows different document types

## User Workflow

1. **Create a Project**: Define what you want to build
2. **Add Documents**: Specify features, pages, components
3. **Edit Content**: Use the Notion-like editor to describe requirements
4. **Preview**: See what the AI would generate
5. **Commit Version**: Save a snapshot when you're happy with changes
6. **Deploy**: Push a version to production
7. **Iterate**: Continue editing, committing, and deploying

## Next Steps for Enhancement

### Phase 1: Core Functionality
- [ ] Implement actual AI generation (currently mockup)
- [ ] Add real-time preview rendering
- [ ] Implement collaborative editing
- [ ] Add user authentication

### Phase 2: Advanced Features
- [ ] Rich text editor with markdown preview
- [ ] Drag-and-drop document organization
- [ ] Export generated code
- [ ] Integration with GitHub
- [ ] Deployment to cloud platforms

### Phase 3: AI Enhancement
- [ ] Natural language processing for specs
- [ ] Intelligent code generation
- [ ] Automated testing generation
- [ ] Performance optimization suggestions

## File Structure

```
app/
├── controllers/
│   ├── projects_controller.rb      # Project CRUD operations
│   ├── documents_controller.rb     # Document management + versioning
│   └── versions_controller.rb      # Version viewing and deployment
├── models/
│   ├── project.rb                  # Project model with validations
│   ├── document.rb                 # Document model with version management
│   └── version.rb                  # Version model with deployment logic
└── views/
    ├── projects/                   # Project views (index, show, form)
    ├── documents/                  # Document views (editor, preview)
    └── versions/                   # Version views (history, details)
```

## API Endpoints (Future)

When building the API for external integrations:

```
GET    /api/v1/projects
POST   /api/v1/projects
GET    /api/v1/projects/:id
PUT    /api/v1/projects/:id
DELETE /api/v1/projects/:id

GET    /api/v1/projects/:project_id/documents
POST   /api/v1/projects/:project_id/documents
GET    /api/v1/documents/:id
PUT    /api/v1/documents/:id
DELETE /api/v1/documents/:id

POST   /api/v1/documents/:id/generate    # Trigger AI generation
POST   /api/v1/documents/:id/versions    # Create new version
GET    /api/v1/versions/:id
POST   /api/v1/versions/:id/deploy       # Deploy version
```

## Performance Considerations

- Use eager loading for nested resources (`includes(:documents)`)
- Index foreign keys and frequently queried fields
- Cache rendered previews
- Implement pagination for large document lists
- Consider Redis for session storage in production

## Security Considerations

- Add user authentication (Devise or similar)
- Implement authorization (CanCanCan or Pundit)
- Validate user input thoroughly
- Sanitize document content
- Rate limit API endpoints
- Encrypt sensitive data in versions

## Deployment

Currently configured for:
- Development: Docker Compose (port 3001)
- Staging: Docker Compose (port 3002)
- Production: Fly.io (configured in fly.toml)

---

**Status**: Demo-ready prototype with full CRUD functionality, version control UI, and sample data.

**Access**: http://localhost:3001 (development)

