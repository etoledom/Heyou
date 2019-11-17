# Heyou

[![CI Status](http://img.shields.io/travis/etoledom/Heyou.svg?style=flat)](https://travis-ci.org/etoledom/Heyou)
[![Version](https://img.shields.io/cocoapods/v/Heyou.svg?style=flat)](http://cocoapods.org/pods/Heyou)
[![License](https://img.shields.io/cocoapods/l/Heyou.svg?style=flat)](http://cocoapods.org/pods/Heyou)
[![Platform](https://img.shields.io/cocoapods/p/Heyou.svg?style=flat)](http://cocoapods.org/pods/Heyou)

### This project is on alpha stage

#### Create UI Alerts on a declarative way:

Instantiate a Heyou alert instance with the elements you want in any order you want.
You can bundle the elements in sections or have all of them in the root.

```swift
let alertController = Heyou(elements: [
    Heyou.Section(elements: [
        Heyou.Image(image: UIImage(named: "alert")!),
        Heyou.Title(text: "Title"),
        Heyou.Body(text: "Description text")
    ]),
    Heyou.ButtonsSection(buttons: [
        Heyou.Button(text: "OK", style: .normal)
    ])
])
```

Show the alert
```swift
alertController.show(onViewController: self)
```

![heyou](https://user-images.githubusercontent.com/9772967/69012078-d2c06500-0971-11ea-9647-398be5be65f1.png)


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
