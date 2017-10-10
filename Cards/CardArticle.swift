//
//  CardArticle.swift
//  Cards
//
//  Created by Paolo on 08/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

@IBDesignable class CardArticle: Card {
    
    // SB Vars
    @IBInspectable var title: String = "The Art of the Impossible"
    @IBInspectable var subtitle: String = "Inside the extraordinary world of Monument Valley 2"
    @IBInspectable var category: String = "world premiere"
    @IBInspectable var blurEffect: UIBlurEffectStyle = UIBlurEffectStyle.extraLight
    
    // Delegate
    var delegate: CardDelegate?
    
    //Priv Vars
    var titleLbl = UILabel ()
    var subtitleLbl = UILabel()
    var categoryLbl = UILabel()
    
    // View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        backgroundIV.addSubview(titleLbl)
        backgroundIV.addSubview(subtitleLbl)
        backgroundIV.addSubview(categoryLbl)
        
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
        
        categoryLbl.frame = CGRect(x: X(insets), y: X(insets), width: X(100-(insets*2)), height: Y(5))
        categoryLbl.text = category.uppercased()
        categoryLbl.textColor = textColor.withAlphaComponent(0.9)
        categoryLbl.font = UIFont.systemFont(ofSize: 100, weight: .bold)
        categoryLbl.shadowColor = UIColor.black
        categoryLbl.shadowOffset = CGSize.zero
        categoryLbl.adjustsFontSizeToFitWidth = true
        categoryLbl.minimumScaleFactor = 0.1
        categoryLbl.lineBreakMode = .byTruncatingTail
        categoryLbl.numberOfLines = 0
        
        titleLbl.frame = CGRect(x: X(insets), y: Y(1, from: categoryLbl), width: X(80), height: Y(17))
        titleLbl.textColor = textColor
        titleLbl.text = title
        titleLbl.font = UIFont.systemFont(ofSize: self.maxTitleFontSize, weight: .bold)
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.minimumScaleFactor = 0.1
        titleLbl.lineBreakMode = .byClipping
        titleLbl.numberOfLines = 2
        titleLbl.baselineAdjustment = .none
        titleLbl.sizeToFit()
        
        subtitleLbl.frame = CGRect(x: X(insets), y: RevY(insets*(frame.width/frame.height), height: Y(7)), width: X(100-(insets*2)), height: Y(10))
        subtitleLbl.text = subtitle
        subtitleLbl.textColor = textColor
        subtitleLbl.font = UIFont.systemFont(ofSize: 100, weight: .medium)
        subtitleLbl.shadowColor = UIColor.black
        subtitleLbl.shadowOffset = CGSize.zero
        subtitleLbl.adjustsFontSizeToFitWidth = true
        subtitleLbl.minimumScaleFactor = 0.1
        subtitleLbl.lineBreakMode = .byTruncatingTail
        subtitleLbl.numberOfLines = 0
        subtitleLbl.textAlignment = .left
     
    }
    
    override func cardTapped() {
        super.cardTapped()
        delegate?.cardDidTapInside(card: self)
    }
    
}



