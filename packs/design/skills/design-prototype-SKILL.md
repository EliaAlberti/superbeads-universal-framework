# Design Prototype Skill

## Description

You MUST use this skill before creating interactive prototypes, user flows, or clickable demos. This applies to flow prototypes, micro-interaction demos, and usability test materials.

---

## Purpose

Create complete, demonstrable prototypes that:
- Show realistic user flows
- Demonstrate interactions and transitions
- Enable usability testing
- Communicate behavior to developers
- Validate design decisions

## When to Use

- Creating clickable flow prototypes
- Demonstrating micro-interactions
- Preparing usability test materials
- Documenting complex interactions

## Prerequisites

- Screen designs completed
- User flow defined
- Interaction requirements clear
- Tool access (Figma, Principle, etc.)

## Process

### Step 1: Define Prototype Scope

Document what the prototype covers:

```markdown
## Prototype: Onboarding Flow

### Scope
- Screens: Welcome → Profile Setup → Preferences → Success
- Interactions: Form inputs, button clicks, transitions
- NOT included: Error states, edge cases

### Purpose
- Usability testing with 5 participants
- Developer handoff for transitions
- Stakeholder review

### Fidelity
- Visual: High (final designs)
- Interaction: Medium (key flows only)
- Data: Static (placeholder content)
```

### Step 2: Map User Flow

Document the flow structure:

```markdown
## Flow Map

### Happy Path
1. Welcome Screen
   → [Get Started] → Profile Setup
2. Profile Setup
   → [Continue] → Preferences
3. Preferences
   → [Finish] → Success
   → [Skip] → Success

### Alternative Paths
- Any screen → [X] → Exit confirmation
- Profile → [Back] → Welcome
- Preferences → [Back] → Profile

### Flow Diagram
```
[Welcome] ──[Get Started]──▶ [Profile] ──[Continue]──▶ [Preferences] ──[Finish]──▶ [Success]
                               │                          │
                               └──[Back]──◀───────────────┘
```
```

### Step 3: Define Interactions

Specify each interaction:

```markdown
## Interaction Specifications

### Button: Get Started
| Property | Value |
|----------|-------|
| Trigger | On tap/click |
| Action | Navigate to Profile |
| Transition | Slide left (300ms) |
| Easing | ease-out |

### Form Input: Name Field
| Property | Value |
|----------|-------|
| On focus | Border color primary-500 |
| On blur (valid) | Border color neutral-300 |
| On blur (invalid) | Border color error-500, show error |
| Keyboard | Text input, auto-capitalize |

### Button Hover
| Property | Value |
|----------|-------|
| Trigger | Mouse enter |
| Action | Background to primary-600 |
| Duration | 150ms |
| Easing | ease-out |
```

### Step 4: Specify Transitions

Document screen transitions:

```markdown
## Screen Transitions

### Forward Navigation (Next)
| Property | Value |
|----------|-------|
| Type | Slide |
| Direction | Left |
| Duration | 300ms |
| Easing | cubic-bezier(0.4, 0, 0.2, 1) |
| Incoming | Slide in from right |
| Outgoing | Slide out to left |

### Back Navigation
| Property | Value |
|----------|-------|
| Type | Slide |
| Direction | Right |
| Duration | 300ms |
| Easing | cubic-bezier(0.4, 0, 0.2, 1) |
| Incoming | Slide in from left |
| Outgoing | Slide out to right |

### Modal Open
| Property | Value |
|----------|-------|
| Type | Fade + Scale |
| Duration | 250ms |
| Overlay | Fade to 50% black |
| Modal | Scale from 95% to 100%, fade in |
```

### Step 5: Create Micro-interactions

Document component-level interactions:

```markdown
## Micro-interactions

### Checkbox Toggle
```
Initial: Unchecked (empty box)
On tap:
  1. Box scales to 90% (50ms)
  2. Box scales to 100% (100ms)
  3. Checkmark draws in (150ms)
  4. Background fills with primary-500
Total: 300ms
```

### Success Checkmark Animation
```
On complete:
  1. Circle draws (200ms, clockwise)
  2. Pause (100ms)
  3. Checkmark draws (200ms, stroke animation)
  4. Scale bounce (1.1 → 1, 200ms, spring)
Total: 700ms
```

### Loading Spinner
```
Continuous:
  - Rotation: 360° per 800ms
  - Easing: linear
  - Stroke dasharray animation
```
```

### Step 6: Set Up Hotspots

Document interactive areas:

```markdown
## Hotspot Map: Profile Screen

### Interactive Elements
| Element | Hotspot Area | Action |
|---------|--------------|--------|
| Back arrow | 44x44px | Navigate back |
| Name input | Full field | Activate keyboard |
| Avatar upload | 80x80px circle | Open image picker |
| Continue button | Full button | Navigate to next |
| Skip link | Link bounds | Navigate to next |

### Non-interactive
- Progress indicator (display only)
- Helper text (display only)
- Avatar placeholder (before upload)
```

### Step 7: Document for Handoff

Create developer-ready specs:

```markdown
## Prototype Handoff

### Files
- Figma prototype: [link]
- Exported video: onboarding-flow.mp4
- GIFs: checkbox-toggle.gif, success-animation.gif

### Timing Sheet
| Animation | Duration | Easing | CSS/Swift |
|-----------|----------|--------|-----------|
| Screen slide | 300ms | ease-out | transition: transform 300ms ease-out |
| Button hover | 150ms | ease-out | transition: background 150ms ease-out |
| Checkbox | 300ms | spring | UISpringTimingParameters |

### Assets Needed
- Lottie file: success-checkmark.json
- SVG sprite: icons.svg
```

## Best Practices

### Do
- Start with the happy path, add alternatives later
- Use consistent transition patterns
- Match timing to platform conventions (iOS, Android, Web)
- Test on actual devices before handoff
- Export video recordings for reference

### Don't
- Prototype every edge case
- Use overly complex animations
- Ignore touch target sizes
- Forget loading and error states
- Skip documentation

## Common Patterns

### Mobile Navigation
```
Forward: Slide left 300ms
Back: Slide right 300ms
Modal: Slide up 350ms
Dismiss: Slide down 300ms
```

### Feedback Animations
```
Success: Scale bounce + checkmark draw
Error: Shake horizontal (3x, 50ms each)
Loading: Continuous spinner
```

### State Transitions
```
Button press: Scale to 95%, 100ms
Button release: Scale to 100%, 150ms
Card hover: Subtle lift (shadow increase)
```

## Output Checklist

- [ ] Prototype scope and purpose defined
- [ ] User flow mapped with all paths
- [ ] All interactions specified (triggers, actions, timing)
- [ ] Screen transitions documented
- [ ] Micro-interactions detailed
- [ ] Hotspots mapped
- [ ] Prototype file created and linked
- [ ] Video/GIF exports for reference
- [ ] Developer handoff specs complete

---

**This skill creates interactive prototypes with clear specifications that enable usability testing and accurate development implementation.**
