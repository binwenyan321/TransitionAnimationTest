//
//  ViewControllerFour.swift
//  TransitionAnimationTest
//
//  Created by yanwenbin on 2021/9/23.
//

import UIKit

class ViewControllerFour: UIViewController {
    
    // MARK: - Public Property
    var imageView: UIImageView = UIImageView()
    
    // MARK: - Private Property
    fileprivate lazy var transitionAnimation: TransitionFour = {
        let transitionAnimation = TransitionFour()
        self.transitioningDelegate = self
        return transitionAnimation
    }()

    /// 转场手势
    fileprivate lazy var transitionInteractive: TransitionInteractiveFour = {
        let transitionInteractive = TransitionInteractiveFour()
        transitionInteractive.addPanGesture(vc: self)
        return transitionInteractive
    }()
    
    // MARK: - Override
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.transitionAnimation.type = .present
        self.transitionInteractive.interactiveType = .dismiss
        self.modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ViewControllerFour dealloc")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1)
        self.imageView.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 230)
        self.imageView.image = UIImage(named: "fly")
        self.view.addSubview(self.imageView)
//        self.addGesture()
        // Do any additional setup after loading the view.
    }
}

// MARK: Private Method
extension ViewControllerFour {
//    /// 添加返回手势
//    fileprivate func addGesture() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(back))
//        self.view.addGestureRecognizer(tap)
//    }
//
//    /// 返回
//    @objc fileprivate func back() {
//        self.dismiss(animated: true, completion: nil)
//    }
}


// MARK: UIViewControllerTransitioningDelegate
extension ViewControllerFour: UIViewControllerTransitioningDelegate {
    /// 控制present转场动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionAnimation.type = .present
        return self.transitionAnimation
    }
    
    /// 控制dismiss转场动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionAnimation.type = .dismiss
        return self.transitionAnimation
    }
    
    /// 控制present手势
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    /// 控制dismiss手势
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.transitionInteractive
    }
}
