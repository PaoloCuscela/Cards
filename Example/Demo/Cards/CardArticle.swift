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
    @IBInspectable var titleSize: CGFloat = 26
    @IBInspectable var subtitle: String = "Inside the extraordinary world of Monument Valley 2"
    @IBInspectable var subtitleSize: CGFloat = 17
    @IBInspectable var category: String = "world premiere"
    @IBInspectable var blurEffect: UIBlurEffectStyle = UIBlurEffectStyle.extraLight

    //Priv Vars
    internal var titleLbl = UILabel ()
    internal var subtitleLbl = UILabel()
    internal var categoryLbl = UILabel()
    
    
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
        backgroundIV.addSubview(titleLbl)
        backgroundIV.addSubview(subtitleLbl)
        backgroundIV.addSubview(categoryLbl)
    }
    
    
    override func draw(_ rect: CGRect) {
        
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
     
        self.layout(backgroundIV.frame)
        
    }
    
    override func cardTapped() {
        super.cardTapped()
        delegate?.cardDidTapInside?(card: self)
    }
    
    
    private func layout(_ rect: CGRect) {
        
        
        let gimme  = LayoutHelper(rect: rect)
        
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

extension CardArticle: CardDelegate {
    
    func cardDidShowDetailView(card: Card) { layout(backgroundIV.bounds) }
    func cardWillCloseDetailView(card: Card) { layout(originalFrame) }

}



