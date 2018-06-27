//
//  MenuViewConntroller2.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/06/19.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import RxSwift
import RxCocoa

class MenuContainerViewController2: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuBar: MenuBarView2!
    
    var menuContentPresenter: MenuContainerPresenter2?
    var menuBarPresenter: MenuBarPresenter2?
    
    let disposeBag = DisposeBag()
    
    var pageVC: MenuContentPageViewController2?
    
    func inject(menuContentPresenter: MenuContainerPresenter2, menuBarPresenter: MenuBarPresenter2, contentPageVC: MenuContentPageViewController2) {
        self.menuContentPresenter = menuContentPresenter
        self.menuBarPresenter = menuBarPresenter
        self.pageVC = contentPageVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurateContent()
        self.configurateTabMenu()
        
        self.setUpInputsObservable()
        self.setUpOutputsObservable()
    }
    
    private func setUpInputsObservable() {
        
    }
    private func setUpOutputsObservable() {
        
        self.menuContentPresenter?.outputs.swipedLeftWithIndex
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { index in
                self.menuBarPresenter?.inputs.indexOfLeftSwiped.onNext(index)
            }).disposed(by: disposeBag)
        
        self.menuContentPresenter?.outputs.swipedRightWithIndex
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { index in
                self.menuBarPresenter?.inputs.indexOfRightSwiped.onNext(index)
            }).disposed(by: disposeBag)
        
        self.menuBarPresenter?.outputs.selectedMenus
            .subscribe(onNext: { menus in
                self.menuContentPresenter?.inputs.selectedMenus.onNext(menus)
            }).disposed(by: disposeBag)
        
        self.menuBar.presenter?.outputs.pushOutMenuFromBefore
            .subscribe(onNext: { menu in
                self.menuContentPresenter?.inputs.pushOutMenuFromBefore.onNext(menu)
            }).disposed(by: disposeBag)
        self.menuBar.presenter?.outputs.pushOutMenuFromAfter
            .subscribe(onNext: { menu in
                self.menuContentPresenter?.inputs.pushOutMenuFromAfter.onNext(menu)
            }).disposed(by: disposeBag)
        
    }

    
    private func configurateContent() {
        
        self.displayMenuPageView()
        self.displayButtomBorder()
    }
    
    private func displayMenuPageView() {
        
        guard let pageVC = pageVC else {
            return
        }
        pageVC.inject(presenter: self.menuContentPresenter!)
        
        pageVC.view.frame = contentView.frame
        contentView.addSubview(pageVC.view)
        pageVC.didMove(toParentViewController: self)
        self.addChildViewController(pageVC)
    }
    
    private func displayButtomBorder() {
        
        let bottomBorder = CALayer()
        let borderHight: CGFloat = 2.0
        bottomBorder.frame = CGRect(x: 0, y: contentView.frame.height - borderHight, width: contentView.bounds.width, height: borderHight)
        bottomBorder.backgroundColor = UIColor.MenuBar.border.cgColor
        
        self.contentView.layer.addSublayer(bottomBorder)
    }
    
    func configurateTabMenu() {
        
        menuBar.dataSource = menuBar
        menuBar.delegate   = menuBar
        menuBar.inject(self.menuBarPresenter!)
        
        menuBar.backgroundColor = UIColor.MenuBar.backgroud
    }
}


