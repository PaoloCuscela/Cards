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
    /**
     Text of the title label.
     */
    @IBInspectable public var title: String = "Welcome to XI Cards !" {
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
    @IBInspectable public var subtitle: String = "from the editors" {
        didSet{
            subtitleLbl.text = subtitle.uppercased()
        }
    }
    /**
     Max font size the subtitle label.
     */
    @IBInspectable public var subtitleSize: CGFloat = 26
    /**
     Style for the blur effect.
     */
    @IBInspectable public var blurEffect: UIBlurEffect.Style = .extraLight {
        didSet{
            blurV.effect = UIBlurEffect(style: blurEffect)
        }
    }
    
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
    
    override open func initialize() {
        super.initialize()
        
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
        
        layout()
    }
    
    override open func layout(animating: Bool = true) {
        super.layout(animating: animating)
        
        let gimme = LayoutHelper(rect: backgroundIV.bounds)
        
        blurV.frame = CGRect(x: 0,
                             y: 0,
                             width: backgroundIV.bounds.width,
                             height: gimme.Y(42))
        
        vibrancyV.frame = blurV.frame
        
        
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

}


