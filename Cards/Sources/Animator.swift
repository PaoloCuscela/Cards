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
            card.log("ANIMATOR>> Begin dismiss transition.")
            card.isPresenting = false
            
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
            let originalFrame = card.originalFrame
            UIView.animate(withDuration: velocity/2, delay: 0, options: .curveEaseOut, animations: {
                
                detailVC.layout(originalFrame, isPresenting: false, transform: bounce)
                self.card.delegate?.cardIsHidingDetail?(card: self.card)
                
            }) { _ in UIView.animate(withDuration: self.velocity/2, delay: 0, options: .curveEaseOut, animations: {
                    
                detailVC.layout(originalFrame, isPresenting: false)
                self.card.delegate?.cardIsHidingDetail?(card: self.card)
                })
            }
            return

        }
        
        // Detail View Controller Present Animations
        card.log("ANIMATOR>> Begin present transition.")
        card.isPresenting = true
        
        let detailVC = to as! DetailViewController
        let bounceOffset = self.bounceTransform(card.originalFrame, to: card.backgroundIV.frame)
        container.bringSubview(toFront: detailVC.view)
        detailVC.card = card
        
        self.card.delegate?.cardIsShowingDetail?(card: self.card)
        
        // This code should actually be executed outside the animation but idk why this first animation is executed and skipped ( even with 'duration' setted up )
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseIn, animations: {
            // Setting detail VC in dismissed mode (VC frame = card frame)
            detailVC.layout(self.card.originalFrame, isPresenting: false)
            
        }, completion: { finished in UIView.animate(withDuration: self.velocity/2, delay: 0, options: .curveEaseIn, animations: {
                detailVC.blurView.alpha = 1
                detailVC.snap.alpha = 1
                detailVC.layout(detailVC.view.frame, isPresenting: true, transform: bounceOffset)
                
            }, completion: { (_) in UIView.animate(withDuration: self.velocity/2, delay: 0, options: .curveEaseIn, animations: {
                    detailVC.layout(detailVC.view.frame, isPresenting: true)
                    
                }, completion: { (_) in
                    detailVC.layout(detailVC.view.frame, isPresenting: true)
                    transitionContext.completeTransition(true)
                    
                })
            })
        })
        
        
    }
    
    private func bounceTransform(_ from: CGRect, to: CGRect ) -> CGAffineTransform {
        
        let old = from.center
        let new = to.center
        
        let xDistance = old.x - new.x
        let yDistance = old.y - new.y
        
        let xMove = -( xDistance * bounceIntensity )
        let yMove = -( yDistance * bounceIntensity )
        
        return CGAffineTransform(translationX: xMove, y: yMove)
    }

    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return velocity
    }
    
}


