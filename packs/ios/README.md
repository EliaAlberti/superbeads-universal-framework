# iOS Pack for SuperBeads Framework

iOS/SwiftUI development pack providing specialized agents and skills for iOS app development.

## Overview

| Component | Count | Description |
|-----------|-------|-------------|
| Agents | 4 | iOS-specialized agents extending core patterns |
| Skills | 9 | Complete iOS development skill library |
| Templates | 2 | verify.sh + DESIGN-SYSTEM.md |

## Agents

| Agent | Role | Model | Purpose |
|-------|------|-------|---------|
| `ios-strategist` | Strategist | Sonnet | Architecture, task planning, MVVM design |
| `ios-executor` | Executor | Sonnet | Swift/SwiftUI implementation |
| `ios-specialist` | Specialist | Sonnet | Complex UI, animations, pixel-perfect |
| `ios-critic` | Critic | Haiku | Code review, test verification |

## Skills

| Skill | Category | Purpose |
|-------|----------|---------|
| `ios-create-view` | UI | SwiftUI view creation with accessibility |
| `ios-create-viewmodel` | Logic | MVVM ViewModel with Combine |
| `ios-create-model` | Data | Codable models with validation |
| `ios-setup-navigation` | Architecture | NavigationStack patterns |
| `ios-networking` | Services | URLSession + Combine networking |
| `ios-setup-subscription` | Services | StoreKit 2 subscriptions |
| `ios-create-widget` | Extensions | WidgetKit implementation |
| `ios-setup-architecture` | Architecture | Project structure setup |
| `ios-setup-storage` | Services | Core Data / SwiftData |

## Installation

```bash
# Using SuperBeads CLI
superbeads pack install ios

# Or manually
cp -r packs/ios/agents/* ~/.superbeads/agents/
cp -r packs/ios/skills/* ~/.superbeads/skills/ios/
```

## Project Setup

After installing the pack, set up your iOS project:

```bash
# Initialize SuperBeads in your iOS project
cd your-ios-project
superbeads init

# Install iOS pack
superbeads pack install ios

# Configure verify.sh
# Edit scripts/verify.sh to set your SCHEME
```

## Configuration

Edit `scripts/verify.sh` with your project settings:

```bash
SCHEME="YourAppScheme"
DESTINATION="platform=iOS Simulator,name=iPhone 15"
PROJECT_TYPE="xcodeproj"  # or "xcworkspace"
```

## Workflow

### 1. Planning (ios-strategist)

```
User: "Add user authentication"

ios-strategist:
- Analyzes requirements
- Designs MVVM architecture
- Creates 10-15 min tasks with context
- Sets up sprint tracking
```

### 2. Implementation (ios-executor)

```
ios-executor:
- Reads task specification
- Loads ONE relevant skill
- Implements Swift/SwiftUI code
- Runs verification
- Commits with task reference
```

### 3. Complex UI (ios-specialist)

```
ios-specialist:
- Handles advanced SwiftUI
- Custom animations
- Pixel-perfect designs
- Accessibility compliance
```

### 4. Review (ios-critic)

```
ios-critic:
- Runs verify.sh
- Checks against criteria
- Reviews code quality
- Reports issues with fixes
```

## Patterns

The iOS pack enforces these patterns:

- **MVVM Architecture**: Views, ViewModels, Models separation
- **Design Tokens**: No magic numbers, use Spacing/Color/Typography
- **State Management**: @StateObject/@ObservedObject/@State
- **Accessibility**: Labels, hints, Dynamic Type
- **Verification**: Build + tests before completion

## File Structure

```
packs/ios/
├── pack.json              # Pack manifest
├── README.md              # This file
├── agents/
│   ├── ios-strategist.md  # Planning agent
│   ├── ios-executor.md    # Implementation agent
│   ├── ios-specialist.md  # UI specialist agent
│   └── ios-critic.md      # Review agent
├── skills/
│   ├── ios-create-view-SKILL.md
│   ├── ios-create-viewmodel-SKILL.md
│   ├── ios-create-model-SKILL.md
│   ├── ios-setup-navigation-SKILL.md
│   ├── ios-networking-SKILL.md
│   ├── ios-setup-subscription-SKILL.md
│   ├── ios-create-widget-SKILL.md
│   ├── ios-setup-architecture-SKILL.md
│   └── ios-setup-storage-SKILL.md
├── templates/
│   └── verify.sh          # Verification script template
└── scripts/
    └── (project-specific scripts)
```

## Related Documentation

- `core/docs/UNIVERSAL-AGENTS.md` — Base agent patterns
- `core/docs/TASK-DISCIPLINE.md` — Task sizing rules
- `core/docs/VERIFICATION-FRAMEWORK.md` — Verification patterns

## Version

- Pack Version: 1.0.0
- Requires Core: >=1.0.0
