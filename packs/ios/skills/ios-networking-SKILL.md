# iOS Networking Skill

## Description

You MUST use this skill before implementing any networking - URLSession setup, API clients, REST or GraphQL integration, authentication handling, request/response processing, caching, or offline support. This is mandatory for all network-related code. Do not write networking code without reading this skill first.

---

## Purpose

Create robust networking layer with:
- URLSession configuration
- Combine publishers
- Request/response handling
- Error mapping
- Retry logic
- Offline support
- Authentication handling
- Comprehensive error handling
- Proper logging and monitoring

## When to Use

- Setting up networking layer
- Creating API clients
- Integrating any REST or GraphQL API
- Setting up backend service connections
- Implementing third-party SDK integrations
- Creating network service layers

## Prerequisites

- API documentation reviewed
- Authentication method understood
- Endpoint specifications clear
- Response/request models defined
- Error scenarios identified

## Process

### Step 1: Create Network Service

```swift
// Services/Network/NetworkService.swift
import Foundation
import Combine
import Network

final class NetworkService {
    static let shared = NetworkService()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let monitor = NWPathMonitor()
    
    @Published var isConnected: Bool = true
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        
        self.session = URLSession(configuration: configuration)
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
        self.encoder.keyEncodingStrategy = .convertToSnakeCase
        
        setupNetworkMonitoring()
    }
    
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        body: Encodable? = nil
    ) -> AnyPublisher<T, Error> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authorization if available
        if let token = AuthManager.shared.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                return Fail(error: NetworkError.encodingFailed)
                    .eraseToAnyPublisher()
            }
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.httpError(statusCode: httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error -> Error in
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.decodingFailed
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
}
```

### Step 2: Define API Endpoints

```swift
// Services/Network/APIEndpoint.swift
import Foundation

enum APIEndpoint {
    case items
    case item(id: String)
    case createItem
    case updateItem(id: String)
    case deleteItem(id: String)
    
    var baseURL: String {
        Environment.current.baseURL
    }
    
    var path: String {
        switch self {
        case .items, .createItem:
            return "/items"
        case .item(let id), .updateItem(let id), .deleteItem(let id):
            return "/items/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .items, .item:
            return .get
        case .createItem:
            return .post
        case .updateItem:
            return .put
        case .deleteItem:
            return .delete
        }
    }
    
    var url: URL? {
        URL(string: baseURL + path)
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}
```

### Step 3: Define Error Types

```swift
// Models/NetworkError.swift
import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case encodingFailed
    case decodingFailed
    case noConnection
    case unauthorized
    case notFound
    case serverError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .encodingFailed:
            return "Failed to encode request"
        case .decodingFailed:
            return "Failed to decode response"
        case .noConnection:
            return "No internet connection"
        case .unauthorized:
            return "You are not authorized to perform this action"
        case .notFound:
            return "The requested resource was not found"
        case .serverError:
            return "Server error. Please try again later"
        case .unknown:
            return "An unknown error occurred"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .noConnection:
            return "Check your internet connection and try again"
        case .unauthorized:
            return "Please log in again"
        case .serverError:
            return "Please try again in a few moments"
        default:
            return "Please try again"
        }
    }
}
```

### Step 4: Create API Configuration

```swift
// Services/APIConfiguration.swift
import Foundation

struct APIConfiguration {
    static let baseURL = URL(string: "https://api.example.com/v1")!
    static let timeout: TimeInterval = 30
    
    enum Endpoint {
        case items
        case item(id: String)
        case createItem
        case updateItem(id: String)
        case deleteItem(id: String)
        
        var path: String {
            switch self {
            case .items, .createItem:
                return "/items"
            case .item(let id), .updateItem(let id), .deleteItem(let id):
                return "/items/\(id)"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .items, .item:
                return .get
            case .createItem:
                return .post
            case .updateItem:
                return .put
            case .deleteItem:
                return .delete
            }
        }
    }
}
```

### Step 5: Create Service Protocol and Implementation

```swift
// Services/[ServiceName]Service.swift
import Foundation
import Combine

protocol [ServiceName]ServiceProtocol {
    func fetchItems() -> AnyPublisher<[Item], Error>
    func fetchItem(id: String) -> AnyPublisher<Item, Error>
    func createItem(_ item: ItemRequest) -> AnyPublisher<Item, Error>
    func updateItem(id: String, _ item: ItemRequest) -> AnyPublisher<Item, Error>
    func deleteItem(id: String) -> AnyPublisher<Void, Error>
}

final class [ServiceName]Service: [ServiceName]ServiceProtocol {
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func fetchItems() -> AnyPublisher<[Item], Error> {
        networkService.request(endpoint: .items)
            .retry(2) // Retry twice on failure
            .eraseToAnyPublisher()
    }
    
    func fetchItem(id: String) -> AnyPublisher<Item, Error> {
        networkService.request(endpoint: .item(id: id))
            .retry(2)
            .eraseToAnyPublisher()
    }
    
    func createItem(_ item: ItemRequest) -> AnyPublisher<Item, Error> {
        networkService.request(endpoint: .createItem, body: item)
    }
    
    func updateItem(id: String, _ item: ItemRequest) -> AnyPublisher<Item, Error> {
        networkService.request(endpoint: .updateItem(id: id), body: item)
    }
    
    func deleteItem(id: String) -> AnyPublisher<Void, Error> {
        networkService.request(endpoint: .deleteItem(id: id))
    }
}
```

### Step 6: Add Caching

```swift
// Services/CacheService.swift
import Foundation

final class CacheService {
    static let shared = CacheService()
    
    private let cache = NSCache<NSString, AnyObject>()
    private let expirationTime: TimeInterval = 300 // 5 minutes
    
    private init() {
        cache.countLimit = 100
    }
    
    func get<T: Codable>(key: String) -> T? {
        guard let cacheEntry = cache.object(forKey: key as NSString) as? CacheEntry<T>,
              !cacheEntry.isExpired else {
            return nil
        }
        return cacheEntry.value
    }
    
    func set<T: Codable>(_ value: T, forKey key: String) {
        let entry = CacheEntry(value: value, expirationDate: Date().addingTimeInterval(expirationTime))
        cache.setObject(entry as AnyObject, forKey: key as NSString)
    }
    
    func remove(key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func clear() {
        cache.removeAllObjects()
    }
}

private class CacheEntry<T> {
    let value: T
    let expirationDate: Date
    
    init(value: T, expirationDate: Date) {
        self.value = value
        self.expirationDate = expirationDate
    }
    
    var isExpired: Bool {
        Date() > expirationDate
    }
}
```

### Step 7: Add Service to ViewModel

```swift
// ViewModels/ItemsViewModel.swift
import Foundation
import Combine

final class ItemsViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let service: [ServiceName]ServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: [ServiceName]ServiceProtocol = [ServiceName]Service()) {
        self.service = service
    }
    
    func loadItems() {
        isLoading = true
        error = nil
        
        service.fetchItems()
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] items in
                self?.items = items
            }
            .store(in: &cancellables)
    }
    
    func deleteItem(_ item: Item) {
        service.deleteItem(id: item.id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.items.removeAll { $0.id == item.id }
            }
            .store(in: &cancellables)
    }
}
```

## Best Practices

### Authentication

âœ… **Do:**
- Store tokens securely in Keychain
- Refresh tokens before expiration
- Handle 401 responses gracefully
- Clear credentials on logout

âŒ **Don't:**
- Store tokens in UserDefaults
- Hardcode API keys
- Ignore token expiration
- Send tokens over HTTP

### Error Handling

âœ… **Do:**
- Map HTTP status codes to meaningful errors
- Provide recovery suggestions
- Log errors for debugging
- Show user-friendly messages

âŒ **Don't:**
- Swallow errors silently
- Show technical errors to users
- Ignore network conditions
- Retry indefinitely

### Performance

âœ… **Do:**
- Use background threads for network calls
- Implement proper caching
- Batch requests when possible
- Cancel ongoing requests on view disappearance

âŒ **Don't:**
- Block main thread
- Make excessive API calls
- Ignore memory limits
- Keep all responses in memory

### Testing

âœ… **Do:**
- Mock network service for tests
- Test error scenarios
- Verify retry logic
- Test offline behavior

âŒ **Don't:**
- Make real API calls in tests
- Skip error case testing
- Ignore edge cases
- Test implementation details

## Common Patterns

### Pagination

```swift
func fetchItems(page: Int, pageSize: Int) -> AnyPublisher<PaginatedResponse<Item>, Error> {
    var components = URLComponents(url: APIConfiguration.baseURL, resolvingAgainstBaseURL: false)!
    components.queryItems = [
        URLQueryItem(name: "page", value: "\(page)"),
        URLQueryItem(name: "page_size", value: "\(pageSize)")
    ]
    
    // Implementation
}
```

### Upload with Progress

```swift
func uploadImage(_ image: UIImage) -> AnyPublisher<UploadProgress, Error> {
    // Implementation with progress tracking
}
```

### WebSocket Connection

```swift
final class WebSocketService {
    private var webSocket: URLSessionWebSocketTask?
    
    func connect() {
        let session = URLSession(configuration: .default)
        webSocket = session.webSocketTask(with: URL(string: "wss://api.example.com")!)
        webSocket?.resume()
        receiveMessage()
    }
    
    private func receiveMessage() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let message):
                // Handle message
                self?.receiveMessage() // Continue receiving
            case .failure(let error):
                // Handle error
                print("WebSocket error: \(error)")
            }
        }
    }
}
```

## Output Checklist

Before marking task complete, verify:

- [ ] Network service created
- [ ] Error handling implemented
- [ ] Combine integration complete
- [ ] Offline detection setup
- [ ] API endpoints defined
- [ ] Service protocol defined
- [ ] Network layer implemented
- [ ] Authentication working
- [ ] Retry logic added
- [ ] Caching implemented (if needed)
- [ ] ViewModels integrated
- [ ] Unit tests written
- [ ] Error scenarios tested
- [ ] Offline behavior handled
- [ ] Documentation added

## Security Checklist

- [ ] HTTPS used for all requests
- [ ] Tokens stored in Keychain
- [ ] No sensitive data logged
- [ ] Certificate pinning (if required)
- [ ] Request signing (if required)
- [ ] Rate limiting respected
- [ ] User data encrypted

---

**This skill creates secure, robust API integrations with proper error handling and offline support.**