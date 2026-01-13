# iOS Create View Skill

## Description

You MUST use this skill before creating any SwiftUI view, screen, component, modal, sheet, card, list row, or any UI element. This applies to implementing screens from Figma designs, building reusable UI components, and converting UIKit views to SwiftUI. Do not create view code without reading this skill first.

---

## Purpose

Generate complete, production-ready SwiftUI views that:
- Match design specifications pixel-perfect
- Follow iOS design guidelines
- Implement full accessibility
- Handle all view states (loading, error, empty, success)
- Include SwiftUI previews
- Are testable and maintainable

## When to Use

- Creating any new SwiftUI view
- Implementing screens from Figma designs
- Building reusable UI components
- Converting UIKit views to SwiftUI

## Prerequisites

- Design system documented (colors, typography, spacing)
- Figma designs available (if applicable)
- View requirements clear (what data to display, interactions)

## Process

### Step 1: Gather Context

**From Beads task:**
- View name and purpose
- Parent feature
- Data requirements
- User interactions needed

**From Design System:**
- Color palette
- Typography scale
- Spacing values
- Component patterns

**From Figma (if provided):**
- Layout specifications
- Component hierarchy
- Exact measurements
- Interaction states

### Step 2: Structure the View

```swift
// Features/[FeatureName]/Views/[ViewName].swift
import SwiftUI

struct [ViewName]: View {
    // MARK: - Properties
    @StateObject private var viewModel: [ViewName]ViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    
    // MARK: - Initialization
    init(viewModel: [ViewName]ViewModel = [ViewName]ViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    var body: some View {
        content
            .navigationTitle("[Title]")
            .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .loaded:
            loadedView
        case .error(let message):
            errorView(message: message)
        case .empty:
            emptyView
        }
    }
    
    private var loadedView: some View {
        // Main content here
        ScrollView {
            VStack(spacing: Spacing.medium) {
                // Components
            }
            .padding()
        }
    }
    
    private var loadingView: some View {
        ProgressView()
    }
    
    private func errorView(message: String) -> some View {
        ContentUnavailableView(
            "Error",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
        )
    }
    
    private var emptyView: some View {
        ContentUnavailableView(
            "[Empty State Title]",
            systemImage: "[sf.symbol]",
            description: Text("[Empty state description]")
        )
    }
}

// MARK: - Supporting Types

extension [ViewName] {
    enum Field: Hashable {
        case field1
        case field2
    }
}

// MARK: - Previews

#Preview("[ViewName] - Loaded") {
    NavigationStack {
        [ViewName]()
    }
}

#Preview("[ViewName] - Loading") {
    NavigationStack {
        [ViewName](viewModel: MockViewModel.loading)
    }
}

#Preview("[ViewName] - Error") {
    NavigationStack {
        [ViewName](viewModel: MockViewModel.error)
    }
}

#Preview("[ViewName] - Empty") {
    NavigationStack {
        [ViewName](viewModel: MockViewModel.empty)
    }
}
```

### Step 3: Implement Accessibility

**Every view must:**

1. **Semantic Labels**
   ```swift
   Image(systemName: "star")
       .accessibilityLabel("Favorite")
   ```

2. **Hints for Actions**
   ```swift
   Button("Delete") { }
       .accessibilityHint("Removes this item")
   ```

3. **Value for Status**
   ```swift
   Toggle("Notifications", isOn: $enabled)
       .accessibilityValue(enabled ? "Enabled" : "Disabled")
   ```

4. **Group Related Content**
   ```swift
   HStack {
       Text("Username")
       Text(user.name)
   }
   .accessibilityElement(children: .combine)
   ```

5. **Dynamic Type Support**
   ```swift
   Text("Title")
       .font(.title)
       .minimumScaleFactor(0.5)
   ```

### Step 4: Apply Design System

**Colors:**
```swift
.foregroundColor(Color.theme.primary)
.background(Color.theme.background)
```

**Typography:**
```swift
.font(.theme.headline)
.font(.theme.body)
```

**Spacing:**
```swift
VStack(spacing: Spacing.medium) {
    // content
}
.padding(Spacing.large)
```

### Step 5: Handle States

**Loading State:**
- Show ProgressView or skeleton
- Disable interactions
- Provide feedback

**Success State:**
- Display data
- Enable interactions
- Smooth transitions

**Error State:**
- Clear error message
- Retry option
- Helpful guidance

**Empty State:**
- Friendly message
- Actionable suggestion
- Relevant icon

### Step 6: Add Interactions

**Buttons:**
```swift
Button {
    viewModel.performAction()
} label: {
    Label("Action", systemImage: "icon")
}
.buttonStyle(.borderedProminent)
.disabled(viewModel.isLoading)
```

**Text Fields:**
```swift
TextField("Placeholder", text: $viewModel.text)
    .textFieldStyle(.roundedBorder)
    .autocapitalization(.none)
    .keyboardType(.emailAddress)
    .focused($focusedField, equals: .email)
    .onChange(of: viewModel.text) { oldValue, newValue in
        viewModel.validate(newValue)
    }
```

**Lists:**
```swift
List(viewModel.items) { item in
    NavigationLink(value: item) {
        ItemRow(item: item)
    }
}
.navigationDestination(for: Item.self) { item in
    ItemDetailView(item: item)
}
```

### Step 7: Create Previews

**Multiple preview states:**
- Loaded with data
- Loading
- Error
- Empty
- Different device sizes
- Light/dark mode

```swift
#Preview("iPhone SE") {
    [ViewName]()
        .previewDevice("iPhone SE (3rd generation)")
}

#Preview("Dark Mode") {
    [ViewName]()
        .preferredColorScheme(.dark)
}

#Preview("Large Text") {
    [ViewName]()
        .environment(\.sizeCategory, .accessibilityExtraLarge)
}
```

## Best Practices

### Structure

âœ… **Do:**
- Break complex views into smaller components
- Extract reusable components
- Use ViewBuilder for conditional content
- Group related views in MARK sections

âŒ **Don't:**
- Put all logic in one massive body
- Repeat code across views
- Nest more than 3-4 levels deep
- Mix business logic with UI

### Performance

âœ… **Do:**
- Use LazyVStack/LazyHStack for long lists
- Implement proper list diffing
- Avoid expensive computations in body
- Use @State for view-local state only

âŒ **Don't:**
- Load all data at once
- Perform network calls in body
- Create unnecessary view updates
- Ignore memory warnings

### Testing

âœ… **Do:**
- Test all view states render correctly
- Verify accessibility labels
- Check responsive layouts
- Validate user interactions

âŒ **Don't:**
- Test UIKit implementation details
- Mock SwiftUI components
- Test Apple's framework
- Ignore edge cases

## Common Patterns

### Form View

```swift
Form {
    Section("Personal Info") {
        TextField("Name", text: $viewModel.name)
        TextField("Email", text: $viewModel.email)
    }
    
    Section("Preferences") {
        Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
        Picker("Theme", selection: $viewModel.theme) {
            ForEach(Theme.allCases) { theme in
                Text(theme.name).tag(theme)
            }
        }
    }
    
    Section {
        Button("Save") {
            viewModel.save()
        }
        .disabled(!viewModel.isValid)
    }
}
```

### List with Pull to Refresh

```swift
List(viewModel.items) { item in
    ItemRow(item: item)
}
.refreshable {
    await viewModel.refresh()
}
```

### Search + Filter

```swift
List(viewModel.filteredItems) { item in
    ItemRow(item: item)
}
.searchable(text: $viewModel.searchText)
.navigationTitle("Items")
```

## Output Checklist

Before marking task complete, verify:

- [ ] View renders correctly
- [ ] All states implemented (loading, success, error, empty)
- [ ] Design system applied throughout
- [ ] Accessibility labels/hints added
- [ ] Dynamic Type supported
- [ ] Previews created for all states
- [ ] Responsive on different devices
- [ ] Dark mode supported
- [ ] Interactions work as expected
- [ ] No SwiftUI warnings
- [ ] Follows project naming conventions

## Examples

See the iOS Skills examples directory for complete view implementations.

---

**This skill creates production-ready SwiftUI views that are accessible, maintainable, and pixel-perfect.**