//
//  CardGroup.swift
//  Cards
//
//  Created by Paolo on 08/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

@IBDesignable open class CardGroup: Card {
    
    // SB Vars
    @IBInspectable public var title: String = "Welcome to XI Cards !"
    @IBInspectable public var titleSize: CGFloat = 26
    @IBInspectable public var subtitle: String = "from the editors"
    @IBInspectable public var subtitleSize: CGFloat = 26
    @IBInspectable public var blurEffect: UIBlurEffectStyle = .extraLight
    
    //Priv Vars
    var subtitleLbl = UILabel ()
    var titleLbl = UILabel()
    var blurV = UIVisualEffectView()
    var vibrancyV = UIVisualEffectView()
    
    // View Life Cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override  func initialize() {
        super.initialize()
        
        self.delegate = self
        vibrancyV = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: blurEffect)))
        backgroundIV.addSubview(blurV)
        blurV.contentView.addSubview(titleLbl)
        blurV.contentView.addSubview(vibrancyV)
        vibrancyV.contentView.addSubview(subtitleLbl)

    }
    
    override open func draw(_ rect: CGRect) {
        
        //Draw
        super.draw(rect)
        
        subtitleLbl.text = subtitle.uppercased()
        subtitleLbl.textColor = textColor
        subtitleLbl.font = UIFont.systemFont(ofSize: subtitleSize, weight: .semibold)
        subtitleLbl.adjustsFontSizeToFitWidth = true
        subtitleLbl.minimumScaleFactor = 0.1
        subtitleLbl.lineBreakMode = .byTruncatingTail
        subtitleLbl.numberOfLines = 0
        
        titleLbl.textColor = textColor
        titleLbl.text = title
        titleLbl.font = UIFont.systemFont(ofSize: titleSize, weight: .bold)
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.minimumScaleFactor = 0.1
        titleLbl.lineBreakMode = .byTruncatingTail
        titleLbl.numberOfLines = 2
        
        let blur = UIBlurEffect(style: blurEffect)
        blurV.effect = blur
        
        layout(backgroundIV.bounds, animated: false, showingDetail: false)
    }
    
    private func layout(_ rect: CGRect, animated: Bool = false, showingDetail: Bool = false) {
        
        let gimme = LayoutHelper(rect: rect)
        
        blurV.frame = CGRect(x: 0,
                             y: 0,
                             width: rect.width,
                             height: gimme.Y(42))
        
        vibrancyV.frame = blurV.frame
        
        guard !animated else { return }
        
        subtitleLbl.frame = CGRect(x: insets,
                                   y: insets,
                                   width: gimme.X(80),
                                   height: gimme.Y(6))
        
        titleLbl.frame = CGRect(x: insets,
                                y: gimme.Y(0, from: subtitleLbl),
                                width: gimme.X(80),
                                height: gimme.Y(20))
        titleLbl.sizeToFit()
    }
    
    
    override  func cardTapped() {
        super.cardTapped()
        delegate?.cardDidTapInside?(card: self)
        
    }
}

extension CardGroup: CardDelegate {
    
    public func cardIsShowingDetail(card: Card) {
        layout(backgroundIV.bounds, animated: true, showingDetail: true)
    }

    public func cardIsHidingDetail(card: Card) {
        layout(backgroundIV.bounds, animated: true, showingDetail: false)
    }
    
    public func cardDidShowDetailView(card: Card) {
        layout(backgroundIV.frame)
    }
    
}


