# iOS Create Widget Skill

## Description

You MUST use this skill before creating any widget - Home Screen widgets, Lock Screen widgets, Live Activities, or any WidgetKit implementation. This applies to implementing timeline providers, multiple widget families, configuration intents, and deep linking support. Do not write widget code without reading this skill first.

---

## Purpose

Implement WidgetKit widgets with:
- Timeline providers
- Multiple widget families (small, medium, large)
- Configuration intent
- Deep linking support
- Live Activities (iOS 16.1+)

## When to Use

- Adding Home Screen widgets
- Implementing Lock Screen widgets
- Creating Live Activities
- Providing at-a-glance information

## Prerequisites

- Widget Extension target created
- App Groups configured (for data sharing)
- Design specs for widget layouts

## Process

### Step 1: Create Widget Extension

In Xcode: File â†’ New â†’ Target â†’ Widget Extension

### Step 2: Define Widget Entry

```swift
// Widget/WidgetEntry.swift
import WidgetKit

struct WidgetEntry: TimelineEntry {
    let date: Date
    let title: String
    let value: String
    let configuration: ConfigurationIntent?
}
```

### Step 3: Create Timeline Provider

```swift
// Widget/WidgetTimelineProvider.swift
import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), title: "Placeholder", value: "â€”", configuration: nil)
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        let entry = WidgetEntry(date: Date(), title: "Snapshot", value: "123", configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        Task {
            let entries = await fetchEntries()
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    private func fetchEntries() async -> [WidgetEntry] {
        // Fetch data from shared container or API
        var entries: [WidgetEntry] = []
        let currentDate = Date()
        
        for offset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: offset, to: currentDate)!
            let entry = WidgetEntry(date: entryDate, title: "Data", value: "\(offset)", configuration: nil)
            entries.append(entry)
        }
        
        return entries
    }
}
```

### Step 4: Create Widget Views

```swift
// Widget/WidgetView.swift
import SwiftUI
import WidgetKit

struct WidgetView: View {
    let entry: WidgetEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct SmallWidgetView: View {
    let entry: WidgetEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.title)
                .font(.caption.bold())
                .foregroundColor(.secondary)
            
            Text(entry.value)
                .font(.largeTitle.bold())
            
            Spacer()
            
            Text(entry.date, style: .time)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.blue.gradient)
        .foregroundColor(.white)
    }
}

struct MediumWidgetView: View {
    let entry: WidgetEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title)
                    .font(.headline)
                Text(entry.value)
                    .font(.title.bold())
                Text(entry.date, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue.gradient)
        .foregroundColor(.white)
    }
}
```

### Step 5: Configure Widget

```swift
// Widget/Widget.swift
import WidgetKit
import SwiftUI

@main
struct MyWidget: Widget {
    let kind: String = "MyWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("Displays your latest stats")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct MyWidget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(entry: WidgetEntry(date: Date(), title: "Preview", value: "123", configuration: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        WidgetView(entry: WidgetEntry(date: Date(), title: "Preview", value: "123", configuration: nil))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
```

### Step 6: Add Deep Linking

```swift
// Add to widget view
.widgetURL(URL(string: "myapp://widget?id=\(entry.id)"))

// Or use Link for multiple tappable areas (medium/large widgets)
Link(destination: URL(string: "myapp://detail")!) {
    VStack {
        Text("View Details")
    }
}
```

### Step 7: Share Data Between App and Widget

```swift
// Shared container
let sharedDefaults = UserDefaults(suiteName: "group.com.yourapp")
sharedDefaults?.set(value, forKey: "widgetData")

// Or use App Groups with file storage
let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yourapp")
```

### Step 8: Live Activities (iOS 16.1+)

```swift
// ActivityAttributes.swift
import ActivityKit

struct MyActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var progress: Double
        var status: String
    }
    
    var name: String
}

// Start Live Activity
let attributes = MyActivityAttributes(name: "Order")
let initialState = MyActivityAttributes.ContentState(progress: 0.0, status: "Preparing")

let activity = try? Activity<MyActivityAttributes>.request(
    attributes: attributes,
    contentState: initialState,
    pushType: nil
)

// Update Live Activity
let updatedState = MyActivityAttributes.ContentState(progress: 0.5, status: "On the way")
await activity?.update(using: updatedState)

// End Live Activity
await activity?.end(dismissalPolicy: .immediate)
```

## Best Practices

âœ… **Do:**
- Keep widget views simple
- Update timeline efficiently
- Use App Groups for data sharing
- Support all requested families
- Test on device (simulators limited)

âŒ **Don't:**
- Perform expensive computations in widgets
- Make network requests in widget view
- Ignore memory limits
- Use complex animations

## Output Checklist

- [ ] Widget Extension created
- [ ] Timeline provider implemented
- [ ] All widget families supported
- [ ] App Groups configured
- [ ] Data sharing working
- [ ] Deep linking functional
- [ ] Previews created
- [ ] Live Activities (if applicable)
- [ ] Tested on device

---

**This skill implements production-ready WidgetKit widgets with proper data management and user experience.**