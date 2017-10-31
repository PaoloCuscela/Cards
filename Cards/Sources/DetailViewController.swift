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
    var card: Card! {
        didSet{
            scrollView.addSubview(card.backgroundIV)
        }
    }
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.snap = UIScreen.main.snapshotView(afterScreenUpdates: true)
        self.view.addSubview(blurView)
        self.view.addSubview(scrollView)
        if let detail = detailView {
            
            scrollView.addSubview(detail)
            detail.autoresizingMask = .flexibleWidth
            detail.alpha = 0
        }
        
        blurView.frame = self.view.bounds
        
        scrollView.layer.backgroundColor = detailView?.backgroundColor?.cgColor ?? UIColor.white.cgColor
        scrollView.layer.cornerRadius = 20
        
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.insertSubview(snap, belowSubview: blurView)
        originalFrame = scrollView.frame
        
        if let detail = detailView {
            
            detail.alpha = 1
            detail.frame = CGRect(x: 0,
                                  y: card.backgroundIV.bounds.maxY,
                                  width: scrollView.frame.width,
                                  height: detail.frame.height)
             
            scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: detail.frame.maxY)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        snap.removeFromSuperview()
    }
    
    
    //MARK: - Layout & Animations for the content ( rect = Scrollview + card + detail )
    
    func layout(_ rect: CGRect, isPresenting: Bool, isAnimating: Bool = true, transform: CGAffineTransform = CGAffineTransform.identity){
        
        guard isPresenting else {
            
            scrollView.frame = rect.applying(transform)
            card.backgroundIV.frame = scrollView.bounds
            card.layout(animating: isAnimating)
            return
        }
        
        scrollView.frame.size = CGSize(width: LayoutHelper.XScreen(85), height: LayoutHelper.YScreen(100) - 20)
        scrollView.center = blurView.center
        scrollView.frame.origin.y = 40
        scrollView.frame = scrollView.frame.applying(transform)
        
        card.backgroundIV.frame.origin = scrollView.bounds.origin
        card.backgroundIV.frame.size = CGSize( width: scrollView.bounds.width,
                                            height: card.backgroundIV.bounds.height)
        card.layout(animating: isAnimating)
    
    }
}


//MARK: - ScrollView Behaviour

extension DetailViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = scrollView.contentOffset.y
        let origin = originalFrame.origin.y
        let currentOrigin = originalFrame.origin.y
        
        if (y<0  || currentOrigin > origin) {
            scrollView.frame.origin.y -= y/2
            scrollView.contentOffset.y = 0
        }
        
        //card.delegate?.cardDetailIsScrolling?(card: card)
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


