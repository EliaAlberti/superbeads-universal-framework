# iOS Setup Storage Skill

## Description

You MUST use this skill before implementing any data persistence - Core Data setup, UserDefaults wrappers, Keychain storage, file storage, or caching mechanisms. This applies to storing user preferences, secure credentials, cached API responses, and any local data storage. Do not write persistence code without reading this skill first.

---

## Purpose

Implement data persistence with:
- Core Data for complex data
- UserDefaults for preferences
- Keychain for sensitive data
- File storage for documents

## When to Use

- Setting up local data storage
- Implementing caching
- Storing user preferences
- Securing sensitive data
- Creating offline support

## Prerequisites

- Data model requirements defined
- Security requirements identified
- Storage strategy determined

## Process

### Step 1: Core Data Stack

```swift
// Services/Persistence/PersistenceService.swift
import CoreData

final class PersistenceService {
    static let shared = PersistenceService()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourApp")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func save() {
        let context = viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Fetch failed: \(error)")
            return []
        }
    }
    
    func delete(_ object: NSManagedObject) {
        viewContext.delete(object)
        save()
    }
}
```

### Step 2: UserDefaults Wrapper

```swift
// Services/Persistence/UserDefaultsService.swift
import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

final class AppSettings {
    @UserDefault(key: "isDarkMode", defaultValue: false)
    static var isDarkMode: Bool
    
    @UserDefault(key: "notificationsEnabled", defaultValue: true)
    static var notificationsEnabled: Bool
    
    @UserDefault(key: "username", defaultValue: "")
    static var username: String
    
    @UserDefault(key: "hasCompletedOnboarding", defaultValue: false)
    static var hasCompletedOnboarding: Bool
}

// Codable support
@propertyWrapper
struct CodableUserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.data(forKey: key),
                  let value = try? JSONDecoder().decode(T.self, from: data) else {
                return defaultValue
            }
            return value
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: key)
            }
        }
    }
}
```

### Step 3: Keychain Service

```swift
// Services/Persistence/KeychainService.swift
import Security
import Foundation

final class KeychainService {
    static let shared = KeychainService()
    
    func save(key: String, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        return status == errSecSuccess ? result as? Data : nil
    }
    
    func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    // Convenience methods for strings
    func saveString(_ value: String, for key: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return save(key: key, data: data)
    }
    
    func loadString(for key: String) -> String? {
        guard let data = load(key: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
```

### Step 4: File Storage Service

```swift
// Services/Persistence/FileStorageService.swift
import Foundation

final class FileStorageService {
    static let shared = FileStorageService()
    
    private let fileManager = FileManager.default
    
    var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    var cachesDirectory: URL {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    func save<T: Encodable>(_ object: T, to filename: String, in directory: URL? = nil) throws {
        let directory = directory ?? documentsDirectory
        let fileURL = directory.appendingPathComponent(filename)
        
        let data = try JSONEncoder().encode(object)
        try data.write(to: fileURL)
    }
    
    func load<T: Decodable>(_ type: T.Type, from filename: String, in directory: URL? = nil) throws -> T {
        let directory = directory ?? documentsDirectory
        let fileURL = directory.appendingPathComponent(filename)
        
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(type, from: data)
    }
    
    func delete(filename: String, in directory: URL? = nil) throws {
        let directory = directory ?? documentsDirectory
        let fileURL = directory.appendingPathComponent(filename)
        
        try fileManager.removeItem(at: fileURL)
    }
    
    func exists(filename: String, in directory: URL? = nil) -> Bool {
        let directory = directory ?? documentsDirectory
        let fileURL = directory.appendingPathComponent(filename)
        
        return fileManager.fileExists(atPath: fileURL.path)
    }
}
```

### Step 5: Cache Service

```swift
// Services/Persistence/CacheService.swift
import Foundation

final class CacheService {
    static let shared = CacheService()
    
    private let cache = NSCache<NSString, AnyObject>()
    private let fileStorage = FileStorageService.shared
    
    init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    // Memory cache
    func set<T: AnyObject>(_ object: T, forKey key: String) {
        cache.setObject(object, forKey: key as NSString)
    }
    
    func get<T: AnyObject>(forKey key: String) -> T? {
        return cache.object(forKey: key as NSString) as? T
    }
    
    func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func clearMemoryCache() {
        cache.removeAllObjects()
    }
    
    // Disk cache
    func saveToDisk<T: Encodable>(_ object: T, forKey key: String) throws {
        try fileStorage.save(object, to: "cache_\(key).json", in: fileStorage.cachesDirectory)
    }
    
    func loadFromDisk<T: Decodable>(_ type: T.Type, forKey key: String) throws -> T {
        return try fileStorage.load(type, from: "cache_\(key).json", in: fileStorage.cachesDirectory)
    }
    
    func clearDiskCache() {
        // Implementation to clear all cache files
    }
}
```

### Step 6: App Group Storage (for Widgets)

```swift
// Services/Persistence/SharedStorage.swift
import Foundation

final class SharedStorage {
    static let shared = SharedStorage()
    
    private let suiteName = "group.com.yourcompany.yourapp"
    
    private var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: suiteName)
    }
    
    var sharedContainerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: suiteName)
    }
    
    func set(_ value: Any?, forKey key: String) {
        sharedDefaults?.set(value, forKey: key)
    }
    
    func get(forKey key: String) -> Any? {
        sharedDefaults?.object(forKey: key)
    }
    
    func save<T: Encodable>(_ object: T, to filename: String) throws {
        guard let containerURL = sharedContainerURL else {
            throw StorageError.containerNotAvailable
        }
        
        let fileURL = containerURL.appendingPathComponent(filename)
        let data = try JSONEncoder().encode(object)
        try data.write(to: fileURL)
    }
    
    func load<T: Decodable>(_ type: T.Type, from filename: String) throws -> T {
        guard let containerURL = sharedContainerURL else {
            throw StorageError.containerNotAvailable
        }
        
        let fileURL = containerURL.appendingPathComponent(filename)
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(type, from: data)
    }
}

enum StorageError: Error {
    case containerNotAvailable
    case fileNotFound
    case encodingFailed
    case decodingFailed
}
```

## Best Practices

### Core Data

âœ… **Do:**
- Use background contexts for heavy operations
- Implement proper error handling
- Use batch operations for bulk updates
- Configure merging policies

âŒ **Don't:**
- Perform heavy operations on main thread
- Ignore context save errors
- Create circular references
- Skip data migration planning

### Keychain

âœ… **Do:**
- Store sensitive data only
- Use appropriate accessibility levels
- Handle errors gracefully
- Clean up on logout

âŒ **Don't:**
- Store large amounts of data
- Use for non-sensitive data
- Ignore keychain errors
- Forget to delete on uninstall

### UserDefaults

âœ… **Do:**
- Store small, simple data
- Use property wrappers
- Synchronize when needed
- Use appropriate keys

âŒ **Don't:**
- Store sensitive data
- Store large objects
- Use for complex data
- Ignore synchronization

## Output Checklist

- [ ] Core Data stack created
- [ ] UserDefaults wrapper implemented
- [ ] Keychain service added
- [ ] File storage configured
- [ ] Cache service implemented
- [ ] App Group storage (if needed)
- [ ] Migration strategy defined
- [ ] Error handling complete
- [ ] Unit tests written

---

**This skill implements production-ready data persistence with multiple storage options.**