//
//  RootViewController.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/01.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

final class RootViewController: UIViewController {
    
    var current: UIViewController! {
        willSet {
            // move
            self.addChildViewController(newValue)
            newValue.view.frame = self.view.bounds
            self.view.addSubview(newValue.view)
            newValue.didMove(toParentViewController: self)
            
            newValue.view.addSubview(activityIndicator)
        }
        didSet {
            // remove
            oldValue.willMove(toParentViewController: self)
            oldValue.view.removeFromSuperview()
            oldValue.removeFromParentViewController()
        }
    }
    
    lazy private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.frame = current.view.bounds
        indicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        return indicator
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        
//        self.current = SplashViewControllerBuilder.build()

        let navigationController =  UINavigationController(rootViewController: LoginViewControllerBuilder.build())

        
        self.current = navigationController
        // 初期設定ではwillSet,didSetが呼ばれないため初期設定を行う
        self.addChildViewController(current)
        current.view.frame = UIScreen.main.bounds
        self.view.addSubview(current.view)
        current.didMove(toParentViewController: self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.addChildViewController(current)
//
//        current.view.frame = UIScreen.main.bounds
//        self.view.addSubview(current.view)
//
//        current.didMove(toParentViewController: self)

    }
    
    func showLoginViewController() {
        let loginVC = LoginViewControllerBuilder.build()
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        current = navigationController
//        transitionViewController(toViewController: navigationController)
        
        
    }
    
    func showTopViewController() {
        let topVC = TopViewControllerBuilder.build()
        let navigationController = UINavigationController(rootViewController: topVC)
        current = navigationController

//        transitionViewController(toViewController: navigationController)
    }
    
//    private func transitionViewController(toViewController vc: UIViewController) {
//
//        // move
//        addChildViewController(vc)
//        vc.view.frame = view.bounds
//        view.addSubview(vc.view)
//        vc.didMove(toParentViewController: self)
//
//        //
//        current.willMove(toParentViewController: self)
//        current.view.removeFromSuperview()
//        current.removeFromParentViewController()
//
//        current = vc
//
//
//    }
    
    func showActivityIndicator() {
        self.activityIndicator.startAnimating()
    }
    
    func stopActivityIndicatior() {
        self.activityIndicator.stopAnimating()
    }
    
}
