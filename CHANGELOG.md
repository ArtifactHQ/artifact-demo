# Changelog

All notable changes to the ArtifactBuilder Demo project will be documented in this file.

## [2.0.0] - 2025-12-05

### 🎉 Major Refactoring - Full Application Implementation

This release transforms the project from a static mockup into a fully functional no-code development platform.

### Added

#### Models & Database
- **Project model**: Core container for applications being built
  - Fields: name, description, status
  - Validations and scopes
  - has_many documents relationship
  
- **Document model**: Specification documents with content
  - Fields: title, content, document_type
  - Support for 6 document types (specification, feature, component, page, api, database)
  - Auto-creates initial version on creation
  - belongs_to project, has_many versions
  
- **Version model**: Git-like version control system
  - Fields: version_number, content, commit_message, committed_at, status
  - Deploy and rollback functionality
  - Unique version numbers per document
  - belongs_to document

- **Database migrations**: 3 migrations with proper indexes and constraints
- **Database schema**: Complete with foreign keys and indexes

#### Controllers
- **ProjectsController**: Full CRUD operations for projects
- **DocumentsController**: Document management with custom actions
  - commit_version: Create new version snapshots
  - preview: Preview AI-generated output
- **VersionsController**: Version viewing and deployment
  - deploy: Deploy specific version
  - rollback: Rollback deployed version

#### Routes
- RESTful nested resource routing
- Custom member routes for versioning actions
- Dashboard route
- Root route to projects index

#### Views
- **Projects**:
  - Index: Card-based project grid with stats
  - Show: Document list with type icons
  - New/Edit: Clean form interfaces
  
- **Documents**:
  - Index: Document listing
  - Show: Split view with content and version history
  - New/Edit: Notion-like editor interface
  - Preview: AI generation preview mockup
  
- **Versions**:
  - Show: Version details with deploy/rollback actions
  
- **Layout**:
  - Professional navbar with navigation
  - Flash message system
  - Breadcrumb navigation
  - Responsive Bootstrap layout

#### Styling
- Custom SCSS enhancements
- Document content prose styling
- Hover effects and transitions
- Status badge color system
- Editor improvements
- Empty state styling

#### Seed Data
- 3 complete sample projects
- 6 realistic documents
- 13 versions with full history
- Immediate demo-ready content

#### Documentation
- `DEMO_ARCHITECTURE.md`: Complete system documentation
- `QUICK_START.md`: Quick start guide and common tasks
- `REFACTORING_SUMMARY.md`: Detailed refactoring record
- `CHANGELOG.md`: This file

### Changed
- Root route now points to projects index (was pages#home)
- Application layout includes navigation and flash messages
- Custom styles extended significantly

### Technical Details
- Rails 8.0
- SQLite database
- Bootstrap 5.3
- Font Awesome icons
- Docker containerized
- Proper Rails conventions throughout

### Migration Path
```bash
docker-compose up -d
docker-compose exec artifact-demo-web bin/rails db:migrate
docker-compose exec artifact-demo-web bin/rails db:seed
```

---

## [1.0.0] - Previous Version

### Initial Release
- Static product mockup showcase
- Bootstrap theme implementation
- Product mockup components
- Design tab implementation
- Template structure
- Docker configuration
- Fly.io deployment setup

---

## Version Naming

This project uses [Semantic Versioning](https://semver.org/):
- MAJOR version for incompatible API changes
- MINOR version for added functionality in a backward compatible manner
- PATCH version for backward compatible bug fixes

## How to Use This Changelog

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Now removed features
- **Fixed**: Any bug fixes
- **Security**: Vulnerability fixes

