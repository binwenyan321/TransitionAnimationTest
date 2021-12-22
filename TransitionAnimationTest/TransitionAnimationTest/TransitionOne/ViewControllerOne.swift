//
//  ViewControllerOne.swift
//  TransitionAnimationTest
//
//  Created by yanwenbin on 2021/9/15.
//

import UIKit

class ViewControllerOne: UIViewController {
    
    // MARK: - Public Property
    var navDelegate: UINavigationControllerDelegate?
    
    var imageView: UIImageView = UIImageView()
    
    lazy var btn: UIButton = {
       let btn = UIButton()
        btn.setTitle("btn", for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(jumpVC), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Private Property
    /// 转场动画
    fileprivate lazy var transitionAnimation: TransitionOne = {
        let transitionAnimation = TransitionOne()
        return transitionAnimation
    }()

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.imageView.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 230)
        self.imageView.image = UIImage(named: "fly")
        self.view.addSubview(self.imageView)
        self.btn.frame = CGRect(x: 100, y: 400, width: 70, height: 30)
        self.view.addSubview(self.btn)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 由其他界面返回到当前界面时 设置代理
        self.navigationController?.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 网上都说在此处置空代理，但实测这里的navigationController为nil，无效操作
        guard let delegate = self.navigationController?.delegate as? UIViewController,
              delegate == self
              else {
            return
        }
        self.navigationController?.delegate = self.navDelegate
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("ViewControllerOne init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ViewControllerOne dealloc")
    }
    
    // MARK: IBAction
    @objc func jumpVC() {
        let vc = ViewController()
        self.navigationController?.delegate = self.navDelegate  // 跳转之前需要先置空代理
        self.navigationController?.pushViewController(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UINavigationControllerDelegate
extension ViewControllerOne: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            self.transitionAnimation.type = .push
        } else if operation == .pop {
            self.transitionAnimation.type = .pop
            
            // 如果返回不需要自定义转场动画，置空代理，返回nil即可
//            self.navigationController?.delegate = self.navDelegate
//            return nil
        }
        return self.transitionAnimation
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard viewController != self else {
            return
        }
        guard let delegate = self.navigationController?.delegate as? UIViewController,
              delegate == self
              else {
            return
        }
        // 返回到上级界面时，置空代理
        self.navigationController?.delegate = self.navDelegate
    }
}
