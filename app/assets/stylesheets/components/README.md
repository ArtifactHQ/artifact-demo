# Product Mockup SCSS Architecture

## Overview
The product mockup interface has been refactored into a modular, maintainable SCSS architecture following DRY principles and best practices for scalable application development.

## File Structure

```
components/
├── _product-mockup-variables.scss  # All variables (colors, spacing, typography, etc.)
├── _product-mockup-mixins.scss     # Reusable mixins (layout, shapes, interactions, etc.)
├── _product-mockup.scss            # Main structural styles (chrome, interface, sidebars)
├── _product-mockup-components.scss # Reusable UI components (cards, selectors, etc.)
└── _product-mockup-views.scss      # View-specific styles (Doc, Design, Preview)
```

## Architecture

### 1. Variables (`_product-mockup-variables.scss`)
Centralized configuration for all styling values:
- **Layout**: Sidebar widths, heights, container dimensions
- **Spacing**: Padding, margins, gaps
- **Colors**: Background colors, text colors, borders, accents
- **Typography**: Font sizes, weights, line heights
- **Shadows**: Predefined shadow levels
- **Transitions**: Timing functions and durations

**Usage:**
```scss
// Instead of hardcoded values
padding: 0.75rem;
color: #1C1917;

// Use variables
padding: $mockup-chrome-padding;
color: $mockup-text-primary;
```

### 2. Mixins (`_product-mockup-mixins.scss`)
Reusable style patterns:
- **Layout**: `flex-center`, `flex-between`, `flex-start`, `flex-end`
- **Shapes**: `circle()`, `square()`, `rounded-box()`
- **Typography**: `monospace`, `text-truncate`, `text-uppercase`
- **Interactions**: `clickable`, `hoverable()`, `active-state()`
- **Animations**: `pulse-animation`, `fade-animation()`
- **Responsive**: `mobile-only`, `tablet-only`, `desktop-only`
- **Components**: `card()`, `button-base`, `input-base`, `scrollbar-custom`

**Usage:**
```scss
// Instead of repeating code
.my-element {
  display: flex;
  justify-content: center;
  align-items: center;
}

// Use mixins
.my-element {
  @include flex-center;
}
```

### 3. Main Styles (`_product-mockup.scss`)
Core structural layout:
- Base `.product-mockup` container
- Browser chrome (dots, tabs, spacer)
- App interface container
- Left sidebar (navigation)
- Main editor (view containers)
- Right sidebar (templates, settings)
- Utility classes

### 4. Components (`_product-mockup-components.scss`)
Reusable UI components:
- Template selector
- Theme section accordion
- Color swatches
- Preview phone
- Nested task wrapper
- Gradient utilities

### 5. Views (`_product-mockup-views.scss`)
View-specific styles:
- **Doc View**: Inherits Artifact theme
- **Design View**: Uses standard Bootstrap styling
- **Preview View**: Dynamic theme from user selections

## Adding New Features

### Adding a New Component
1. Add variables to `_product-mockup-variables.scss`:
```scss
$mockup-mycomponent-width: 20rem;
$mockup-mycomponent-bg: $mockup-bg-primary;
```

2. Add mixins if needed to `_product-mockup-mixins.scss`:
```scss
@mixin mycomponent-layout {
  @include card;
  width: $mockup-mycomponent-width;
}
```

3. Add component styles to `_product-mockup-components.scss`:
```scss
.my-component {
  @include mycomponent-layout;
  background: $mockup-mycomponent-bg;
  
  .my-component-header {
    @include flex-between;
    padding: $mockup-sidebar-padding;
  }
}
```

### Adding a New View
Add to `_product-mockup-views.scss`:
```scss
.product-mockup .view-container[data-view="myview"] {
  // View-specific overrides
  letter-spacing: normal;
  
  .myview-specific-element {
    color: $mockup-text-primary;
  }
}
```

### Modifying Colors/Spacing
Update values in `_product-mockup-variables.scss`:
```scss
// Change globally
$mockup-chrome-padding: 1rem; // was 0.75rem

// Change specific color
$mockup-accent-primary: #E63946; // was #D95D39
```

## Best Practices

### 1. Use Variables
✅ **DO:**
```scss
color: $mockup-text-primary;
padding: $mockup-sidebar-padding;
```

❌ **DON'T:**
```scss
color: #1C1917;
padding: 1rem;
```

### 2. Use Mixins
✅ **DO:**
```scss
@include flex-center;
@include hoverable;
@include clickable;
```

❌ **DON'T:**
```scss
display: flex;
justify-content: center;
align-items: center;
cursor: pointer;
transition: all 0.2s ease;
```

### 3. Follow Naming Conventions
- Variables: `$mockup-category-property`
- Classes: BEM-style or semantic names
- Mixins: Descriptive action names

### 4. Keep Specificity Low
✅ **DO:**
```scss
.sidebar-item {
  &.active { ... }
}
```

❌ **DON'T:**
```scss
.product-mockup .app-interface .sidebar .sidebar-item.active { ... }
```

### 5. Mobile-First Responsive
✅ **DO:**
```scss
.element {
  padding: 1rem;
  
  @include desktop-only {
    padding: 2rem;
  }
}
```

## Responsive Breakpoints
- **Mobile**: 0-767px (`@include mobile-only`)
- **Tablet**: 768-991px (`@include tablet-only`)
- **Desktop**: 992px+ (`@include desktop-only`)

## Color Palette
- **Primary Text**: `$mockup-text-primary` (#1C1917)
- **Secondary Text**: `$mockup-text-secondary` (#44403C)
- **Tertiary Text**: `$mockup-text-tertiary` (#57534E)
- **Quaternary Text**: `$mockup-text-quaternary` (#78716C)
- **Quinary Text**: `$mockup-text-quinary` (#A8A29E)
- **Accent**: `$mockup-accent-primary` (#D95D39)
- **Background**: `$mockup-bg-primary` (#FFFFFF)

## Performance Tips
1. Use CSS custom properties (variables) for runtime changes
2. Avoid deep nesting (max 3-4 levels)
3. Use `transform` for animations (GPU accelerated)
4. Leverage `@include scrollbar-custom` for consistent scrollbars
5. Use `will-change` sparingly for complex animations

## Future Enhancements
- [ ] Dark mode support (add dark color scheme variables)
- [ ] Animation library (expand animation mixins)
- [ ] Accessibility utilities (focus states, contrast helpers)
- [ ] Print styles (add print-specific views)
- [ ] RTL support (add RTL mixins and utilities)

## Questions?
Refer to the inline comments in each SCSS file for detailed explanations of specific components and patterns.

