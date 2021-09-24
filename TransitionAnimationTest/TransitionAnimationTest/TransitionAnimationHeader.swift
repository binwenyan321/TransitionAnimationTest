//
//  TransitionAnimationHeader.swift
//  TransitionAnimationTest
//
//  Created by yanwenbin on 2021/9/18.
//

import Foundation
import UIKit

/// 导航栏高度
let TWSwiftNavigationHeigth: CGFloat = 44.0

/// 状态栏高度
var TWSwiftStatusBarHeight: CGFloat {
    get {
        if TWSwiftIsIhoneX() {
            return 44.0
        } else {
            return 20.0
        }
    }
}

/// 状态栏 + 导航栏高度
let TWSwiftStatusAndNavigationHeigth = TWSwiftNavigationHeigth + TWSwiftStatusBarHeight

/// 获取当前window(适配windowScene和application)
private func getCurrentWindow() -> UIWindow? {
    if let window = UIApplication.shared.delegate?.window {
        return window
    }
    if #available(iOS 13.0, *) {
        if let windowScene = UIApplication.shared.connectedScenes.first {
            if let mainWindow = windowScene.value(forKey: "delegate.window") as? UIWindow {
                return mainWindow
            }
            return UIApplication.shared.windows.last
        }
    }
    return UIApplication.shared.keyWindow
}

public func TWSwiftIsIhoneX() -> Bool {
    var bottomSafeInset: CGFloat = 0
    if #available(iOS 11.0, *) {
        bottomSafeInset = getCurrentWindow()?.safeAreaInsets.bottom ?? 0
    }
    return bottomSafeInset > 0
}
