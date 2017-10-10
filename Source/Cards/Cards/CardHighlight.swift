//
//  CardHighlight.swift
//  Cards
//
//  Created by Paolo on 07/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

@IBDesignable class CardHighlight: Card {

    // SB Vars
    @IBInspectable var title: String = "gioco del giorno"
    @IBInspectable var itemTitle: String = "Flappy Bird"
    @IBInspectable var ItemTitleSize: CGFloat = 14
    @IBInspectable var itemSubtitle: String = "Flap that !"
    @IBInspectable var itemSubtitleSize: CGFloat = 12
    @IBInspectable var icon: UIImage?
    @IBInspectable var iconRadius: CGFloat = 16
    @IBInspectable var buttonText: String = "view"
    
    var delegate: CardDelegate?
    
    //Priv Vars
    var iconIV = UIImageView()
    var actionBtn = UIButton()
    var titleLbl = UILabel ()
    var itemTitleLbl = UILabel()
    var itemSubtitleLbl = UILabel()
    var lightColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    var bgIconIV = UIImageView()
    
    // View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundIV.addSubview(iconIV)
        backgroundIV.addSubview(titleLbl)
        backgroundIV.addSubview(itemTitleLbl)
        backgroundIV.addSubview(itemSubtitleLbl)
        backgroundIV.addSubview(actionBtn)
        
        if bgImage == nil {  backgroundIV.addSubview(bgIconIV); }
        else { bgIconIV.alpha = 0 }
    }
    
  
    override func draw(_ rect: CGRect) {
       super.draw(rect)
        
        // Helpers func
        func X(_ percentage: CGFloat ) -> CGFloat { return percentage*rect.width/100 }
        func Y(_ percentage: CGFloat ) -> CGFloat { return percentage*rect.height/100 }
        func X(_ percentage: CGFloat, from: UIView ) -> CGFloat { return percentage*rect.width/100 + from.frame.maxX }
        func Y(_ percentage: CGFloat, from: UIView ) -> CGFloat { return percentage*rect.height/100 + from.frame.maxY }
        func RevX(_ percentage: CGFloat, width: CGFloat ) -> CGFloat { return (rect.width - percentage*rect.width/100) - width }
        func RevY(_ percentage: CGFloat, height: CGFloat) -> CGFloat { return (rect.height - percentage*rect.height/100) - height }
        let btnWidth = CGFloat((buttonText.characters.count + 2) * 10)
        
        //Draw
        bgIconIV.frame = CGRect(x: RevX(-20, width: X(60)), y: Y(0), width: X(60), height: X(60))
        bgIconIV.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/6))
        bgIconIV.image = icon
        bgIconIV.alpha = bgImage != nil ? 0 : 0.6
        bgIconIV.layer.cornerRadius = iconRadius * 2
        bgIconIV.clipsToBounds = true
        
        iconIV.frame = CGRect(x: X(insets), y: X(insets), width: X(25), height: X(25))
        iconIV.image = icon
        iconIV.layer.cornerRadius = iconRadius
        iconIV.clipsToBounds = true
        
        titleLbl.frame = CGRect(x: X(insets), y: Y(5, from: iconIV), width: X(60), height: Y(35))
        titleLbl.text = title.uppercased()
        titleLbl.textColor = textColor
        titleLbl.font = UIFont.systemFont(ofSize: 72, weight: .heavy)
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.setLineHeight(0.65)
        titleLbl.minimumScaleFactor = 0.1
        titleLbl.lineBreakMode = .byTruncatingTail
        titleLbl.numberOfLines = 3
        
        itemTitleLbl.frame = CGRect(x: X(insets), y: RevY(17, height: Y(8)) + X(insets), width: X(80) - btnWidth, height: Y(8))
        itemTitleLbl.textColor = textColor
        itemTitleLbl.text = itemTitle
        itemTitleLbl.font = UIFont.boldSystemFont(ofSize: ItemTitleSize)
        itemTitleLbl.adjustsFontSizeToFitWidth = true
        itemTitleLbl.minimumScaleFactor = 0.1
        itemTitleLbl.lineBreakMode = .byTruncatingTail
        itemTitleLbl.numberOfLines = 0

        itemSubtitleLbl.frame = CGRect(x: X(insets), y: Y(0, from: itemTitleLbl), width: X(80) - btnWidth, height: Y(13))
        itemSubtitleLbl.textColor = textColor
        itemSubtitleLbl.text = itemSubtitle
        itemSubtitleLbl.font = UIFont.systemFont(ofSize: itemSubtitleSize)
        itemSubtitleLbl.adjustsFontSizeToFitWidth = true
        itemSubtitleLbl.minimumScaleFactor = 0.1
        itemSubtitleLbl.lineBreakMode = .byTruncatingTail
        itemSubtitleLbl.numberOfLines = 2
        itemSubtitleLbl.sizeToFit()
        
        actionBtn.frame = CGRect(x: RevX(insets, width: btnWidth), y: RevY(insets+2, height: 28), width: btnWidth, height: 28)
        actionBtn.backgroundColor = UIColor.clear
        actionBtn.layer.backgroundColor = lightColor.cgColor
        actionBtn.layer.cornerRadius = actionBtn.layer.bounds.height/2
        let btnTitle = NSAttributedString(string: buttonText.uppercased(), attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .black), NSAttributedStringKey.foregroundColor : self.tintColor])
        actionBtn.setAttributedTitle(btnTitle, for: .normal)
        actionBtn.addTarget(self, action: #selector(buttonTapped), for: UIControlEvents.touchUpInside)
        
        bringSubview(toFront: titleLbl)
    }
    
   
    //Actions
    @objc func buttonTapped(){
        //delegate?.cardDidTapButton(button: actionBtn); print("button tapped")
        UIView.animate(withDuration: 0.2, animations: {
            self.actionBtn.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        }) { (true) in
            UIView.animate(withDuration: 0.1, animations: {
                self.actionBtn.transform = CGAffineTransform.identity
            })
        }
        delegate?.cardDidTapButton(button: actionBtn)
    }
    

}



