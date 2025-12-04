import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="design-tab"
// This controller manages the design tab interface for customizing app preview styles
export default class extends Controller {
  static targets = [
    "preview",           // The .app-preview element
    "colorSchemeToggle", // Light/Dark mode toggle
    "accentColorPicker", // Accent color selector
    "customCssInput",    // Custom CSS textarea
    "fontFamilySelect",  // Font family dropdown
    "fontSizeRange"      // Font size slider
  ]
  
  static values = {
    colorScheme: { type: String, default: "light" },
    accentColor: { type: String, default: "orange" },
    customThemeId: { type: String, default: "app-preview-custom-theme" }
  }
  
  connect() {
    console.log("Design Tab controller connected")
    this.initializePreview()
  }
  
  // Initialize preview with default values
  initializePreview() {
    if (this.hasPreviewTarget) {
      this.previewTarget.setAttribute('data-color-scheme', this.colorSchemeValue)
      this.previewTarget.setAttribute('data-accent', this.accentColorValue)
    }
  }
  
  // Toggle between light and dark color schemes
  toggleColorScheme(event) {
    const scheme = event.currentTarget.dataset.scheme || 'light'
    this.colorSchemeValue = scheme
    
    if (this.hasPreviewTarget) {
      this.previewTarget.setAttribute('data-color-scheme', scheme)
      this.updateActiveButton(event.currentTarget)
    }
    
    this.logChange('Color Scheme', scheme)
  }
  
  // Change accent color
  changeAccentColor(event) {
    const color = event.currentTarget.dataset.color || event.currentTarget.value
    this.accentColorValue = color
    
    if (this.hasPreviewTarget) {
      this.previewTarget.setAttribute('data-accent', color)
    }
    
    this.logChange('Accent Color', color)
  }
  
  // Apply custom CSS from textarea
  applyCustomCss(event) {
    event.preventDefault()
    
    if (!this.hasCustomCssInputTarget) return
    
    const customCss = this.customCssInputTarget.value.trim()
    
    if (customCss) {
      this.injectCustomTheme(customCss)
      this.logChange('Custom CSS', 'Applied')
    } else {
      this.removeCustomTheme()
      this.logChange('Custom CSS', 'Removed')
    }
  }
  
  // Inject custom CSS into the page
  injectCustomTheme(customCss) {
    // Remove existing custom theme
    this.removeCustomTheme()
    
    // Create new style element
    const style = document.createElement('style')
    style.id = this.customThemeIdValue
    style.textContent = `
      .app-preview[data-theme="custom"] {
        ${customCss}
      }
    `
    document.head.appendChild(style)
    
    // Apply custom theme to preview
    if (this.hasPreviewTarget) {
      this.previewTarget.setAttribute('data-theme', 'custom')
    }
  }
  
  // Remove custom theme
  removeCustomTheme() {
    const existingStyle = document.getElementById(this.customThemeIdValue)
    if (existingStyle) {
      existingStyle.remove()
    }
    
    if (this.hasPreviewTarget) {
      this.previewTarget.removeAttribute('data-theme')
    }
  }
  
  // Change font family
  changeFontFamily(event) {
    const fontFamily = event.currentTarget.value
    
    if (this.hasPreviewTarget) {
      this.previewTarget.style.fontFamily = fontFamily
    }
    
    this.logChange('Font Family', fontFamily)
  }
  
  // Change font size
  changeFontSize(event) {
    const fontSize = event.currentTarget.value + 'px'
    
    if (this.hasPreviewTarget) {
      this.previewTarget.style.fontSize = fontSize
    }
    
    // Update display value if there's a display element
    const display = event.currentTarget.nextElementSibling
    if (display) {
      display.textContent = fontSize
    }
    
    this.logChange('Font Size', fontSize)
  }
  
  // Reset all customizations
  resetToDefaults(event) {
    event.preventDefault()
    
    // Reset color scheme
    this.colorSchemeValue = 'light'
    
    // Reset accent color
    this.accentColorValue = 'orange'
    
    // Remove custom CSS
    this.removeCustomTheme()
    
    // Clear custom CSS input
    if (this.hasCustomCssInputTarget) {
      this.customCssInputTarget.value = ''
    }
    
    // Reset inline styles
    if (this.hasPreviewTarget) {
      this.previewTarget.style.fontFamily = ''
      this.previewTarget.style.fontSize = ''
      this.previewTarget.setAttribute('data-color-scheme', 'light')
      this.previewTarget.setAttribute('data-accent', 'orange')
    }
    
    // Reset font size display
    if (this.hasFontSizeRangeTarget) {
      this.fontSizeRangeTarget.value = 16
      const display = this.fontSizeRangeTarget.nextElementSibling
      if (display) {
        display.textContent = '16px'
      }
    }
    
    console.log('🔄 Reset to defaults')
  }
  
  // Export current theme as JSON
  exportTheme(event) {
    event.preventDefault()
    
    const theme = {
      colorScheme: this.colorSchemeValue,
      accentColor: this.accentColorValue,
      customCss: this.hasCustomCssInputTarget ? this.customCssInputTarget.value : '',
      fontFamily: this.hasPreviewTarget ? this.previewTarget.style.fontFamily : '',
      fontSize: this.hasPreviewTarget ? this.previewTarget.style.fontSize : '',
      timestamp: new Date().toISOString()
    }
    
    // Create downloadable JSON file
    const blob = new Blob([JSON.stringify(theme, null, 2)], { type: 'application/json' })
    const url = URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `app-preview-theme-${Date.now()}.json`
    link.click()
    URL.revokeObjectURL(url)
    
    console.log('📥 Exported theme:', theme)
  }
  
  // Import theme from JSON
  importTheme(event) {
    const file = event.target.files[0]
    if (!file) return
    
    const reader = new FileReader()
    reader.onload = (e) => {
      try {
        const theme = JSON.parse(e.target.result)
        
        // Apply imported theme
        if (theme.colorScheme) {
          this.colorSchemeValue = theme.colorScheme
          if (this.hasPreviewTarget) {
            this.previewTarget.setAttribute('data-color-scheme', theme.colorScheme)
          }
        }
        
        if (theme.accentColor) {
          this.accentColorValue = theme.accentColor
          if (this.hasPreviewTarget) {
            this.previewTarget.setAttribute('data-accent', theme.accentColor)
          }
        }
        
        if (theme.customCss) {
          if (this.hasCustomCssInputTarget) {
            this.customCssInputTarget.value = theme.customCss
          }
          this.injectCustomTheme(theme.customCss)
        }
        
        if (theme.fontFamily && this.hasPreviewTarget) {
          this.previewTarget.style.fontFamily = theme.fontFamily
        }
        
        if (theme.fontSize && this.hasPreviewTarget) {
          this.previewTarget.style.fontSize = theme.fontSize
        }
        
        console.log('📤 Imported theme:', theme)
      } catch (error) {
        console.error('❌ Failed to import theme:', error)
        alert('Failed to import theme. Please check the file format.')
      }
    }
    reader.readAsText(file)
  }
  
  // Helper: Update active button state
  updateActiveButton(activeButton) {
    // Remove active class from siblings
    const siblings = activeButton.parentElement.querySelectorAll('[data-scheme]')
    siblings.forEach(btn => btn.classList.remove('active'))
    
    // Add active class to clicked button
    activeButton.classList.add('active')
  }
  
  // Helper: Log changes for debugging
  logChange(property, value) {
    console.log(`✨ ${property} changed to: ${value}`)
  }
}

