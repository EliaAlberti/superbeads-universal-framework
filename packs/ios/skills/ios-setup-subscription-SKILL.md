# iOS Setup Subscriptions Skill

## Description

You MUST use this skill before implementing any in-app purchases - StoreKit 2 setup, subscription management, product fetching, purchase flows, receipt validation, or paywall UI. This applies to adding premium subscriptions, implementing freemium models, and managing subscription tiers. Do not write IAP code without reading this skill first.

---

## Purpose

Implement subscription system with:
- StoreKit 2 or RevenueCat integration
- Product fetching and display
- Purchase flow handling
- Receipt validation
- Subscription status tracking
- Restore purchases functionality

## When to Use

- Adding premium subscriptions
- Implementing freemium model
- Setting up IAP
- Managing subscription tiers

## Prerequisites

- App Store Connect configured
- Products created in App Store Connect
- Shared secret obtained (StoreKit)
- RevenueCat account setup (if using RevenueCat)

## Process

### Option 1: StoreKit 2 Implementation

```swift
// Services/SubscriptionService.swift
import StoreKit

@MainActor
final class SubscriptionService: ObservableObject {
    @Published var products: [Product] = []
    @Published var purchasedProductIDs = Set<String>()
    @Published var subscriptionStatus: SubscriptionStatus?
    
    private var updateListenerTask: Task<Void, Error>?
    
    private let productIDs = [
        "com.yourapp.monthly",
        "com.yourapp.yearly"
    ]
    
    init() {
        updateListenerTask = listenForTransactions()
        
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // Load products from App Store
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    // Purchase product
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updateSubscriptionStatus()
            return transaction
            
        case .userCancelled, .pending:
            return nil
            
        @unknown default:
            return nil
        }
    }
    
    // Restore purchases
    func restore() async {
        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
        } catch {
            print("Failed to restore purchases: \(error)")
        }
    }
    
    // Listen for transaction updates
    func listenForTransactions() -> Task<Void, Error> {
        Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updateSubscriptionStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed")
                }
            }
        }
    }
    
    // Update subscription status
    func updateSubscriptionStatus() async {
        var activeSubscriptions: [Product] = []
        
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if let product = products.first(where: { $0.id == transaction.productID }) {
                    activeSubscriptions.append(product)
                }
            }
        }
        
        subscriptionStatus = SubscriptionStatus(
            isActive: !activeSubscriptions.isEmpty,
            products: activeSubscriptions,
            expirationDate: nil  // Extract from transaction
        )
    }
    
    // Verify transaction
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

struct SubscriptionStatus {
    let isActive: Bool
    let products: [Product]
    let expirationDate: Date?
}

enum StoreError: Error {
    case failedVerification
}
```

### Option 2: RevenueCat Implementation

```swift
// Services/RevenueCatService.swift
import RevenueCat

@MainActor
final class RevenueCatService: ObservableObject {
    @Published var offerings: Offerings?
    @Published var customerInfo: CustomerInfo?
    @Published var isSubscribed: Bool = false
    
    init() {
        Purchases.configure(withAPIKey: "your_revenuecat_api_key")
        Purchases.shared.delegate = self
        
        Task {
            await loadOfferings()
            await loadCustomerInfo()
        }
    }
    
    func loadOfferings() async {
        do {
            offerings = try await Purchases.shared.offerings()
        } catch {
            print("Error loading offerings: \(error)")
        }
    }
    
    func loadCustomerInfo() async {
        do {
            customerInfo = try await Purchases.shared.customerInfo()
            updateSubscriptionStatus()
        } catch {
            print("Error loading customer info: \(error)")
        }
    }
    
    func purchase(package: Package) async throws {
        let (_, customerInfo, _) = try await Purchases.shared.purchase(package: package)
        self.customerInfo = customerInfo
        updateSubscriptionStatus()
    }
    
    func restore() async throws {
        customerInfo = try await Purchases.shared.restorePurchases()
        updateSubscriptionStatus()
    }
    
    private func updateSubscriptionStatus() {
        isSubscribed = customerInfo?.entitlements.active.isEmpty == false
    }
}

extension RevenueCatService: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        self.customerInfo = customerInfo
        updateSubscriptionStatus()
    }
}
```

### Paywall View

```swift
// Views/PaywallView.swift
import SwiftUI
import StoreKit

struct PaywallView: View {
    @StateObject private var subscriptionService = SubscriptionService()
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            Text("Unlock Premium")
                .font(.largeTitle.bold())
            
            Text("Get unlimited access to all features")
                .foregroundColor(.secondary)
            
            // Features
            VStack(alignment: .leading, spacing: 16) {
                FeatureRow(icon: "star.fill", title: "Unlimited Access", description: "Use all premium features")
                FeatureRow(icon: "cloud.fill", title: "Cloud Sync", description: "Access across all devices")
                FeatureRow(icon: "sparkles", title: "Ad-Free", description: "Enjoy without interruptions")
            }
            .padding()
            
            // Products
            ForEach(subscriptionService.products, id: \.id) { product in
                ProductButton(product: product) {
                    await purchaseProduct(product)
                }
            }
            
            // Restore button
            Button("Restore Purchases") {
                Task {
                    await subscriptionService.restore()
                }
            }
            .font(.footnote)
            
            // Terms
            Text("Terms and Privacy Policy")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .disabled(isPurchasing)
        .task {
            await subscriptionService.loadProducts()
        }
    }
    
    private func purchaseProduct(_ product: Product) async {
        isPurchasing = true
        
        do {
            if let transaction = try await subscriptionService.purchase(product) {
                // Purchase successful
                dismiss()
            }
        } catch {
            // Handle error
            print("Purchase failed: \(error)")
        }
        
        isPurchasing = false
    }
}

struct ProductButton: View {
    let product: Product
    let action: () async -> Void
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(product.displayName)
                        .font(.headline)
                    Text(product.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(product.displayPrice)
                    .font(.title3.bold())
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
```

## Best Practices

âœ… **Do:**
- Always verify transactions
- Handle all purchase states
- Provide restore purchases
- Test in sandbox environment
- Handle errors gracefully

âŒ **Don't:**
- Skip receipt validation
- Ignore transaction updates
- Hardcode product IDs in UI
- Test with real purchases during development

## Output Checklist

- [ ] StoreKit 2 or RevenueCat configured
- [ ] Products fetched from App Store
- [ ] Purchase flow implemented
- [ ] Receipt validation added
- [ ] Restore purchases functional
- [ ] Error handling complete
- [ ] Paywall UI created
- [ ] Subscription status tracked
- [ ] Testing completed in sandbox
- [ ] App Store Connect configured

---

**This skill implements production-ready subscription system with proper purchase handling and validation.**