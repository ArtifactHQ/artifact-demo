import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "view", "checkbox", "docContent", "designCanvas", "previewFrame"]
  static values = {
    sessionKey: { type: String, default: "appPreviewState" }
  }

  connect() {
    // Load state from session storage
    this.loadState()
    
    // Set up mutation observers for cross-view updates
    this.setupObservers()
    
    // Apply saved theme
    this.applyTheme()
    
    // Set active template in UI
    if (this.state.theme && this.state.theme.template) {
      const templateElement = this.element.querySelector(`[data-template="${this.state.theme.template}"]`)
      if (templateElement) {
        this.element.querySelectorAll(".template-selector").forEach(t => t.classList.remove("active"))
        templateElement.classList.add("active")
      }
    }
    
    // Initialize first tab
    if (!this.currentTab) {
      this.switchTab({ currentTarget: this.tabTargets[0] })
    } else {
      this.showCurrentTab()
    }
  }

  disconnect() {
    // Clean up observers
    if (this.docObserver) this.docObserver.disconnect()
  }

  // Tab switching
  switchTab(event) {
    const clickedTab = event.currentTarget
    const tabName = clickedTab.dataset.tab
    
    // Update active tab
    this.tabTargets.forEach(tab => tab.classList.remove("active"))
    clickedTab.classList.add("active")
    
    // Update visible view
    this.viewTargets.forEach(view => {
      if (view.dataset.view === tabName) {
        view.classList.add("active")
      } else {
        view.classList.remove("active")
      }
    })
    
    // Save current tab to state
    this.currentTab = tabName
    this.saveState()
    
    // Sync views when switching
    this.syncViews(tabName)
  }

  // Checkbox interaction
  toggleCheckbox(event) {
    const checkbox = event.currentTarget
    const checkboxId = checkbox.dataset.checkboxId
    
    // Toggle checked state
    checkbox.classList.toggle("checked")
    const isChecked = checkbox.classList.contains("checked")
    
    // Update associated text
    const textElement = checkbox.nextElementSibling
    if (textElement) {
      if (isChecked) {
        textElement.style.color = "#A8A29E"
        textElement.style.textDecoration = "line-through"
      } else {
        textElement.style.color = "#44403C"
        textElement.style.textDecoration = "none"
      }
    }
    
    // Save to state
    this.updateCheckboxState(checkboxId, isChecked)
    
    // Sync across all views
    this.syncCheckbox(checkboxId, isChecked)
  }

  // Sidebar navigation
  navigateToItem(event) {
    const item = event.currentTarget
    const itemId = item.dataset.itemId
    
    // Update active state
    this.element.querySelectorAll(".sidebar-item").forEach(i => {
      i.classList.remove("active")
    })
    item.classList.add("active")
    
    // Save to state
    this.updateNavigationState(itemId)
    this.saveState()
    
    // Load content for this item (placeholder for now)
    this.loadItemContent(itemId)
  }

  // State management
  loadState() {
    try {
      const stateJson = sessionStorage.getItem(this.sessionKeyValue)
      if (stateJson) {
        this.state = JSON.parse(stateJson)
      } else {
        this.state = this.getDefaultState()
      }
    } catch (e) {
      console.error("Error loading state:", e)
      this.state = this.getDefaultState()
    }
  }

  saveState() {
    try {
      sessionStorage.setItem(this.sessionKeyValue, JSON.stringify(this.state))
    } catch (e) {
      console.error("Error saving state:", e)
    }
  }

  getDefaultState() {
    return {
      currentTab: "doc",
      checkboxes: {},
      currentItem: "user-types",
      editorContent: {},
      theme: {
        template: "minimalist",
        colors: {
          "primary-300": "#A5B4FC",
          "primary-500": "#2563EB",
          "primary-700": "#0D3C9A",
          "success": "#A7F3D0",
          "warning": "#FDE68A",
          "error": "#FCA5A5"
        }
      }
    }
  }

  updateCheckboxState(checkboxId, isChecked) {
    if (!this.state.checkboxes) {
      this.state.checkboxes = {}
    }
    this.state.checkboxes[checkboxId] = isChecked
    this.saveState()
  }

  updateNavigationState(itemId) {
    this.state.currentItem = itemId
  }

  // View synchronization
  syncCheckbox(checkboxId, isChecked) {
    // Find all checkboxes with this ID across all views
    const checkboxes = this.element.querySelectorAll(`[data-checkbox-id="${checkboxId}"]`)
    
    checkboxes.forEach(checkbox => {
      const textElement = checkbox.nextElementSibling
      
      if (isChecked) {
        checkbox.classList.add("checked")
        if (textElement) {
          textElement.style.color = "#A8A29E"
          textElement.style.textDecoration = "line-through"
        }
      } else {
        checkbox.classList.remove("checked")
        if (textElement) {
          textElement.style.color = "#44403C"
          textElement.style.textDecoration = "none"
        }
      }
    })
  }

  syncViews(targetTab) {
    // Restore checkbox states from session
    if (this.state.checkboxes) {
      Object.keys(this.state.checkboxes).forEach(checkboxId => {
        this.syncCheckbox(checkboxId, this.state.checkboxes[checkboxId])
      })
    }
    
    // Apply theme to ensure colors are consistent
    this.applyTheme()
  }

  showCurrentTab() {
    const currentTab = this.state.currentTab || "doc"
    const tabElement = this.tabTargets.find(t => t.dataset.tab === currentTab)
    if (tabElement) {
      this.switchTab({ currentTarget: tabElement })
    }
  }

  setupObservers() {
    // Set up mutation observer for doc content changes
    if (this.hasDocContentTarget) {
      this.docObserver = new MutationObserver((mutations) => {
        this.handleDocChanges(mutations)
      })
      
      this.docObserver.observe(this.docContentTarget, {
        childList: true,
        subtree: true,
        characterData: true
      })
    }
  }

  handleDocChanges(mutations) {
    // Handle changes to document content and sync to other views
    // This will be expanded as needed
  }

  loadItemContent(itemId) {
    // Placeholder for loading different artifact content
    // This would typically fetch content from the server
    console.log(`Loading content for: ${itemId}`)
  }

  // Theme management
  selectTemplate(event) {
    const templateElement = event.currentTarget
    const templateName = templateElement.dataset.template
    
    // Update active template
    this.element.querySelectorAll(".template-selector").forEach(t => {
      t.classList.remove("active")
    })
    templateElement.classList.add("active")
    
    // Update theme state
    this.state.theme.template = templateName
    
    // Apply template-specific colors
    this.applyTemplateTheme(templateName)
    
    // Save and apply theme
    this.saveState()
    this.applyTheme()
  }

  applyTemplateTheme(templateName) {
    const templates = {
      minimalist: {
        "primary-300": "#A5B4FC",
        "primary-500": "#2563EB",
        "primary-700": "#0D3C9A",
        "success": "#A7F3D0",
        "warning": "#FDE68A",
        "error": "#FCA5A5"
      },
      bold: {
        "primary-300": "#FDE68A",
        "primary-500": "#F97316",
        "primary-700": "#C2410C",
        "success": "#86EFAC",
        "warning": "#FCD34D",
        "error": "#FCA5A5"
      },
      corporate: {
        "primary-300": "#94A3B8",
        "primary-500": "#475569",
        "primary-700": "#1E293B",
        "success": "#A7F3D0",
        "warning": "#FDE68A",
        "error": "#FCA5A5"
      },
      organic: {
        "primary-300": "#BBF7D0",
        "primary-500": "#10B981",
        "primary-700": "#047857",
        "success": "#6EE7B7",
        "warning": "#FDE047",
        "error": "#FDA4AF"
      }
    }
    
    if (templates[templateName]) {
      this.state.theme.colors = { ...templates[templateName] }
      
      // Update color swatches in design view
      Object.keys(templates[templateName]).forEach(colorKey => {
        const swatch = this.element.querySelector(`[data-color="${colorKey}"]`)
        if (swatch) {
          swatch.style.background = templates[templateName][colorKey]
          const valueElement = swatch.parentElement.querySelector(".color-value")
          if (valueElement) {
            valueElement.textContent = templates[templateName][colorKey]
          }
        }
      })
    }
  }

  selectColor(event) {
    const colorSwatch = event.currentTarget
    const colorKey = colorSwatch.dataset.color
    
    // For now, just mark as active (in a real app, would open color picker)
    this.element.querySelectorAll(".color-swatch").forEach(s => {
      s.classList.remove("active")
    })
    colorSwatch.classList.add("active")
    
    console.log(`Selected color: ${colorKey}`)
    // In a full implementation, would open a color picker here
  }

  toggleSection(event) {
    const header = event.currentTarget
    const section = header.parentElement
    const content = section.querySelector(".theme-section-content")
    
    // Toggle active state
    content.classList.toggle("active")
    header.classList.toggle("collapsed")
  }

  applyTheme() {
    if (!this.state.theme) return
    
    const colors = this.state.theme.colors
    
    // ONLY apply theme colors to the PREVIEW view
    // Doc tab uses Artifact UI styles as-is
    // Design tab uses standard Bootstrap/main site styling
    const previewView = this.element.querySelector('.view-container[data-view="preview"]')
    
    if (!previewView) return
    
    // Update primary color elements
    const primaryElements = previewView.querySelectorAll('[style*="border-bottom: 1px solid rgba(217, 93, 57"]')
    primaryElements.forEach(el => {
      if (colors["primary-500"]) {
        const rgb = this.hexToRgb(colors["primary-500"])
        el.style.borderBottom = `1px solid rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, 0.3)`
      }
    })
    
    // Update checked checkbox colors in preview
    const checkedCheckboxes = previewView.querySelectorAll(".checkbox.checked")
    checkedCheckboxes.forEach(checkbox => {
      if (colors["primary-500"]) {
        checkbox.style.background = colors["primary-500"]
        checkbox.style.borderColor = colors["primary-500"]
      }
    })
    
    // Update accent colors in preview
    const accentBorders = previewView.querySelectorAll('[style*="border-left: 3px solid"]')
    accentBorders.forEach(el => {
      if (colors["primary-500"]) {
        el.style.borderLeftColor = colors["primary-500"]
      }
    })
    
    // Update background colors for completed items in preview
    const completedBackgrounds = previewView.querySelectorAll('[style*="background: #FEF3EF"]')
    completedBackgrounds.forEach(el => {
      if (colors["primary-300"]) {
        const rgb = this.hexToRgb(colors["primary-300"])
        el.style.background = `rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, 0.2)`
      }
    })
    
    // Update success/completed items in preview
    const successBackgrounds = previewView.querySelectorAll('[style*="background: #E7F5EF"]')
    successBackgrounds.forEach(el => {
      if (colors["success"]) {
        const rgb = this.hexToRgb(colors["success"])
        el.style.background = `rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, 0.2)`
      }
    })
    
    // Apply theme to task item wrapper backgrounds
    const taskWrappers = previewView.querySelectorAll('.task-item-wrapper-small')
    taskWrappers.forEach(wrapper => {
      if (colors["success"]) {
        const rgb = this.hexToRgb(colors["success"])
        wrapper.style.background = `rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, 0.2)`
      }
    })
  }

  hexToRgb(hex) {
    // Remove # if present
    hex = hex.replace('#', '')
    
    // Parse hex values
    const r = parseInt(hex.substring(0, 2), 16)
    const g = parseInt(hex.substring(2, 4), 16)
    const b = parseInt(hex.substring(4, 6), 16)
    
    return { r, g, b }
  }

  // Getter/setter for current tab
  get currentTab() {
    return this.state?.currentTab
  }

  set currentTab(value) {
    if (!this.state) this.state = this.getDefaultState()
    this.state.currentTab = value
  }
}

