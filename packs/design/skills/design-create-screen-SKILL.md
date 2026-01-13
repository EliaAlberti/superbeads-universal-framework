# Design Create Screen Skill

## Description

You MUST use this skill before designing any complete screen or page. This applies to app screens, web pages, modals, and any full-view designs.

---

## Purpose

Create complete, production-ready screen designs that:
- Follow established layout patterns
- Use existing components from the design system
- Support responsive breakpoints
- Include all required screen states
- Are documented for developer handoff

## When to Use

- Designing new app screens or web pages
- Creating modal or overlay designs
- Designing onboarding flows
- Building dashboard or data-heavy views

## Prerequisites

- Component library available
- Layout grid defined
- Screen requirements clear from task
- User flow context understood

## Process

### Step 1: Define Screen Purpose

Document the screen's role:

```markdown
## Screen: Login

### Purpose
Allow returning users to access their account

### User Goal
Quick, frictionless access to personalized content

### Entry Points
- Direct URL: /login
- Redirect from protected routes
- "Sign In" CTA from header

### Success State
- Redirect to dashboard
- Session cookie set
```

### Step 2: Map Information Architecture

Define content hierarchy:

```markdown
## Content Hierarchy

### Primary
1. Logo/Brand
2. Email input
3. Password input
4. Submit button

### Secondary
- "Forgot password?" link
- "Remember me" checkbox

### Tertiary
- Social login options
- "Create account" link
- Legal/privacy links
```

### Step 3: Apply Layout Grid

Use the established grid system:

```markdown
## Layout Grid

### Mobile (< 768px)
- Columns: 4
- Gutter: 16px
- Margin: 16px
- Content: Centered, full width

### Tablet (768-1024px)
- Columns: 8
- Gutter: 24px
- Margin: 32px
- Content: 6 columns centered

### Desktop (> 1024px)
- Columns: 12
- Gutter: 24px
- Margin: 64px
- Content: 4 columns centered (form)
```

### Step 4: Compose with Components

Reference existing components:

```markdown
## Components Used

| Component | Variant | Count |
|-----------|---------|-------|
| Text Input | default | 2 |
| Button | primary, lg | 1 |
| Checkbox | default | 1 |
| Link | default | 3 |
| Divider | text ("or") | 1 |
| Social Button | Google, Apple | 2 |
```

### Step 5: Design Screen States

Create all required states:

| State | Description | Elements |
|-------|-------------|----------|
| Empty | Initial load | Empty inputs, CTA disabled |
| Filling | User typing | Active input states |
| Ready | Form valid | CTA enabled |
| Loading | Submitting | Button loading state |
| Error | Validation failed | Error messages shown |
| Success | Auth complete | Redirect (no UI) |

### Step 6: Add Empty & Error States

```markdown
## Error States

### Field-level Errors
- Position: Below input
- Color: error-500
- Icon: Alert circle
- Text: Specific guidance

### Form-level Errors
- Position: Above form
- Style: Alert component (error variant)
- Dismissible: Yes

## Empty States
N/A for login (always has form)
```

### Step 7: Design Responsive Variants

```markdown
## Responsive Behavior

### Mobile (< 768px)
- Stack all elements vertically
- Full-width inputs and buttons
- Logo smaller (120px)
- Social buttons stack

### Desktop (> 1024px)
- Centered card layout (max 400px)
- Optional: Split layout with illustration
- Social buttons inline
```

### Step 8: Create Specification Document

```markdown
# Login Screen Specification

## Layout
- Type: Centered card
- Max width: 400px
- Padding: 32px (space-8)
- Background: neutral-100 (light), neutral-900 (dark)

## Spacing
| Element | Spacing |
|---------|---------|
| Logo to form | 48px |
| Input to input | 16px |
| Input to button | 24px |
| Button to social | 32px |

## Typography
| Element | Style |
|---------|-------|
| Heading | heading-lg |
| Labels | body-sm |
| Body | body-md |
| Links | body-sm, primary-500 |

## Components
[Reference to component specs]

## Interactions
- Form validation: On blur
- Submit: On enter or click
- Error clear: On focus

## Accessibility
- Focus order: Logo → Email → Password → Remember → Submit → Forgot → Social
- Skip link: To main content
- Errors: Announced via aria-live
```

## Best Practices

### Do
- Reuse existing components, don't redesign
- Design mobile-first, then desktop
- Include all states (empty, loading, error, success)
- Document scroll behavior for long content
- Consider keyboard and screen reader flow

### Don't
- Create new components when existing ones work
- Ignore responsive breakpoints
- Skip error and empty states
- Forget dark mode
- Leave spacing undocumented

## Common Patterns

### Centered Card
```
Container: flex, center, min-height: 100vh
Card: max-width: 400px, padding: 32px
Background: Subtle gradient or illustration
```

### Split Layout
```
Left: Marketing content, illustration
Right: Form content
Mobile: Stack, form on top
```

### Full-Width Header
```
Header: Fixed, full width
Content: Below header, scrollable
Footer: Sticky bottom or end of content
```

## Output Checklist

- [ ] Screen purpose and user goal documented
- [ ] Information architecture defined
- [ ] Layout grid applied correctly
- [ ] All components from design system used
- [ ] All screen states designed (empty, loading, error, success)
- [ ] Responsive variants for all breakpoints
- [ ] Dark mode variant complete
- [ ] Spacing and typography documented
- [ ] Accessibility flow documented
- [ ] Design file saved at correct path

---

**This skill creates production-ready screen designs with complete state coverage, responsive behavior, and comprehensive specifications for development.**
