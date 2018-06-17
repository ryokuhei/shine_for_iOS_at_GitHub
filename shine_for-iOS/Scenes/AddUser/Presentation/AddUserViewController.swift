//
//  AddViewController.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/04/01.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class AddUserViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var icon: UIImageView!
    var backButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    
    var wirefreame: AddUserWireFrame?
    var presenter: AddUserPresenter?
    
    func inject(wireframe: AddUserWireFrame, presenter: AddUserPresenter) {
        self.wirefreame = wireframe
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewConfigure()
        
        self.setOutputsObservable()
        self.setInputsObservable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeNotification()
    }
    
    func configureNotification() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeNotification() {
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    

    func viewConfigure() {
        
        self.name.delegate = self
        self.email.delegate = self
        self.comment.delegate = self
        
        self.icon.image = UIImage(named: Assets.no_profile_icon.rawValue)
        
        self.doneButton = UIBarButtonItem(title: "done", style: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = self.doneButton
        
        self.backButton = UIBarButtonItem(title: "back", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = self.backButton
        
    }
    
    func setInputsObservable() {
        
        let doneButtonTap = self.navigationItem.rightBarButtonItem?.rx.tap
        doneButtonTap?.bind(to: presenter!.inputs.tapDoneBuutton)
            .disposed(by: disposeBag)
        
        let backButtonTap = self.navigationItem.leftBarButtonItem?.rx.tap
        backButtonTap?.bind(to: presenter!.inputs.tapBackBuutton)
            .disposed(by: disposeBag)

        let name = self.name.rx.text
        name.bind(to: presenter!.inputs.name)
        .disposed(by: disposeBag)
        
        let email = self.email.rx.text
        email.bind(to: presenter!.inputs.email)
            .disposed(by: disposeBag)
        
        let comment = self.comment.rx.text
        comment.bind(to: presenter!.inputs.comment)
            .disposed(by: disposeBag)
    }
    
    func setOutputsObservable() {
        self.presenter?.outputs.registeredUser
            .subscribe(onNext: {
                [unowned self] (result) in
                if result {
                    MenuManager.reload()
                    self.wirefreame?.showTopView()
                }
            })
            .disposed(by: disposeBag)
        
        self.presenter?.outputs.back
            .subscribe(onNext: {
                [unowned self] _ in
                    self.wirefreame?.showTopView()
            })
            .disposed(by: disposeBag)
        
    }
    
    // view touched event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
}

extension AddUserViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        name.resignFirstResponder()
        email.resignFirstResponder()
        comment.resignFirstResponder()
        
        return true
    }
    
}
