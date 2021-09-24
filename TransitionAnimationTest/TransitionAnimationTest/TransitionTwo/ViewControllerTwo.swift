//
//  ViewControllerTwo.swift
//  TransitionAnimationTest
//
//  Created by yanwenbin on 2021/9/23.
//

import UIKit

class ViewControllerTwo: UIViewController {
    
    // MARK: - Public Property
    var imageView: UIImageView = UIImageView()
    
    // MARK: - Private Property
    fileprivate lazy var transitionAnimation: TransitionTwo = {
        let transitionAnimation = TransitionTwo()
        self.transitioningDelegate = self
        return transitionAnimation
    }()

    // MARK: - Override
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.transitionAnimation.type = .present
        self.modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ViewControllerTwo dealloc")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1)
        self.imageView.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 230)
        self.imageView.image = UIImage(named: "fly")
        self.view.addSubview(self.imageView)
        self.addGesture()
        // Do any additional setup after loading the view.
    }
}

// MARK: Private Method
extension ViewControllerTwo {
    /// 添加返回手势
    fileprivate func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(back))
        self.view.addGestureRecognizer(tap)
    }
    
    /// 返回
    @objc fileprivate func back() {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: UIViewControllerTransitioningDelegate
extension ViewControllerTwo: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionAnimation.type = .present
        return self.transitionAnimation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionAnimation.type = .dismiss
        return self.transitionAnimation
    }
}
