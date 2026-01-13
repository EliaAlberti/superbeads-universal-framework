# iOS Create ViewModel Skill

## Description

You MUST use this skill before creating any ViewModel, ObservableObject, or business logic class for SwiftUI views. This applies to implementing view state management, Combine reactive bindings, user interaction handling, and connecting services to views. Do not create ViewModel code without reading this skill first.

---

## Purpose

Generate production-ready ViewModels that:
- Follow MVVM architecture pattern
- Use Combine for reactive data flow
- Handle business logic properly
- Manage state effectively
- Include comprehensive unit tests
- Support dependency injection

## When to Use

- Creating ViewModels for SwiftUI views
- Implementing business logic layer
- Managing view state and user interactions
- Connecting services to views
- Building testable architecture

## Prerequisites

- View requirements defined
- Data models created
- Services/APIs identified
- State management needs understood

## Process

### Step 1: Define ViewModel Structure

```swift
// ViewModels/[FeatureName]/[ViewName]ViewModel.swift
import Foundation
import Combine
import SwiftUI

final class [ViewName]ViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var state: ViewState = .idle
    @Published var items: [Item] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    // MARK: - Input Properties
    @Published var searchText: String = ""
    @Published var selectedFilter: FilterOption = .all
    
    // MARK: - Private Properties
    private let service: ServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(service: ServiceProtocol = Service()) {
        self.service = service
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // Reactive bindings
    }
    
    // MARK: - Public Methods
    func load() {
        // Implementation
    }
    
    func refresh() async {
        // Implementation
    }
    
    // MARK: - Private Methods
    private func handleError(_ error: Error) {
        // Error handling
    }
}

// MARK: - View State

extension [ViewName]ViewModel {
    enum ViewState {
        case idle
        case loading
        case loaded
        case error(String)
        case empty
    }
}
```

### Step 2: Implement Published Properties

**State Properties** (trigger view updates):
```swift
@Published var isLoading: Bool = false
@Published var errorMessage: String?
@Published var showAlert: Bool = false
@Published var items: [Item] = []
```

**Input Properties** (user interactions):
```swift
@Published var searchText: String = ""
@Published var selectedCategory: Category = .all
@Published var sortOption: SortOption = .name
```

**Computed Properties** (derived state):
```swift
var filteredItems: [Item] {
    items.filter { item in
        // Filtering logic
        searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
    }
}

var hasItems: Bool {
    !items.isEmpty
}

var canSave: Bool {
    !isLoading && isValid
}
```

### Step 3: Setup Reactive Bindings

```swift
private func setupBindings() {
    // Search with debounce
    $searchText
        .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
        .removeDuplicates()
        .sink { [weak self] text in
            self?.performSearch(text)
        }
        .store(in: &cancellables)
    
    // Combined filters
    Publishers.CombineLatest($selectedCategory, $sortOption)
        .sink { [weak self] category, sort in
            self?.applyFilters(category: category, sort: sort)
        }
        .store(in: &cancellables)
    
    // Validation
    Publishers.CombineLatest3($name, $email, $age)
        .map { name, email, age in
            !name.isEmpty && email.contains("@") && age >= 18
        }
        .assign(to: &$isValid)
}
```

### Step 4: Implement Business Logic

**Loading Data:**
```swift
func load() {
    guard !isLoading else { return }
    
    state = .loading
    isLoading = true
    errorMessage = nil
    
    service.fetchItems()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.state = .error(error.localizedDescription)
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] items in
            self?.items = items
            self?.state = items.isEmpty ? .empty : .loaded
        }
        .store(in: &cancellables)
}
```

**Async/Await Pattern:**
```swift
@MainActor
func refresh() async {
    isLoading = true
    errorMessage = nil
    
    do {
        items = try await service.fetchItems()
        state = items.isEmpty ? .empty : .loaded
    } catch {
        state = .error(error.localizedDescription)
        errorMessage = error.localizedDescription
    }
    
    isLoading = false
}
```

**User Actions:**
```swift
func deleteItem(_ item: Item) {
    service.deleteItem(id: item.id)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] _ in
            self?.items.removeAll { $0.id == item.id }
        }
        .store(in: &cancellables)
}

func toggleFavorite(_ item: Item) {
    guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
    
    items[index].isFavorite.toggle()
    
    service.updateItem(items[index])
        .sink { completion in
            // Handle completion
        } receiveValue: { _ in
            // Success
        }
        .store(in: &cancellables)
}
```

### Step 5: Handle Validation

```swift
// Real-time validation
private var isValid: Bool {
    !name.isEmpty &&
    email.contains("@") &&
    password.count >= 8
}

// Specific field validation
func validateEmail(_ email: String) -> String? {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    
    if !emailPredicate.evaluate(with: email) {
        return "Please enter a valid email address"
    }
    return nil
}

// Form validation
var validationErrors: [String] {
    var errors: [String] = []
    
    if name.isEmpty {
        errors.append("Name is required")
    }
    
    if let emailError = validateEmail(email) {
        errors.append(emailError)
    }
    
    if password.count < 8 {
        errors.append("Password must be at least 8 characters")
    }
    
    return errors
}
```

### Step 6: Implement Error Handling

```swift
private func handleError(_ error: Error) {
    isLoading = false
    
    if let apiError = error as? APIError {
        switch apiError {
        case .unauthorized:
            errorMessage = "Please log in again"
            // Trigger logout
        case .notFound:
            errorMessage = "Resource not found"
        case .networkError:
            errorMessage = "Please check your internet connection"
        default:
            errorMessage = apiError.localizedDescription
        }
    } else {
        errorMessage = "An unexpected error occurred"
    }
    
    state = .error(errorMessage ?? "Unknown error")
}
```

### Step 7: Add Lifecycle Methods

```swift
func onAppear() {
    if items.isEmpty {
        load()
    }
}

func onDisappear() {
    // Cancel ongoing operations if needed
    cancellables.forEach { $0.cancel() }
}

deinit {
    cancellables.removeAll()
}
```

### Step 8: Create Unit Tests

```swift
// Tests/ViewModels/[ViewName]ViewModelTests.swift
import XCTest
import Combine
@testable import YourApp

final class [ViewName]ViewModelTests: XCTestCase {
    var sut: [ViewName]ViewModel!
    var mockService: MockService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockService()
        sut = [ViewName]ViewModel(service: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Loading Tests
    
    func testLoad_Success_SetsItemsAndState() {
        // Given
        let expectedItems = [Item.mock1, Item.mock2]
        mockService.fetchItemsResult = .success(expectedItems)
        
        let expectation = expectation(description: "Items loaded")
        
        sut.$items
            .dropFirst()
            .sink { items in
                if !items.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.load()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.items, expectedItems)
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testLoad_Failure_SetsErrorState() {
        // Given
        mockService.fetchItemsResult = .failure(APIError.networkError(NSError()))
        
        let expectation = expectation(description: "Error set")
        
        sut.$state
            .dropFirst()
            .sink { state in
                if case .error = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.load()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testLoad_EmptyResponse_SetsEmptyState() {
        // Given
        mockService.fetchItemsResult = .success([])
        
        let expectation = expectation(description: "Empty state set")
        
        sut.$state
            .dropFirst()
            .sink { state in
                if case .empty = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.load()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(sut.items.isEmpty)
    }
    
    // MARK: - Search Tests
    
    func testSearchText_DebounceAndFilter() {
        // Given
        sut.items = [
            Item(name: "Apple"),
            Item(name: "Banana"),
            Item(name: "Apricot")
        ]
        
        let expectation = expectation(description: "Search completed")
        
        // When
        sut.searchText = "App"
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            XCTAssertEqual(self.sut.filteredItems.count, 2)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Validation Tests
    
    func testIsValid_WithValidInputs_ReturnsTrue() {
        // Given
        sut.name = "John Doe"
        sut.email = "john@example.com"
        sut.password = "password123"
        
        // Then
        XCTAssertTrue(sut.isValid)
    }
    
    func testIsValid_WithInvalidEmail_ReturnsFalse() {
        // Given
        sut.name = "John Doe"
        sut.email = "invalid-email"
        sut.password = "password123"
        
        // Then
        XCTAssertFalse(sut.isValid)
    }
    
    // MARK: - Delete Tests
    
    func testDeleteItem_Success_RemovesItem() {
        // Given
        let item = Item.mock1
        sut.items = [item, Item.mock2]
        mockService.deleteItemResult = .success(())
        
        let expectation = expectation(description: "Item deleted")
        
        sut.$items
            .dropFirst()
            .sink { items in
                if items.count == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.deleteItem(item)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.items.count, 1)
        XCTAssertFalse(sut.items.contains(where: { $0.id == item.id }))
    }
}

// MARK: - Mock Service

class MockService: ServiceProtocol {
    var fetchItemsResult: Result<[Item], Error> = .success([])
    var deleteItemResult: Result<Void, Error> = .success(())
    
    func fetchItems() -> AnyPublisher<[Item], Error> {
        fetchItemsResult.publisher
            .delay(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func deleteItem(id: String) -> AnyPublisher<Void, Error> {
        deleteItemResult.publisher
            .delay(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
```

## Best Practices

### Architecture

âœ… **Do:**
- Keep ViewModels focused on single responsibility
- Use dependency injection for testability
- Separate business logic from view logic
- Use protocols for services

âŒ **Don't:**
- Import SwiftUI in ViewModels (except for @Published)
- Access UIKit directly
- Perform view layout logic
- Store references to views

### Combine

âœ… **Do:**
- Use proper operators (debounce, removeDuplicates, combineLatest)
- Always specify scheduler for UI updates
- Store cancellables properly
- Use [weak self] to avoid retain cycles

âŒ **Don't:**
- Forget to receive on main thread for UI updates
- Create retain cycles
- Ignore cancellation
- Overuse nested subscriptions

### State Management

âœ… **Do:**
- Define clear state enum
- Update state atomically
- Provide computed properties for derived state
- Use @Published for all public state

âŒ **Don't:**
- Expose mutable collections directly
- Update state from multiple threads
- Keep redundant state
- Ignore race conditions

### Testing

âœ… **Do:**
- Test all public methods
- Mock dependencies
- Test error scenarios
- Verify state transitions
- Use expectations for async code

âŒ **Don't:**
- Test private implementation
- Skip error cases
- Make tests flaky with timing
- Test framework code

## Common Patterns

### Pagination

```swift
@Published var items: [Item] = []
@Published var canLoadMore: Bool = true
private var currentPage: Int = 1

func loadMore() {
    guard canLoadMore, !isLoading else { return }
    
    isLoading = true
    
    service.fetchItems(page: currentPage)
        .sink { [weak self] completion in
            self?.isLoading = false
            if case .failure = completion {
                self?.canLoadMore = false
            }
        } receiveValue: { [weak self] newItems in
            if newItems.isEmpty {
                self?.canLoadMore = false
            } else {
                self?.items.append(contentsOf: newItems)
                self?.currentPage += 1
            }
        }
        .store(in: &cancellables)
}
```

### Optimistic Updates

```swift
func toggleFavorite(_ item: Item) {
    // Optimistic update
    if let index = items.firstIndex(where: { $0.id == item.id }) {
        items[index].isFavorite.toggle()
        let previousState = !items[index].isFavorite
        
        // Sync with backend
        service.updateFavorite(itemId: item.id, isFavorite: items[index].isFavorite)
            .sink { [weak self] completion in
                if case .failure = completion {
                    // Revert on failure
                    if let index = self?.items.firstIndex(where: { $0.id == item.id }) {
                        self?.items[index].isFavorite = previousState
                    }
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
```

### Form Submission

```swift
func submit() {
    guard isValid else {
        showValidationErrors = true
        return
    }
    
    isLoading = true
    errorMessage = nil
    
    let request = FormRequest(
        name: name,
        email: email,
        password: password
    )
    
    service.submit(request)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            
            if case .failure(let error) = completion {
                self?.handleError(error)
            }
        } receiveValue: { [weak self] response in
            self?.showSuccess = true
            // Navigate or dismiss
        }
        .store(in: &cancellables)
}
```

## Output Checklist

Before marking task complete, verify:

- [ ] ViewModel follows MVVM pattern
- [ ] All @Published properties defined
- [ ] Reactive bindings setup correctly
- [ ] Business logic implemented
- [ ] Error handling comprehensive
- [ ] Validation implemented
- [ ] Dependency injection used
- [ ] Unit tests written (>80% coverage)
- [ ] All tests passing
- [ ] No retain cycles (checked with Instruments)
- [ ] Thread safety ensured
- [ ] Documentation added

---

**This skill creates production-ready ViewModels with reactive data flow, comprehensive testing, and proper architecture.**