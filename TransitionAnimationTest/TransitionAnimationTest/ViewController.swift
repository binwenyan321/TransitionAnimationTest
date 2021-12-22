//
//  ViewController.swift
//  TransitionAnimationTest
//
//  Created by yanwenbin on 2021/9/15.
//

import UIKit

class ViewController: UIViewController {
    
    struct Metric {
        static let cellHeight: CGFloat = 100
    }
    
    var selectCell: UITableViewCell?
    
    fileprivate let dataSource: [String] = ["push/pop转场", "present/dismiss转场", "push/pop转场 带手势效果", "present/dismiss转场 带手势效果", "push/pop转场 工具类实现"]
    
    fileprivate let vcArr: [UIViewController] = [ViewControllerOne(), ViewControllerTwo(), ViewControllerThree(), ViewControllerFour(), ViewControllerFive()]
    
    fileprivate lazy var tableview: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: Metric.cellHeight*CGFloat(dataSource.count)), style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tableview)
        // Do any additional setup after loading the view.
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = vcArr[indexPath.row]
        self.selectCell = tableview.cellForRow(at: indexPath)
        switch indexPath.row {
        case 0:
            (vc as? ViewControllerOne)?.navDelegate = self.navigationController?.delegate
            self.navigationController?.delegate = vc as? UINavigationControllerDelegate
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            self.present(vc, animated: true, completion: nil)
        case 2:
            (vc as? ViewControllerThree)?.navDelegate = self.navigationController?.delegate
            self.navigationController?.delegate = vc as? UINavigationControllerDelegate
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            self.present(vc, animated: true, completion: nil)
        case 4:
            self.animationView = self.selectCell?.imageView
            vc.animationView = (vc as? ViewControllerFive)?.imageView
            self.navigationController?.animationPushViewController(vc: vc, animationType: .openOrCloseDoor)
        default:
            let vc = ViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.imageView?.image = UIImage(named: "fly")
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

