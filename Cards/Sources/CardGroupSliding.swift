//
//  CardGroupSliding.swift
//  Cards
//
//  Created by Paolo on 08/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//
import Foundation
import UIKit

@IBDesignable open class CardGroupSliding: CardGroup {

    @IBInspectable public var iconsSize: CGFloat = 80
    @IBInspectable public var iconsRadius: CGFloat = 40
    
    public var icons: [UIImage]?
    
    // Priv vars
    fileprivate final let CellID = "SlidingCVCell"
    fileprivate var slidingCV: UICollectionView!
    fileprivate var timer = Timer()
    fileprivate var w: CGFloat = 0
    fileprivate var layout = UICollectionViewFlowLayout()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override  func initialize() {
        super.initialize()
        
        self.delegate = self
        
        layout.scrollDirection = .horizontal
        slidingCV = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        slidingCV.register(SlidingCVCell.self, forCellWithReuseIdentifier: CellID)
        slidingCV.delegate = self
        slidingCV.dataSource = self
        slidingCV.backgroundColor = UIColor.clear
        slidingCV.isUserInteractionEnabled = false
        
        backgroundIV.addSubview(subtitleLbl)
        backgroundIV.addSubview(titleLbl)
        backgroundIV.addSubview(slidingCV)
        blurV.removeFromSuperview()
        
        backgroundIV.backgroundColor = UIColor.white
    }
    
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        slidingCV.reloadData()
        startSlide()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        subtitleLbl.textColor = textColor.withAlphaComponent(0.4)
        layout(backgroundIV.bounds)
    }
    
    private func layout(_ rect: CGRect, animated: Bool = false, showingDetail: Bool = false) {
        
        let gimme = LayoutHelper(rect: rect)
        
        slidingCV.frame = CGRect(x: 0,
                                 y: gimme.Y(5, from: titleLbl),
                                 width: backgroundIV.frame.width,
                                 height: rect.height - blurV.frame.height - insets )
    }
    
    override public func cardIsShowingDetail(card: Card) {
        super.cardIsShowingDetail(card: card)
        self.layout(backgroundIV.bounds, animated: true, showingDetail: true)
    }

    public func cardDidCloseDetailView(card: Card) {
        self.layout(backgroundIV.bounds, animated: true, showingDetail: false)
    }
    
    
    //Sliding Logic
    
    public func startSlide() {
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(self.slide), userInfo: nil, repeats: true)
    }

    public func stopSlide() {
        timer.invalidate()
    }
    
    private func onTimer(){ slide() }
    
    @objc private func slide(){
        let startPoint = CGPoint(x: w, y: 0)
        if __CGPointEqualToPoint(startPoint, slidingCV.contentOffset) {
            
            if w<slidingCV.contentSize.width { w+=0.3 }
            else { w = -self.frame.size.width }
            
            slidingCV.contentOffset = CGPoint(x: w, y: 0)
        } else {
            w = slidingCV.contentOffset.x
        }
    }
}


//MARK: - Collection View Delegates

extension CardGroupSliding: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if icons?.count != nil { return 10000 }
        else { return 0 }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let icon = icons?[indexPath.row % icons!.count]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as! SlidingCVCell
        cell.radius = cell.frame.height/2
        cell.icon = icon
        return cell
        
    }
    
}

extension CardGroupSliding: UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        iconsSize = collectionView.bounds.height/3 - layout.minimumLineSpacing
        return CGSize(width: iconsSize, height: iconsSize )
    }
}


open class SlidingCVCell: UICollectionViewCell {
    
    public var icon = UIImage(named: "math")
    public var iconIV = UIImageView()
    public var radius: CGFloat?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(iconIV)
        self.backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.cornerRadius = radius ?? 15
        iconIV.image = icon
        iconIV.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.width)
        iconIV.layer.cornerRadius = radius ?? 15
        iconIV.clipsToBounds = true
        iconIV.contentMode = .scaleAspectFill
    }
}













