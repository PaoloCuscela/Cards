//
//  CardGroup.swift
//  Cards
//
//  Created by Paolo on 08/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

@IBDesignable class CardGroup: Card {
    
    // SB Vars
    @IBInspectable var title: String = "Welcome to XI Cards !"
    @IBInspectable var titleSize: CGFloat = 26
    @IBInspectable var subtitle: String = "from the editors"
    @IBInspectable var subtitleSize: CGFloat = 26
    @IBInspectable var blurEffect: UIBlurEffectStyle = UIBlurEffectStyle.extraLight
    
    //Priv Vars
    internal var subtitleLbl = UILabel ()
    internal var titleLbl = UILabel()
    internal var blurV = UIVisualEffectView()
    internal var vibrancyV = UIVisualEffectView()
    
    // View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func initialize() {
        super.initialize()
        
        self.delegate = self
        vibrancyV = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: blurEffect)))
        backgroundIV.addSubview(blurV)
        blurV.contentView.addSubview(titleLbl)
        blurV.contentView.addSubview(vibrancyV)
        vibrancyV.contentView.addSubview(subtitleLbl)

    }
    
    override func draw(_ rect: CGRect) {
        
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
    
    fileprivate func layout(_ rect: CGRect, animated: Bool = false, showingDetail: Bool = false) {
        
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
    
    
    override func cardTapped() {
        super.cardTapped()
        delegate?.cardDidTapInside?(card: self)
        
    }
}

extension CardGroup: CardDelegate {
    
    func cardIsShowingDetail(card: Card) { layout(backgroundIV.bounds, animated: true, showingDetail: true) }
    func cardIsHidingDetail(card: Card) { layout(backgroundIV.bounds, animated: true, showingDetail: false) }
    
    func cardDidShowDetailView(card: Card) { layout(backgroundIV.frame) }
    
}


