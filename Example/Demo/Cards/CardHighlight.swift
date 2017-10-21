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
    @IBInspectable var title: String = "welcome/n to cards/n XI !"
    @IBInspectable var titleSize:CGFloat = 26
    @IBInspectable var itemTitle: String = "Flappy Bird"
    @IBInspectable var itemTitleSize: CGFloat = 16
    @IBInspectable var itemSubtitle: String = "Flap that !"
    @IBInspectable var itemSubtitleSize: CGFloat = 14
    @IBInspectable var icon: UIImage?
    @IBInspectable var iconRadius: CGFloat = 16
    @IBInspectable var buttonText: String = "view"
    
    //Priv Vars
    internal var iconIV = UIImageView()
    internal var actionBtn = UIButton()
    internal var titleLbl = UILabel ()
    internal var itemTitleLbl = UILabel()
    internal var itemSubtitleLbl = UILabel()
    internal var lightColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    internal var bgIconIV = UIImageView()
    
    fileprivate var btnWidth = CGFloat()
    
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
        actionBtn.addTarget(self, action: #selector(buttonTapped), for: UIControlEvents.touchUpInside)
        
        backgroundIV.addSubview(iconIV)
        backgroundIV.addSubview(titleLbl)
        backgroundIV.addSubview(itemTitleLbl)
        backgroundIV.addSubview(itemSubtitleLbl)
        detailSV.addSubview(actionBtn)
        
        if backgroundImage == nil {  backgroundIV.addSubview(bgIconIV); }
        else { bgIconIV.alpha = 0 }
    }
    
  
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //Draw
        bgIconIV.image = icon
        bgIconIV.alpha = backgroundImage != nil ? 0 : 0.6
        bgIconIV.clipsToBounds = true
        
        
        iconIV.image = icon
        iconIV.clipsToBounds = true
        
        titleLbl.text = title.uppercased()
        titleLbl.textColor = textColor
        titleLbl.font = UIFont.systemFont(ofSize: titleSize, weight: .heavy)
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.lineHeight(0.70)
        titleLbl.minimumScaleFactor = 0.1
        titleLbl.lineBreakMode = .byTruncatingTail
        titleLbl.numberOfLines = 3
        backgroundIV.bringSubview(toFront: titleLbl)
        
        itemTitleLbl.textColor = textColor
        itemTitleLbl.text = itemTitle
        itemTitleLbl.font = UIFont.boldSystemFont(ofSize: itemTitleSize)
        itemTitleLbl.adjustsFontSizeToFitWidth = true
        itemTitleLbl.minimumScaleFactor = 0.1
        itemTitleLbl.lineBreakMode = .byTruncatingTail
        itemTitleLbl.numberOfLines = 0

        itemSubtitleLbl.textColor = textColor
        itemSubtitleLbl.text = itemSubtitle
        itemSubtitleLbl.font = UIFont.systemFont(ofSize: itemSubtitleSize)
        itemSubtitleLbl.adjustsFontSizeToFitWidth = true
        itemSubtitleLbl.minimumScaleFactor = 0.1
        itemSubtitleLbl.lineBreakMode = .byTruncatingTail
        itemSubtitleLbl.numberOfLines = 2
        itemSubtitleLbl.sizeToFit()
        
        actionBtn.backgroundColor = UIColor.clear
        actionBtn.layer.backgroundColor = lightColor.cgColor
        actionBtn.clipsToBounds = true
        let btnTitle = NSAttributedString(string: buttonText.uppercased(), attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16, weight: .black), NSAttributedStringKey.foregroundColor : self.tintColor])
        actionBtn.setAttributedTitle(btnTitle, for: .normal)
        
        btnWidth = CGFloat((buttonText.characters.count + 2) * 10)
        
        layout(backgroundIV.frame, animated: true, showingDetail: false)
        
    }
    
    fileprivate func layout(_ rect: CGRect, animated: Bool = false, showingDetail: Bool = false) {
        
        let gimme = LayoutHelper(rect: rect)
        
        iconIV.frame = CGRect(x: insets,
                              y: insets,
                              width: gimme.Y(25),
                              height: gimme.Y(25))
        
        titleLbl.frame.origin = CGPoint(x: insets, y: gimme.Y(5, from: iconIV))
        titleLbl.frame.size.width = (originalFrame.width * 0.65) + ((rect.width - originalFrame.width)/3)
        titleLbl.frame.size.height = gimme.Y(35)
        
        itemSubtitleLbl.sizeToFit()
        itemSubtitleLbl.frame.origin = CGPoint(x: insets, y: gimme.RevY(0, height: itemSubtitleLbl.bounds.size.height) - insets)
        
        itemTitleLbl.frame = CGRect(x: insets,
                                    y: gimme.RevY(0, height: gimme.Y(9), from: itemSubtitleLbl),
                                    width: gimme.X(80) - btnWidth,
                                    height: gimme.Y(9))
        
        bgIconIV.transform = CGAffineTransform.identity
        
        guard animated else { return }
        
        iconIV.layer.cornerRadius = iconRadius
        
        bgIconIV.frame.size = CGSize(width: iconIV.bounds.width * 2, height: iconIV.bounds.width * 2)
        bgIconIV.frame.origin = CGPoint(x: gimme.RevX(0, width: bgIconIV.frame.width) + gimme.Width(40, of: bgIconIV) , y: 0)
        
        
        bgIconIV.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/6))
        bgIconIV.layer.cornerRadius = iconRadius * 2
        
        actionBtn.frame = CGRect(x: gimme.RevX(0, width: btnWidth) - insets,
                                 y: gimme.RevY(0, height: 32) - insets,
                                 width: btnWidth,
                                 height: 32)
        actionBtn.layer.cornerRadius = actionBtn.layer.bounds.height/2
        actionBtn.removeFromSuperview()
        if showingDetail { detailSV.addSubview(actionBtn) }
        else { self.addSubview(actionBtn) }
        
    }
   
    //Actions
    override func cardTapped() {
        super.cardTapped()
        delegate?.cardDidTapInside?(card: self)
    }
    
    @objc func buttonTapped(){

        UIView.animate(withDuration: 0.2, animations: {
            self.actionBtn.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        }) { (true) in
            UIView.animate(withDuration: 0.1, animations: {
                self.actionBtn.transform = CGAffineTransform.identity
            })
        }
        delegate?.cardHighlightDidTapButton?(card: self, button: actionBtn)
    }
}

extension CardHighlight: CardDelegate {
    
    func cardIsShowingDetail(card: Card) { layout(backgroundIV.frame, animated: true, showingDetail: true) }
    func cardIsHidingDetail(card: Card) { layout(originalFrame, animated: true, showingDetail: false) }
    
}



