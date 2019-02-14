//
//  AnimationToGistAuthorsVC.swift
//  Github Gists Editor
//
//  Created by Serhii on 2/9/19.
//  Copyright © 2019 Serhii. All rights reserved.
//

import UIKit

class AnimationToGistAuthorsVC: NSObject {
    
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    var startingFrame = CGRect.zero
}

extension AnimationToGistAuthorsVC: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if presenting {
            presentingAnimation(transitionContext: transitionContext)
        } else {
            dismissingAnimation(transitionContext: transitionContext)
        }
    }
    
    func presentingAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView   = transitionContext.viewController(forKey: .to) as? AccountInfoViewController else { return }
        containerView.addSubview(toView.view)
        
        let endFrame = toView.avatarImage.frame
        //toView.avatarImage.frame = startingFrame
        toView.avatarImage.layer.cornerRadius = 10
        toView.avatarImage.layer.add(addKeyFrameAnimation(startingFrame: startingFrame,
                                                          endFrame: endFrame,
                                                          isBackwards: false), forKey: "animation")
        
        toView.view.alpha = 0.0
        UIView.animate(withDuration: duration, animations: {
            toView.view.alpha = 1.0
            //toView.avatarImage.frame = endFrame
            toView.avatarImage.layer.borderWidth = 1
            toView.avatarImage.layer.masksToBounds = false
            toView.avatarImage.layer.borderColor = UIColor.black.cgColor
            toView.avatarImage.layer.cornerRadius = toView.avatarImage.frame.height/2
            toView.avatarImage.clipsToBounds = true
        }, completion: { (_) in
            transitionContext.completeTransition(true)
        })

    }
    
    func dismissingAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.viewController(forKey: .from) as? AccountInfoViewController else { return }
        containerView.addSubview(fromView.view)
        
        guard let toView = transitionContext.viewController(forKey: .to) as? UITabBarController else { return }
        containerView.addSubview(toView.view)
        
        let startFrame = startingFrame
        let endFrame = fromView.avatarImage.frame
        //toView.avatarImage.frame = startingFrame
        fromView.avatarImage.layer.add(addKeyFrameAnimation(startingFrame: startFrame,
                                                          endFrame: endFrame,
                                                          isBackwards: true), forKey: "animation")
        
        toView.view.alpha = 0.0
        
        UIView.animate(withDuration: duration, animations: {
            toView.view.alpha = 1.0
            
            fromView.avatarImage.layer.cornerRadius = 10
        }, completion: { (_) in
            transitionContext.completeTransition(true)
        })
    }
    
    func addKeyFrameAnimation(startingFrame: CGRect, endFrame: CGRect, isBackwards: Bool) -> CAKeyframeAnimation {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
        let mutablePath = CGMutablePath()
        
        if isBackwards {
            mutablePath.move(to: CGPoint(x: endFrame.midX, y: endFrame.midY))
            mutablePath.addQuadCurve(to: CGPoint(x: startingFrame.midX,
                                                 y: startingFrame.midY),
                                     control: CGPoint(x: 30, y: 50))
        } else {
            mutablePath.move(to: CGPoint(x: startingFrame.maxX, y: startingFrame.maxY))
            mutablePath.addQuadCurve(to: CGPoint(x: endFrame.midX,
                                                 y: endFrame.midY + 20),
                                     control: CGPoint(x: 30, y: 50))
        }
        
        keyFrameAnimation.path = mutablePath
        keyFrameAnimation.duration = duration
        keyFrameAnimation.fillMode = CAMediaTimingFillMode.forwards
        keyFrameAnimation.isRemovedOnCompletion = false
        return keyFrameAnimation
    }
}
