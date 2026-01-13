# Design System Skill

## Description

You MUST use this skill before creating or updating design tokens, defining foundational styles, or establishing design system foundations.

---

## Purpose

Create complete, production-ready design system foundations that:
- Define consistent design tokens
- Establish typography and color scales
- Document spacing and sizing systems
- Enable systematic design at scale
- Are exportable for development

## When to Use

- Starting a new design system
- Adding new token categories
- Updating existing token values
- Defining foundational patterns

## Prerequisites

- Brand guidelines (if available)
- Platform requirements (web, iOS, Android)
- Accessibility requirements (WCAG level)

## Process

### Step 1: Define Color Palette

Create semantic color tokens:

```markdown
## Color Tokens

### Brand Colors
| Token | Light Mode | Dark Mode | Usage |
|-------|------------|-----------|-------|
| primary-50 | #EFF6FF | #1E3A5F | Subtle backgrounds |
| primary-100 | #DBEAFE | #1E40AF | Hover backgrounds |
| primary-500 | #3B82F6 | #60A5FA | Primary actions |
| primary-600 | #2563EB | #3B82F6 | Hover states |
| primary-700 | #1D4ED8 | #2563EB | Active states |

### Neutral Colors
| Token | Light Mode | Dark Mode | Usage |
|-------|------------|-----------|-------|
| neutral-50 | #FAFAFA | #18181B | Page background |
| neutral-100 | #F4F4F5 | #27272A | Card background |
| neutral-500 | #71717A | #71717A | Muted text |
| neutral-900 | #18181B | #FAFAFA | Primary text |

### Semantic Colors
| Token | Light Mode | Dark Mode | Usage |
|-------|------------|-----------|-------|
| success-500 | #22C55E | #4ADE80 | Success states |
| warning-500 | #F59E0B | #FBBF24 | Warning states |
| error-500 | #EF4444 | #F87171 | Error states |
| info-500 | #3B82F6 | #60A5FA | Info states |
```

### Step 2: Define Typography Scale

Create type tokens:

```markdown
## Typography Tokens

### Font Families
| Token | Value | Usage |
|-------|-------|-------|
| font-sans | Inter, system-ui, sans-serif | Body text |
| font-mono | JetBrains Mono, monospace | Code |

### Font Sizes
| Token | Size | Line Height | Letter Spacing |
|-------|------|-------------|----------------|
| text-xs | 12px | 16px | 0.01em |
| text-sm | 14px | 20px | 0 |
| text-base | 16px | 24px | 0 |
| text-lg | 18px | 28px | -0.01em |
| text-xl | 20px | 28px | -0.01em |
| text-2xl | 24px | 32px | -0.02em |
| text-3xl | 30px | 36px | -0.02em |
| text-4xl | 36px | 40px | -0.02em |

### Font Weights
| Token | Value | Usage |
|-------|-------|-------|
| font-normal | 400 | Body text |
| font-medium | 500 | Emphasis |
| font-semibold | 600 | Subheadings |
| font-bold | 700 | Headings |

### Composite Tokens
| Token | Size | Weight | Line Height |
|-------|------|--------|-------------|
| heading-xl | 36px | 700 | 40px |
| heading-lg | 24px | 700 | 32px |
| heading-md | 20px | 600 | 28px |
| body-lg | 18px | 400 | 28px |
| body-md | 16px | 400 | 24px |
| body-sm | 14px | 400 | 20px |
| button-md | 14px | 600 | 20px |
| caption | 12px | 400 | 16px |
```

### Step 3: Define Spacing Scale

Create spacing tokens:

```markdown
## Spacing Tokens

### Base Scale (4px grid)
| Token | Value | Usage |
|-------|-------|-------|
| space-0 | 0px | Reset |
| space-1 | 4px | Tight |
| space-2 | 8px | Compact |
| space-3 | 12px | Default small |
| space-4 | 16px | Default |
| space-5 | 20px | Relaxed |
| space-6 | 24px | Section |
| space-8 | 32px | Large section |
| space-10 | 40px | Extra large |
| space-12 | 48px | Page section |
| space-16 | 64px | Major section |
| space-20 | 80px | Hero |
| space-24 | 96px | Mega |
```

### Step 4: Define Sizing & Radius

```markdown
## Border Radius
| Token | Value | Usage |
|-------|-------|-------|
| radius-none | 0px | Sharp corners |
| radius-sm | 4px | Subtle rounding |
| radius-md | 8px | Default |
| radius-lg | 12px | Cards |
| radius-xl | 16px | Large cards |
| radius-2xl | 24px | Modals |
| radius-full | 9999px | Pills, avatars |

## Shadows
| Token | Value | Usage |
|-------|-------|-------|
| shadow-sm | 0 1px 2px rgba(0,0,0,0.05) | Subtle elevation |
| shadow-md | 0 4px 6px rgba(0,0,0,0.1) | Cards |
| shadow-lg | 0 10px 15px rgba(0,0,0,0.1) | Dropdowns |
| shadow-xl | 0 20px 25px rgba(0,0,0,0.15) | Modals |

## Z-Index
| Token | Value | Usage |
|-------|-------|-------|
| z-base | 0 | Default |
| z-dropdown | 100 | Dropdowns |
| z-sticky | 200 | Sticky headers |
| z-modal | 300 | Modals |
| z-toast | 400 | Toasts |
| z-tooltip | 500 | Tooltips |
```

### Step 5: Define Motion Tokens

```markdown
## Motion Tokens

### Durations
| Token | Value | Usage |
|-------|-------|-------|
| duration-fast | 100ms | Micro-interactions |
| duration-normal | 200ms | Standard |
| duration-slow | 400ms | Page transitions |

### Easings
| Token | Value | Usage |
|-------|-------|-------|
| ease-default | cubic-bezier(0.4, 0, 0.2, 1) | General |
| ease-in | cubic-bezier(0.4, 0, 1, 1) | Exit |
| ease-out | cubic-bezier(0, 0, 0.2, 1) | Enter |
| ease-spring | cubic-bezier(0.34, 1.56, 0.64, 1) | Bounce |
```

### Step 6: Export Format

Create export-ready token file:

```json
{
  "color": {
    "primary": {
      "50": { "value": "#EFF6FF", "type": "color" },
      "500": { "value": "#3B82F6", "type": "color" },
      "600": { "value": "#2563EB", "type": "color" }
    },
    "neutral": {
      "50": { "value": "#FAFAFA", "type": "color" },
      "900": { "value": "#18181B", "type": "color" }
    }
  },
  "spacing": {
    "1": { "value": "4px", "type": "spacing" },
    "2": { "value": "8px", "type": "spacing" },
    "4": { "value": "16px", "type": "spacing" }
  },
  "radius": {
    "md": { "value": "8px", "type": "borderRadius" }
  }
}
```

## Best Practices

### Do
- Use semantic naming (primary, not blue)
- Include dark mode values for all colors
- Base spacing on 4px or 8px grid
- Test color contrast at every level
- Document usage guidelines

### Don't
- Use arbitrary values outside the scale
- Create one-off tokens for single uses
- Ignore dark mode in initial setup
- Skip accessibility contrast checks
- Leave tokens undocumented

## Common Patterns

### Color Naming
```
{semantic}-{scale}
primary-500, neutral-100, error-500
```

### Spacing Naming
```
space-{multiplier}
space-1 (4px), space-4 (16px)
```

### Token Organization
```
tokens/
├── colors.json
├── typography.json
├── spacing.json
├── effects.json
└── motion.json
```

## Output Checklist

- [ ] Color palette defined (brand, neutral, semantic)
- [ ] Dark mode values for all colors
- [ ] Typography scale with composite tokens
- [ ] Spacing scale on consistent grid
- [ ] Border radius tokens
- [ ] Shadow tokens
- [ ] Motion tokens (duration, easing)
- [ ] Z-index scale
- [ ] Export format ready (JSON)
- [ ] Documentation complete

---

**This skill creates production-ready design tokens that enable consistent, scalable design across all product surfaces.**
