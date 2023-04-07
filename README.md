This is a small SwiftUI App project using the `.continuousClock` dependency to demonstrate a crash seen when attempting to profile with the Instruments Allocations tool.

# Description

I was attempting to profile our TCA-based SwiftUI App for memory leaks using Instruments with the Allocations tool, and every time I tried to run the app with the profiler, the app would almost instantly crash 😱. 

Injecting the `.continuousClock` dependency provided by the `Dependencies` library seems to trigger this. I had injected the dependency in a few `Reducer` features in the app using the `@Dependency` property wrapper:

```swift
@Dependency(\.continuousClock) var continuousClock
```

While investigating, I found that replacing the `@Dependency` injection with an in-line declaration resolved the issue with no further changes:

```swift
var continuousClock = ContinuousClock()
```

> Of course, this isn't an acceptable long-term option (_I was injecting that clock for a reason..._), but it helps to demonstrate the issue.

To reproduce:

Launch the app from the Instruments profiler with the Allocations tool enabled. You can also reproduce by attaching the profiler to the already running app. The app crashes as soon at the profiler is attached.

## Details

These error messages would print in the log file before the crash:

```
**/Library/Caches/com.apple.xbs/Sources/swiftlang/swift/lib/Demangling/Demangler.cpp:347: assertion failed for Node 0x16b9b9c90: Child**
**/Library/Caches/com.apple.xbs/Sources/swiftlang/swift/lib/Demangling/Demangler.cpp:347: Node 0x16b9b9c90 is:**
**kind=TypeMangling**

**2023-04-06 19:17:45.342355-0700 DIT[70657:1723402] /Library/Caches/com.apple.xbs/Sources/swiftlang/swift/lib/Demangling/Demangler.cpp:347: assertion failed for Node 0x16b9b9c90: Child**
**/Library/Caches/com.apple.xbs/Sources/swiftlang/swift/lib/Demangling/Demangler.cpp:347: Node 0x16b9b9c90 is:**
**kind=TypeMangling**
```

The `.continuousClock` dependency is declared as `any Clock<Duration>`.
From what I can tell, the Swift Demangler is somehow failing to parse the mangled type of the dependency value.

This seems like more of an issue with the Swift compiler (or maybe Instruments? 🤷), but I thought it might be of use or interest to someone else here.
