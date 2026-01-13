# Design Icons Skill

## Description

You MUST use this skill before creating icons, icon sets, or icon systems. This applies to UI icons, app icons, and iconography systems.

---

## Purpose

Create complete, production-ready icons that:
- Follow consistent visual style
- Work at multiple sizes
- Support accessibility needs
- Export in required formats
- Integrate with the design system

## When to Use

- Creating new UI icons
- Designing app icons
- Building icon libraries
- Updating existing icon sets

## Prerequisites

- Icon grid and guidelines defined
- Target sizes identified
- Export formats determined
- Brand style understood

## Process

### Step 1: Define Icon Specifications

Document the icon requirements:

```markdown
## Icon Specifications

### Grid
- Base size: 24x24px
- Safe area: 20x20px (2px padding)
- Stroke width: 1.5px
- Corner radius: 2px

### Optical Sizing
| Size | Grid | Stroke | Usage |
|------|------|--------|-------|
| 16px | 16x16 | 1px | Dense UI |
| 20px | 20x20 | 1.5px | Compact |
| 24px | 24x24 | 1.5px | Default |
| 32px | 32x32 | 2px | Prominent |

### Style
- Style: Outlined (stroke-based)
- Caps: Round
- Joins: Round
- Alignment: Pixel-perfect
```

### Step 2: Create Icon Grid

Set up the working grid:

```markdown
## Icon Grid Template

### 24x24 Grid
┌────────────────────────┐
│  ┌──────────────────┐  │
│  │                  │  │
│  │    Safe Area     │  │
│  │     20x20px      │  │
│  │                  │  │
│  └──────────────────┘  │
└────────────────────────┘
   2px margin all sides

### Key Lines
- Horizontal center: 12px
- Vertical center: 12px
- Top keyline: 4px
- Bottom keyline: 20px
- Circle guide: 20px diameter centered
- Square guide: 18x18px centered
```

### Step 3: Design Icons

Create each icon following the grid:

```markdown
## Icon: Search

### Visual Description
Magnifying glass with circular lens and diagonal handle

### Construction
1. Circle: 14px diameter, centered at (10, 10)
2. Handle: Line from (17, 17) to (21, 21)
3. Stroke: 1.5px, round caps

### Keyshapes Used
- Circle for lens
- Line for handle

### Optical Adjustments
- Handle extends 1px beyond circle edge
- Slight overlap for visual connection
```

### Step 4: Ensure Consistency

Check across the icon set:

```markdown
## Consistency Checklist

### Visual Weight
- [ ] All icons have similar visual density
- [ ] Filled areas balanced with strokes
- [ ] No icon significantly lighter/heavier

### Alignment
- [ ] Centered on grid
- [ ] Optical adjustments applied
- [ ] Pixel-aligned strokes

### Style Matching
- [ ] Same stroke width throughout
- [ ] Consistent corner radius
- [ ] Matching cap and join styles
```

### Step 5: Create Size Variants

Optimize for each size:

```markdown
## Size Variants

### 16px Variant
- Reduce stroke to 1px
- Simplify details
- Increase spacing
- May remove secondary elements

### 24px Variant (Base)
- Standard construction
- Full detail
- 1.5px stroke

### 32px Variant
- Increase stroke to 2px
- May add subtle details
- Maintain proportions
```

### Step 6: Prepare Exports

Document export specifications:

```markdown
## Export Specifications

### SVG (Primary)
- Viewport: Match icon size
- Stroke: currentColor (inherits text color)
- Fill: none (for outlined icons)
- Optimize: Remove metadata, simplify paths

### PNG (Fallback)
- Sizes: 1x, 2x, 3x
- Color: Neutral-900 (light mode default)
- Background: Transparent

### Icon Font
- Unicode: Private Use Area (E000+)
- Format: WOFF2, WOFF, TTF
- Ligatures: icon-search, icon-home, etc.

### File Naming
```
icon-{name}.svg
icon-{name}@2x.png
icon-{name}-filled.svg (for filled variants)
```
```

### Step 7: Document Usage

Create usage guidelines:

```markdown
## Icon Usage Guidelines

### Do
- Use icons at intended sizes (16, 20, 24, 32px)
- Pair with text labels for clarity
- Use currentColor for automatic theming
- Maintain touch targets (44px minimum)

### Don't
- Scale icons arbitrarily
- Use icons without labels for critical actions
- Modify stroke width inconsistently
- Recolor with non-system colors

### Accessibility
- Always provide aria-label for icon-only buttons
- Use aria-hidden="true" for decorative icons
- Ensure 3:1 contrast ratio minimum
```

## Best Practices

### Do
- Work on the pixel grid at target sizes
- Test icons at actual sizes before export
- Create size-specific variants for clarity
- Use consistent metaphors across the set
- Optimize SVG output for file size

### Don't
- Design at large sizes and scale down
- Ignore optical adjustments
- Use overly detailed icons for small sizes
- Mix styles within a single set
- Forget dark mode considerations

## Common Patterns

### Icon Types by Function
```
Navigation: Arrow, chevron, menu
Action: Plus, minus, edit, delete
Status: Check, alert, info, error
Object: File, folder, user, settings
Media: Play, pause, volume, camera
```

### Filled vs Outlined
```
Outlined: Default state, navigation
Filled: Active state, selected, emphasis
```

### Paired Icons
```
icon-chevron-left / icon-chevron-right
icon-volume-on / icon-volume-off
icon-eye / icon-eye-off
```

## Output Checklist

- [ ] Icon grid and guidelines documented
- [ ] All icons designed on grid
- [ ] Size variants created (16, 20, 24, 32)
- [ ] Consistency check passed
- [ ] SVG exports optimized
- [ ] PNG exports at all densities
- [ ] Naming conventions followed
- [ ] Usage guidelines documented
- [ ] Accessibility notes included
- [ ] Icon set organized in library

---

**This skill creates production-ready icons with consistent style, proper sizing, and complete export specifications for development implementation.**
