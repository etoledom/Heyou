# Heyou

[![CI Status](http://img.shields.io/travis/etoledom/Heyou.svg?style=flat)](https://travis-ci.org/etoledom/Heyou)
[![Version](https://img.shields.io/cocoapods/v/Heyou.svg?style=flat)](http://cocoapods.org/pods/Heyou)
[![License](https://img.shields.io/cocoapods/l/Heyou.svg?style=flat)](http://cocoapods.org/pods/Heyou)
[![Platform](https://img.shields.io/cocoapods/p/Heyou.svg?style=flat)](http://cocoapods.org/pods/Heyou)

### This project is on alpha stage

Instanciate HYAlertController
```swift
let alertController = HYAlertController()
```

Add elements to the alert (in any order)
```swift
alertController.elements = [
.title("Title"),
.subTitle("A Subtitle"),
.image(named: "house"),
.description("A long description text goes here.")
]
```

Add actions (buttons)
```swift
let mainAction = HYAlertAction(title: "First main", style: .main)
let normalAction = HYAlertAction(title: "Normal button", style: .default)
let secondMainAction = HYAlertAction(title: "Second main", style: .main)

alertController.addAction(mainAction)
alertController.addAction(normalAction)
alertController.addAction(secondMainAction)
```

Show the alert
```swift
alertController.show(onViewController: self)
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Heyou is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Heyou'
```

## Author

etoledom, etoledom@icloud.com

## License

Heyou is available under the MIT license. See the LICENSE file for more info.
