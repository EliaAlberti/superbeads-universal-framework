# Design Handoff Skill

## Description

You MUST use this skill before creating developer handoff documentation. This applies to component specs, screen documentation, and any design-to-development transition materials.

---

## Purpose

Create complete, developer-ready handoff documentation that:
- Contains all measurements and specifications
- Includes all states and variants
- Provides exportable assets
- Answers implementation questions
- Reduces back-and-forth between design and development

## When to Use

- Completing component design for development
- Finishing screen designs for implementation
- Updating existing components with changes
- Creating design system documentation

## Prerequisites

- Design work complete (all states, variants)
- Design tokens defined
- Export formats agreed upon
- Development framework known (React, SwiftUI, etc.)

## Process

### Step 1: Prepare Handoff Checklist

Verify design is complete:

```markdown
## Pre-Handoff Checklist

### Design Completeness
- [ ] All states designed (default, hover, active, disabled, error, loading)
- [ ] All variants included (sizes, styles)
- [ ] Dark mode variant complete
- [ ] Responsive breakpoints designed
- [ ] Edge cases considered (long text, empty state)

### Documentation Ready
- [ ] Token mapping documented
- [ ] Spacing measurements added
- [ ] Interaction notes written
- [ ] Accessibility requirements noted
```

### Step 2: Document Measurements

Provide all dimensions:

```markdown
## Button Component Specifications

### Dimensions

#### Small (sm)
| Property | Value | Token |
|----------|-------|-------|
| Height | 32px | - |
| Min width | 64px | - |
| Padding horizontal | 12px | space-3 |
| Padding vertical | 6px | - |
| Border radius | 6px | radius-sm |
| Font size | 14px | text-sm |

#### Medium (md)
| Property | Value | Token |
|----------|-------|-------|
| Height | 40px | - |
| Min width | 80px | - |
| Padding horizontal | 16px | space-4 |
| Padding vertical | 8px | space-2 |
| Border radius | 8px | radius-md |
| Font size | 14px | text-sm |

#### Large (lg)
| Property | Value | Token |
|----------|-------|-------|
| Height | 48px | - |
| Min width | 96px | - |
| Padding horizontal | 24px | space-6 |
| Padding vertical | 12px | space-3 |
| Border radius | 8px | radius-md |
| Font size | 16px | text-base |
```

### Step 3: Specify Colors and Styles

Document visual properties:

```markdown
## Visual Specifications

### Primary Button
| State | Background | Text | Border |
|-------|------------|------|--------|
| Default | primary-500 | white | none |
| Hover | primary-600 | white | none |
| Active | primary-700 | white | none |
| Disabled | neutral-200 | neutral-400 | none |
| Loading | primary-500 | white | none |

### Secondary Button
| State | Background | Text | Border |
|-------|------------|------|--------|
| Default | transparent | primary-500 | 1px primary-500 |
| Hover | primary-50 | primary-600 | 1px primary-600 |
| Active | primary-100 | primary-700 | 1px primary-700 |
| Disabled | transparent | neutral-400 | 1px neutral-300 |

### Focus State (All Variants)
- Outline: 2px solid primary-400
- Outline offset: 2px
```

### Step 4: Document Interactions

Specify behavior:

```markdown
## Interaction Specifications

### Hover Transition
```css
transition: background-color 150ms ease-out,
            border-color 150ms ease-out;
```

### Active State
```css
transform: scale(0.98);
transition: transform 100ms ease-out;
```

### Loading State
- Replace label with spinner
- Maintain button width (prevent layout shift)
- Spinner: 16px, rotating 360° per 800ms
- Disable pointer events

### Keyboard
- Focus: Tab navigation
- Activate: Enter or Space
- Focus visible: Show outline
```

### Step 5: Provide Assets

List exportable assets:

```markdown
## Exported Assets

### Icons
| Icon | File | Size | Format |
|------|------|------|--------|
| Loading spinner | spinner.svg | 16x16 | SVG |
| Checkmark | check.svg | 16x16 | SVG |
| Arrow right | arrow-right.svg | 16x16 | SVG |

### Location
All assets exported to: `/design/exports/button/`

### Asset Usage
- SVG: Use as inline SVG or img src
- Icons use currentColor for automatic theming
- Include loading spinner for async buttons
```

### Step 6: Add Developer Notes

Provide implementation guidance:

```markdown
## Developer Notes

### HTML Structure
```html
<button class="btn btn-primary btn-md" type="button">
  <span class="btn-icon btn-icon-leading"><!-- optional --></span>
  <span class="btn-label">Button Label</span>
  <span class="btn-icon btn-icon-trailing"><!-- optional --></span>
</button>
```

### Accessibility
- Use native `<button>` element
- Add `type="button"` for non-submit buttons
- Loading state: Add `aria-busy="true"` and `aria-disabled="true"`
- Icon-only: Add `aria-label="Action description"`

### Edge Cases
- Long labels: Truncate with ellipsis, no wrap
- Icon-only: Minimum 40px touch target
- Full width: Add `btn-block` class

### Related Components
- ButtonGroup: For connected buttons
- IconButton: For icon-only variant
- LinkButton: For navigation styled as button
```

### Step 7: Create Handoff Document

Compile into single reference:

```markdown
# Button Component Handoff

## Overview
Primary action component for forms and CTAs.

## Quick Reference
- Figma: [Link to component]
- Tokens: primary-*, neutral-*, space-*, radius-*
- States: default, hover, active, disabled, loading

## Specifications
[Include all measurements, colors, interactions from above]

## Code Examples
[Framework-specific examples if available]

## Changelog
| Date | Change | Designer |
|------|--------|----------|
| 2024-01-15 | Initial handoff | @designer |
| 2024-01-20 | Added loading state | @designer |
```

## Best Practices

### Do
- Use design tokens, not raw values
- Include all states and variants
- Provide code-ready measurements
- Annotate edge cases and gotchas
- Link to related components

### Don't
- Leave measurements vague ("some padding")
- Skip disabled or error states
- Forget dark mode specs
- Assume developers will guess
- Ignore accessibility requirements

## Common Patterns

### Component Handoff
```
1. Measurements (dimensions, spacing)
2. Colors (states, variants)
3. Typography (font, size, weight)
4. Interactions (transitions, animations)
5. Assets (icons, images)
6. Accessibility (ARIA, keyboard)
7. Developer notes (edge cases, gotchas)
```

### Screen Handoff
```
1. Layout grid
2. Component placement
3. Responsive behavior
4. Navigation/routing
5. Loading/error states
6. Assets
```

## Output Checklist

- [ ] Pre-handoff checklist complete
- [ ] All measurements documented with tokens
- [ ] Color specifications for all states
- [ ] Interaction specifications with code
- [ ] Assets exported and listed
- [ ] Developer notes with edge cases
- [ ] Accessibility requirements documented
- [ ] Handoff document compiled
- [ ] Figma link included
- [ ] Changelog started

---

**This skill creates comprehensive handoff documentation that enables developers to implement designs accurately without extensive back-and-forth.**
