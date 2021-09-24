//
//  TransitionInteractiveFour.swift
//  TransitionAnimationTest
//
//  Created by yanwenbin on 2021/9/24.
//

import UIKit

enum TransitionInteractiveFourType {
    case present
    case dismiss
}

class TransitionInteractiveFour: UIPercentDrivenInteractiveTransition {
    
    // MARK: Public Property
    /// 类型
    var interactiveType: TransitionInteractiveFourType = .dismiss
    
    /// 是否通过手势触发事件 直接转场为false
    var isInteractive: Bool = false
    
    // MARK: - Private Property
    fileprivate var transitionVC: UIViewController?
    
}

// MARK: Public Method
extension TransitionInteractiveFour {
    /// 添加手势
    func addPanGesture(vc: UIViewController) {
        self.transitionVC = vc
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        vc.view.addGestureRecognizer(pan)
    }
}

// MARK: Private Method
extension TransitionInteractiveFour {
    /// 手势动作
    @objc fileprivate func handleGesture(gesture: UIPanGestureRecognizer) {
        switch self.interactiveType {
        case .present:
            self.interactiveWithPresent(gesture: gesture)
        case .dismiss:
            self.interactiveWithDismiss(gesture: gesture)
        }
    }
    
    /// push手势
    fileprivate func interactiveWithPresent(gesture: UIPanGestureRecognizer) {
        
    }
    
    /// pop手势
    fileprivate func interactiveWithDismiss(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        guard let transitionVC = self.transitionVC else { return }
        // 获取百分比
        var percentComplete: CGFloat = 0
        percentComplete = abs(translation.x / transitionVC.view.frame.size.width)
        switch gesture.state {
        case .began:
            self.isInteractive = true
            transitionVC.dismiss(animated: true, completion: nil)
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
