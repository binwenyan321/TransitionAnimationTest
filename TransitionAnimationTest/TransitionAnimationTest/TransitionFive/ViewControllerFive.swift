//
//  ViewControllerFive.swift
//  TransitionAnimationTest
//
//  Created by yanwenbin on 2021/12/22.
//

import UIKit

class ViewControllerFive: UIViewController {

    // MARK: - Public Property
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
    fileprivate lazy var transitionAnimation: TransitionThree = {
        let transitionAnimation = TransitionThree()
        return transitionAnimation
    }()
    
    /// 转场手势
    fileprivate lazy var transitionInteractive: TransitionInteractiveThree = {
        let transitionInteractive = TransitionInteractiveThree()
        transitionInteractive.addPanGesture(vc: self)
        return transitionInteractive
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.transitionInteractive.interactiveType = .pop
        print("ViewControllerThree init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ViewControllerThree dealloc")
    }
    
    // MARK: IBAction
    @objc func jumpVC() {
        let vc = ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

