# GesturableGraph
GesturableGraph is a library that expresses values in a graph based on user touch.

# Example

<img width=250 src="https://github.com/ohdair/GesturableGraph/assets/79438622/f2719049-6adf-4c22-a042-c7a6d559ee10">

# Requirements
- iOS 13.0+

# Installation
## Swift Package Manager
Swift Package Manager is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Xcode 11+ is required to build SnapKit using Swift Package Manager.

To integrate SnapKit into your Xcode project using Swift Package Manager, add it to the dependencies value of your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/ohdair/GesturableGraph")
]
```

# Usage
## Initialization
If the graph has fewer than two elements, the GesturableGraph cannot be created and returns nil.
```swift
import GesturableGraph

class ViewController: UIViewController {

    override func viewDidLoad() {
        let data: [Double] = [3, 8, 7, 4, 6, 9, 11, 12, 8, 7, 6, 10]
        guard let graphView = GesturableGraph(elements: data) else {
            return
        }
    }
}
```
## protocol
GesturableGraphEnable must be adopted to receive values for gestures.
You can use the delegate pattern to receive GraphData.
```swift
class ViewController: UIViewController {

    override func viewDidLoad() {
        graphView.delegate = self
    }
}

extension ViewController: GesturableGraphEnable {
    func gesturableGraph(_ gesturableGraph: GesturableGraph, didTapWithData data: GraphData?) {
        // You can use the data and present it in a UI.
    }
}
```
