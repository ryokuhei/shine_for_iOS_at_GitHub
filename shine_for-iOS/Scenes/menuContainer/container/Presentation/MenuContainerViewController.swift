//
//  FirstCharactersMenuBarViewController.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/11.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MenuContainerViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuBar: MenuBarView!
    var pageViewController: MenuPageViewController = MenuPageViewControllerBuilder.build()

    var presenter: MenuContainerPresenter?
    
    let disposeBag = DisposeBag()

    func inject(presenter: MenuContainerPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurateContent()
        self.configurateTabMenu()
        
        self.setOutputObservable()
    }
    
    func configurateContent() {
        
        pageViewController.inject(presenter: presenter!)
        pageViewController.view.frame = contentView.frame
        contentView.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
        self.addChildViewController(pageViewController)
        
        let bottomBorder = CALayer()
        let borderHight: CGFloat = 2.0
        bottomBorder.frame = CGRect(x: 0, y: contentView.frame.height - borderHight, width: contentView.bounds.width, height: borderHight)
        bottomBorder.backgroundColor = UIColor.MenuBar.border.cgColor

        pageViewController.view.layer.addSublayer(bottomBorder)
    }
    
    func configurateTabMenu() {
        menuBar.dataSource = menuBar
        menuBar.delegate   = menuBar
        menuBar.inject(presenter!)
        
        menuBar.backgroundColor = UIColor.MenuBar.backgroud
    }
    
    
    func setOutputObservable() {
        
        presenter?.outputs.contentIndexOfCurrent
            .subscribe(onNext: {
              [unowned self] (index) in
                if let index = index {
                    self.menuBar.selectMenu(index: index)
                }
            })
            .disposed(by: disposeBag)
        
        presenter?.outputs.menuList
            .subscribe(onNext: {
              [unowned self] (menuList) in
                MenuManager.menuList = menuList
                self.menuBar.reloadData()
            })
            .disposed(by: disposeBag)
        
    }
}


