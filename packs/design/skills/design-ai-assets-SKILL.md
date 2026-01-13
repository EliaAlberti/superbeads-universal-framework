# Design AI Assets Skill

## Description

You MUST use this skill before using AI tools to generate design assets. This applies to image generation (Midjourney, DALL-E), copy assistance (Claude, ChatGPT, Gemini), and other AI-assisted design workflows.

---

## Purpose

Create production-quality assets using AI tools that:
- Match brand and design system
- Are properly licensed for use
- Meet quality standards
- Are documented for reproducibility
- Integrate seamlessly with designs

## When to Use

- Generating images, illustrations, or graphics
- Creating placeholder or hero imagery
- Writing microcopy or UI text
- Generating icons or patterns
- Exploring visual directions

## Prerequisites

- Clear asset requirements
- Brand guidelines and design tokens
- Understanding of AI tool capabilities
- License/usage rights verified

## Process

### Step 1: Define Asset Requirements

Document what you need:

```markdown
## Asset Brief

### Type
Image / Illustration / Icon / Pattern / Copy

### Purpose
Hero image for landing page

### Specifications
- Dimensions: 1920x1080px
- Style: Photo-realistic / Illustrated / Abstract
- Mood: Professional, trustworthy, modern
- Color palette: Must align with brand (blue/white primary)
- Subject: Diverse team collaborating in modern office

### Usage
- Web: Landing page hero
- Social: May be cropped for social cards
- Print: None

### Restrictions
- No identifiable faces (if needed, use diverse representation)
- No competitor logos/products visible
- Must be original/licensed for commercial use
```

### Step 2: Select Appropriate AI Tool

Choose the right tool for the job:

```markdown
## AI Tool Selection

### Image Generation
| Tool | Best For | Style Strengths |
|------|----------|-----------------|
| Midjourney | Artistic, stylized, illustrations | Aesthetic quality |
| DALL-E 3 | Photorealistic, specific compositions | Prompt adherence |
| Stable Diffusion | Customizable, self-hosted | Control, privacy |

### Copy/Text
| Tool | Best For |
|------|----------|
| Claude | Nuanced copy, technical writing, tone matching |
| ChatGPT | Versatile, creative variations |
| Gemini | Multimodal, image-aware copy |

### Selected Tool
**Midjourney** - Best for our illustrated style, high aesthetic quality
```

### Step 3: Craft Effective Prompts

Structure prompts for best results:

```markdown
## Prompt Engineering

### Image Prompt Structure
[Subject] [Action/Context] [Style] [Medium] [Lighting] [Composition] [Parameters]

### Example: Team Collaboration Image

**Prompt v1:**
"Diverse team of professionals collaborating around a modern glass table,
minimalist office with plants, soft natural lighting, corporate photography style,
shot on Sony A7III, shallow depth of field --ar 16:9 --style raw --v 6"

**Prompt v2 (refined):**
"Three colleagues reviewing designs on laptop, modern coworking space,
warm natural light from large windows, professional corporate photography,
diversity in team, clean minimal aesthetic, blue and white color scheme
--ar 16:9 --style raw --s 250 --v 6"

### Parameters
| Param | Value | Effect |
|-------|-------|--------|
| --ar | 16:9 | Landscape aspect ratio |
| --style | raw | Less stylized, more realistic |
| --s | 250 | Stylization level (0-1000) |
| --v | 6 | Midjourney version |
```

### Step 4: Iterate and Refine

Document the iteration process:

```markdown
## Iteration Log

### Batch 1 (Initial)
- Prompt: [v1 prompt]
- Results: 4 variations
- Selected: None - lighting too harsh

### Batch 2 (Lighting Fix)
- Prompt: Added "soft natural lighting"
- Results: 4 variations
- Selected: #3 - good composition, needs color adjustment

### Batch 3 (Color Match)
- Prompt: Added "blue and white color scheme"
- Upscaled: Variation #2
- Selected: FINAL - matches brand, good quality

### Final Selection
- File: team-collaboration-v3-2-upscaled.png
- Resolution: 2048x1152
- Post-processing needed: Color grade to match brand primary
```

### Step 5: Post-Process Assets

Align with design system:

```markdown
## Post-Processing

### Color Correction
- Adjusted blue tones to match primary-500 (#3B82F6)
- Increased warmth by 10%
- Lifted shadows for consistency

### Cropping/Sizing
- Cropped to exactly 1920x1080
- Created social variant: 1200x630
- Created mobile variant: 750x1334

### Export
- Web: JPEG, 80% quality (optimized)
- Full: PNG, lossless (archive)
- Social: JPEG, 90% quality
```

### Step 6: AI Copy Generation

For text and microcopy:

```markdown
## Copy Generation with Claude/ChatGPT

### Brief
**Context**: Error message for failed payment
**Tone**: Friendly, helpful, not alarming
**Length**: 1-2 sentences
**Action needed**: Retry or contact support

### Prompt
"Write an error message for when a payment fails. The tone should be
friendly and helpful, not alarming. Include a suggestion to retry or
contact support. Keep it to 1-2 sentences. Provide 5 variations."

### Generated Options
1. "Your payment didn't go through this time. Please try again or contact our support team."
2. "We couldn't process your payment. Double-check your details and try again."
3. "Something went wrong with your payment. Give it another try, or we're here to help."
4. "Payment unsuccessful—this happens sometimes. Try again or reach out to us."
5. "We hit a snag processing your payment. Please retry or contact support."

### Selected: Option 3
- Friendly tone ✓
- Acknowledges issue without blame ✓
- Clear next steps ✓
```

### Step 7: Document for Reproducibility

```markdown
## Asset Documentation

### Final Asset
- File: hero-team-collaboration.jpg
- Dimensions: 1920x1080px
- File size: 245KB

### Generation Details
- Tool: Midjourney v6
- Final prompt: "[full prompt]"
- Seed: 3847291 (if available)
- Post-processing: Lightroom preset "Brand-Blue-Warm"

### License
- Generated with: Midjourney Pro subscription
- Commercial use: Allowed per Midjourney ToS
- Attribution: Not required

### Usage Rights
- Web: ✓ Unlimited
- Print: ✓ Unlimited
- Resale: ✗ Not permitted
```

## Best Practices

### Do
- Start with detailed briefs before prompting
- Iterate systematically, documenting each attempt
- Post-process to match brand colors
- Save prompts and seeds for reproducibility
- Verify licensing for commercial use

### Don't
- Accept first-generation results without review
- Ignore brand guidelines in prompts
- Use AI-generated faces without consideration
- Skip post-processing for brand alignment
- Forget to document the generation process

## Common Patterns

### Hero Images
```
Style: Photorealistic or illustration matching brand
Composition: Leave space for text overlay
Color: Match brand palette
Resolution: 2x for retina displays
```

### Illustrations
```
Style: Consistent across set
Characters: Diverse, inclusive representation
Background: Simple, doesn't compete
Export: SVG when possible, PNG fallback
```

### Placeholder Content
```
Purpose: Design mockups, not production
Style: Match intended final content
Label: Mark clearly as placeholder
Replace: Before production launch
```

## Output Checklist

- [ ] Asset requirements documented
- [ ] Appropriate AI tool selected
- [ ] Prompts crafted and documented
- [ ] Multiple iterations generated
- [ ] Best result selected with rationale
- [ ] Post-processing applied for brand alignment
- [ ] Final assets exported in required formats
- [ ] Full prompt/generation documented
- [ ] Licensing verified and noted
- [ ] Assets organized in design system

---

**This skill enables effective AI-assisted asset creation with proper documentation, brand alignment, and licensing compliance.**
