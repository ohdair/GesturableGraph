# GesturableGraph
GesturableGraph is a library that expresses values in a graph based on user touch.

# Example

|<img width="300" src="https://github.com/ohdair/GesturableGraph/assets/79438622/5bd3af1b-ea7e-4f3f-865e-9c98f4b9a50f">|<img width=300 src=https://github.com/ohdair/GesturableGraph/assets/79438622/0bc1139f-99d4-4d68-ab32-f4429071dda0>|
|-|-|


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
## Data
<img width="400" alt="Group 6@2x" src="https://github.com/ohdair/GesturableGraph/assets/79438622/64f65def-07b7-4f65-a6dd-f5865b40ddf7">

### graph
graph has 3 properties
- type
    ```swift
    enum GraphType {
        case curve    // default
        case straight
    }
    ```
- distribution
    ```swift
    // aroundSpacing is that spacing at left/right spacing is 1/2 the size of the inner spacing.
    // evenSpacing is that inner spacing and left/right spacing are the same.
    enum Distribution {
        case equalSpacing    // default
        case aroundSpacing
        case evenSpacing
    }
    ```
- padding
    ```swift
    // Padding is a scaling factor for the height of the graph.
    struct Padding {
        var top: Double = 0.3       // default
        var bottom: Double = 0.3    // default
    }
    ```
### axisX
```swift
enum UnitOfTime {
    case seconds
    case minutes
    case hours    // default
    case days
    case months
}
```
### axisY
```swift
// position adjusts the position of axisY
// division display the label on the axisY axis by the value.
// decimalPlaces adjusts the position of the decimal point
struct AxisY {
    var dataUnit: String = ""
    var division: Int = 8
    var decimalPlaces: Int = 0

    var position: Position = .right

    enum Position {
        case left
        case right
    }
}
```
### extraUnits
extraUnits only allows collection of images.

## View
### gesturableGraphView
change the color and size property values.
- line
- point
- enableLine
- enablePoint
- area
```swift
struct GraphLine {
    var width: Double
    var color: UIColor
}

struct GraphPoint {
    var width: Double
    var color: UIColor
    var isHidden: Bool
}

struct GraphEnablePoint {
    var width: Double
    var color: UIColor
}

struct GraphEnableLine {
    var width: Double
    var color: UIColor
}

struct GraphArea {
    var gradientColors: [UIColor]
    var isFill: Bool
}
```
