//
//  DetailView.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/27.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD

class DetailViewController: UIViewController {
    
    @IBOutlet weak var icon: IconImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var edit: UIButton!

    var key: String?
    var menuGroup: Group?
    
    let disposeBag = DisposeBag()
    
    var presenter: DetailPresenter?
    var wireframe: DetailWireFrame?
    
    func inject(userKey: String, menu group: Group, presenter: DetailPresenter, wireframe: DetailWireFrame) {
        self.presenter = presenter
        self.wireframe = wireframe
        
        self.key = userKey
        self.menuGroup = group
    }
    
    lazy private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.frame = self.navigationController?.view.bounds ?? self.view.bounds
        indicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()

        self.setOutputsObservable()
        self.setInputsObservable()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let key = key  {
            presenter?.inputs.key.onNext(key)
        }
        

    }
    
    func configureView() {

        let editButton = UIBarButtonItem(title: "edit", style: .done, target: nil, action: nil)
        self.navigationItem.setRightBarButton(editButton, animated: true)
        
        let listButton = UIBarButtonItem(title: "< list", style: .done, target: nil, action: nil)
        self.navigationItem.setLeftBarButton(listButton, animated: true)
        
        self.navigationController?.view.addSubview(activityIndicator) ?? self.view.addSubview(activityIndicator)
    }
    
    func setInputsObservable() {

        let editButton2 = edit.rx.tap
        editButton2.bind(to: presenter!.inputs.tapEditBuutton).disposed(by: disposeBag)
        
        let editButton = navigationItem.rightBarButtonItem?.rx.tap
        editButton?.bind(to: presenter!.inputs.tapEditBuutton).disposed(by: disposeBag)
        
        let listButton = navigationItem.leftBarButtonItem?.rx.tap
        listButton?.bind(to: presenter!.inputs.tapListBuutton).disposed(by: disposeBag)
    }
    
    func setOutputsObservable() {
        // properties
        presenter?.outputs.name
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(self.name.rx.text).disposed(by: disposeBag)
        presenter?.outputs.mail
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(self.mail.rx.text).disposed(by: disposeBag)
        presenter?.outputs.comment
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(self.comment.rx.text).disposed(by: disposeBag)
        presenter?.outputs.icon
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: {
                [unowned self] (data) in
                guard let data = data else {
                    self.icon.image = UIImage(named: Assets.no_profile_icon.rawValue)
                    return
                }
                self.icon.image = UIImage(data: data)
            })
            .disposed(by: disposeBag)
        
        // events
        presenter?.outputs.isLoaded
            .asDriver()
            .drive(onNext: {
                isLoaded in
                    if isLoaded {
                        self.activityIndicator.stopAnimating()
                    } else {
                        self.activityIndicator.startAnimating()
                    }
            }).disposed(by: disposeBag)
        
        presenter?.outputs.isIconLoding
            .asDriver()
            .drive(onNext: {
                isLoding in
                if isLoding {
//                    SVProgressHUD.setContainerView(self.icon)
                    SVProgressHUD.resetOffsetFromCenter()
                    SVProgressHUD.setOffsetFromCenter(UIOffset.init(horizontal: 500, vertical: 500))
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            }).disposed(by: disposeBag)
        
        
        presenter?.outputs.showEditView
            .subscribe(onNext:
                { [unowned self] dataOf in
                    self.wireframe?.showEditViewController(user: dataOf.user, icon: dataOf.icon)
            }).disposed(by: disposeBag)
        
        presenter?.outputs.dismissView
            .subscribe(onNext:
                { [unowned self] in
                    self.wireframe?.dismissViewController()
            }).disposed(by: disposeBag)
        

    }
    
}
