//
//  TransitionOne.swift
//  house591
//
//  Created by yanwenbin on 2021/9/14.
//

import UIKit

enum TransitionOneType {
    case push
    case pop
}

class TransitionOne: NSObject {
    
    // MARK: - Public Property
    var type: TransitionOneType = .push
    
    // MARK: - Override
    deinit {
        NSLog("TransitionOne dealloc")
    }
}

// MARK: Private Method
extension TransitionOne {
    /// push动效
    fileprivate func pushAnimation(transitionContext: UIViewControllerContextTransitioning) {
        // 通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是转场后的VC、fromVC就是转场前的VC
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? ViewControllerOne
        else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        var fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        if let navVC = fromVC as? UINavigationController {
            fromVC = navVC.viewControllers.last
        }
        guard let fromListVC = fromVC as? ViewController else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
//        // 取出转场前后视图控制器上的视图view
//        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
//        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        // 这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
        let containerView = transitionContext.containerView
        // 动画效果
        guard let cell = fromListVC.selectCell, let animationView = cell.imageView else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        guard let tempView = animationView.snapshotView(afterScreenUpdates: false) else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        tempView.frame = animationView.convert(animationView.bounds, to: containerView)
        toVC.view.alpha = 0
        toVC.imageView.isHidden = true
        // tempView 添加到containerView中，要保证在最上层，所以后添加
        containerView.addSubview(toVC.view)
        containerView.addSubview(tempView)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            tempView.frame = toVC.imageView.convert(toVC.imageView.bounds, to: containerView)
            toVC.view.alpha = 1
        } completion: { (isFinished) in
            tempView.removeFromSuperview()
            toVC.imageView.isHidden = false
            // 如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中断动画完成的部署，会出现无法交互之类的bug
            transitionContext.completeTransition(true)
        }
    }
    
    /// pop动效
    fileprivate func popAnimation(transitionContext: UIViewControllerContextTransitioning) {
        // 通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是转场后的VC、fromVC就是转场前的VC
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? ViewControllerOne
        else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        var toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        if let navVC = toVC as? UINavigationController {
            toVC = navVC.viewControllers.last
        }
        guard let toListVC = toVC as? ViewController else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        // 这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
        let containerView = transitionContext.containerView
        guard let tempView = fromVC.imageView.snapshotView(afterScreenUpdates: false) else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        guard let cell = toListVC.selectCell,
              let cellImageView = cell.imageView,
              let cellImageViewSuperView = cellImageView.superview  else {
            handleUnexpectationState(transitionContext: transitionContext)
            return
        }
        tempView.frame = fromVC.imageView.convert(fromVC.imageView.bounds, to: containerView)
        containerView.addSubview(toListVC.view)
        containerView.addSubview(tempView)
        let rect = cellImageViewSuperView.convert(cellImageView.frame, to: containerView)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            tempView.frame = rect
        } completion: { (isFinished) in
            tempView.removeFromSuperview()
            // 如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中断动画完成的部署，会出现无法交互之类的bug
            transitionContext.completeTransition(true)
        }
    }
    
    /// 异常处理
    fileprivate func handleUnexpectationState(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            transitionContext.completeTransition(true)
            return
        }
        containerView.addSubview(toVC.view)
        transitionContext.completeTransition(true)
    }
}

// MARK: UIViewControllerAnimatedTransitioning
extension TransitionOne: UIViewControllerAnimatedTransitioning {
    /// 返回动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    /// 所有的过渡动画事务都在这个方法里面完成
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch self.type {
        case .push:
            self.pushAnimation(transitionContext: transitionContext)
        case .pop:
            self.popAnimation(transitionContext: transitionContext)
        }
    }
}
