![https://raw.githubusercontent.com/PaoloCuscela/Cards/master/Images/Customization.png](https://raw.githubusercontent.com/PaoloCuscela/Cards/master/Images/Customization.png) 

# Common parameters

## Shadows


```
@IBInspectable public var shadowBlur: CGFloat = 14	// How much blur is applied to the shadow
@IBInspectable public var shadowOpacity: Float = 0.6	// Alpha value of the shadow
@IBInspectable public var shadowColor: UIColor = UIColor.gray	// Color of the shadow
```

## Card Content
 
 
```swift
open var backgroundColor: UIColor?	// Color of the Card's layer
@IBInspectable public var backgroundImage: UIImage? 	// Image displayed below content
@IBInspectable public var textColor: UIColor = UIColor.black	// Text color of every label inside the Card content
@IBInspectable public var cardRadius: CGFloat = 20 	// Corner radius of the Card's layer
@IBInspectable public var contentInset: CGFloat = 6	// The insets of the content inside the card's view ( in % )
open var detailView: UIView?	// The view shown as content when the detail is presented

```

## Behaviour

```
@IBInspectable public var shouldPresentDetailView: Bool = true	// If the detail should be presented or not
var delegate: CardDelegate?	// Delegate protocol for intercepting actions
```

![Cards](https://raw.githubusercontent.com/PaoloCuscela/Cards/master/Images/Overview.png)

# Card Highlight

## Content


```
@IBInspectable public var title: String		// Highlight title text
@IBInspectable public var itemTitle: String	// Title of the item at the bottom of the card
@IBInspectable public var itemSubtitle: String	// Subitle of the item at the bottom of the card
@IBInspectable public var buttonText: String	// Text of the button
@IBInspectable public var icon: UIImage?	// Image for the icon
/* If no background image is set, the card will show a faded icon in the top-right corner of the card */ 
```

## Content settings

```
@IBInspectable public var titleSize:CGFloat = 26	// Max font size for the title
@IBInspectable public var itemTitleSize:CGFloat = 16	// Max font size for the itemTitle
@IBInspectable public var itemSubitleSize:CGFloat = 14	// Max font size for the itemSubtitle
@IBInspectable public var iconRadius: CGFloat = 16	// Corner radius for the icon

```

# Card Article

## Content


```
@IBInspectable public var title: String	
@IBInspectable public var subtitle: String
@IBInspectable public var category: String	// Text for the label on top of the title

```

## Content settings

```
@IBInspectable public var titleSize:CGFloat = 26
@IBInspectable public var subitleSize:CGFloat = 17
@IBInspectable public var blurEffect: UIBlurEffectStyle = .extraLight	// The style of the blur effect below content

```

# Card Group

## Content


```
@IBInspectable public var title: String	
@IBInspectable public var subtitle: String

```

## Content settings

```
@IBInspectable public var titleSize:CGFloat = 26
@IBInspectable public var subitleSize:CGFloat = 17
@IBInspectable public var blurEffect: UIBlurEffectStyle = .extraLight

```

# Card Group Sliding (CardGroup)

## Content


```
[...]
public var icons: [UIImage]?	// Data source for the sliding view

```

## Content settings

```
[...]
@IBInspectable public var iconsSize: CGFloat = 80	// Size for the icons in the sliding view
@IBInspectable public var iconsRadius: CGFloat = 40	// Corner radius for the icons in the sliding view
```


# Card Player

## Content


```
@IBInspectable public var title: String	
@IBInspectable public var subtitle: String
@IBInspectable public var category: String
open var player = Player()	// The player from 
patrickpiemonte

```

## Content settings

```
@IBInspectable public var titleSize:CGFloat = 26
@IBInspectable public var subitleSize:CGFloat = 17
@IBInspectable public var playBtnSize: CGFloat = 56	// Size for the Play/Pause button
@IBInspectable public var playImage: UIImage?	// Image for the play icon (if you don't have any download the one in the assets folder of the Demo project)
@IBInspectable public var playerCover: UIImage?	// The image shown while the player is buffering
@IBInspectable public var videoSource: URL?	// URL Path for the video ( streaming or local )
/* If you're going to stream a video from an http source remember to set 
App Transport Security Settings -> Allow Arbitrary Loads to "YES" in your info.plist file */

```

## Behaviour

```
@IBInspectable public var isAutoplayEnabled: Bool = false	// If the card should (or not) play the video whenever the player is ready
@IBInspectable public var shouldRestartVideoWhenPlaybackEnds: Bool = true	// If the player should start the video from beginning when it ends

```
