[![CocoaPods Version](https://img.shields.io/cocoapods/v/Cards.svg?style=flat)](http://cocoadocs.org/docsets/Cards)
[![Platform](https://img.shields.io/cocoapods/p/Cards.svg?style=flat)](http://cocoadocs.org/docsets/Cards)
![Cards](https://raw.githubusercontent.com/PaoloCuscela/Cards/master/Images/Logo.png)

Cards brings to XCode the card views that you can see on the new iOS XI Appstore.

## Getting Started

### Storyboard
- Go to the **main.storyboard** and add a **blank UIView**
- Open the **Identity Inspector** and type 'CardHighligth' the **'class' field**
- Switch to the **Attributes Inspector** and **configure** it as you like. 

### Code
```swift
// Aspect Ratio of 5:6 is preferred
let card = CardHighlight(frame: CGRect(x: 100, y: 100, width: 200, height: 240))
card.bgColor = UIColor(red: 0, green: 94/255, blue: 112/255, alpha: 1)
card.bgImage = UIImage(named: "flBackground")
card.icon = UIImage(named: "flappy")
card.title = "Welcome to XI Cards !"
card.itemTitle = "Flappy Bird"
card.itemSubtitle = "Flap That !"
view.addSubview(card)
```

![GetStarted](https://raw.githubusercontent.com/PaoloCuscela/Cards/master/Images/GetStarted.png)

## Prerequisites

- **XCode 9.0** or newer
- **Swift 4.0**

## Installation

### Cocoapods
```
use_frameworks!
pod 'Cards'
```
### Manual
- **Download** the repo
- ⌘C ⌘V the **'Cards' folder** in your project
- In your **Project's Info** go to '**Build Phases**'
- Open '**Compile Sources**' and **add all the files** in the folder

## Overview

![Overview](https://raw.githubusercontent.com/PaoloCuscela/Cards/master/Images/Overview.png)

## Customization

```swift
//Shadow settings
var shadowBlur: CGFloat
var shadowOpacity: Float
var shadowColor: UIColor
//Use those for the background instead of UIView.backgroundColor
var bgImage: UIImage?
var bgColor: UIColor

var textColor: UIColor 	//Color used for the labels
var insets: CGFloat 	//Spacing between content and card borders
var cardRadius: CGFloat //Corner radius of the card
var icons: [UIImage]? 	//DataSource for CardGroupSliding
var blurEffect: UIBlurEffectStyle //Blur effect of CardGroup
```

## License

Cards is released under the [MIT License](LICENSE).