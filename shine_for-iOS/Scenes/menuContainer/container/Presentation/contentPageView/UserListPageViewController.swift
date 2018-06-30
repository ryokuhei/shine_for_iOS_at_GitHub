//
//  UserListPageViewController.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/13.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class MenuPageViewController : UIPageViewController {
    
    var presenter: MenuContainerPresenter?
    var disposeBag = DisposeBag()
    
    var prevMenu: MenuModel?
    var currentMenu: MenuModel?
    var nextMenu: MenuModel?
    
    func inject(presenter: MenuContainerPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate   = self
        
        self.setOutputObservable()
    }
    
    func setOutputObservable() {
        
        presenter?.outputs.contentIndexOfCurrent
            .subscribe(onNext: { [unowned self] index in
                if let index = index {
                    self.currentMenu = MenuManager.menuList[index]
                }
            }).disposed(by: disposeBag)
        
        presenter?.outputs.contentIndexOfBefore.subscribe(
            onNext: { [unowned self] index in
                if let index = index {
                    self.prevMenu = MenuManager.menuList[index]
                }
            }).disposed(by: disposeBag)

        presenter?.outputs.contentIndexOfAfter.subscribe(
            onNext: { [unowned self] index in
                if let index = index {
                    self.nextMenu = MenuManager.menuList[index]
                }
            }).disposed(by: disposeBag)
        
        presenter?.outputs.selectedMenu.subscribe(
            onNext: { [unowned self] menu in
                let vc = MenuContentViewContorllerBuilder.build(menu: menu)
                self.setViewContorller(vc)
        }).disposed(by: disposeBag)
    }
    
    func setViewContorller(_ viewController: UIViewController) {
        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
}

extension MenuPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let prevMenu = self.prevMenu else {
            return nil
        }
        let beforeViewController = MenuContentViewContorllerBuilder.build(menu: prevMenu)

        return beforeViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let nextMenu = self.nextMenu else {
            return nil
        }
        let afterViewController = MenuContentViewContorllerBuilder.build(menu: nextMenu)
        
        return afterViewController
    }
}

extension MenuPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if finished {
            
            let transistedVC = pageViewController.viewControllers?.first as! MenuContentViewContorller
            
            if transistedVC.menu?.index == prevMenu?.index {
                presenter?.inputs.swipeOfRight.onNext(())
            } else if transistedVC.menu?.index == nextMenu?.index {
                presenter?.inputs.swipeOfLeft.onNext(())
            }
        }

    }
    
}
