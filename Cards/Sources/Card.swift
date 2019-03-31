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
    /**
     Color for the card's labels.
     */
    @IBInspectable public var textColor: UIColor = UIColor.black
    /**
     Amount of blur for the card's shadow.
     */
    @IBInspectable public var shadowBlur: CGFloat = 14 {
        didSet{
            self.layer.shadowRadius = shadowBlur
        }
    }
    /**
     Alpha of the card's shadow.
     */
    @IBInspectable public var shadowOpacity: Float = 0.6 {
        didSet{
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    /**
     Color of the card's shadow.
     */
    @IBInspectable public var shadowColor: UIColor = UIColor.gray {
        didSet{
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    /**
     The image to display in the background.
     */
    @IBInspectable public var backgroundImage: UIImage? {
        didSet{
            self.backgroundIV.image = backgroundImage
        }
    }
    /**
     Corner radius of the card.
     */
    @IBInspectable public var cardRadius: CGFloat = 20{
        didSet{
            self.layer.cornerRadius = cardRadius
        }
    }
    /**
     Insets between card's content and edges ( in percentage )
     */
    @IBInspectable public var contentInset: CGFloat = 6 {
        didSet {
            insets = LayoutHelper(rect: frame).X(contentInset)
        }
    }
    /**
     Color of the card's background.
     */
    override open var backgroundColor: UIColor? {
        didSet(new) {
            if let color = new { backgroundIV.backgroundColor = color }
            if backgroundColor != UIColor.clear { backgroundColor = UIColor.clear }
        }
    }
    /**
     contentViewController  -> The view controller to present when the card is tapped
     from                   -> Your current ViewController (self)
     */
    public func shouldPresent( _ contentViewController: UIViewController?, from superVC: UIViewController?, fullscreen: Bool = false) {
        if detailVC.children.count > 0{
            let viewControllers:[UIViewController] = detailVC.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        detailVC.isViewAdded = false
        if let content = contentViewController{
            self.superVC = superVC
            detailVC.addChild(content)
            detailVC.detailView = content.view
            detailVC.card = self
            detailVC.delegate = self.delegate
            detailVC.isFullscreen = fullscreen
        }
    }
    /**
     If the card should display parallax effect.
     */
    public var hasParallax: Bool = true {
        didSet {
            if self.motionEffects.isEmpty && hasParallax { goParallax() }
            else if !hasParallax && !motionEffects.isEmpty { motionEffects.removeAll() }
        }
    }
    /**
     If the card should print debug logs.
     */
    public var isDebug: Bool = false
    /**
     Delegate for the card. Should extend your VC with CardDelegate.
     */
    public var delegate: CardDelegate?
    
    //Private Vars
    fileprivate var tap = UITapGestureRecognizer()
    var detailVC = DetailViewController()
    weak var superVC: UIViewController?
    var originalFrame = CGRect.zero
    public var backgroundIV = UIImageView()
    public var insets = CGFloat()
    var isPresenting = false
    
    //MARK: - View Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    open func initialize() {
        log("CARD: Initializing Card")
        
        // Tap gesture init
        self.addGestureRecognizer(tap)
        tap.delegate = self
        tap.cancelsTouchesInView = false
       
        detailVC.transitioningDelegate = self
        
        // Adding Subviews
        self.addSubview(backgroundIV)
        
        backgroundIV.isUserInteractionEnabled = true
        
        if backgroundIV.backgroundColor == nil {
            backgroundIV.backgroundColor = UIColor.white
            super.backgroundColor = UIColor.clear
        }
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
        
        backgroundIV.frame.origin = bounds.origin
        backgroundIV.frame.size = CGSize(width: bounds.width, height: bounds.height)
        contentInset = 6
    }
    
    /**
     Opens the card if detail view is set.
     */
    open func open(){
        if let superview = self.superview {
            originalFrame = superview.convert(self.frame, to: nil)
            log("CARD: open() called, setting original frame to ---> \(originalFrame)" )
        }
        shrinkAnimated()
        self.cardTapped()
    }
    
    //MARK: - Layout
    
    open func layout(animating: Bool = true){ }
    
    
    //MARK: - Actions
    
    @objc func cardTapped() {
        self.delegate?.cardDidTapInside?(card: self)
        resetAnimated()
        
        if let vc = superVC {
            log("CARD: Card tapped, Presenting DetailViewController")
            vc.present(self.detailVC, animated: true, completion: nil)
        }
    }

    
    //MARK: - Animations
    
    private func shrinkAnimated() {
        
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95) })
    }
    
    private func resetAnimated() {
        
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform.identity })
    }
    
    func goParallax() {
        let amount = 20
        
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
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetAnimated()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let superview = self.superview {
            originalFrame = superview.convert(self.frame, to: nil)
            log("CARD: Card's touch began, setting original frame to ---> \(originalFrame)" )
        }
        shrinkAnimated()
    }
}


	//MARK: - Helpers

extension Card {
    
    public func log(_ message: String){
        if self.isDebug { print(message) }
    }
    
}

extension UILabel {
    
    func lineHeight(_ height: CGFloat) {
        
        let attributedString = NSMutableAttributedString(string: self.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = height
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
}
