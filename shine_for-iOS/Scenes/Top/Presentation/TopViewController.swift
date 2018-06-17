//
//  TopViewController.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/05.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class TopViewController: UIViewController {
    
    var slideMenuViewController: SlideMenuViewController? {
        didSet {
            self.addChildViewController(slideMenuViewController!)
            self.view.addSubview(slideMenuViewController!.view)
            slideMenuViewController!.didMove(toParentViewController: self)
            slideMenuViewController?.view.isHidden = true
        }
    }
    var contentViewController: UIViewController? {
        didSet {
            self.addChildViewController(contentViewController!)
            self.view.addSubview(contentViewController!.view)
            contentViewController!.didMove(toParentViewController: self)
        }
    }
    
    var presenter: TopPresenter?
    var wireframe: TopWireFrame?
    var disposeBag = DisposeBag()
    
    func inject(wireframe: TopWireFrame, presenter: TopPresenterImpl) {
        self.wireframe = wireframe
        self.presenter = presenter
    }
    func setViewController(slideMenuVC: SlideMenuViewController, contentVC: UIViewController) {
        self.slideMenuViewController = slideMenuVC
        self.contentViewController = contentVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewConfigure()
        
        self.setInputsObservable()
        self.setOutputsObservable()
    }
    
    private func viewConfigure() {
        
        let slideMenuButton = UIBarButtonItem(image: UIImage(named: "slide_menu_icon"), style: .plain, target: nil, action: nil)
        slideMenuButton.tintColor = UIColor.SlideMenu.icon
        self.navigationItem.leftBarButtonItem = slideMenuButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    
    private func setInputsObservable() {
        let tapSlideMenuButton = self.navigationItem.leftBarButtonItem?.rx.tap
        tapSlideMenuButton?.bind(to: self.presenter!.inputs.tapSlideMenuButton)
        .disposed(by: disposeBag)
        
        let tapAddButton = self.navigationItem.rightBarButtonItem?.rx.tap
        tapAddButton?.bind(to: self.presenter!.inputs.tapAddButton)
        .disposed(by: disposeBag)
        
    }
    
    private func setOutputsObservable() {
        
        self.presenter?.outputs.tapedSlideMenuButton
            .subscribe(onNext: {[unowned self] _ in
                if self.slideMenuViewController!.view.isHidden {
                    self.view.bringSubview(toFront: self.slideMenuViewController!.view)
                    self.slideMenuViewController?.showSlideMenuView()
                } else {
                    self.slideMenuViewController?.hideSlideMenuView()
                }
            })
            .disposed(by: disposeBag)
        
        self.presenter?.outputs.tapedAddButton
            .subscribe(onNext: {[unowned self] _ in
                self.wireframe?.showAddUserViewController()
            })
            .disposed(by: disposeBag)
    }
}

