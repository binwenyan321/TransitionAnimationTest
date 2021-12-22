//
//  UINavigationController+AnimationPush.swift
//  TransitionAnimationTest
//
//  Created by yanwenbin on 2021/12/22.
//

import UIKit

extension UINavigationController {
    
    /// 转场动画
    func animationPushViewController(vc: UIViewController, animationType: WBVCAnimationType) {
        let animationDelegate: WBVCAnimationPushDelegate = WBVCAnimationPushDelegate()
        animationDelegate.navigation = self
        animationDelegate.navDelegate = self.delegate
        animationDelegate.animationType = animationType
        vc.animationDelegate = animationDelegate
        self.delegate = animationDelegate
        self.pushViewController(vc, animated: true)
    }
}
