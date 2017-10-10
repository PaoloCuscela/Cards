//
//  CardGroupSliding.swift
//  Cards
//
//  Created by Paolo on 08/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//
import Foundation
import UIKit

@IBDesignable class CardGroupSliding: CardGroup {

    @IBInspectable var iconsSize: CGFloat = 80
    @IBInspectable var iconsRadius: CGFloat = 40
    
    var icons: [UIImage]?
    
    final let CellID = "SlidingCVCell"
    var slidingCV: UICollectionView!
    var timer = Timer()
    var w: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        slidingCV = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        slidingCV.register(SlidingCVCell.self, forCellWithReuseIdentifier: CellID)
        slidingCV.delegate = self
        slidingCV.dataSource = self
        slidingCV.backgroundColor = UIColor.clear
        slidingCV.isUserInteractionEnabled = false
        
        backgroundIV.addSubview(titleLbl)
        backgroundIV.addSubview(subtitleLbl)
        backgroundIV.addSubview(slidingCV)
        blurV.removeFromSuperview()
        
        backgroundIV.backgroundColor = UIColor.white
    }
    
    override func draw(_ rect: CGRect) {
        
        // Helpers func
        func X(_ percentage: CGFloat ) -> CGFloat { return percentage*rect.width/100 }
        func Y(_ percentage: CGFloat ) -> CGFloat { return percentage*rect.height/100 }
        func X(_ percentage: CGFloat, from: UIView ) -> CGFloat { return percentage*rect.width/100 + from.frame.maxX }
        func Y(_ percentage: CGFloat, from: UIView ) -> CGFloat { return percentage*rect.height/100 + from.frame.maxY }
        func RevX(_ percentage: CGFloat, width: CGFloat ) -> CGFloat { return (rect.width - percentage*rect.width/100) - width }
        func RevY(_ percentage: CGFloat, height: CGFloat) -> CGFloat { return (rect.height - percentage*rect.height/100) - height }
        super.draw(rect)
        
        //subtitleLbl.frame = CGRect(x: X(insets), y: Y(1, from: titleLbl), width: X(100 - (2 * insets)), height: Y(10))
        titleLbl.textColor = textColor.withAlphaComponent(0.3)
        
        slidingCV.frame = CGRect(x: 0, y: Y(8, from: subtitleLbl), width: rect.width, height: Y(65))
        
    }
    
    override func didMoveToWindow() {
        
        slidingCV.reloadData()
        startSlide()
        
    }
    
    
    
    //Sliding Logic
    
    func startSlide() { timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(self.slide), userInfo: nil, repeats: true) }
    func stopSlide() { timer.invalidate() }
    
    func onTimer(){ slide() }
    
    
    @objc func slide(){
        
        let startPoint = CGPoint(x: w, y: 0)
        if __CGPointEqualToPoint(startPoint, slidingCV.contentOffset) {
            
            if w<slidingCV.contentSize.width { w+=0.3 }
            else { w = -self.frame.size.width }
            
            slidingCV.contentOffset = CGPoint(x: w, y: 0)
        }
        else { w = slidingCV.contentOffset.x }
        
    }
    
    
}

class SlidingCVCell: UICollectionViewCell {
    
    var icon = UIImage(named: "math")
    var iconIV = UIImageView()
    var radius: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(iconIV)
        self.backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.cornerRadius = radius ?? 15
        iconIV.image = icon
        iconIV.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.width)
        iconIV.layer.cornerRadius = radius ?? 15
        iconIV.clipsToBounds = true
        iconIV.contentMode = .scaleAspectFill
        
    }
}

extension CardGroupSliding: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if icons?.count != nil { return 100 }
        else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    
        let icon = icons?[indexPath.row % icons!.count]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as! SlidingCVCell
        cell.radius = iconsRadius
        cell.icon = icon
        return cell
        
    }
    
}

extension CardGroupSliding: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { return CGSize(width: iconsSize, height: iconsSize ) }
    
}

extension CardGroupSliding: UICollectionViewDelegate {
    

}











