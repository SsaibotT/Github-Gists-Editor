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
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.viewController(forKey: .to) as? AccountInfo else { return }
        
        let endFrame = toView.avatarImage.frame
        containerView.addSubview(toView.view)
        toView.avatarImage.frame = startingFrame
        toView.avatarImage.layer.cornerRadius = 10
        //containerView.addSubview(fromView)
        
        toView.view.alpha = 0.0
        UIView.animate(withDuration: self.duration,
                       animations: {
                        toView.view.alpha = 1.0
                        toView.avatarImage.frame = endFrame
                        toView.avatarImage.layer.borderWidth = 1
                        toView.avatarImage.layer.masksToBounds = false
                        toView.avatarImage.layer.borderColor = UIColor.black.cgColor
                        toView.avatarImage.layer.cornerRadius = toView.avatarImage.frame.height/2
                        toView.avatarImage.clipsToBounds = true
        },
                       completion: { _ in
                        transitionContext.completeTransition(true)
        }
        )
        
    }
}
