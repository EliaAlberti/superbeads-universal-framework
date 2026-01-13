# iOS Setup Navigation Skill

## Description

You MUST use this skill before implementing any navigation in your iOS app - NavigationStack, TabView, sheets, modals, alerts, deep links, or programmatic navigation. This applies to setting up app-wide navigation architecture, implementing complex navigation flows, and adding deep link support. Do not write navigation code without reading this skill first.

---

## Purpose

Create navigation architecture that:
- Uses NavigationStack for modern SwiftUI navigation
- Implements type-safe routing
- Supports deep linking
- Handles modal presentation
- Provides programmatic navigation
- Maintains navigation state

## When to Use

- Setting up app-wide navigation
- Implementing complex navigation flows
- Adding deep link support
- Creating coordinator pattern (if needed)

## Prerequisites

- App structure defined
- Screen flow documented
- Deep link schemes identified

## Process

### Step 1: Define Route Enum

```swift
// Navigation/AppRoute.swift
import Foundation

enum AppRoute: Hashable {
    // Main tabs
    case home
    case browse
    case favorites
    case profile
    
    // Detail screens
    case itemDetail(id: String)
    case userProfile(userId: String)
    case settings
    
    // Nested flows
    case checkout(items: [String])
    case editProfile(userId: String)
    
    // Auth
    case login
    case signup
    case forgotPassword
}
```

### Step 2: Create Navigation Coordinator

```swift
// Navigation/NavigationCoordinator.swift
import SwiftUI

@MainActor
final class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: AppRoute?
    @Published var fullScreenCover: AppRoute?
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func presentSheet(_ route: AppRoute) {
        sheet = route
    }
    
    func presentFullScreenCover(_ route: AppRoute) {
        fullScreenCover = route
    }
    
    func dismissSheet() {
        sheet = nil
    }
    
    func dismissCover() {
        fullScreenCover = nil
    }
}
```

### Step 3: Create Root Navigation View

```swift
// Navigation/AppNavigationView.swift
import SwiftUI

struct AppNavigationView: View {
    @StateObject private var coordinator = NavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)
                
                BrowseView()
                    .tabItem {
                        Label("Browse", systemImage: "magnifyingglass")
                    }
                    .tag(1)
                
                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }
                    .tag(2)
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(3)
            }
            .navigationDestination(for: AppRoute.self) { route in
                destination(for: route)
            }
        }
        .sheet(item: $coordinator.sheet) { route in
            NavigationStack {
                destination(for: route)
            }
        }
        .fullScreenCover(item: $coordinator.fullScreenCover) { route in
            NavigationStack {
                destination(for: route)
            }
        }
        .environmentObject(coordinator)
    }
    
    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .home:
            HomeView()
        case .browse:
            BrowseView()
        case .favorites:
            FavoritesView()
        case .profile:
            ProfileView()
        case .itemDetail(let id):
            ItemDetailView(itemId: id)
        case .userProfile(let userId):
            UserProfileView(userId: userId)
        case .settings:
            SettingsView()
        case .checkout(let items):
            CheckoutView(itemIds: items)
        case .editProfile(let userId):
            EditProfileView(userId: userId)
        case .login:
            LoginView()
        case .signup:
            SignupView()
        case .forgotPassword:
            ForgotPasswordView()
        }
    }
}
```

### Step 4: Implement Deep Linking

```swift
// Navigation/DeepLinkHandler.swift
import Foundation

final class DeepLinkHandler {
    static let shared = DeepLinkHandler()
    
    private init() {}
    
    func handleURL(_ url: URL) -> AppRoute? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        // Handle custom scheme: myapp://
        guard components.scheme == "myapp" else {
            return nil
        }
        
        // Parse path and parameters
        let path = components.path
        let queryItems = components.queryItems
        
        switch components.host {
        case "item":
            if let id = queryItems?.first(where: { $0.name == "id" })?.value {
                return .itemDetail(id: id)
            }
        case "user":
            if let userId = queryItems?.first(where: { $0.name == "id" })?.value {
                return .userProfile(userId: userId)
            }
        case "checkout":
            if let itemsParam = queryItems?.first(where: { $0.name == "items" })?.value {
                let items = itemsParam.components(separatedBy: ",")
                return .checkout(items: items)
            }
        case "login":
            return .login
        case "signup":
            return .signup
        default:
            break
        }
        
        return nil
    }
    
    // Universal Links: https://example.com/app/item/123
    func handleUniversalLink(_ url: URL) -> AppRoute? {
        let pathComponents = url.pathComponents
        
        guard pathComponents.count >= 3, pathComponents[1] == "app" else {
            return nil
        }
        
        let route = pathComponents[2]
        
        switch route {
        case "item":
            if pathComponents.count >= 4 {
                let id = pathComponents[3]
                return .itemDetail(id: id)
            }
        case "user":
            if pathComponents.count >= 4 {
                let userId = pathComponents[3]
                return .userProfile(userId: userId)
            }
        case "login":
            return .login
        case "signup":
            return .signup
        default:
            break
        }
        
        return nil
    }
}
```

### Step 5: Integrate Deep Links in App

```swift
// YourApp.swift
import SwiftUI

@main
struct YourApp: App {
    @StateObject private var coordinator = NavigationCoordinator()
    
    var body: some Scene {
        WindowGroup {
            AppNavigationView()
                .environmentObject(coordinator)
                .onOpenURL { url in
                    handleDeepLink(url)
                }
        }
    }
    
    private func handleDeepLink(_ url: URL) {
        // Try custom scheme first
        if let route = DeepLinkHandler.shared.handleURL(url) {
            coordinator.push(route)
            return
        }
        
        // Try universal link
        if let route = DeepLinkHandler.shared.handleUniversalLink(url) {
            coordinator.push(route)
            return
        }
    }
}
```

### Step 6: Add Navigation Extensions

```swift
// Extensions/View+Navigation.swift
import SwiftUI

extension View {
    func navigate(to route: AppRoute) -> some View {
        self.modifier(NavigationModifier(route: route))
    }
}

struct NavigationModifier: ViewModifier {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    let route: AppRoute
    
    func body(content: Content) -> some View {
        Button {
            coordinator.push(route)
        } label: {
            content
        }
    }
}

// Usage in views
extension View {
    func withCoordinator() -> some View {
        self.environmentObject(NavigationCoordinator())
    }
}
```

### Step 7: Example View Integration

```swift
// Views/HomeView.swift
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        List(viewModel.items) { item in
            Button {
                coordinator.push(.itemDetail(id: item.id))
            } label: {
                ItemRow(item: item)
            }
        }
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    coordinator.push(.settings)
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
    }
}

// Modal presentation
struct ProfileView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    
    var body: some View {
        VStack {
            // Content
            
            Button("Edit Profile") {
                coordinator.presentSheet(.editProfile(userId: "current"))
            }
            
            Button("Settings") {
                coordinator.push(.settings)
            }
        }
        .navigationTitle("Profile")
    }
}
```

## Best Practices

### Architecture

âœ… **Do:**
- Use NavigationStack for modern navigation
- Define routes in single enum
- Keep coordinator lightweight
- Use environment object for coordinator

âŒ **Don't:**
- Use deprecated NavigationView
- Hardcode screen transitions
- Pass coordinator through initializers
- Mix navigation paradigms

### Deep Linking

âœ… **Do:**
- Validate URL schemes
- Parse parameters safely
- Handle invalid URLs gracefully
- Test all deep link paths

âŒ **Don't:**
- Assume URLs are always valid
- Force-unwrap URL components
- Ignore universal links
- Skip error handling

### State Management

âœ… **Do:**
- Use @Published for path changes
- Clear state on logout
- Restore state if needed
- Handle modal dismissal

âŒ **Don't:**
- Keep stale navigation state
- Ignore memory warnings
- Create retain cycles
- Forget to cleanup

## Common Patterns

### Conditional Navigation

```swift
Button("Continue") {
    if user.isLoggedIn {
        coordinator.push(.checkout(items: cart.items))
    } else {
        coordinator.presentSheet(.login)
    }
}
```

### Navigation with Completion

```swift
func presentEditProfile(completion: @escaping (Bool) -> Void) {
    coordinator.presentSheet(.editProfile(userId: user.id))
    // Handle completion via notification or callback
}
```

### Tab-Specific Navigation

```swift
struct BrowseView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @State private var tabPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $tabPath) {
            // Content
            .navigationDestination(for: AppRoute.self) { route in
                destination(for: route)
            }
        }
    }
}
```

## Output Checklist

Before marking task complete, verify:

- [ ] Route enum defined
- [ ] NavigationCoordinator implemented
- [ ] Root navigation view created
- [ ] Deep linking configured
- [ ] Universal links supported
- [ ] Tab navigation setup
- [ ] Modal presentation working
- [ ] Back navigation handled
- [ ] State restoration considered
- [ ] Tests written for routing logic
- [ ] Documentation added

---

**This skill creates production-ready navigation architecture with type-safe routing and deep linking support.**