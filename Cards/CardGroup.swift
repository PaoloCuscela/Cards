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
    
    // Delegate
    var delegate: CardDelegate?
    
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
        
        vibrancyV = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: blurEffect)))
        backgroundIV.addSubview(blurV)
        blurV.contentView.addSubview(titleLbl)
        blurV.contentView.addSubview(vibrancyV)
        vibrancyV.contentView.addSubview(subtitleLbl)
    }
    
    override func draw(_ rect: CGRect) {
        
        // Helpers func
        func X(_ percentage: CGFloat ) -> CGFloat { return percentage*rect.width/100 }
        func Y(_ percentage: CGFloat ) -> CGFloat { return percentage*rect.height/100 }
        func X(_ percentage: CGFloat, from: UIView ) -> CGFloat { return percentage*rect.width/100 + from.frame.maxX }
        func Y(_ percentage: CGFloat, from: UIView ) -> CGFloat { return percentage*rect.height/100 + from.frame.maxY }
        func RevX(_ percentage: CGFloat, width: CGFloat ) -> CGFloat { return (rect.width - percentage*rect.width/100) - width }
        func RevY(_ percentage: CGFloat, height: CGFloat) -> CGFloat { return (rect.height - percentage*rect.height/100) - height }
        
        //Draw
        super.draw(rect)
        
        subtitleLbl.frame = CGRect(x: X(insets), y: X(insets), width: X(100-(insets*2)), height: Y(5))
        subtitleLbl.text = subtitle.uppercased()
        subtitleLbl.textColor = textColor
        subtitleLbl.font = UIFont.systemFont(ofSize: subtitleSize, weight: .semibold)
        subtitleLbl.adjustsFontSizeToFitWidth = true
        subtitleLbl.minimumScaleFactor = 0.1
        subtitleLbl.lineBreakMode = .byTruncatingTail
        subtitleLbl.numberOfLines = 0
        
        titleLbl.frame = CGRect(x: X(insets), y: Y(2, from: subtitleLbl), width: X(100-(insets*2)), height: Y(15))
        titleLbl.textColor = textColor
        titleLbl.text = title
        titleLbl.font = UIFont.systemFont(ofSize: titleSize, weight: .bold)
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.minimumScaleFactor = 0.1
        titleLbl.lineBreakMode = .byTruncatingTail
        titleLbl.numberOfLines = 2
        titleLbl.sizeToFit()
        //subtitleLbl.backgroundColor = UIColor.blue
        
        blurV.frame = CGRect(x: 0, y: 0, width: rect.width, height: Y(insets*2) + subtitleLbl.frame.size.height + titleLbl.frame.height)
        let blur = UIBlurEffect(style: blurEffect)
        blurV.effect = blur
        
        vibrancyV.frame = blurV.frame
    }
    
    override func cardTapped() {
        super.cardTapped()
        delegate?.cardDidTapInside?(card: self)
        
    }
}


