//
//  Card.swift
//  Cards
//
//  Created by Paolo on 09/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

protocol CardDelegate {
    
    func cardDidTapButton(button: UIButton)
    func cardDidTapInside(card: Card)
}

@IBDesignable class Card: UIView {
    
    // SB Vars
    @IBInspectable var shadowBlur: CGFloat = 14
    @IBInspectable var shadowOpacity: Float = 0.6
    @IBInspectable var shadowColor: UIColor = UIColor.gray
    @IBInspectable var bgImage: UIImage?
    @IBInspectable var bgColor: UIColor = UIColor.darkGray
    @IBInspectable var textColor: UIColor = UIColor.white
    @IBInspectable var insets: CGFloat = 6
    @IBInspectable var cardRadius: CGFloat = 20
    @IBInspectable var maxTitleFontSize: CGFloat = 26
    
    
    //Priv Vars
    var backgroundIV = UIImageView()
    
    // View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cardTapped)))
        
        addSubview(backgroundIV)
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
        self.layer.backgroundColor = bgColor.cgColor
        
        //Draw
        backgroundIV.frame = rect
        backgroundIV.image = bgImage
        backgroundIV.layer.cornerRadius = self.layer.cornerRadius
        backgroundIV.clipsToBounds = true
        backgroundIV.contentMode = .scaleAspectFill
    }
    
    
    //Actions
    @objc func cardTapped(){
        print("card tapped")
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
