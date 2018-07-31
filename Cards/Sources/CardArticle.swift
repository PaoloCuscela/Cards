//
//  CardArticle.swift
//  Cards
//
//  Created by Paolo on 08/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

@IBDesignable open class CardArticle: Card {
    
    // SB Vars
    /**
     Text of the title label.
     */
    @IBInspectable public var title: String = "The Art of the Impossible" {
        didSet{
            titleLbl.text = title
        }
    }
    /**
     Max font size the title label.
     */
    @IBInspectable public var titleSize: CGFloat = 26
    /**
     Text of the subtitle label.
     */
    @IBInspectable public var subtitle: String = "Inside the extraordinary world of Monument Valley 2" {
        didSet{
            subtitleLbl.text = subtitle
        }
    }
    /**
     Max font size the subtitle label.
     */
    @IBInspectable public var subtitleSize: CGFloat = 17
    /**
     Text of the category label.
     */
    @IBInspectable public var category: String = "world premiere" {
        didSet{
            categoryLbl.text = category.uppercased()
        }
    }

    //Priv Vars
    var titleLbl = UILabel ()
    var subtitleLbl = UILabel()
    var categoryLbl = UILabel()
    
    // View Life Cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override open func initialize() {
        super.initialize()
        
        backgroundIV.addSubview(titleLbl)
        backgroundIV.addSubview(subtitleLbl)
        backgroundIV.addSubview(categoryLbl)
    }
    
    
    override open func draw(_ rect: CGRect) {
        
        //Draw
        super.draw(rect)
        
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
        
        let gimme  = LayoutHelper(rect: backgroundIV.bounds)
        
        categoryLbl.frame = CGRect(x: insets,
                                   y: insets,
                                   width: gimme.X(80),
                                   height: gimme.Y(7))
        
        titleLbl.frame = CGRect(x: insets,
                                y: gimme.Y(1, from: categoryLbl),
                                width: gimme.X(80),
                                height: gimme.Y(17))
        
        subtitleLbl.frame = CGRect(x: insets,
                                   y: gimme.RevY(0, height: gimme.Y(14)) - insets,
                                   width: gimme.X(80),
                                   height: gimme.Y(14))
        titleLbl.sizeToFit()
    }
    
}



