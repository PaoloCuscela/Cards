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
    @IBInspectable var title: String = "from the editors"
    @IBInspectable var subtitle: String = "Welcome to XI Cards !"
    @IBInspectable var blurEffect: UIBlurEffectStyle = UIBlurEffectStyle.extraLight
    
    //Priv Vars
    var titleLbl = UILabel ()
    var subtitleLbl = UILabel()
    var blurV = UIVisualEffectView()
    var vibrancyV = UIVisualEffectView()
    
    
    // View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        vibrancyV = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: blurEffect)))
        
        
        backgroundIV.addSubview(blurV)
        blurV.contentView.addSubview(subtitleLbl)
        blurV.contentView.addSubview(vibrancyV)
        vibrancyV.contentView.addSubview(titleLbl)
        
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
        
        
        
        
        titleLbl.frame = CGRect(x: X(insets), y: X(insets), width: X(100-(insets*2)), height: Y(5))
        titleLbl.text = title.uppercased()
        titleLbl.textColor = textColor
        titleLbl.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        titleLbl.shadowColor = UIColor.black
        titleLbl.shadowOffset = CGSize.zero
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.minimumScaleFactor = 0.1
        titleLbl.lineBreakMode = .byTruncatingTail
        titleLbl.numberOfLines = 0
        
        
        subtitleLbl.frame = CGRect(x: X(insets), y: Y(2, from: titleLbl), width: X(100-(insets*2)), height: Y(15))
        subtitleLbl.textColor = textColor
        subtitleLbl.text = subtitle
        subtitleLbl.font = UIFont.systemFont(ofSize: self.maxTitleFontSize, weight: .bold)
        subtitleLbl.adjustsFontSizeToFitWidth = true
        subtitleLbl.minimumScaleFactor = 0.1
        subtitleLbl.lineBreakMode = .byTruncatingTail
        subtitleLbl.numberOfLines = 2
        subtitleLbl.sizeToFit()
        //subtitleLbl.backgroundColor = UIColor.blue
        
        blurV.frame = CGRect(x: 0, y: 0, width: rect.width, height: Y(insets*2) + titleLbl.frame.size.height + subtitleLbl.frame.height)
        let blur = UIBlurEffect(style: blurEffect)
        blurV.effect = blur
        
        vibrancyV.frame = blurV.frame
    }
}


