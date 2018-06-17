//
//  EditViewController.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/28.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class EditViewController: UIViewController  {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var comment: UITextField!
    
    var doneButton: UIBarButtonItem!
    
    lazy private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.frame = self.navigationController?.view.bounds ?? self.view.bounds
        indicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        return indicator
    }()

    let disposeBag = DisposeBag()
    
    var presenter: EditPresenter?
    var wireframe: EditWireFrame?
    
    func inject(user: UserModel,icon: Data?, presenter: EditPresenter, wireframe: EditWireFrame) {
        self.presenter = presenter
        self.wireframe = wireframe
        
        self.presenter?.inputs.setSubject(of: user, and: icon)
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
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapIcon))
        self.icon.addGestureRecognizer(tapRecognizer)
        
        self.doneButton = UIBarButtonItem(title: "done", style: .done, target: nil, action: nil)
        self.navigationItem.setRightBarButton(doneButton, animated: true)
        
        self.navigationController?.view.addSubview(activityIndicator) ?? self.view.addSubview(activityIndicator)
        
   }
    
    func setInputsObservable() {
        
        let name = self.name.rx.text
        name.bind(to: presenter!.inputs.name).disposed(by: disposeBag)
        let email = self.email.rx.text
        email.bind(to: presenter!.inputs.email).disposed(by: disposeBag)
        let comment = self.comment.rx.text
        comment.bind(to: presenter!.inputs.comment).disposed(by: disposeBag)
        
        let doneButtonTap = self.navigationItem.rightBarButtonItem?.rx.tap
        doneButtonTap?.bind(to: presenter!.inputs.tapDoneBuutton)
            .disposed(by: disposeBag)
        
        

    }
    
    func setOutputsObservable() {

        // properties
        presenter?.outputs.name.asObservable().bind(to: self.name.rx.text).disposed(by: disposeBag)
        presenter?.outputs.email.asObservable().bind(to: self.email.rx.text).disposed(by: disposeBag)
        presenter?.outputs.comment.asObservable().bind(to: self.comment.rx.text).disposed(by: disposeBag)
        presenter?.outputs.icon
            .asDriver()
            .drive(onNext: {
                [unowned self] (data) in
                guard let data = data else {
                    self.icon.image = UIImage(named: Assets.no_profile_icon.rawValue)
                    return
                }
                self.icon.image = UIImage(data: data)
            })
            .disposed(by: disposeBag)
        
        presenter?.outputs.updatedUser
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: {
              [unowned self] result in
                guard result else {
                    return
                }
                self.wireframe?.showDetailViewController()
            })
            .disposed(by: disposeBag)

        presenter?.outputs.isUpdating
            .asDriver()
            .drive(onNext: {
                [unowned self] isUpdating in
                if isUpdating {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    // view touched event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func didTapIcon() {
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) else {
            return
        }
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    // MARK: UIImagePickerDelegate
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let quality: CGFloat = 1.0

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
           let resizeImage = image.resize(size: ObjectSize.icon.size()),
           let uploadData = UIImageJPEGRepresentation(resizeImage, quality) {

            self.presenter?.inputs.icon.value = uploadData
            self.presenter?.inputs.iconFileName.value = self.generateFileName()
            self.presenter?.inputs.isUploadedIcon.value = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func generateFileName() ->String {
        return UUID().uuidString
    }
    
}

extension EditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        name.resignFirstResponder()
        email.resignFirstResponder()
        comment.resignFirstResponder()
        
        return true
    }
    
}
