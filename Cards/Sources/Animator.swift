//
//  Animator.swift
//  Cards
//
//  Created by Paolo Cuscela on 23/10/17.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {

    
    fileprivate var presenting: Bool
    fileprivate var velocity = 0.6
    var bounceIntensity: CGFloat = 0.07
    var card: Card
    
    init(presenting: Bool, from card: Card) {
        self.presenting = presenting
        self.card = card
        super.init()
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // Animation Context Setup
        let container = transitionContext.containerView
        let to = transitionContext.viewController(forKey: .to)!
        let from = transitionContext.viewController(forKey: .from)!
        container.addSubview(to.view)
        container.addSubview(from.view)
        
        
        guard presenting else {
            
            // Detail View Controller Dismiss Animations
            card.isPresenting = false
            
            let superVC = to
            let detailVC = from as! DetailViewController
            let cardBackgroundFrame = detailVC.scrollView.convert(card.backgroundIV.frame, to: nil)
            let bounce = self.bounceTransform(cardBackgroundFrame, to: card.originalFrame)
            
            // Blur and fade with completion
            UIView.animate(withDuration: velocity, delay: 0, options: .curveEaseOut, animations: {
                
                detailVC.blurView.alpha = 0
                detailVC.snap.alpha = 0
                self.card.backgroundIV.layer.cornerRadius = self.card.cardRadius
                
            }, completion: { _ in
                
                detailVC.layout(self.card.originalFrame, isPresenting: false, isAnimating: false)
                self.card.addSubview(detailVC.card.backgroundIV)
                transitionContext.completeTransition(true)
            })
            
            // Layout with bounce effect
            UIView.animate(withDuration: velocity/2, delay: 0, options: .curveEaseOut, animations: {
                
                detailVC.layout(self.card.originalFrame, isPresenting: false, transform: bounce)
                self.card.delegate?.cardIsHidingDetail?(card: self.card)
                
            }) { _ in UIView.animate(withDuration: self.velocity/2, delay: 0, options: .curveEaseOut, animations: {
                    
                detailVC.layout(self.card.originalFrame, isPresenting: false)
                self.card.delegate?.cardIsHidingDetail?(card: self.card)
                })
            }
            return

        }
        
        // Detail View Controller Present Animations
        card.isPresenting = true
        
        let detailVC = to as! DetailViewController
        let bounce = self.bounceTransform(card.originalFrame, to: card.backgroundIV.frame)
        
        container.bringSubview(toFront: detailVC.view)
        detailVC.card = card
        detailVC.layout(card.originalFrame, isPresenting: false)
        
        // Blur and fade with completion
        UIView.animate(withDuration: velocity, delay: 0, options: .curveEaseOut, animations: {
            
            self.card.transform = CGAffineTransform.identity    // Reset card identity after push back on tap
            detailVC.blurView.alpha = 1
            detailVC.snap.alpha = 1
            self.card.backgroundIV.layer.cornerRadius = 0
            
        }, completion: { _ in
            
            detailVC.layout(self.card.originalFrame, isPresenting: true, isAnimating: false, transform: .identity)
            transitionContext.completeTransition(true)
        })
        
        // Layout with bounce effect
        UIView.animate(withDuration: velocity/2, delay: 0, options: .curveEaseOut, animations: {
            
            detailVC.layout(detailVC.view.frame, isPresenting: true, transform: bounce)
            self.card.delegate?.cardIsShowingDetail?(card: self.card)
            
        }) { _ in UIView.animate(withDuration: self.velocity/2, delay: 0, options: .curveEaseOut, animations: {
                
            detailVC.layout(detailVC.view.frame, isPresenting: true)
            self.card.delegate?.cardIsShowingDetail?(card: self.card)
                
            })
        }
        
    }
    
    private func bounceTransform(_ from: CGRect, to: CGRect ) -> CGAffineTransform {
        
        let old = from.center
        let new = to.center
        
        let xDistance = old.x - new.x
        let yDistance = old.y - new.y
        
        let xMove = -( xDistance * bounceIntensity )
        let yMove = -( yDistance * bounceIntensity )
        
        //let xMove = (old.x < new.x ) ? LayoutHelper.XScreen(bounceIntensity) : -LayoutHelper.XScreen(bounceIntensity)
        //let yMove = (old.y < new.y ) ? LayoutHelper.YScreen(bounceIntensity) : -LayoutHelper.YScreen(bounceIntensity)
        
        return CGAffineTransform(translationX: xMove, y: yMove)
    }

    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return velocity
    }
    
}


