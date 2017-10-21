![Player](https://github.com/piemonte/Player/raw/master/Player.gif)

## Player

`Player` is a simple iOS video player library written in [Swift](https://developer.apple.com/swift/).

[![Build Status](https://travis-ci.org/piemonte/Player.svg?branch=master)](https://travis-ci.org/piemonte/Player) [![Pod Version](https://img.shields.io/cocoapods/v/Player.svg?style=flat)](http://cocoadocs.org/docsets/Player/) [![Swift Version](https://img.shields.io/badge/language-swift%204.0-brightgreen.svg)](https://developer.apple.com/swift) [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/piemonte/Player/blob/master/LICENSE)

- Looking for an obj-c video player? Check out [PBJVideoPlayer (obj-c)](https://github.com/piemonte/PBJVideoPlayer).
- Looking for a Swift camera library? Check out [Next Level](https://github.com/NextLevel/NextLevel).

### Features
- [x] plays local media or streams remote media over HTTP
- [x] customizable UI and user interaction
- [x] no size restrictions
- [x] orientation change support
- [x] simple API

# Quick Start

`Player` is available for installation using the Cocoa dependency manager [CocoaPods](http://cocoapods.org/).  Alternatively, you can simply copy the `Player.swift` file into your Xcode project.

```ruby
# CocoaPods
swift_version = "4.0"
pod "Player", "~> 0.8.0"

# Carthage
github "piemonte/Player" ~> 0.8.0
```

Need Swift 3? Use release `0.7.0`

## Usage

The sample project provides an example of how to integrate `Player`, otherwise you can follow these steps.

Allocate and add the `Player` controller to your view hierarchy.

``` Swift
 self.player = Player()
 self.player.playerDelegate = self
 self.player.playbackDelegate = self
 self.player.view.frame = self.view.bounds
    
 self.addChildViewController(self.player)
 self.view.addSubview(self.player.view)
 self.player.didMove(toParentViewController: self)
```

Provide the file path to the resource you would like to play locally or stream. Ensure you're including the file extension.

``` Swift
let videoUrl: URL = // file or http url
self.player.url = videoUrl
```

play/pause/chill

``` Swift
 self.player.playFromBeginning()
```

Adjust the fill mode for the video, if needed.

``` Swift
 self.player.fillMode = PlayerFillMode.resizeAspectFit.avFoundationType
```

Display video playback progress, if needed.

``` Swift
extension ViewController: PlayerPlaybackDelegate {

    public func playerPlaybackWillStartFromBeginning(_ player: Player) {
    }
    
    public func playerPlaybackDidEnd(_ player: Player) {
    }
    
    public func playerCurrentTimeDidChange(_ player: Player) {
        let fraction = Double(player.currentTime) / Double(player.maximumDuration)
        self._playbackViewController?.setProgress(progress: CGFloat(fraction), animated: true)
    }
    
    public func playerPlaybackWillLoop(_ player: Player) {
        self. _playbackViewController?.reset()
    }
    
}
```

## Documentation

You can find [the docs here](http://piemonte.github.io/Player/). Documentation is generated with [jazzy](https://github.com/realm/jazzy) and hosted on [GitHub-Pages](https://pages.github.com).

## Community

- Need help? Use [Stack Overflow](http://stackoverflow.com/questions/tagged/player-swift) with the tag 'player-swift'.
- Questions? Use [Stack Overflow](http://stackoverflow.com/questions/tagged/player-swift) with the tag 'player-swift'.
- Found a bug? Open an [issue](https://github.com/piemonte/player/issues).
- Feature idea? Open an [issue](https://github.com/piemonte/player/issues).
- Want to contribute? Submit a [pull request](https://github.com/piemonte/player/pulls).

## Resources

* [Swift Evolution](https://github.com/apple/swift-evolution)
* [AV Foundation Programming Guide](https://developer.apple.com/library/ios/documentation/AudioVideo/Conceptual/AVFoundationPG/Articles/00_Introduction.html)
* [Next Level](https://github.com/NextLevel/NextLevel/), rad media capture in Swift
* [PBJVision](https://github.com/piemonte/PBJVision), iOS camera engine, features touch-to-record video, slow motion video, and photo capture
* [PBJVideoPlayer](https://github.com/piemonte/PBJVideoPlayer), a simple iOS video player library, written in obj-c

## License

Player is available under the MIT license, see the [LICENSE](https://github.com/piemonte/player/blob/master/LICENSE) file for more information.

