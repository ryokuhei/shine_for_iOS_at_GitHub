//
//  AddUserPresenter.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/04/01.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol AddUserInputs {
    
    // properties
    var name: Variable<String?> {get}
    var id: Variable<String?> {get}
    var email: Variable<String?> {get}
    var comment: Variable<String?> {get}
    var icon: Variable<Data?> {get}
    var iconFileName: Variable<String?> {get}
    var isUploadedIcon: Variable<Bool> {get}
    
    // Events
    var tapDoneBuutton: PublishSubject<Void> {get}
    var tapBackBuutton: PublishSubject<Void> {get}
}

protocol AddUserOutputs {
    
    var icon: Variable<Data?> {get}
    var isRegistering: Variable<Bool> {get}
    var registeredUser: Observable<Bool> {get}
    var back: Observable<Void> {get}
}

protocol AddUserPresenter {
    var inputs: AddUserInputs {get}
    var outputs: AddUserOutputs {get}
}

class AddUserPresenterImpl: BasePresetner, AddUserPresenter, AddUserInputs, AddUserOutputs {

    lazy var inputs: AddUserInputs = {self}()
    lazy var outputs: AddUserOutputs = {self}()
    
    var usecase: AddUserUseCase
    
    var id = Variable<String?>("")
    var name = Variable<String?>("")
    var email = Variable<String?>("")
    var comment = Variable<String?>("")
    var icon = Variable<Data?>(nil)
    var iconFileName = Variable<String?>(nil)
    
    var isRegistering = Variable<Bool>(false)
    var isUploadedIcon = Variable<Bool>(false)
    
    var tapDoneBuutton = PublishSubject<Void>()
    var tapBackBuutton = PublishSubject<Void>()
    
    lazy var back: Observable<Void> = {
        return tapBackBuutton
    }()
    
    lazy var user: Observable<UserModel> = {
        return Observable.combineLatest(name.asObservable(),
                                        id.asObservable(),
                                        email.asObservable(),
                                        comment.asObservable(),
                                        icon.asObservable(),
                                        iconFileName.asObservable()
        ) {
            (name, id ,email, comment, icon, iconFileName) ->UserModel in
            return UserModel(key: "",
                             id: id!,
                             name: name!,
                             email: email!,
                             comment: comment,
                             icon: icon,
                             iconFileName: iconFileName)
            }
    }()
    
    lazy var registeredUser: Observable<Bool> = {
        return tapDoneBuutton
            .withLatestFrom(self.user) { $1 }
            .filter {
              [unowned self] (user) in
                return user.name.count >= 1
            }
            .do(onNext: { _ in
                self.isRegistering.value = true
            })
            .flatMap {
              [unowned self] (user) in
                return self.usecase.register(user: user, self.isUploadedIcon.value)
            }
            .do(onNext:{ _ in
                self.isRegistering.value = false
            }, onError: { _ in
                self.isRegistering.value = false
            }, onCompleted: { () in
                self.isRegistering.value = false
            })
    }()
    
    init(usecase: AddUserUseCase) {
        self.usecase = usecase
        
        super.init()
    }
    
}
