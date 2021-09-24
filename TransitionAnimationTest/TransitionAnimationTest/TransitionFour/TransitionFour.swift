//
//  TransitionFour.swift
//  TransitionAnimationTest
//
//  Created by yanwenbin on 2021/9/23.
//

import UIKit

enum TransitionFourType {
    case present
    case dismiss
}

class TransitionFour: NSObject {
    
    // MARK: - Public Property
    var type: TransitionFourType = .present
    
    // MARK: - Override
    deinit {
        NSLog("TransitionFour dealloc")
    }
}

// MARK: Private Method
extension TransitionFour {
    /// present动效
    fileprivate func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? ViewControllerFour,
              let toView = toVC.view else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        var fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        if let navVC = fromVC as? UINavigationController {
            fromVC = navVC.viewControllers.last
        }
        guard let fromListVC = fromVC as? ViewController,
              let fromView = fromListVC.view else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        // 这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
        let containerView = transitionContext.containerView
        // 左侧动画视图
        guard let leftFromView = fromView.snapshotView(afterScreenUpdates: false) else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: fromView.frame.size.width/2, height: fromView.frame.size.height))
        leftView.clipsToBounds = true
        leftView.addSubview(leftFromView)
        // 右侧动画视图
        guard let rightFromView = fromView.snapshotView(afterScreenUpdates: false) else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        rightFromView.frame = CGRect(x: -fromView.frame.size.width/2, y: 0, width: fromView.frame.size.width, height: fromView.frame.size.height)
        let rightView = UIView(frame: CGRect(x: fromView.frame.size.width/2, y: 0, width: fromView.frame.size.width/2, height: fromView.frame.size.height))
        rightView.clipsToBounds = true
        rightView.addSubview(rightFromView)
        // 动画效果
        containerView.addSubview(toView)
        containerView.addSubview(leftView)
        containerView.addSubview(rightView)
        fromView.isHidden = true
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            leftView.frame = CGRect(x: -fromView.frame.size.width/2, y: 0, width: fromView.frame.size.width/2, height: fromView.frame.size.height)
            rightView.frame = CGRect(x: fromView.frame.size.width, y: 0, width: fromView.frame.size.width/2, height: fromView.frame.size.height)
        } completion: { (isFinished) in
            fromView.isHidden = false
            leftView.removeFromSuperview()
            rightView.removeFromSuperview()
            // 如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中断动画完成的部署，会出现无法交互之类的bug
            transitionContext.completeTransition(true)
        }
    }
    
    /// dismiss动效
    fileprivate func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
        // 通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是转场后的VC、fromVC就是转场前的VC
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? ViewControllerFour
        else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        var toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        if let navVC = toVC as? UINavigationController {
            toVC = navVC.viewControllers.last
        }
        guard let toListVC = toVC as? ViewController,
              let toView = toListVC.view else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        
        // 左侧动画视图
        guard let leftToView = toView.snapshotView(afterScreenUpdates: false) else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        let leftView = UIView(frame: CGRect(x: -toView.frame.size.width/2, y: 0, width: toView.frame.size.width/2, height: toView.frame.size.height))
        leftView.clipsToBounds = true
        leftView.addSubview(leftToView)
        // 右侧动画视图
        guard let rightToView = toView.snapshotView(afterScreenUpdates: false) else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        rightToView.frame = CGRect(x: -toView.frame.size.width/2, y: 0, width: toView.frame.size.width, height: toView.frame.size.height)
        let rightView = UIView(frame: CGRect(x: toView.frame.size.width, y: 0, width: toView.frame.size.width/2, height: toView.frame.size.height))
        rightView.clipsToBounds = true
        rightView.addSubview(rightToView)
        // 这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
        let containerView = transitionContext.containerView
        containerView.addSubview(leftView)
        containerView.addSubview(rightView)
        toView.isHidden = true
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            leftView.frame = CGRect(x: 0, y: 0, width: toView.frame.size.width/2, height: toView.frame.size.height)
            rightView.frame = CGRect(x: toView.frame.size.width/2, y: 0, width: toView.frame.size.width/2, height: toView.frame.size.height)
        } completion: { (isFinish) in
            toView.isHidden = false
            leftView.removeFromSuperview()
            rightView.removeFromSuperview()
            // 手势处理
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    /// 异常处理
    fileprivate func handleUnexpectationState(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
              self.type == .present else {
            transitionContext.completeTransition(true)
            return
        }
        containerView.addSubview(toVC.view)
        transitionContext.completeTransition(true)
    }
}

// MARK: UIViewControllerAnimatedTransitioning
extension TransitionFour: UIViewControllerAnimatedTransitioning {
    /// 返回动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    /// 所有的过渡动画事务都在这个方法里面完成
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch self.type {
        case .present:
            self.presentAnimation(transitionContext: transitionContext)
        case .dismiss:
            self.dismissAnimation(transitionContext: transitionContext)
        }
    }
}
