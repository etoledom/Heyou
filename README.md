# Heyou

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