//
//  WBVCAnimationPushDelegate.swift
//  TransitionAnimationTest
//
//  Created by yanwenbin on 2021/12/22.
//

import UIKit

enum WBVCAnimationType: Int {
    /// 移动
    case move
    /// 开关门
    case openOrCloseDoor
}

class WBVCAnimationPushDelegate: NSObject, UINavigationControllerDelegate {

    // MARK: - Public Property
    /// 原本的代理
    var navDelegate: UINavigationControllerDelegate?
    
    /// 原本的navigationController
    var navigation: UINavigationController?
    
    /// 动画方式
    var animationType: WBVCAnimationType = .move
    
    deinit {
        self.navigation?.delegate = self.navDelegate
    }
}

extension WBVCAnimationPushDelegate {
    /// 响应转场动画
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var transitionAnimation: UIViewControllerAnimatedTransitioning?
        if operation == .push {
            guard let _ = toVC.animationDelegate else { return nil }
            switch self.animationType {
            case .move:
                transitionAnimation = WBTransitionMove()
                (transitionAnimation as? WBTransitionMove)?.type = .push
            case .openOrCloseDoor:
                transitionAnimation = WBTransitionOpenOrCloseDoor()
                (transitionAnimation as? WBTransitionOpenOrCloseDoor)?.type = .push
            }
        } else if operation == .pop {
            guard let _ = fromVC.animationDelegate else { return nil }
            switch self.animationType {
            case .move:
                transitionAnimation = WBTransitionMove()
                (transitionAnimation as? WBTransitionMove)?.type = .pop
            case .openOrCloseDoor:
                transitionAnimation = WBTransitionOpenOrCloseDoor()
                (transitionAnimation as? WBTransitionOpenOrCloseDoor)?.type = .push
            }
        }
        return transitionAnimation
    }
}
