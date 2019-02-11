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
    //var movingImage: (() -> Void)?
}

extension AnimationToGistAuthorsVC: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        //let fromView = transitionContext.view(forKey: .from)!
        
        containerView.addSubview(toView)
        //containerView.addSubview(fromView)
        
        //movingImage!()
        toView.alpha = 0.0
        UIView.animate(withDuration: self.duration / 2,
                       animations: {
                        toView.alpha = 1.0
        },
                       completion: { _ in
                        transitionContext.completeTransition(true)
        }
        )
        
    }
}
