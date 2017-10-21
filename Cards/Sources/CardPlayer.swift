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

    @IBInspectable public var title: String = "Big Buck Bunny"
    @IBInspectable public var titleSize: CGFloat = 26
    @IBInspectable public var subtitle: String = "Inside the extraordinary world of Buck Bunny"
    @IBInspectable public var subtitleSize: CGFloat = 19
    @IBInspectable public var category: String = "today's movie"
    @IBInspectable public var playBtnSize: CGFloat = 56
    @IBInspectable public var playImage: UIImage?
    @IBInspectable public var playerCover: UIImage?
    @IBInspectable public var isAutoplayEnabled: Bool = false
    @IBInspectable public var shouldRestartVideoWhenPlaybackEnds: Bool = true
    @IBInspectable public var videoSource: URL?  {
        didSet { player.url = videoSource }
    }

    open var player = Player() // Player provided by Patrik Piemonte

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
    
    override  func initialize() {
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
        backgroundIV.backgroundColor = UIColor.yellow
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
        
        layout(rect, animated: false, showingDetail: false)
    }
    
    fileprivate func layout(_ rect: CGRect, animated: Bool = false, showingDetail: Bool = false) {
        let gimme = LayoutHelper(rect: rect)
        
        let aspect916 = rect.width *  (9/16)
        let aspect921 = rect.width *  (9/21)
        let move = ( aspect916 - aspect921 ) * 2
        
        subtitleLbl.transform = showingDetail ? CGAffineTransform(translationX: 0, y: move) : CGAffineTransform.identity
        backgroundIV.frame.size.height = originalFrame.height + ( showingDetail ? move : 0 )
        
        player.view.frame.origin = CGPoint.zero
        player.view.frame.size = CGSize(width: rect.width, height: showingDetail ? aspect916 : aspect921 )
        playerCoverIV.frame = player.view.bounds
        
        playPauseV.frame.size = CGSize(width: playBtnSize, height: playBtnSize)
        playPauseV.center = player.view.center
        playPauseV.layer.cornerRadius = playPauseV.frame.height/2
        
        playIV.center = playPauseV.contentView.center.applying(CGAffineTransform(translationX: gimme.Width(5, of: playPauseV), y: 0))
        playIV.frame.size = CGSize(width: gimme.Width(50, of: playPauseV),
                                   height: gimme.Width(50, of: playPauseV))
        
        categoryLbl.frame.origin.y = gimme.Y(3, from: player.view)
        titleLbl.frame.origin.y = gimme.Y(0, from: categoryLbl)
        titleLbl.sizeToFit()
        
        guard !animated else { return }
            
        categoryLbl.frame = CGRect(x: insets,
                                   y: gimme.Y(3, from: player.view),
                                   width: gimme.X(80),
                                   height: gimme.Y(7))
        
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
    
    // Actions
    override  func cardTapped() {
        super.cardTapped()
        delegate?.cardDidTapInside?(card: self)
    }
    
    @objc  func playTapped() {
        delegate?.cardPlayerDidPlay?(card: self)
        player.playFromCurrentTime()
        
        UIView.animate(withDuration: 0.2) {
            self.playPauseV.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.playPauseV.alpha = 0
        }
    }
    
    @objc  func playerTapped() {
        delegate?.cardPlayerDidPause?(card: self)
        player.pause()
        
        UIView.animate(withDuration: 0.1) {
            self.playPauseV.transform = CGAffineTransform.identity
            self.playPauseV.alpha = 1
        }
    }

}


// Player Delegates
extension CardPlayer: PlayerDelegate {
    public func playerReady(_ player: Player) {
        
        player.view.addSubview(playPauseV)
        if isAutoplayEnabled {
            
            player.playFromBeginning()
            self.playPauseV.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.playPauseV.alpha = 0
        } else {
            player.pause()
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

extension CardPlayer: CardDelegate {
    
    public func cardIsHidingDetail(card: Card) {
        layout(backgroundIV.frame, animated: true, showingDetail: false)
    }

    public func cardIsShowingDetail(card: Card) {
        layout(backgroundIV.frame, animated: true, showingDetail: true)
    }
   
}


