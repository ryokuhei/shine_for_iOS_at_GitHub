//
//  TestViewController.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/19.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class TestViewController: UIPageViewController {
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
//        let currentVC = MenuContentViewContorllerBuilder.build()
//        currentVC.index = count

//        setViewControllers([currentVC], direction: .forward, animated: true, completion: nil)
        
    }
}

extension TestViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
    
}

extension TestViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let beforeVC = MenuContentViewContorllerBuilder.build()
        self.count = count - 1
//        beforeVC.inject(index: count, wireframe: )
        return beforeVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let afterVC = MenuContentViewContorllerBuilder.build()
        self.count = count + 1
//        afterVC.inject(index: count, wireframe: )
        
        return afterVC
    }
}
