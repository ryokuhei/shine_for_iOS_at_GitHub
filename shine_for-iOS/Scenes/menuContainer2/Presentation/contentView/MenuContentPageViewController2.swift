//
//  ContentPageViewController.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/06/18.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import RxCocoa
import RxSwift

class MenuContentPageViewController2 : UIPageViewController, UIGestureRecognizerDelegate {
    
    var presenter: MenuContainerPresenter2?
    var disposeBag = DisposeBag()
    
    private var swipeDirection = SwipeDirection.none
    
    var beforeMenu: MenuModel?
    var currentMenu: MenuModel?
    var afterMenu: MenuModel?
    
    func inject(presenter: MenuContainerPresenter2) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate   = self
        
        self.setOutputsObservable()
    }
    
    private func setOutputsObservable() {
        
        self.presenter?.outputs.currentMenu
            .subscribe(onNext: {
                menu in
                    self.currentMenu = menu
            }).disposed(by: disposeBag)
        
        self.presenter?.outputs.beforeMenu
            .subscribe(onNext: {
                menu in
                self.beforeMenu = menu
            }).disposed(by: disposeBag)
        
        self.presenter?.outputs.afterMenu
            .subscribe(onNext: {
                menu in
                self.afterMenu = menu
            }).disposed(by: disposeBag)
        
        self.presenter?.outputs.selectedMenu
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [unowned self] menu in
                let vc = MenuContentViewContorllerBuilder.build(menu: menu)
                self.setViewContorller(vc)
            })
            .disposed(by: disposeBag)
        
        self.presenter?.outputs.pushOutMenuFromBefore
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [unowned self] menu in
                self.afterMenu = self.currentMenu
                self.currentMenu = self.beforeMenu
                self.beforeMenu = menu
            })
            .disposed(by: disposeBag)
        
        self.presenter?.outputs.pushOutMenuFromAfter
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [unowned self] menu in
                self.beforeMenu = self.currentMenu
                self.currentMenu = self.afterMenu
                self.afterMenu = menu
            })
            .disposed(by: disposeBag)
        
    }
    
    // selected menu bar
    func setViewContorller(_ viewController: UIViewController) {
        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
}

extension MenuContentPageViewController2: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var vc: UIViewController?
        if let menu = beforeMenu {
            vc = MenuContentViewContorllerBuilder.build(menu: menu)
        }
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var vc: UIViewController?
        if let menu = afterMenu {
            vc = MenuContentViewContorllerBuilder.build(menu: menu)
        }
        return vc
    }
}

extension MenuContentPageViewController2: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            let vc = pageViewController.viewControllers?.first as! MenuContentViewContorller
            if vc.menu == beforeMenu {
                presenter?.inputs.swipedRightWithIndex.onNext(vc.menu!.index)
            } else if vc.menu == afterMenu {
                presenter?.inputs.swipedLeftWithIndex.onNext(vc.menu!.index)
            }
        }
    }
    
}

enum SwipeDirection {
    case none
    case left
    case right
}
