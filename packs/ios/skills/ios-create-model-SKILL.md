# iOS Create Model Skill

## Description

You MUST use this skill before creating any data model, struct, class, enum, DTO, entity, or Codable type. This applies to API response models, domain entities, Core Data managed objects, and value types for state management. Do not create model code without reading this skill first.

---

## Purpose

Generate production-ready data models that:
- Conform to Codable for serialization
- Implement Identifiable for SwiftUI
- Support Hashable and Equatable when needed
- Include proper relationships
- Have computed properties for business logic
- Are immutable by default with clear mutation points

## When to Use

- Creating data models from API responses
- Implementing domain entities
- Building Core Data managed objects
- Defining value types for state management

## Prerequisites

- API documentation or schema
- Understanding of data relationships
- Knowledge of required properties
- Naming conventions established

## Process

### Step 1: Define Basic Model

```swift
// Models/[ModelName].swift
import Foundation

struct [ModelName]: Codable, Identifiable, Hashable {
    // MARK: - Properties
    let id: String
    let name: String
    let createdAt: Date
    var updatedAt: Date
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
```

### Step 2: Add Computed Properties

```swift
extension [ModelName] {
    // MARK: - Computed Properties
    
    var displayName: String {
        name.capitalized
    }
    
    var ageInDays: Int {
        Calendar.current.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
    }
    
    var formattedDate: String {
        createdAt.formatted(date: .abbreviated, time: .omitted)
    }
    
    var isRecent: Bool {
        let daysSince = Calendar.current.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
        return daysSince <= 7
    }
}
```

### Step 3: Implement Relationships

**One-to-Many:**
```swift
struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    var posts: [Post]
}

struct Post: Codable, Identifiable {
    let id: String
    let title: String
    let content: String
    let userId: String
    let createdAt: Date
}
```

**Many-to-Many:**
```swift
struct Student: Codable, Identifiable {
    let id: String
    let name: String
    var enrollments: [Enrollment]
    
    var courses: [Course] {
        enrollments.map { $0.course }
    }
}

struct Course: Codable, Identifiable {
    let id: String
    let name: String
    let code: String
}

struct Enrollment: Codable, Identifiable {
    let id: String
    let studentId: String
    let courseId: String
    let enrolledAt: Date
    var course: Course
}
```

### Step 4: Add Convenience Initializers

```swift
extension [ModelName] {
    // MARK: - Convenience Initializers
    
    init(name: String) {
        self.init(
            id: UUID().uuidString,
            name: name,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
    
    // For preview/testing
    static var preview: [ModelName] {
        [
            [ModelName](id: "1", name: "Sample 1", createdAt: Date(), updatedAt: Date()),
            [ModelName](id: "2", name: "Sample 2", createdAt: Date(), updatedAt: Date()),
        ]
    }
    
    static var empty: [ModelName] {
        [ModelName](id: "", name: "", createdAt: Date(), updatedAt: Date())
    }
}
```

### Step 5: Implement Custom Codable (When Needed)

**Complex JSON Structure:**
```swift
struct User: Codable {
    let id: String
    let name: String
    let email: String
    let address: Address
    let preferences: Preferences
    
    struct Address: Codable {
        let street: String
        let city: String
        let country: String
    }
    
    struct Preferences: Codable {
        let theme: String
        let notifications: Bool
    }
    
    // Custom decoding for nested structure
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        
        // Decode nested address
        let addressContainer = try container.nestedContainer(keyedBy: AddressCodingKeys.self, forKey: .address)
        address = Address(
            street: try addressContainer.decode(String.self, forKey: .street),
            city: try addressContainer.decode(String.self, forKey: .city),
            country: try addressContainer.decode(String.self, forKey: .country)
        )
        
        // Decode preferences with defaults
        let preferencesContainer = try? container.nestedContainer(keyedBy: PreferencesCodingKeys.self, forKey: .preferences)
        preferences = Preferences(
            theme: (try? preferencesContainer?.decode(String.self, forKey: .theme)) ?? "light",
            notifications: (try? preferencesContainer?.decode(Bool.self, forKey: .notifications)) ?? true
        )
    }
}
```

**Date Formatting:**
```swift
struct Event: Codable {
    let id: String
    let name: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id, name, date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        // Custom date decoding
        let dateString = try container.decode(String.self, forKey: .date)
        let formatter = ISO8601DateFormatter()
        
        guard let date = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .date,
                in: container,
                debugDescription: "Date string does not match expected format"
            )
        }
        
        self.date = date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: date)
        try container.encode(dateString, forKey: .date)
    }
}
```

### Step 6: Add Validation

```swift
extension [ModelName] {
    // MARK: - Validation
    
    var isValid: Bool {
        !name.isEmpty &&
        email.contains("@") &&
        age >= 18
    }
    
    func validate() throws {
        guard !name.isEmpty else {
            throw ValidationError.emptyName
        }
        
        guard email.contains("@") else {
            throw ValidationError.invalidEmail
        }
        
        guard age >= 18 else {
            throw ValidationError.underAge
        }
    }
}

enum ValidationError: LocalizedError {
    case emptyName
    case invalidEmail
    case underAge
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Name cannot be empty"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .underAge:
            return "You must be at least 18 years old"
        }
    }
}
```

### Step 7: Implement Mutation Methods

```swift
extension [ModelName] {
    // MARK: - Mutations
    
    func updated(name: String) -> [ModelName] {
        var copy = self
        copy.name = name
        copy.updatedAt = Date()
        return copy
    }
    
    func markAsRead() -> [ModelName] {
        var copy = self
        copy.isRead = true
        copy.readAt = Date()
        return copy
    }
    
    mutating func toggleFavorite() {
        isFavorite.toggle()
        updatedAt = Date()
    }
}
```

### Step 8: Add Mock Data

```swift
#if DEBUG
extension [ModelName] {
    // MARK: - Mock Data
    
    static let mock1 = [ModelName](
        id: "1",
        name: "John Doe",
        email: "john@example.com",
        createdAt: Date(),
        updatedAt: Date()
    )
    
    static let mock2 = [ModelName](
        id: "2",
        name: "Jane Smith",
        email: "jane@example.com",
        createdAt: Date().addingTimeInterval(-86400),
        updatedAt: Date()
    )
    
    static let mockArray: [[ModelName]] = [mock1, mock2]
    
    static func random() -> [ModelName] {
        [ModelName](
            id: UUID().uuidString,
            name: ["Alice", "Bob", "Charlie", "Diana"].randomElement()!,
            email: "\(UUID().uuidString)@example.com",
            createdAt: Date().addingTimeInterval(-Double.random(in: 0...86400*30)),
            updatedAt: Date()
        )
    }
}
#endif
```

## Common Patterns

### Enum-Based Models

```swift
enum Status: String, Codable {
    case pending
    case active
    case completed
    case cancelled
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var color: Color {
        switch self {
        case .pending: return .yellow
        case .active: return .green
        case .completed: return .blue
        case .cancelled: return .red
        }
    }
}
```

### Optional Property Handling

```swift
struct Profile: Codable {
    let id: String
    let name: String
    let bio: String?
    let avatarURL: URL?
    
    var displayBio: String {
        bio ?? "No bio available"
    }
    
    var hasAvatar: Bool {
        avatarURL != nil
    }
}
```

### Nested Collections

```swift
struct Restaurant: Codable, Identifiable {
    let id: String
    let name: String
    let menu: [MenuCategory]
    
    var allItems: [MenuItem] {
        menu.flatMap { $0.items }
    }
    
    func items(in category: String) -> [MenuItem] {
        menu.first(where: { $0.name == category })?.items ?? []
    }
}

struct MenuCategory: Codable, Identifiable {
    let id: String
    let name: String
    let items: [MenuItem]
}

struct MenuItem: Codable, Identifiable {
    let id: String
    let name: String
    let price: Decimal
    let description: String?
}
```

### Value Transformations

```swift
struct Price: Codable {
    let amount: Decimal
    let currency: String
    
    var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
    }
}
```

## Best Practices

### Structure

âœ… **Do:**
- Use structs for value types
- Make properties immutable (let) when possible
- Provide clear property names
- Group related properties

âŒ **Don't:**
- Use classes unless reference semantics needed
- Expose implementation details
- Create mutable properties without reason
- Skip documentation

### Codable

âœ… **Do:**
- Use CodingKeys for snake_case conversion
- Handle optionals gracefully
- Provide default values where appropriate
- Document expected JSON format

âŒ **Don't:**
- Force-unwrap decoded values
- Ignore decoding errors
- Assume all properties always present
- Skip custom decoding when needed

### Relationships

âœ… **Do:**
- Model relationships explicitly
- Use computed properties for derived data
- Keep models focused
- Document relationship types

âŒ **Don't:**
- Create circular dependencies
- Embed large collections
- Ignore cascade deletion needs
- Mix concerns

### Testing

âœ… **Do:**
- Test encoding/decoding
- Verify computed properties
- Test validation logic
- Create mock data for tests

âŒ **Don't:**
- Skip edge cases
- Ignore invalid data
- Test implementation details
- Forget nil cases

## Unit Tests Example

```swift
// Tests/Models/[ModelName]Tests.swift
import XCTest
@testable import YourApp

final class [ModelName]Tests: XCTestCase {
    
    func testDecoding_ValidJSON_Success() throws {
        // Given
        let json = """
        {
            "id": "123",
            "name": "Test",
            "created_at": "2025-01-01T00:00:00Z",
            "updated_at": "2025-01-01T00:00:00Z"
        }
        """
        
        let data = json.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let model = try decoder.decode([ModelName].self, from: data)
        
        // Then
        XCTAssertEqual(model.id, "123")
        XCTAssertEqual(model.name, "Test")
    }
    
    func testEncoding_ValidModel_Success() throws {
        // Given
        let model = [ModelName](
            id: "123",
            name: "Test",
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(model)
        
        // Then
        XCTAssertNotNil(data)
        
        // Verify round-trip
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode([ModelName].self, from: data)
        XCTAssertEqual(decoded.id, model.id)
        XCTAssertEqual(decoded.name, model.name)
    }
    
    func testComputedProperty_DisplayName() {
        // Given
        let model = [ModelName](
            id: "1",
            name: "test name",
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // Then
        XCTAssertEqual(model.displayName, "Test Name")
    }
    
    func testValidation_ValidModel_ReturnsTrue() {
        // Given
        let model = [ModelName](
            id: "1",
            name: "John",
            email: "john@example.com",
            age: 25
        )
        
        // Then
        XCTAssertTrue(model.isValid)
    }
    
    func testValidation_InvalidEmail_ReturnsFalse() {
        // Given
        let model = [ModelName](
            id: "1",
            name: "John",
            email: "invalid",
            age: 25
        )
        
        // Then
        XCTAssertFalse(model.isValid)
    }
    
    func testEquality_SameProperties_Equal() {
        // Given
        let model1 = [ModelName](id: "1", name: "Test")
        let model2 = [ModelName](id: "1", name: "Test")
        
        // Then
        XCTAssertEqual(model1, model2)
    }
    
    func testHashability_DifferentInstances_CanBeStoredInSet() {
        // Given
        let model1 = [ModelName](id: "1", name: "Test")
        let model2 = [ModelName](id: "2", name: "Test")
        
        // When
        let set: Set<[ModelName]> = [model1, model2]
        
        // Then
        XCTAssertEqual(set.count, 2)
    }
}
```

## Output Checklist

Before marking task complete, verify:

- [ ] Model conforms to Codable
- [ ] Model implements Identifiable
- [ ] Hashable/Equatable implemented if needed
- [ ] CodingKeys defined for snake_case
- [ ] Computed properties added
- [ ] Validation logic implemented
- [ ] Convenience initializers provided
- [ ] Mock data created for testing
- [ ] Relationships properly modeled
- [ ] Custom coding logic (if needed)
- [ ] Documentation added
- [ ] Unit tests written
- [ ] All tests passing

---

**This skill creates production-ready data models with proper protocols, relationships, and comprehensive testing.**