//
//  Card.swift
//  Cards
//
//  Created by Paolo on 09/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

//TODO: - Risolvere il problema del layout dopo l' animazione passando il backgroundIV al detailVC
//TODO: - Trovare il frame originario relativo alla view del VC della card ( in una table )

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

@IBDesignable open class Card: UIView, CardDelegate {

    // Storyboard Inspectable vars
    @IBInspectable public var shadowBlur: CGFloat = 14
    @IBInspectable public var shadowOpacity: Float = 0.6
    @IBInspectable public var shadowColor: UIColor = UIColor.gray
    @IBInspectable public var backgroundImage: UIImage?
    @IBInspectable public var textColor: UIColor = UIColor.black
    @IBInspectable public var cardRadius: CGFloat = 20
    @IBInspectable public var contentInset: CGFloat = 6 {
        didSet {
            insets = LayoutHelper(rect: originalFrame).X(contentInset)
        }
    }
    
    override open var backgroundColor: UIColor? {
        didSet(new) {
            if let color = new { backgroundIV.backgroundColor = color }
            if backgroundColor != UIColor.clear { backgroundColor = UIColor.clear }
        }
    }
    
    /**
     detailView -> The view to show after presenting detail; from -> Your current ViewController (self)
     */
    public func shouldPresent( _ detailView: UIView? = nil, from superVC: UIViewController? = nil) {
        self.superVC = superVC
        self.detailView = detailView
    }
    
    public var hasParallax: Bool = true {
        didSet {
            if self.motionEffects.isEmpty && hasParallax { goParallax() }
            else if !hasParallax && !motionEffects.isEmpty { motionEffects.removeAll() }
        }
    }
    
    var delegate: CardDelegate?
    
    //Private Vars
    fileprivate var tap: UITapGestureRecognizer!
    fileprivate var detailVC: DetailViewController!
    fileprivate var detailView: UIView?
    var superVC: UIViewController?
    var originalFrame = CGRect.zero
    var backgroundIV = UIImageView()
    var insets = CGFloat()
    
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
        tap = UITapGestureRecognizer()
        self.addGestureRecognizer(tap)
        tap.delegate = self
        tap.cancelsTouchesInView = false
       
        detailVC = DetailViewController()
        detailVC.detailView = self.detailView
        detailVC.transitioningDelegate = self
        
        // Adding Subviews
        self.addSubview(backgroundIV)
        
        delegate = self
        backgroundIV.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.white
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = shadowBlur
        self.layer.cornerRadius = cardRadius
        
        backgroundIV.image = backgroundImage
        backgroundIV.layer.cornerRadius = self.layer.cornerRadius
        backgroundIV.clipsToBounds = true
        backgroundIV.contentMode = .scaleAspectFill
        
        layout(rect)
        
        originalFrame = rect
        contentInset = 6
    }
    
    
    //MARK: - Layout
    
    func layout(_ rect: CGRect){
        
        backgroundIV.frame.origin = rect.origin
        backgroundIV.frame.size = CGSize(width: rect.width, height: rect.height)
    }
    
    
    //MARK: - Actions
    
    @objc  func cardTapped(){
        
        guard superVC != nil else { resetAnimated { }; return }
        detailVC.detailView = detailView
        self.superVC?.present(self.detailVC, animated: true, completion: nil)
    }

    
    //MARK: - Animations
    
    private func pushBackAnimated() {
        
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95) })
    }
    
    private func resetAnimated(_ completion: @escaping () -> ()) {
        
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform.identity }) { _ in
            self.delegate?.cardDidTapInside?(card: self)
            completion()
        }
    }
    
    func goParallax() {
        let amount = 10
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        self.addMotionEffect(group)
    }
    
}


    //MARK: - Transition Delegate

extension Card: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(presenting: true, from: self)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(presenting: false, from: self)
    }
    
}

    //MARK: - Gesture Delegate

extension Card: UIGestureRecognizerDelegate {
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cardTapped()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let superview = self.superview {
            originalFrame = superview.convert(self.frame, to: nil)
        }
        pushBackAnimated()
    }
}


	//MARK: - Helpers

extension UILabel {
    
    func lineHeight(_ height: CGFloat) {
        
        let attributedString = NSMutableAttributedString(string: self.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = height
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
}
