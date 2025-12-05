# Clear existing data in development
if Rails.env.development?
  puts "Clearing existing data..."
  Version.destroy_all
  Document.destroy_all
  Project.destroy_all
end

puts "Creating demo projects..."

# Project 1: E-commerce Platform
ecommerce = Project.create!(
  name: "E-commerce Platform",
  description: "A modern e-commerce platform with product catalog, shopping cart, and checkout functionality",
  status: "active"
)

# Product Catalog Document
catalog_doc = ecommerce.documents.create!(
  title: "Product Catalog",
  document_type: "feature",
  content: <<~CONTENT
    # Product Catalog Feature
    
    ## Overview
    Users should be able to browse products with filtering and search capabilities.
    
    ## Requirements
    - Display products in a grid layout
    - Each product shows: image, name, price, rating
    - Filter by category, price range, and rating
    - Search by product name
    - Sort by: price (low to high, high to low), popularity, newest
    
    ## User Stories
    - As a customer, I want to browse products so I can find items to purchase
    - As a customer, I want to filter products so I can narrow down my search
    - As a customer, I want to search for specific products by name
  CONTENT
)

# Shopping Cart Document
cart_doc = ecommerce.documents.create!(
  title: "Shopping Cart",
  document_type: "feature",
  content: <<~CONTENT
    # Shopping Cart Feature
    
    ## Overview
    Users can add products to cart and manage quantities before checkout.
    
    ## Requirements
    - Add/remove products from cart
    - Update product quantities
    - Display cart total
    - Persist cart across sessions
    - Show cart icon with item count in navigation
    
    ## User Stories
    - As a customer, I want to add products to my cart
    - As a customer, I want to see my cart total
    - As a customer, I want to update quantities in my cart
  CONTENT
)

# Create versions for the documents
catalog_doc.create_new_version(commit_message: "Added filtering requirements")
catalog_doc.create_new_version(commit_message: "Added search and sort functionality")

cart_doc.create_new_version(commit_message: "Added persistence requirements")

# Project 2: Task Management App
taskapp = Project.create!(
  name: "Task Management App",
  description: "A collaborative task management application with boards, lists, and cards",
  status: "active"
)

# Boards Document
boards_doc = taskapp.documents.create!(
  title: "Boards & Lists",
  document_type: "feature",
  content: <<~CONTENT
    # Boards and Lists
    
    ## Overview
    Organize tasks in boards with multiple lists (e.g., To Do, In Progress, Done).
    
    ## Requirements
    - Create, edit, and delete boards
    - Each board contains multiple lists
    - Drag and drop lists to reorder
    - Archive boards
    - Set board background colors or images
    
    ## User Stories
    - As a user, I want to create boards for different projects
    - As a user, I want to organize tasks in lists within boards
    - As a user, I want to customize my board appearance
  CONTENT
)

# Cards Document
cards_doc = taskapp.documents.create!(
  title: "Task Cards",
  document_type: "feature",
  content: <<~CONTENT
    # Task Cards
    
    ## Overview
    Individual task cards with details, assignments, and due dates.
    
    ## Requirements
    - Create, edit, delete cards
    - Add title, description, and due date
    - Assign members to cards
    - Add labels/tags
    - Drag and drop between lists
    - Add comments
    - Attach files
    
    ## User Stories
    - As a user, I want to create task cards with details
    - As a user, I want to move cards between lists
    - As a user, I want to assign tasks to team members
  CONTENT
)

boards_doc.create_new_version(commit_message: "Added board customization")
cards_doc.create_new_version(commit_message: "Added file attachments")

# Project 3: Social Media Dashboard
social = Project.create!(
  name: "Social Media Dashboard",
  description: "Analytics dashboard for social media metrics and insights",
  status: "draft"
)

# Analytics Document
analytics_doc = social.documents.create!(
  title: "Analytics Overview",
  document_type: "page",
  content: <<~CONTENT
    # Analytics Dashboard
    
    ## Overview
    Display key metrics and insights from connected social media accounts.
    
    ## Requirements
    - Connect multiple social media accounts (Twitter, Instagram, Facebook)
    - Display follower counts and growth trends
    - Show engagement metrics (likes, comments, shares)
    - Display top performing posts
    - Date range filters
    - Export reports as PDF
    
    ## Metrics to Display
    - Total followers across all platforms
    - Engagement rate
    - Post reach and impressions
    - Best posting times
    - Audience demographics
  CONTENT
)

# Database Schema Document
db_doc = social.documents.create!(
  title: "Database Schema",
  document_type: "database",
  content: <<~CONTENT
    # Database Schema
    
    ## Tables
    
    ### accounts
    - id (primary key)
    - platform (string: twitter, instagram, facebook)
    - username (string)
    - access_token (encrypted string)
    - created_at, updated_at
    
    ### metrics
    - id (primary key)
    - account_id (foreign key)
    - date (date)
    - followers_count (integer)
    - engagement_rate (decimal)
    - posts_count (integer)
    - created_at, updated_at
    
    ### posts
    - id (primary key)
    - account_id (foreign key)
    - platform_post_id (string)
    - content (text)
    - likes_count (integer)
    - comments_count (integer)
    - shares_count (integer)
    - posted_at (datetime)
    - created_at, updated_at
  CONTENT
)

analytics_doc.create_new_version(commit_message: "Initial analytics requirements")
db_doc.create_new_version(commit_message: "Added posts table")

puts "Seed data created successfully!"
puts "- #{Project.count} projects"
puts "- #{Document.count} documents"
puts "- #{Version.count} versions"
