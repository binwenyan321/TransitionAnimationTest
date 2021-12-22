# TransitionAnimationTest

### 转场动画对象

1. 创建转场动画控制对象  继承**UIViewControllerAnimatedTransitioning**对象

   实现以下两个代理方法

   ```swift
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
           case .present:
               self.presentAnimation(transitionContext: transitionContext)
           case .dismiss:
               self.dismissAnimation(transitionContext: transitionContext)
           }
       }
   ```

2. 转场环境协议 

   转场环境协议 **UIViewControllerContextTransitioning**  是转场动画的核心，存储转场双方的数据等


    动画协议UIViewControllerAnimatedTransitioning 的两个代理方法都有个遵守UIViewControllerContextTransitioning协议的参数，表示的是当前转场的上下文，可以获取到 fromViewController、或者是toViewController以及fromView、toView、containerView等。

   ```swift
   // 通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是转场后的VC、fromVC就是转场前的VC
   let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
   
   var fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
   
   
   // 取出转场前后视图控制器上的视图view
   let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
   let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
   ```

   经过试验发现不同情况下的fromView、toView有不同的表现

   * push

      ![截屏2021-09-26 下午2 09 58](https://user-images.githubusercontent.com/19942237/134801503-47275961-7dc5-4d67-b574-4c3d64444e4b.png)

     可以发现fromView、toView都是有值的，且fromView与fromVC的view一致，toView与toVC的view一致

   * pop

     同上

   * present

     ![截屏2021-09-26 下午2 24 21](https://user-images.githubusercontent.com/19942237/134801519-8d546ecf-fa10-441e-a3ed-f663336d83fd.png)

     fromView为nil

   * dismiss

     ![截屏2021-09-26 下午2 26 06](https://user-images.githubusercontent.com/19942237/134801525-065397ec-a3c7-4642-b947-f1d44e09c748.png)

     toView为nil

3. containerView

   如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图

   ```swift
   let containerView = transitionContext.containerView
   containerView.addSubview(toVC.view)
   // 一般使用snapshotView制作截屏来实现动画效果
   let tempView = animationView.snapshotView(afterScreenUpdates: false)
   containerView.addSubview(tempView)
   ```

   **注意：push和pop以及present的时候，需要添加toVC.view到容器视图上，才能完成正常跳转， dismiss的时候则不需要添加，否则会出现黑屏问题**

4. 动画完成之后需要执行完成方法

   ```swift
   // 当有手势参与时，此处需要进行手势过渡判断，没有则可以直接传true
   transitionContext.completeTransition(true) 
   ```

### 导航控制器push和pop 自定义转场

1. 创建转场动画对象

2. UINavigationControllerDelegate代理

   **push**和**pop**转场需要通过**UINavigationControllerDelegate**来实现

   需要跳转的控制器需要继承UINavigationControllerDelegate，并实现以下方法

   ```swift
   func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
   				// 在此处返回转场动画控制对象
           return self.transitionAnimation 
    }
   ```

3. delegate生命周期

   * push前

     记录原代理对象

     ```swift
     (vc as? ViewControllerOne)?.navDelegate = self.navigationController?.delegate
     ```
   
     为转场到的控制器设置代理，未设置会执行系统转场动画
   
     ```swift
     self.navigationController?.delegate = vc as? UINavigationControllerDelegate
     self.navigationController?.pushViewController(vc, animated: true)
     ```

   * pop后

     还原代理，否则会出现内存泄漏导致crash问题
   
     研究发现过早还原会导致转场动画不生效，太晚还原会导致crash
   
     网上查询到的资料都建议在viewDidDisappear进行还原，但实际验证发现此时**navigationController**已经为**nil**，无法设置代理，无效操作
   
     ```swift
     // 无效
     override func viewDidDisappear(_ animated: Bool) {
             super.viewDidDisappear(animated)
             self.navigationController?.delegate = self.navDelegate
         }
     ```
   
     研究发现可以在**UINavigationControllerDelegate**的另外一个代理方法中执行还原操作
   
     ```swift
     /// 发生转场，新的控制器界面即将出现
         func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
             // 返回到上级界面时才进行还原代理操作
             guard viewController != self else {
                 return
             }
             guard let delegate = self.navigationController?.delegate as? UIViewController,
                   delegate == self
                   else {
                 return
             }
             // 还原代理
             self.navigationController?.delegate = self.navDelegate
         }
     ```
   
   * 当前界面继续进行转场
   
     当前界面需要继续进行转场时，需要先还原代理，否则会出现转场异常，导致黑屏等问题
   
     ```swift
     @objc func jumpVC() {
         let vc = ViewController()
         self.navigationController?.delegate = self.navDelegate  // 跳转之前需要先还原代理
         self.navigationController?.pushViewController(vc, animated: true)
     }
     ```
   
   * 从别的界面返回到当前界面，需要重设代理为自身，不然返回时会执行系统转场动画
   
     ```swift
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         // 由其他界面返回到当前界面时 设置代理
         self.navigationController?.delegate = self
     }
     ```

### 模态present和dismiss 自定义转场

1. 创建转场动画对象

2. **UIViewControllerTransitioningDelegate**代理

   **present**和**dismiss**转场需要通过**UIViewControllerTransitioningDelegate**来实现

   需要跳转的控制器需要继承UIViewControllerTransitioningDelegate，并实现以下方法

   ```swift
   /// present转场动画
       func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
           self.transitionAnimation.type = .present
           return self.transitionAnimation
       }
       
       /// dismiss转场动画
       func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
           self.transitionAnimation.type = .dismiss
           return self.transitionAnimation
       }
   ```

3. delegate生命周期

   界面创建时设置代理

   ```swift
   self.transitioningDelegate = self
   self.modalPresentationStyle = .custom
   ```

### 手势转场

1. 创建转场动画对象

2. 创建手势转场控制对象  

   继承自交互控制器协议 UIViewControllerInteractiveTransitioning， 官方提供了一个已实现UIViewControllerInteractiveTransitioning协议的类[UIPercentDrivenInteractiveTransition](https://developer.apple.com/library/ios/documentation/uikit/reference/UIPercentDrivenInteractiveTransition_class/Reference/Reference.html)
    为我们预先实现和提供了一系列便利的方法，可以用一个百分比来控制交互式切换的过程，利用手势来完成这个转场

   ```objective-c
   //暂停交互 
   - (void)pauseInteractiveTransition NS_AVAILABLE_IOS(10_0);
   //更新方法，一般交互时候的进度更新就在这个方法里面
   - (void)updateInteractiveTransition:(CGFloat)percentComplete;
   //第三个是取消交互
   - (void)cancelInteractiveTransition;
   //第四个的话就是设置交互完成
   - (void)finishInteractiveTransition;
   ```

3. 为转场控制器添加手势

   ```swift
   /// 添加手势
       func addPanGesture(vc: UIViewController) {
           self.transitionVC = vc
           let pan = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
           vc.view.addGestureRecognizer(pan)
       }
   ```

   针对手势操作进行处理,通过UIPercentDrivenInteractiveTransition的方法来控制进度

   ```swift
   fileprivate func interactiveWithPop(gesture: UIPanGestureRecognizer) {
         let translation = gesture.translation(in: gesture.view)
         guard let transitionVC = self.transitionVC else { return }
         // 获取百分比
         var percentComplete: CGFloat = 0
         percentComplete = abs(translation.x / transitionVC.view.frame.size.width)
         // 根据手势状态进行处理
         switch gesture.state {
         case .began: // 开始转场动画
             self.isInteractive = true
             transitionVC.navigationController?.popViewController(animated: true)
         case .changed:
             // 手势过程中，通过updateInteractiveTransition设置转场过程动画进行的百分比，然后系统会根据百分比自动布局动画控件，不用我们控制了
             self.update(percentComplete)
         case .ended: // 根据进度来结束转场或取消转场
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
   ```

4. push和pop 手势转场

   实现UINavigationControllerDelegate的代理方法

   ```swift
   func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
       switch self.transitionAnimation.type {
       case .pop: // 如果不是通过手势触发则返回nil
           return self.transitionInteractive.isInteractive ? self.transitionInteractive : nil
       default:
           return nil
       }
   }
   ```

   同时，要在转场动画对象中添加手势判断

   决定是否完成转场，抑或取消转场

   ```swift
   /// pop动效
       fileprivate func popAnimation(transitionContext: UIViewControllerContextTransitioning) {
           
       …………
   
       UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) 
       {…………} completion: { (isFinished) in
           …………
           // 由于加入了手势必须判断
           transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
       }
   }
   ```

5. present、dismiss手势转场

   实现UIViewControllerTransitioningDelegate的代理方法

   ```swift
   /// 控制present手势
       func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
           return nil
       }
       
       /// 控制dismiss手势
       func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
           return self.transitionInteractive
       }
   ```

   同时，要在转场动画对象中添加手势判断，同上4
