//
//  DetailViewController.swift
//  Cards
//
//  Created by Paolo Cuscela on 23/10/17.
//

import UIKit

internal class DetailViewController: UIViewController {
    
    var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight ))
    var detailView: UIView?
    var scrollView = UIScrollView()
    var originalFrame = CGRect.zero
    var snap = UIView()
    var card: Card!
    var delegate: CardDelegate?
    var isFullscreen = false
    
    fileprivate var xButton = XButton()
    
    override var prefersStatusBarHidden: Bool {
        if isFullscreen { return true }
        else { return false }
    }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } 

        self.snap = UIScreen.main.snapshotView(afterScreenUpdates: true)
        self.view.addSubview(blurView)
        self.view.addSubview(scrollView)
        
        if let detail = detailView {
            
            scrollView.addSubview(detail)
            detail.alpha = 0
            detail.autoresizingMask = .flexibleWidth
        }
        
        blurView.frame = self.view.bounds
        
        scrollView.layer.backgroundColor = detailView?.backgroundColor?.cgColor ?? UIColor.white.cgColor
        scrollView.layer.cornerRadius = isFullscreen ? 0 :  20
        
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        xButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissVC)))
        xButton.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        scrollView.addSubview(card.backgroundIV)
        self.delegate?.cardWillShowDetailView?(card: self.card)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        originalFrame = scrollView.frame
        
        if isFullscreen {
            view.addSubview(xButton)
        }
        
        view.insertSubview(snap, belowSubview: blurView)
        
        if let detail = detailView {
            
            detail.alpha = 1
            detail.frame = CGRect(x: 0,
                                  y: card.backgroundIV.bounds.maxY,
                                  width: scrollView.frame.width,
                                  height: detail.frame.height)
             
            scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: detail.frame.maxY)
            
            
            xButton.frame = CGRect (x: scrollView.frame.maxX - 20 - 40,
                                    y: scrollView.frame.minY + 20,
                                    width: 40,
                                    height: 40)
            
           

        }
        
        self.delegate?.cardDidShowDetailView?(card: self.card)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.cardWillCloseDetailView?(card: self.card)
        detailView?.alpha = 0
        snap.removeFromSuperview()
        xButton.removeFromSuperview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.delegate?.cardDidCloseDetailView?(card: self.card)
    }
    
    
    //MARK: - Layout & Animations for the content ( rect = Scrollview + card + detail )
    
    func layout(_ rect: CGRect, isPresenting: Bool, isAnimating: Bool = true, transform: CGAffineTransform = CGAffineTransform.identity){
        
        guard isPresenting else {
            
            scrollView.frame = rect.applying(transform)
            card.backgroundIV.frame = scrollView.bounds
            card.layout(animating: isAnimating)
            return
        }
        
        if isFullscreen {
           
            scrollView.frame = view.bounds
            scrollView.frame.origin.y = 0
            print(scrollView.frame)
            
        } else {
            scrollView.frame.size = CGSize(width: LayoutHelper.XScreen(85), height: LayoutHelper.YScreen(100) - 20)
            scrollView.center = blurView.center
            scrollView.frame.origin.y = 40
        }
        
        scrollView.frame = scrollView.frame.applying(transform)
        
        card.backgroundIV.frame.origin = scrollView.bounds.origin
        card.backgroundIV.frame.size = CGSize( width: scrollView.bounds.width,
                                            height: card.backgroundIV.bounds.height)
        card.layout(animating: isAnimating)
    
    }
    
    
    //MARK: - Actions
    
    @objc func dismissVC(){
        scrollView.contentOffset.y = 0
        dismiss(animated: true, completion: nil)
    }
}


//MARK: - ScrollView Behaviour

extension DetailViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = scrollView.contentOffset.y
        let origin = originalFrame.origin.y
        let currentOrigin = originalFrame.origin.y
        
        xButton.alpha = y - (card.backgroundIV.bounds.height * 0.6)
        
        if (y<0  || currentOrigin > origin) {
            scrollView.frame.origin.y -= y/2
            
            scrollView.contentOffset.y = 0
        }
        
        card.delegate?.cardDetailIsScrolling?(card: card)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let origin = originalFrame.origin.y
        let currentOrigin = scrollView.frame.origin.y
        let max = 4.0
        let min = 2.0
        var speed = Double(-velocity.y)
        
        if speed > max { speed = max }
        if speed < min { speed = min }
        
        //self.bounceIntensity = CGFloat(speed-1)
        speed = (max/speed*min)/10
        
        guard (currentOrigin - origin) < 60 else { dismiss(animated: true, completion: nil); return }
        UIView.animate(withDuration: speed) { scrollView.frame.origin.y = self.originalFrame.origin.y }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        UIView.animate(withDuration: 0.1) { scrollView.frame.origin.y = self.originalFrame.origin.y }
    }
    
}

class XButton: UIButton {
    
    private let circle = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override var frame: CGRect {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(circle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let xPath = UIBezierPath()
        let xLayer = CAShapeLayer()
        let inset = rect.width * 0.3
        
        xPath.move(to: CGPoint(x: inset, y: inset))
        xPath.addLine(to: CGPoint(x: rect.maxX - inset, y: rect.maxY - inset))
        
        xPath.move(to: CGPoint(x: rect.maxX - inset, y: inset))
        xPath.addLine(to: CGPoint(x: inset, y: rect.maxY - inset))
    
        xLayer.path = xPath.cgPath
        
        xLayer.strokeColor = UIColor.white.cgColor
        xLayer.lineWidth = 2.0
        self.layer.addSublayer(xLayer)
    
        circle.frame = rect
        circle.layer.cornerRadius = circle.bounds.width / 2
        circle.clipsToBounds = true
        circle.isUserInteractionEnabled = false
        
        
    }
    
    
}










