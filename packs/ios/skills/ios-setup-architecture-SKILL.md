# iOS Setup Architecture Skill

## Description

You MUST use this skill before setting up any new iOS project structure, creating folder hierarchies, establishing MVVM patterns, configuring dependency injection, or making architectural decisions. This is mandatory when starting any new iOS project or restructuring an existing one. Do not scaffold project structure without reading this skill first.

---

## Purpose

Create complete MVVM architecture with:
- Organized folder structure
- Dependency injection framework
- Service layer setup
- Testing infrastructure
- Environment configuration

## When to Use

- Starting a new iOS project
- Restructuring existing projects
- Setting up MVVM architecture
- Creating project scaffolding

## Prerequisites

- Project requirements defined
- Feature list documented
- Target iOS version determined

## Process

### Step 1: Create Folder Structure

```
YourApp/
â”œâ”€â”€ App/
â”‚   â”œâ”€â”€ YourApp.swift
â”‚   â””â”€â”€ AppDelegate.swift (if needed)
â”œâ”€â”€ Models/
â”‚   â”œâ”€â”€ [EntityName].swift
â”‚   â””â”€â”€ [EntityName]+Extensions.swift
â”œâ”€â”€ Views/
â”‚   â”œâ”€â”€ [FeatureName]/
â”‚   â”‚   â”œâ”€â”€ [ScreenName]View.swift
â”‚   â”‚   â””â”€â”€ Components/
â”‚   â”‚       â””â”€â”€ [ComponentName].swift
â”œâ”€â”€ ViewModels/
â”‚   â”œâ”€â”€ [FeatureName]/
â”‚   â”‚   â””â”€â”€ [ScreenName]ViewModel.swift
â”œâ”€â”€ Services/
â”‚   â”œâ”€â”€ Network/
â”‚   â”‚   â”œâ”€â”€ NetworkService.swift
â”‚   â”‚   â””â”€â”€ APIEndpoint.swift
â”‚   â”œâ”€â”€ Persistence/
â”‚   â”‚   â””â”€â”€ PersistenceService.swift
â”‚   â””â”€â”€ [ServiceName]Service.swift
â”œâ”€â”€ Navigation/
â”‚   â”œâ”€â”€ AppRoute.swift
â”‚   â””â”€â”€ NavigationCoordinator.swift
â”œâ”€â”€ Resources/
â”‚   â”œâ”€â”€ Assets.xcassets
â”‚   â”œâ”€â”€ Fonts/
â”‚   â””â”€â”€ Localizable.strings
â”œâ”€â”€ Utilities/
â”‚   â”œâ”€â”€ Extensions/
â”‚   â””â”€â”€ Helpers/
â””â”€â”€ Tests/
    â”œâ”€â”€ ModelTests/
    â”œâ”€â”€ ViewModelTests/
    â””â”€â”€ ServiceTests/
```

### Step 2: Setup Dependency Injection

```swift
// Services/DependencyContainer.swift
import Foundation

final class DependencyContainer: ObservableObject {
    // Services
    let networkService: NetworkService
    let persistenceService: PersistenceService
    let authService: AuthService
    
    // ViewModels Factory
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(networkService: networkService)
    }
    
    init() {
        self.networkService = NetworkService()
        self.persistenceService = PersistenceService()
        self.authService = AuthService(networkService: networkService)
    }
}

// App entry point
@main
struct YourApp: App {
    @StateObject private var container = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            AppNavigationView()
                .environmentObject(container)
        }
    }
}
```

### Step 3: Create Base Service Protocol

```swift
// Services/ServiceProtocol.swift
import Foundation
import Combine

protocol ServiceProtocol {
    associatedtype T
    func fetch() -> AnyPublisher<[T], Error>
    func create(_ item: T) -> AnyPublisher<T, Error>
}
```

### Step 4: Setup Environment Configuration

```swift
// App/Environment.swift
import Foundation

enum Environment {
    case development
    case staging
    case production
    
    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
    
    var baseURL: String {
        switch self {
        case .development:
            return "https://dev.api.example.com"
        case .staging:
            return "https://staging.api.example.com"
        case .production:
            return "https://api.example.com"
        }
    }
}
```

### Step 5: Create App Entry Point

```swift
// App/YourApp.swift
import SwiftUI

@main
struct YourApp: App {
    @StateObject private var container = DependencyContainer()
    @StateObject private var coordinator = NavigationCoordinator()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(container)
                .environmentObject(coordinator)
                .onOpenURL { url in
                    handleDeepLink(url)
                }
        }
    }
    
    private func handleDeepLink(_ url: URL) {
        if let route = DeepLinkHandler.shared.handleURL(url) {
            coordinator.push(route)
        }
    }
}
```

### Step 6: Create Root View

```swift
// Views/RootView.swift
import SwiftUI

struct RootView: View {
    @EnvironmentObject private var container: DependencyContainer
    @State private var isAuthenticated = false
    
    var body: some View {
        Group {
            if isAuthenticated {
                MainTabView()
            } else {
                AuthenticationView()
            }
        }
        .onAppear {
            checkAuthStatus()
        }
    }
    
    private func checkAuthStatus() {
        isAuthenticated = container.authService.isAuthenticated
    }
}
```

### Step 7: Create Feature Module Template

```swift
// Views/[FeatureName]/[FeatureName]View.swift
import SwiftUI

struct [FeatureName]View: View {
    @StateObject private var viewModel: [FeatureName]ViewModel
    
    init(viewModel: [FeatureName]ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        // Implementation
    }
}

// ViewModels/[FeatureName]/[FeatureName]ViewModel.swift
import Foundation
import Combine

final class [FeatureName]ViewModel: ObservableObject {
    @Published var state: ViewState = .idle
    
    private let service: [ServiceName]ServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: [ServiceName]ServiceProtocol) {
        self.service = service
    }
}
```

## Best Practices

### Architecture

âœ… **Do:**
- Keep layers separated
- Use dependency injection
- Follow SOLID principles
- Write testable code

âŒ **Don't:**
- Mix UI and business logic
- Create tight coupling
- Skip protocols
- Ignore separation of concerns

### File Organization

âœ… **Do:**
- Group by feature
- Keep related files together
- Use consistent naming
- Create clear hierarchies

âŒ **Don't:**
- Dump everything in one folder
- Use inconsistent naming
- Create deep nesting
- Mix concerns in files

## Output Checklist

- [ ] Folder structure created
- [ ] Dependency injection setup
- [ ] Service layer implemented
- [ ] Environment configuration added
- [ ] Testing targets configured
- [ ] Navigation architecture defined
- [ ] Feature module template created
- [ ] App entry point configured

---

**This skill creates production-ready MVVM architecture with proper separation of concerns.**