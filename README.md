# StackViewController

StackViewController is a simple and easy-to-use UI component to implement a BottomSheet similar to the one provided by Apple. The main advantage of this implementation is that the app is able to transition from the panning gesture on the sheet to scrolling content gesture in a scrollView or tableView.

![demo](https://user-images.githubusercontent.com/27446881/197181656-a761b10a-5cca-46cb-bf4f-5127141698e9.gif)

## Samples and Example Usage

**Step 1:** Inside your VC with a tableView - change tableView type to ```StackUITableView```

```swift
// If you use UIViewController with a tableView inside:
var tableView: StackUITableView

// - - - - - - - - - - OR - - - - - - - - - - //

// If you use UITableViewController:
override func viewDidLoad() {
    super.viewDidLoad()
    tableView = StackUITableView()
}
```

**Step 2:** Create the StackViewController with any two controllers

```swift
let mainVC = MapViewController()
let sheetVC = TableViewController()
let stackVC = StackViewController(mainVC: mainVC, sheetVC: sheetVC)
```

That's it! You can already use ```StackViewController``` in your project 🤩


The StackViewController object is always available to you:

## Customization

Create your own class signed under the ```StackViewConfigurationType``` protocol

```swift
final class MyConfiguration: StackViewConfigurationType {
    var minHeight: CGFloat { UIScreen.main.bounds.height / 5 }
    var maxHeight: CGFloat { UIScreen.main.bounds.height / 2 }
    var backColor: UIColor { .white }
    var cornerRadius: CGFloat { 16.0 }
    var headerHeight: CGFloat { 20.0 }
    var shadowColor: UIColor { .black.withAlphaComponent(0.5) }
    var shadowOffset: CGSize { .zero }
    var shadowRadius: CGFloat { 8.0 }
    var shadowOpacity: CGFloat { 4.0 }
}
```
```swift
stackVC.configuration = MyConfiguration()
```

You can also create your own HeaderView and replace it with a custom one
```swift
stackVC.headerView = MyHeaderView()
```

## Public Access

In a StackViewController object, you are always available:

```swift
public enum BottomSheetPosition {
    case minimum, maximum, progressing
}

public var headerView: UIView? { get set }
public var configuration: StackViewConfigurationType? { get set }
public var state: BottomSheetPosition { get }

public func move(to state: BottomSheetPosition)
```

## Requirements

iOS 11.0+
Swift 5.0+

## Created by Oleksandr Kurtsev (Copyright © 2022) [LICENSE](https://github.com/kurtsev0103/StackViewController/blob/main/LICENSE)
