//
//  Card.swift
//  Cards
//
//  Created by Paolo on 09/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

@objc protocol CardDelegate {
    
    @objc optional func cardDidTapInside(card: Card)
    @objc optional func cardHighlightDidTapButton(card: CardHighlight, button: UIButton)
    @objc optional func cardPlayerDidPlay(card: CardPlayer)
    @objc optional func cardPlayerDidPause(card: CardPlayer)
}

@IBDesignable class Card: UIView {
    
    // SB Vars
    @IBInspectable var shadowBlur: CGFloat = 14
    @IBInspectable var shadowOpacity: Float = 0.6
    @IBInspectable var shadowColor: UIColor = UIColor.gray
    @IBInspectable var backgroundImage: UIImage?
    @IBInspectable var textColor: UIColor = UIColor.black
    @IBInspectable var insets: CGFloat = 6
    @IBInspectable var cardRadius: CGFloat = 20
    
    override var backgroundColor: UIColor? {
        didSet(new) {
            if let color = new { self.layer.backgroundColor = color.cgColor }
            if backgroundColor != UIColor.clear { backgroundColor = UIColor.clear }
        }
    }
    
    //Priv Vars
    internal var backgroundIV = UIImageView()
    
    // View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cardTapped)))
        self.addSubview(backgroundIV)
        self.backgroundColor = UIColor.white
    }
    
    
    override func draw(_ rect: CGRect) {
        
        // Helpers func
        func X(_ percentage: CGFloat ) -> CGFloat { return percentage*rect.width/100 }
        func Y(_ percentage: CGFloat ) -> CGFloat { return percentage*rect.height/100 }
        func X(_ percentage: CGFloat, from: UIView ) -> CGFloat { return percentage*rect.width/100 + from.frame.maxX }
        func Y(_ percentage: CGFloat, from: UIView ) -> CGFloat { return percentage*rect.height/100 + from.frame.maxY }
        func RevX(_ percentage: CGFloat, width: CGFloat ) -> CGFloat { return (rect.width - percentage*rect.width/100) - width }
        func RevY(_ percentage: CGFloat, height: CGFloat) -> CGFloat { return (rect.height - percentage*rect.height/100) - height }
    
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = shadowBlur
        self.layer.cornerRadius = cardRadius
        
        //Draw
        backgroundIV.frame = rect
        backgroundIV.image = backgroundImage
        backgroundIV.layer.cornerRadius = self.layer.cornerRadius
        backgroundIV.clipsToBounds = true
        backgroundIV.contentMode = .scaleAspectFill
    }
    
    
    //Actions
    @objc func cardTapped(){
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (true) in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        }
    }
}


// Label Helpers
extension UILabel {
    
    func setLineHeight(_ lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(NSAttributedStringKey.font, value: self.font, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        self.allowsDefaultTighteningForTruncation = true
        
        self.attributedText = attrString
    }
}
