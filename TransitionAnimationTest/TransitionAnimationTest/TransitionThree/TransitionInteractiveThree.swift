//
//  TransitionInteractiveThree.swift
//  TransitionAnimationTest
//
//  Created by yanwenbin on 2021/9/23.
//

import UIKit

enum TransitionInteractiveThreeType {
    case push
    case pop
}

class TransitionInteractiveThree: UIPercentDrivenInteractiveTransition {
    
    // MARK: Public Property
    /// 类型
    var interactiveType: TransitionInteractiveThreeType = .push
    
    /// 是否通过手势触发事件 直接转场为false
    var isInteractive: Bool = false
    
    // MARK: - Private Property
    fileprivate var transitionVC: UIViewController?
    
}

// MARK: Public Method
extension TransitionInteractiveThree {
    /// 添加手势
    func addPanGesture(vc: UIViewController) {
        self.transitionVC = vc
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        vc.view.addGestureRecognizer(pan)
    }
}

// MARK: Private Method
extension TransitionInteractiveThree {
    /// 手势动作
    @objc fileprivate func handleGesture(gesture: UIPanGestureRecognizer) {
        switch self.interactiveType {
        case .push:
            self.interactiveWithPush(gesture: gesture)
        case .pop:
            self.interactiveWithPop(gesture: gesture)
        }
    }
    
    /// push手势
    fileprivate func interactiveWithPush(gesture: UIPanGestureRecognizer) {
        
    }
    
    /// pop手势
    fileprivate func interactiveWithPop(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        guard let transitionVC = self.transitionVC else { return }
        // 获取百分比
        var percentComplete: CGFloat = 0
        percentComplete = abs(translation.x / transitionVC.view.frame.size.width)
        switch gesture.state {
        case .began:
            self.isInteractive = true
            transitionVC.navigationController?.popViewController(animated: true)
        case .changed:
            // 手势过程中，通过updateInteractiveTransition设置转场过程动画进行的百分比，然后系统会根据百分比自动布局动画控件，不用我们控制了
            self.update(percentComplete)
        case .ended:
            self.isInteractive = false
            if percentComplete > 0.5 {
                self.finish()
            } else {
                self.cancel()
            }
        default:
            break
        }
    }
}
