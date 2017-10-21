//  Player.swift
//
//  Created by patrick piemonte on 11/26/14.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014-present patrick piemonte (http://patrickpiemonte.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import Foundation
import AVFoundation
import CoreGraphics

// MARK: - types

/// Video fill mode options for `Player.fillMode`.
///
/// - resize: Stretch to fill.
/// - resizeAspectFill: Preserve aspect ratio, filling bounds.
/// - resizeAspectFit: Preserve aspect ratio, fill within bounds.
public enum PlayerFillMode {
    case resize
    case resizeAspectFill
    case resizeAspectFit // default
    
    public var avFoundationType: String {
        get {
            switch self {
            case .resize:
                return AVLayerVideoGravity.resize.rawValue
            case .resizeAspectFill:
                return AVLayerVideoGravity.resizeAspectFill.rawValue
            case .resizeAspectFit:
                return AVLayerVideoGravity.resizeAspect.rawValue
            }
        }
    }
}

/// Asset playback states.
public enum PlaybackState: Int, CustomStringConvertible {
    case stopped = 0
    case playing
    case paused
    case failed

    public var description: String {
        get {
            switch self {
            case .stopped:
                return "Stopped"
            case .playing:
                return "Playing"
            case .failed:
                return "Failed"
            case .paused:
                return "Paused"
            }
        }
    }
}

/// Asset buffering states.
public enum BufferingState: Int, CustomStringConvertible {
    case unknown = 0
    case ready
    case delayed

    public var description: String {
        get {
            switch self {
            case .unknown:
                return "Unknown"
            case .ready:
                return "Ready"
            case .delayed:
                return "Delayed"
            }
        }
    }
}

// MARK: - PlayerDelegate

/// Player delegate protocol
public protocol PlayerDelegate: NSObjectProtocol {
    func playerReady(_ player: Player)
    func playerPlaybackStateDidChange(_ player: Player)
    func playerBufferingStateDidChange(_ player: Player)
    
    // This is the time in seconds that the video has been buffered.
    // If implementing a UIProgressView, user this value / player.maximumDuration to set progress.
    func playerBufferTimeDidChange(_ bufferTime: Double)
}


/// Player playback protocol
public protocol PlayerPlaybackDelegate: NSObjectProtocol {
    func playerCurrentTimeDidChange(_ player: Player)
    func playerPlaybackWillStartFromBeginning(_ player: Player)
    func playerPlaybackDidEnd(_ player: Player)
    func playerPlaybackWillLoop(_ player: Player)
}

// MARK: - Player

/// ▶️ Player, simple way to play and stream media
open class Player: UIViewController {

    /// Player delegate.
    open weak var playerDelegate: PlayerDelegate?
    
    /// Playback delegate.
    open weak var playbackDelegate: PlayerPlaybackDelegate?

    // configuration
    
    /// Local or remote URL for the file asset to be played.
    ///
    /// - Parameter url: URL of the asset.
    open var url: URL? {
        didSet {
            setup(url: url)
        }
    }
    
    /// Determines if the video should autoplay when a url is set
    ///
    /// - Parameter bool: defaults to true
    open var autoplay: Bool = true

    /// For setting up with AVAsset instead of URL
    /// Note: Resets URL (cannot set both)
    open var asset: AVAsset? {
        get { return _asset }
        set { _ = newValue.map { setupAsset($0) } }
    }
    
    /// Mutes audio playback when true.
    open var muted: Bool {
        get {
            return self._avplayer.isMuted
        }
        set {
            self._avplayer.isMuted = newValue
        }
    }
    
    /// Volume for the player, ranging from 0.0 to 1.0 on a linear scale.
    open var volume: Float {
        get {
            return self._avplayer.volume
        }
        set {
            self._avplayer.volume = newValue
        }
    }

    /// Specifies how the video is displayed within a player layer’s bounds.
    /// The default value is `AVLayerVideoGravityResizeAspect`. See `FillMode` enum.
    open var fillMode: String {
        get {
            return self._playerView.fillMode
        }
        set {
            self._playerView.fillMode = newValue
        }
    }

    /// Pauses playback automatically when resigning active.
    open var playbackPausesWhenResigningActive: Bool = true
    
    /// Pauses playback automatically when backgrounded.
    open var playbackPausesWhenBackgrounded: Bool = true
    
    /// Resumes playback when became active.
    open var playbackResumesWhenBecameActive: Bool = true

    /// Resumes playback when entering foreground.
    open var playbackResumesWhenEnteringForeground: Bool = true
    
    // state

    /// Playback automatically loops continuously when true.
    open var playbackLoops: Bool {
        get {
            return self._avplayer.actionAtItemEnd == .none
        }
        set {
            if newValue {
                self._avplayer.actionAtItemEnd = .none
            } else {
                self._avplayer.actionAtItemEnd = .pause
            }
        }
    }

    /// Playback freezes on last frame frame at end when true.
    open var playbackFreezesAtEnd: Bool = false

    /// Current playback state of the Player.
    open var playbackState: PlaybackState = .stopped {
        didSet {
            if playbackState != oldValue || !playbackEdgeTriggered {
                self.playerDelegate?.playerPlaybackStateDidChange(self)
            }
        }
    }
    
    /// Current buffering state of the Player.
    open var bufferingState: BufferingState = .unknown {
       didSet {
            if bufferingState != oldValue || !playbackEdgeTriggered {
                self.playerDelegate?.playerBufferingStateDidChange(self)
            }
        }
    }

    /// Playback buffering size in seconds.
    open var bufferSize: Double = 10
    
    /// Playback is not automatically triggered from state changes when true.
    open var playbackEdgeTriggered: Bool = true

    /// Maximum duration of playback.
    open var maximumDuration: TimeInterval {
        get {
            if let playerItem = self._playerItem {
                return CMTimeGetSeconds(playerItem.duration)
            } else {
                return CMTimeGetSeconds(kCMTimeIndefinite)
            }
        }
    }

    /// Media playback's current time.
    open var currentTime: TimeInterval {
        get {
            if let playerItem = self._playerItem {
                return CMTimeGetSeconds(playerItem.currentTime())
            } else {
                return CMTimeGetSeconds(kCMTimeIndefinite)
            }
        }
    }

    /// The natural dimensions of the media.
    open var naturalSize: CGSize {
        get {
            if let playerItem = self._playerItem,
                let track = playerItem.asset.tracks(withMediaType: .video).first {

                let size = track.naturalSize.applying(track.preferredTransform)
                return CGSize(width: fabs(size.width), height: fabs(size.height))
            } else {
                return CGSize.zero
            }
        }
    }

    /// Player view's initial background color.
    open var layerBackgroundColor: UIColor? {
        get {
            guard let backgroundColor = self._playerView.playerLayer.backgroundColor
            else {
                return nil
            }
            return UIColor(cgColor: backgroundColor)
        }
        set {
            self._playerView.playerLayer.backgroundColor = newValue?.cgColor
        }
    }
    
    // MARK: - private instance vars
    
    internal var _asset: AVAsset? {
        didSet {
            if let _ = self._asset {
                self.setupPlayerItem(nil)
            }
        }
    }
    internal var _avplayer: AVPlayer
    internal var _playerItem: AVPlayerItem?
    internal var _timeObserver: Any?
    
    internal var _playerView: PlayerView = PlayerView(frame: .zero)
    internal var _seekTimeRequested: CMTime?
    
    internal var _lastBufferTime: Double = 0
    
    //Boolean that determines if the user or calling coded has trigged autoplay manually.
    internal var _hasAutoplayActivated: Bool = true
    
    // MARK: - object lifecycle

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        self._avplayer = AVPlayer()
        self._avplayer.actionAtItemEnd = .pause
        self._timeObserver = nil
        
        super.init(coder: aDecoder)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self._avplayer = AVPlayer()
        self._avplayer.actionAtItemEnd = .pause
        self._timeObserver = nil
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    deinit {
        self._avplayer.pause()
        self.setupPlayerItem(nil)

        self.removePlayerObservers()

        self.playerDelegate = nil
        self.removeApplicationObservers()
 
        self.playbackDelegate = nil
        self.removePlayerLayerObservers()
        self._playerView.player = nil
    }

    // MARK: - view lifecycle

    open override func loadView() {
        self._playerView.playerLayer.isHidden = true
        self.view = self._playerView
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = url {
            setup(url: url)
        } else if let asset = asset {
            setupAsset(asset)
        }
        
        self.addPlayerLayerObservers()
        self.addPlayerObservers()
        self.addApplicationObservers()
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if self.playbackState == .playing {
            self.pause()
        }
    }
    
    // MARK: - Playback funcs

    /// Begins playback of the media from the beginning.
    open func playFromBeginning() {
        self.playbackDelegate?.playerPlaybackWillStartFromBeginning(self)
        self._avplayer.seek(to: kCMTimeZero)
        self.playFromCurrentTime()
    }

    /// Begins playback of the media from the current time.
    open func playFromCurrentTime() {
        if !autoplay {
            //external call to this method with auto play off.  activate it before calling play
            _hasAutoplayActivated = true
        }
        play()
    }
    
    fileprivate func play() {
        if autoplay || _hasAutoplayActivated {
            self.playbackState = .playing
            self._avplayer.play()
        }
    }

    /// Pauses playback of the media.
    open func pause() {
        if self.playbackState != .playing {
            return
        }

        self._avplayer.pause()
        self.playbackState = .paused
    }

    /// Stops playback of the media.
    open func stop() {
        if self.playbackState == .stopped {
            return
        }

        self._avplayer.pause()
        self.playbackState = .stopped
        self.playbackDelegate?.playerPlaybackDidEnd(self)
    }
    
    /// Updates playback to the specified time.
    ///
    /// - Parameters:
    ///   - time: The time to switch to move the playback.
    ///   - completionHandler: Call block handler after seeking/
    open func seek(to time: CMTime, completionHandler: ((Bool) -> Swift.Void)? = nil) {
        if let playerItem = self._playerItem {
            return playerItem.seek(to: time, completionHandler: completionHandler)
        } else {
            _seekTimeRequested = time
        }
    }

    /// Updates the playback time to the specified time bound.
    ///
    /// - Parameters:
    ///   - time: The time to switch to move the playback.
    ///   - toleranceBefore: The tolerance allowed before time.
    ///   - toleranceAfter: The tolerance allowed after time.
    ///   - completionHandler: call block handler after seeking
    open func seekToTime(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime, completionHandler: ((Bool) -> Swift.Void)? = nil) {
        if let playerItem = self._playerItem {
            return playerItem.seek(to: time, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter, completionHandler: completionHandler)
        }
    }
    
    /// Captures a snapshot of the current Player view.
    ///
    /// - Returns: A UIImage of the player view.
    open func takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self._playerView.frame.size, false, UIScreen.main.scale)
        self._playerView.drawHierarchy(in: self._playerView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    /// Return the av player layer for consumption by
    /// things such as Picture in Picture
    open func playerLayer() -> AVPlayerLayer? {
        return self._playerView.playerLayer
    }
}

// MARK: - loading funcs

extension Player {
    
    fileprivate func setup(url: URL?) {
        guard isViewLoaded else { return }
        
        // ensure everything is reset beforehand
        if self.playbackState == .playing {
            self.pause()
        }
        
        //Reset autoplay flag since a new url is set.
        _hasAutoplayActivated = false
        if autoplay {
            playbackState = .playing
        } else {
            playbackState = .stopped
        }
        
        self.setupPlayerItem(nil)
        
        if let url = url {
            let asset = AVURLAsset(url: url, options: .none)
            self.setupAsset(asset)
        }
    }

    fileprivate func setupAsset(_ asset: AVAsset) {
        guard isViewLoaded else { return }
        
        if self.playbackState == .playing {
            self.pause()
        }

        self.bufferingState = .unknown

        self._asset = asset

        let keys = [PlayerTracksKey, PlayerPlayableKey, PlayerDurationKey]
        self._asset?.loadValuesAsynchronously(forKeys: keys, completionHandler: { () -> Void in
            for key in keys {
                var error: NSError? = nil
                let status = self._asset?.statusOfValue(forKey: key, error:&error)
                if status == .failed {
                    self.playbackState = .failed
                    return
                }
            }

            if let asset = self._asset {
                if !asset.isPlayable {
                    self.playbackState = .failed
                    return
                }
                
                let playerItem = AVPlayerItem(asset:asset)
                self.setupPlayerItem(playerItem)
            }
        })
    }

    fileprivate func setupPlayerItem(_ playerItem: AVPlayerItem?) {
        self._playerItem?.removeObserver(self, forKeyPath: PlayerEmptyBufferKey, context: &PlayerItemObserverContext)
        self._playerItem?.removeObserver(self, forKeyPath: PlayerKeepUpKey, context: &PlayerItemObserverContext)
        self._playerItem?.removeObserver(self, forKeyPath: PlayerStatusKey, context: &PlayerItemObserverContext)
        self._playerItem?.removeObserver(self, forKeyPath: PlayerLoadedTimeRangesKey, context: &PlayerItemObserverContext)

        if let currentPlayerItem = self._playerItem {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: currentPlayerItem)
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemFailedToPlayToEndTime, object: currentPlayerItem)
        }

        self._playerItem = playerItem

        if let seek = _seekTimeRequested, self._playerItem != nil {
            _seekTimeRequested = nil
            self.seek(to: seek)
        }

        self._playerItem?.addObserver(self, forKeyPath: PlayerEmptyBufferKey, options: [.new, .old], context: &PlayerItemObserverContext)
        self._playerItem?.addObserver(self, forKeyPath: PlayerKeepUpKey, options: [.new, .old], context: &PlayerItemObserverContext)
        self._playerItem?.addObserver(self, forKeyPath: PlayerStatusKey, options: [.new, .old], context: &PlayerItemObserverContext)
        self._playerItem?.addObserver(self, forKeyPath: PlayerLoadedTimeRangesKey, options: [.new, .old], context: &PlayerItemObserverContext)

        if let updatedPlayerItem = self._playerItem {
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime(_:)), name: .AVPlayerItemDidPlayToEndTime, object: updatedPlayerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemFailedToPlayToEndTime(_:)), name: .AVPlayerItemFailedToPlayToEndTime, object: updatedPlayerItem)
        }

        self._avplayer.replaceCurrentItem(with: self._playerItem)
        
        // update new playerItem settings
        if self.playbackLoops {
            self._avplayer.actionAtItemEnd = .none
        } else {
            self._avplayer.actionAtItemEnd = .pause
        }
    }

}

// MARK: - NSNotifications

extension Player {
    
    // MARK: - AVPlayerItem
    
    @objc internal func playerItemDidPlayToEndTime(_ aNotification: Notification) {
        if self.playbackLoops {
            self.playbackDelegate?.playerPlaybackWillLoop(self)
            self._avplayer.seek(to: kCMTimeZero)
        } else {
            if self.playbackFreezesAtEnd {
                self.stop()
            } else {
                self._avplayer.seek(to: kCMTimeZero, completionHandler: { _ in
                    self.stop()
                })
            }
        }
    }

    @objc internal func playerItemFailedToPlayToEndTime(_ aNotification: Notification) {
        self.playbackState = .failed
    }
    
    // MARK: - UIApplication
    
    internal func addApplicationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillResignActive(_:)), name: .UIApplicationWillResignActive, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationDidBecomeActive(_:)), name: .UIApplicationDidBecomeActive, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationDidEnterBackground(_:)), name: .UIApplicationDidEnterBackground, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillEnterForeground(_:)), name: .UIApplicationWillEnterForeground, object: UIApplication.shared)
    }
    
    internal func removeApplicationObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - handlers
    
    @objc internal func handleApplicationWillResignActive(_ aNotification: Notification) {
        if self.playbackState == .playing && self.playbackPausesWhenResigningActive {
            self.pause()
        }
    }

    @objc internal func handleApplicationDidBecomeActive(_ aNotification: Notification) {
        if self.playbackState != .playing && self.playbackResumesWhenBecameActive {
            self.play()
        }
    }

    @objc internal func handleApplicationDidEnterBackground(_ aNotification: Notification) {
        if self.playbackState == .playing && self.playbackPausesWhenBackgrounded {
            self.pause()
        }
    }
  
    @objc internal func handleApplicationWillEnterForeground(_ aNoticiation: Notification) {
        if self.playbackState != .playing && self.playbackResumesWhenEnteringForeground {
            self.play()
        }
    }

}

// MARK: - KVO

// KVO contexts

private var PlayerObserverContext = 0
private var PlayerItemObserverContext = 0
private var PlayerLayerObserverContext = 0

// KVO player keys

private let PlayerTracksKey = "tracks"
private let PlayerPlayableKey = "playable"
private let PlayerDurationKey = "duration"
private let PlayerRateKey = "rate"

// KVO player item keys

private let PlayerStatusKey = "status"
private let PlayerEmptyBufferKey = "playbackBufferEmpty"
private let PlayerKeepUpKey = "playbackLikelyToKeepUp"
private let PlayerLoadedTimeRangesKey = "loadedTimeRanges"

// KVO player layer keys

private let PlayerReadyForDisplayKey = "readyForDisplay"

extension Player {
    
    // MARK: - AVPlayerLayerObservers
    
    internal func addPlayerLayerObservers() {
        self._playerView.layer.addObserver(self, forKeyPath: PlayerReadyForDisplayKey, options: [.new, .old], context: &PlayerLayerObserverContext)
    }
    
    internal func removePlayerLayerObservers() {
        self._playerView.layer.removeObserver(self, forKeyPath: PlayerReadyForDisplayKey, context: &PlayerLayerObserverContext)
    }
    
    // MARK: - AVPlayerObservers
    
    internal func addPlayerObservers() {
        self._timeObserver = self._avplayer.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 100), queue: DispatchQueue.main, using: { [weak self] timeInterval in
            guard let strongSelf = self
            else {
                return
            }
            strongSelf.playbackDelegate?.playerCurrentTimeDidChange(strongSelf)
        })
        self._avplayer.addObserver(self, forKeyPath: PlayerRateKey, options: [.new, .old], context: &PlayerObserverContext)
    }
    
    internal func removePlayerObservers() {
        if let observer = self._timeObserver {
            self._avplayer.removeTimeObserver(observer)
        }
        self._avplayer.removeObserver(self, forKeyPath: PlayerRateKey, context: &PlayerObserverContext)
    }
    
    // MARK: -
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {

        // PlayerRateKey, PlayerObserverContext
        
        if context == &PlayerItemObserverContext {
            
            // PlayerStatusKey
            
            if keyPath == PlayerKeepUpKey {
                
                // PlayerKeepUpKey
                
                if let item = self._playerItem {

                  if item.isPlaybackLikelyToKeepUp {
                        self.bufferingState = .ready
                        if self.playbackState == .playing {
                            self.playFromCurrentTime()
                        }
                    }
                }
                
                if let status = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                    switch status.intValue as AVPlayerStatus.RawValue {
                    case AVPlayerStatus.readyToPlay.rawValue:
                        self._playerView.playerLayer.player = self._avplayer
                        self._playerView.playerLayer.isHidden = false
                    case AVPlayerStatus.failed.rawValue:
                        self.playbackState = PlaybackState.failed
                    default:
                        break
                    }
                }
                    
            } else if keyPath == PlayerEmptyBufferKey {
                
                // PlayerEmptyBufferKey
                
                if let item = self._playerItem {
                    if item.isPlaybackBufferEmpty {
                        self.bufferingState = .delayed
                    }
                }
                
                if let status = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                    switch status.intValue as AVPlayerStatus.RawValue {
                    case AVPlayerStatus.readyToPlay.rawValue:
                        self._playerView.playerLayer.player = self._avplayer
                        self._playerView.playerLayer.isHidden = false
                    case AVPlayerStatus.failed.rawValue:
                        self.playbackState = PlaybackState.failed
                    default:
                        break
                    }
                }
                
            } else if keyPath == PlayerLoadedTimeRangesKey {
                
                // PlayerLoadedTimeRangesKey
                
                if let item = self._playerItem {
                    self.bufferingState = .ready
                    
                    let timeRanges = item.loadedTimeRanges
                    if let timeRange = timeRanges.first?.timeRangeValue {
                        let bufferedTime = CMTimeGetSeconds(CMTimeAdd(timeRange.start, timeRange.duration))
                        if _lastBufferTime != bufferedTime {
                            self.executeClosureOnMainQueueIfNecessary {
                                self.playerDelegate?.playerBufferTimeDidChange(bufferedTime)
                            }
                            _lastBufferTime = bufferedTime
                        }
                    }
                    
                    let currentTime = CMTimeGetSeconds(item.currentTime())
                    if ((_lastBufferTime - currentTime) >= self.bufferSize ||
                        _lastBufferTime == maximumDuration ||
                        timeRanges.first == nil)
                        && self.playbackState == .playing
                        {
                        self.play()
                    }
                    
                }
                
            }
        
        } else if context == &PlayerLayerObserverContext {
            if self._playerView.playerLayer.isReadyForDisplay {
                self.executeClosureOnMainQueueIfNecessary {
                    self.playerDelegate?.playerReady(self)
                }
            }
        }
        
    }

}

// MARK: - queues

extension Player {
    
    internal func executeClosureOnMainQueueIfNecessary(withClosure closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async(execute: closure)
        }
    }
    
}

// MARK: - PlayerView

internal class PlayerView: UIView {

    // MARK: - properties
    
    override class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }

    var playerLayer: AVPlayerLayer {
        get {
            return self.layer as! AVPlayerLayer
        }
    }

    var player: AVPlayer? {
        get {
            return self.playerLayer.player
        }
        set {
            self.playerLayer.player = newValue
        }
    }

    var fillMode: String {
        get {
            return self.playerLayer.videoGravity.rawValue
        }
        set {
            self.playerLayer.videoGravity = AVLayerVideoGravity(rawValue: newValue)
        }
    }
    
    // MARK: - object lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.playerLayer.backgroundColor = UIColor.black.cgColor
        self.playerLayer.fillMode = PlayerFillMode.resizeAspectFit.avFoundationType
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.playerLayer.backgroundColor = UIColor.black.cgColor
        self.playerLayer.fillMode = PlayerFillMode.resizeAspectFit.avFoundationType
    }

    deinit {
        self.player?.pause()
        self.player = nil
    }
    
}
