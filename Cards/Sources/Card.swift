//
//  Card.swift
//  Cards
//
//  Created by Paolo on 09/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

@objc public protocol CardDelegate {
    
    @objc optional func cardDidTapInside(card: Card)
    @objc optional func cardWillShowDetailView(card: Card)
    @objc optional func cardDidShowDetailView(card: Card)
    @objc optional func cardWillCloseDetailView(card: Card)
    @objc optional func cardDidCloseDetailView(card: Card)
    @objc optional func cardIsShowingDetail(card: Card)
    @objc optional func cardIsHidingDetail(card: Card)
    
    @objc optional func cardDetailIsScrolling(card: Card)
    
    @objc optional func cardHighlightDidTapButton(card: CardHighlight, button: UIButton)
    @objc optional func cardPlayerDidPlay(card: CardPlayer)
    @objc optional func cardPlayerDidPause(card: CardPlayer)
}

@IBDesignable open class Card: UIView {

    @IBInspectable public var shadowBlur: CGFloat = 14
    @IBInspectable public var shadowOpacity: Float = 0.6
    @IBInspectable public var shadowColor: UIColor = UIColor.gray
    @IBInspectable public var backgroundImage: UIImage?
    @IBInspectable public var textColor: UIColor = UIColor.black
    @IBInspectable public var cardRadius: CGFloat = 20
    open var detailView: UIView?
    @IBInspectable public var contentInset: CGFloat = 6 {
        didSet {
            insets = LayoutHelper(rect: self.backgroundIV.bounds).X(contentInset)
        }
    }
    
    override open var backgroundColor: UIColor? {
        didSet(new) {
            if let color = new { self.layer.backgroundColor = color.cgColor }
            if backgroundColor != UIColor.clear { backgroundColor = UIColor.clear }
        }
    }
    
    override open var frame: CGRect {
        didSet{ layout() }
    }
    
    var delegate: CardDelegate?
    
    //Priv Vars
    fileprivate var isDetailPresented = false
    fileprivate var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight ))
    fileprivate var bounceIntensity = CGFloat()
    fileprivate var tap: UITapGestureRecognizer!
    var backgroundIV = UIImageView()
    var insets = CGFloat()
    var originalFrame = CGRect.zero
    var detailFrame = CGRect.zero
    var detailSV = UIScrollView()
    
    //MARK: - View Life Cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        
        // Tap gesture init
        tap = UITapGestureRecognizer(target: self, action: #selector(self.cardTapped))
        detailSV.addGestureRecognizer(tap)
        tap.delegate = self
        tap.cancelsTouchesInView = false
        
        // Adding Subviews
        self.addSubview(detailSV)
        detailSV.addSubview(backgroundIV)
        detailSV.delegate = self
        detailSV.alwaysBounceVertical = true
        detailSV.isUserInteractionEnabled = false
        detailSV.showsVerticalScrollIndicator = false
        detailSV.showsHorizontalScrollIndicator = false
        originalFrame = frame
        
    }
    
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = shadowBlur
        self.layer.cornerRadius = cardRadius
        self.contentInset = 6
        
        backgroundIV.image = backgroundImage
        backgroundIV.layer.cornerRadius = self.layer.cornerRadius
        backgroundIV.clipsToBounds = true
        backgroundIV.contentMode = .scaleAspectFill
        
        blurView.frame = UIScreen.main.bounds
        blurView.alpha = 0
        
        detailSV.frame = self.bounds
        backgroundIV.frame = detailSV.bounds
        
    }
    
    private func layout(_ animated: Bool = false, showingDetail: Bool = false){
        
        self.backgroundIV.frame.size = CGSize(width: self.frame.width, height: self.backgroundIV.frame.height)
        
        guard animated else { return }
        
        if showingDetail { self.frame.size = CGSize(width: LayoutHelper.XScreen(85), height: LayoutHelper.YScreen(100) - 20)

        } else {
             // Scale to full screen
            self.frame = self.originalFrame
        }
        detailSV.frame.size = self.frame.size
    }
    
    
    //Actions
    @objc  func cardTapped(){
        if !isDetailPresented {
            superview?.bringSubview(toFront: self)
            showDetailAnimated()
        }
    }

    @objc  func cardTapping(){
        if !isDetailPresented {
            pushBackAnimated()
        }
    }
    
    //MARK: - Setup Stuff
    private func prepareDetailView(){
        
        if detailView == nil {
            
            detailView = UIView(frame: CGRect(x: 0, y: backgroundIV.frame.maxY, width: self.bounds.width, height: 100))
            let testLbl = UILabel(frame: detailView!.bounds)
            testLbl.text = " No content to show."
            detailView?.addSubview(testLbl)
        }
        
        self.clipsToBounds = true
        detailSV.addSubview(detailView!)
        detailView?.autoresizingMask = UIViewAutoresizing.flexibleWidth
        detailSV.isUserInteractionEnabled = true
        detailSV.frame = self.bounds
        detailView!.frame = CGRect(x: 0, y: backgroundIV.bounds.maxY, width: self.bounds.width, height: detailView!.frame.height)
        detailSV.contentSize = CGSize(width: self.bounds.width, height: backgroundIV.bounds.height + detailView!.bounds.height)
        self.isDetailPresented = true
    }
    
    private func prepareToDiscardDetailView() {
        detailView?.removeFromSuperview()
        detailSV.contentSize = backgroundIV.frame.size
        detailSV.frame = backgroundIV.bounds
        detailSV.isUserInteractionEnabled = false
    }
}


//MARK: - ANIMATION things
extension Card {
    
    private func bounceTransform() -> CGAffineTransform {
        
        let absoluteCenter = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        let originalCenter = CGPoint(x: originalFrame.minX + originalFrame.width/2, y: originalFrame.minY + originalFrame.height/2)
        let theOneToMove = isDetailPresented ? absoluteCenter  : originalCenter
        let theOneToMoveTo = isDetailPresented ? originalCenter  : absoluteCenter
        
        let xMove = (theOneToMove.x < theOneToMoveTo.x ) ? LayoutHelper.XScreen(bounceIntensity) : -LayoutHelper.XScreen(bounceIntensity)
        let yMove = (theOneToMove.y < theOneToMoveTo.y ) ? LayoutHelper.YScreen(bounceIntensity) : -LayoutHelper.YScreen(bounceIntensity)
        
        return CGAffineTransform(translationX: xMove, y: yMove)
    }
    
    private func showDetailAnimated(){
        
        delegate?.cardWillShowDetailView?(card: self)
        superview?.insertSubview(blurView, belowSubview: self)
        self.bounceIntensity = 4
        
        // SCALE
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
            self.blurView.alpha = 1
            self.transform = CGAffineTransform.identity       //Rescale to 100% after tapDownInside
            self.layer.shadowOpacity = 0
            self.layout(true, showingDetail: true)
            self.delegate?.cardIsShowingDetail?(card: self)
        }){ (true) in
            self.prepareDetailView()
            self.delegate?.cardDidShowDetailView?(card: self)
            self.detailFrame = self.frame
        }
        
        // BOUNCE
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
            
            self.center = UIApplication.shared.keyWindow?.center ?? self.superview!.center  // Center the view
            self.center.y += 40
            self.transform = self.bounceTransform()
            
        }) { (true) in UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                            
            self.transform = CGAffineTransform.identity
            })
        }
    }
    
    private func hideDetailAnimated(velocity: Double = 0.4){
        
        self.prepareToDiscardDetailView()
        delegate?.cardWillCloseDetailView?(card: self)
        
        // SCALE
        UIView.animate(withDuration: velocity, delay: 0, options: .curveEaseOut, animations: {
            self.blurView.alpha = 0
            self.layer.shadowOpacity = 1
            self.layout(true, showingDetail: false)
            self.delegate?.cardIsHidingDetail?(card: self)
            
        }) { (true) in
            
            self.blurView.removeFromSuperview()
            self.clipsToBounds = false
            self.delegate?.cardDidCloseDetailView?(card: self)
            self.isDetailPresented = false
        }
        
        // BOUNCE
        UIView.animate(withDuration: velocity, delay: 0, options: .curveEaseOut, animations: {
            
            self.transform = self.bounceTransform()
            
        }) { (true) in UIView.animate(withDuration: velocity, delay: 0, options: .curveEaseOut, animations: {
            
            self.transform = CGAffineTransform.identity
            
            })
        }
    }
    
    private func pushBackAnimated() {
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95) })
    }
    
}


//MARK: - DELEGATE Stuff
extension Card: UIGestureRecognizerDelegate {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cardTapping()
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cardTapped()
    }
}

extension Card: UIScrollViewDelegate {

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard isDetailPresented else { return }
        
        let y = scrollView.contentOffset.y
        let origin = self.detailFrame.origin.y
        let currentOrigin = self.frame.origin.y

        if (y<0  || currentOrigin > origin) {
            self.frame.origin.y -= y/2
            scrollView.contentOffset.y = 0
        }
        
        delegate?.cardDetailIsScrolling?(card: self)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard isDetailPresented else { return }
        
        let origin = self.detailFrame.origin.y
        let currentOrigin = self.frame.origin.y
        let max = 4.0
        let min = 2.0
        var speed = Double(-velocity.y)
        
        if speed > max { speed = max }
        if speed < min { speed = min }
        
        self.bounceIntensity = CGFloat(speed-1)
        speed = (max/speed*min)/10
        
        guard (currentOrigin - origin) < 60 else { hideDetailAnimated(velocity: speed); return }
        UIView.animate(withDuration: speed) { self.frame.origin.y = self.detailFrame.origin.y }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        UIView.animate(withDuration: 0.1) { self.frame.origin.y = self.detailFrame.origin.y }
    }
    
}

// Label Helpers
extension UILabel {
    
    func lineHeight(_ height: CGFloat) {
        
        let attributedString = NSMutableAttributedString(string: self.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = height
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
}
