//
//  CardPlayer.swift
//  Cards
//
//  Created by Paolo on 12/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit
import Player

@IBDesignable open class CardPlayer: Card {

    /**
     Text of the title label.
     */
    @IBInspectable public var title: String = "Big Buck Bunny" {
        didSet{
            titleLbl.text = title
        }
    }
    /**
     Max font size of the title label.
     */
    @IBInspectable public var titleSize: CGFloat = 26
    /**
     Text of the subtitle label.
     */
    @IBInspectable public var subtitle: String = "Inside the extraordinary world of Buck Bunny" {
        didSet{
            subtitleLbl.text = subtitle
        }
    }
    /**
     Max font size of the subtitle label.
     */
    @IBInspectable public var subtitleSize: CGFloat = 19
    /**
     Text of the category label.
     */
    @IBInspectable public var category: String = "today's movie" {
        didSet{
            categoryLbl.text = category.uppercased()
        }
    }
    /**
     Size for the play button in the player.
     */
    @IBInspectable public var playBtnSize: CGFloat = 56 {
        didSet {
            layout(animating: false)
        }
    }
    /**
     Image shown in the play button.
     */
    @IBInspectable public var playImage: UIImage? {
        didSet {
            playIV.image = playImage
        }
    }
    /**
     Image shown before the player is loaded.
     */
    @IBInspectable public var playerCover: UIImage? {
        didSet{
            playerCoverIV.image = playerCover
        }
    }
    /**
     If the player should start the playback when is ready.
     */
    @IBInspectable public var isAutoplayEnabled: Bool = false
    /**
     If the player should restart the playback when it ends.
     */
    @IBInspectable public var shouldRestartVideoWhenPlaybackEnds: Bool = true
    /**
     Source for the video ( streaming or local ).
     */
    @IBInspectable public var videoSource: URL?  {
        didSet {
            player.url = videoSource
        }
    }

    /**
     Required. View controller that should display the player.
     */
    public func shouldDisplayPlayer( from vc: UIViewController ) {
        vc.addChildViewController(player)
    }
    
    private var player = Player() // Player provided by Patrik Piemonte

    private var titleLbl = UILabel ()
    private var subtitleLbl = UILabel()
    private var playPauseV = UIVisualEffectView()
    private var playIV = UIImageView()
    private var playerCoverIV = UIImageView()
    private var categoryLbl = UILabel()

    // View Life Cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override open func initialize() {
        super.initialize()
        self.delegate = self
        
        backgroundIV.addSubview(categoryLbl)
        backgroundIV.addSubview(titleLbl)
        backgroundIV.addSubview(subtitleLbl)
        backgroundIV.addSubview(playerCoverIV)
        
        // Player Init
        player.playerDelegate = self
        player.playbackDelegate = self
        player.fillMode = PlayerFillMode.resizeAspectFill.avFoundationType
        if let url = videoSource { player.url = url }
        else { print("CARDS: Something wrong with the video source URL") }
       
        backgroundIV.addSubview(self.player.view)
        playPauseV.contentView.addSubview(playIV)
        playPauseV.contentView.bringSubview(toFront: playIV)
        
        // Gestures
        player.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playerTapped)))
        playPauseV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playTapped)))
        
        backgroundIV.isUserInteractionEnabled = true
        player.view.isUserInteractionEnabled = true
        playPauseV.isUserInteractionEnabled = true
        
    }
    
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
    
        if let cover = playerCover {
            playerCoverIV.image = cover
        }
        
        playPauseV.effect = UIBlurEffect(style: .dark)
        playPauseV.clipsToBounds = true
        
        playIV.contentMode = .scaleAspectFit
        playIV.tintColor = UIColor.white
        if let img = playImage ?? UIImage(named: "CardPlayerPlayIcon") {
            playIV.image = img.withRenderingMode(.alwaysTemplate)
        } else {
            print("CARDS: Missing play icon, assign one to 'playImage' or download it from my repo and import it to your assests folder")
        }
        
        categoryLbl.text = category.uppercased()
        categoryLbl.textColor = textColor.withAlphaComponent(0.3)
        categoryLbl.font = UIFont.systemFont(ofSize: 100, weight: .bold)
        categoryLbl.shadowColor = UIColor.black
        categoryLbl.shadowOffset = CGSize.zero
        categoryLbl.adjustsFontSizeToFitWidth = true
        categoryLbl.minimumScaleFactor = 0.1
        categoryLbl.lineBreakMode = .byTruncatingTail
        categoryLbl.numberOfLines = 0
        
        titleLbl.textColor = textColor
        titleLbl.text = title
        titleLbl.font = UIFont.systemFont(ofSize: titleSize, weight: .bold)
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.minimumScaleFactor = 0.1
        titleLbl.lineBreakMode = .byClipping
        titleLbl.numberOfLines = 2
        titleLbl.baselineAdjustment = .none
        
        subtitleLbl.text = subtitle
        subtitleLbl.textColor = textColor
        subtitleLbl.font = UIFont.systemFont(ofSize: subtitleSize, weight: .medium)
        subtitleLbl.shadowColor = UIColor.black
        subtitleLbl.shadowOffset = CGSize.zero
        subtitleLbl.adjustsFontSizeToFitWidth = true
        subtitleLbl.minimumScaleFactor = 0.1
        subtitleLbl.lineBreakMode = .byTruncatingTail
        subtitleLbl.numberOfLines = 0
        subtitleLbl.textAlignment = .left
        
        self.layout()
    }
    
    override open func layout(animating: Bool = true) {
        super.layout(animating: animating)
        
        let gimme = LayoutHelper(rect: backgroundIV.bounds)
        
        let aspect1016 = backgroundIV.bounds.width *  (10/16)
        let aspect921 = backgroundIV.bounds.width *  (9/21)
        let move = ( aspect1016 - aspect921 ) * 2
        
        subtitleLbl.transform = isPresenting ? CGAffineTransform(translationX: 0, y: move) : CGAffineTransform.identity
        backgroundIV.frame.size.height = originalFrame.height + ( isPresenting ? move/2 : 0 )
        
        player.view.frame.origin = CGPoint.zero
        player.view.frame.size = CGSize(width: backgroundIV.bounds.width, height: isPresenting ? aspect1016 : aspect921 )
        playerCoverIV.frame = player.view.bounds
        
        
        playPauseV.center = player.view.center
        playIV.center = playPauseV.contentView.center.applying(CGAffineTransform(translationX: LayoutHelper.Width(5, of: playPauseV), y: 0))
        
        categoryLbl.frame.origin.y = gimme.Y(3, from: player.view)
        titleLbl.frame.origin.y = gimme.Y(0, from: categoryLbl)
        titleLbl.sizeToFit()
        
        categoryLbl.frame = CGRect(x: insets,
                                   y: gimme.Y(3, from: player.view),
                                   width: gimme.X(80),
                                   height: gimme.Y(5))
        
        titleLbl.frame = CGRect(x: insets,
                                y: gimme.Y(0, from: categoryLbl),
                                width: gimme.X(70),
                                height: gimme.Y(12))
        titleLbl.sizeToFit()
        
        subtitleLbl.frame = CGRect(x: insets,
                                   y: gimme.RevY(0, height: gimme.Y(14)) - insets,
                                   width: gimme.X(80),
                                   height: gimme.Y(12))
    }
    
    
    //MARK: - Actions
    
    public func play() {
        
        player.playFromCurrentTime()
        UIView.animate(withDuration: 0.2) {
            self.playPauseV.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.playPauseV.alpha = 0
        }
    }
    
    public func pause() {
        
        player.pause()
        UIView.animate(withDuration: 0.1) {
            self.playPauseV.transform = CGAffineTransform.identity
            self.playPauseV.alpha = 1
        }
    }
    
    public func stop() {
        
        pause()
        player.stop()
    }
    
    @objc  func playTapped() {
        
        play()
        delegate?.cardPlayerDidPlay?(card: self)
    }
    
    @objc  func playerTapped() {
        
        pause()
        delegate?.cardPlayerDidPause?(card: self)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == player.view || touches.first?.view == playPauseV.contentView { playerTapped() }
        else { super.touchesBegan(touches, with: event) }
    }

}


// Player Delegates
extension CardPlayer: PlayerDelegate {
    public func playerReady(_ player: Player) {
        
        player.view.addSubview(playPauseV)
        playPauseV.frame.size = CGSize(width: playBtnSize, height: playBtnSize)
        playPauseV.layer.cornerRadius = playPauseV.frame.height/2
        playIV.frame.size = CGSize(width: LayoutHelper.Width(50, of: playPauseV),
                                   height: LayoutHelper.Width(50, of: playPauseV))
        playPauseV.center = player.view.center
        playIV.center = playPauseV.contentView.center.applying(CGAffineTransform(translationX: LayoutHelper.Width(5, of: playPauseV), y: 0))
        
        if isAutoplayEnabled {
            
            play()
        } else {
            pause()
        }
    }
    
    public func playerPlaybackStateDidChange(_ player: Player) { }
    public func playerBufferingStateDidChange(_ player: Player) { }
    public func playerBufferTimeDidChange(_ bufferTime: Double) { }
}

extension CardPlayer: PlayerPlaybackDelegate {
    
    public func playerPlaybackDidEnd(_ player: Player) {
        
        if shouldRestartVideoWhenPlaybackEnds { player.playFromBeginning() }
        else { playerTapped()  }
        
    }
    
    public func playerPlaybackWillLoop(_ player: Player) { }
    public func playerCurrentTimeDidChange(_ player: Player) { }
    public func playerPlaybackWillStartFromBeginning(_ player: Player) { }
}


