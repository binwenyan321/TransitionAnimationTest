//
//  WBAnimationViewController.swift
//  TransitionAnimationTest
//
//  Created by yanwenbin on 2021/12/22.
//

import UIKit

extension UIViewController {
    
    fileprivate struct Macro {
        static var animationDelegateKey: String = "WBAnimationDelegateKey"
        static var animationViewKey: String = "WBAnimationViewKey"
    }
    
    /// 处理动画的代理对象
    var animationDelegate: WBVCAnimationPushDelegate? {
        get {
            if let object: WBVCAnimationPushDelegate = objc_getAssociatedObject(self, &Macro.animationDelegateKey) as AnyObject as? WBVCAnimationPushDelegate {
                return object
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &Macro.animationDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var animationView: UIView? {
        get {
            if let object: UIView = objc_getAssociatedObject(self, &Macro.animationViewKey) as AnyObject as? UIView {
                return object
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &Macro.animationViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
