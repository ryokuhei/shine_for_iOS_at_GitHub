//
//  SideMenuViewController.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/05.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol SlideMewControllerDelegate {
    func showSlideMenuViewController()
    func hideSlideMenuViewController()
}
class SlideMenuViewController: UIViewController {
    
    @IBOutlet weak var slideMenuView: SlideMenuView!
    @IBOutlet weak var signOutButton: UIButton!

    var presenter: SlideMenuPresenter!
    var wireframe: SlideMenuWireFrame!
    
    var disposeBag = DisposeBag()

    public func inject(_ presenter: SlideMenuPresenter, _ wireframe: SlideMenuWireFrame) {
        self.presenter = presenter
        self.wireframe = wireframe
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureDisplay()
        
        self.setupOutpus()
        self.setupInputs()
    }
    
    private func configureDisplay() {
        
        let frame = self.slideMenuView.frame
        self.slideMenuView.frame = CGRect(x: -frame.width , y: 0, width: frame.width, height: frame.height)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideSlideMenuView))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
//        let swipeOfLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.hideSlideMenuView))
//        swipeOfLeftGesture.direction = .left
//        self.slideMenuView.addGestureRecognizer(swipeOfLeftGesture)
//        swipeOfLeftGesture.delegate = self
        
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.swipeGesture(sender:)))
        self.slideMenuView.addGestureRecognizer(dragGesture)

    }
    
    @objc func swipeGesture(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
            
        case .began:
            break
        case .changed:
            let currentPoint = sender.translation(in: self.view)
            let moveDistance = CGPoint(x: slideMenuView.center.x + currentPoint.x, y: slideMenuView.center.y)

            self.slideMenuView.center = moveDistance
            
            if self.slideMenuView.frame.width < self.slideMenuView.frame.maxX {
                self.slideMenuView.frame = CGRect(x: 0, y: 0, width: slideMenuView.frame.width, height: slideMenuView.frame.height)
            }
        case .ended:
            let currentPoint = sender.translation(in: self.view)
            let moveDistance = CGPoint(x: slideMenuView.center.x + currentPoint.x, y: slideMenuView.center.y)
            if moveDistance.x < 0 {
                hideSlideMenuView()
            } else {
                showSlideMenuView()
            }
        default:
            break
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    
    }

    private func setupInputs() {
        
        let buttonTap = signOutButton.rx.tap
        buttonTap.bind(to: self.presenter.inputs.signOutButton)
            .disposed(by: disposeBag)
    }
    
    private func setupOutpus() {
        
        self.presenter.outputs.signOut
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] _ in
                self.wireframe.showLoginViewController()
            })
            .disposed(by: disposeBag)
    }
    
    @objc public func showSlideMenuView() {
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        self.beginAppearanceTransition(true, animated: true)
        self.view.isHidden = false
        
//        self.view.frame = CGRect(x: -frame.width, y: 0, width: frame.width, height: frame.height)
        let frame = self.slideMenuView.frame
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.slideMenuView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            }, completion: { [unowned self] _ in
                self.endAppearanceTransition()
        })
    }
    
    @objc public func hideSlideMenuView() {
        
        self.beginAppearanceTransition(true, animated: true)
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            let frame = self.slideMenuView.frame
            self.slideMenuView.frame = CGRect(x: -frame.width , y: 0, width: frame.width, height: frame.height)
            
            }, completion: { [unowned self] _ in
                self.view.isHidden = true
                self.endAppearanceTransition()
                
        })
    }
    
}

extension SlideMenuViewController: UIGestureRecognizerDelegate {
    
    // disabled tap content view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view == self.view else {
            return false
        }
        return true
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if otherGestureRecognizer is UIPanGestureRecognizer {
//            return true
//        }
//
//        return false
//    }
    
}
