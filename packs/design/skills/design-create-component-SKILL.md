# Design Create Component Skill

## Description

You MUST use this skill before designing any UI component. This applies to buttons, cards, inputs, navigation elements, and any reusable design elements.

---

## Purpose

Create complete, production-ready component designs that:
- Follow atomic design principles
- Include all required states
- Support dark mode variants
- Are accessible (WCAG 2.1 AA)
- Are documented for developer handoff

## When to Use

- Designing any new UI component
- Creating component variants
- Updating existing components
- Building component libraries

## Prerequisites

- Design system tokens defined (colors, spacing, typography)
- Component requirements clear from task
- Target platforms identified (web, mobile, both)

## Process

### Step 1: Define Component Anatomy

Document the component structure:

```markdown
## Button Component Anatomy

### Elements
- Container (background, border)
- Label (text)
- Icon (optional, leading or trailing)
- Loading indicator (optional)

### Sizes
- Small (sm): 32px height
- Medium (md): 40px height
- Large (lg): 48px height

### Variants
- Primary (filled)
- Secondary (outlined)
- Ghost (text only)
```

### Step 2: Apply Design Tokens

Map tokens to component properties:

```markdown
## Token Mapping

### Primary Button
| Property | Token | Value |
|----------|-------|-------|
| Background | primary-500 | #3B82F6 |
| Text | neutral-100 | #FFFFFF |
| Border radius | radius-md | 8px |
| Padding horizontal | space-4 | 16px |
| Padding vertical | space-2 | 8px |
| Font | button-md | 14px/600 |
```

### Step 3: Design All States

Create each required state:

| State | Description | Visual Changes |
|-------|-------------|----------------|
| Default | Resting state | Base token values |
| Hover | Mouse over | Background darkens 10% |
| Active | Click/tap | Background darkens 20% |
| Focused | Keyboard focus | 2px outline offset |
| Disabled | Not interactive | 50% opacity, no pointer |
| Loading | Action in progress | Spinner replaces label |

### Step 4: Create Size Variants

For each size, document:

```markdown
## Size: Medium (md)

### Dimensions
- Height: 40px
- Min width: 80px
- Padding: 8px 16px

### Typography
- Font size: 14px
- Font weight: 600
- Line height: 20px

### Icon
- Size: 16px
- Gap from label: 8px

### Touch Target
- Meets 44px minimum (with padding)
```

### Step 5: Design Dark Mode

Create dark mode variant:

```markdown
## Dark Mode Variant

| Property | Light Mode | Dark Mode |
|----------|------------|-----------|
| Background | primary-500 | primary-400 |
| Text | neutral-100 | neutral-900 |
| Border | transparent | transparent |
| Disabled bg | neutral-200 | neutral-700 |
| Disabled text | neutral-400 | neutral-500 |
```

### Step 6: Document Accessibility

```markdown
## Accessibility Specifications

### Color Contrast
- Default text on background: 7.2:1 (AAA)
- Disabled: 3.1:1 (acceptable for disabled)

### Focus Indicator
- Style: 2px solid primary-400
- Offset: 2px
- Visible on all backgrounds

### Touch Target
- Minimum: 44x44px
- Actual: 40x80px + 2px margin = compliant

### ARIA
- Role: button (native)
- Disabled: aria-disabled="true"
- Loading: aria-busy="true", aria-label="Loading"
```

### Step 7: Create Specification Document

```markdown
# Button Component Specification

## Overview
Primary action button for forms and CTAs.

## Variants
[Table of all variants]

## States
[State table with visual specs]

## Tokens Used
[Complete token reference]

## Responsive Behavior
- Mobile: Full width in forms
- Desktop: Auto width

## Interaction
- Hover delay: 0ms
- Active transition: 100ms ease-out
- Loading spinner: 400ms rotation

## Implementation Notes
- Use native <button> element
- Ensure type="button" for non-submit
- Support icon-only variant with aria-label
```

## Best Practices

### Do
- Start with design tokens, never hardcode values
- Design mobile-first, then adapt for desktop
- Include all interaction states before moving on
- Document edge cases (long labels, icon-only)
- Test color contrast for every state

### Don't
- Skip disabled or loading states
- Forget dark mode variant
- Use arbitrary spacing values
- Ignore touch target requirements
- Leave accessibility undocumented

## Common Patterns

### Icon + Label Button
```
[icon] [label]  or  [label] [icon]
Gap: 8px (space-2)
Icon aligned to text baseline
```

### Loading State
```
Replace label with spinner
Keep button width stable
Use aria-busy="true"
```

### Full Width Variant
```
width: 100%
text-align: center
Maintain min-height
```

## Output Checklist

- [ ] Component anatomy documented
- [ ] All sizes designed (sm, md, lg)
- [ ] All states designed (default, hover, active, focused, disabled, loading)
- [ ] All variants designed (primary, secondary, ghost)
- [ ] Dark mode variant complete
- [ ] Token mapping documented
- [ ] Accessibility specs included
- [ ] Handoff specification written
- [ ] Design file saved at correct path

---

**This skill creates production-ready component designs with comprehensive state coverage, accessibility compliance, and developer-ready specifications.**
