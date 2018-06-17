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
    var tapDoneBuutton: PublishSubject<Void> {get}
    var tapBackBuutton: PublishSubject<Void> {get}
    var name: Variable<String?> {get}
    var id: Variable<String?> {get}
    var email: Variable<String?> {get}
    var comment: Variable<String?> {get}
}
protocol AddUserOutputs {
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
    
    var name = Variable<String?>("")
    var id = Variable<String?>("")
    var email = Variable<String?>("")
    var comment = Variable<String?>("")
    
    var tapDoneBuutton = PublishSubject<Void>()
    var tapBackBuutton = PublishSubject<Void>()
    
    lazy var back: Observable<Void> = {
        return tapBackBuutton
    }()
    
    lazy var user: Observable<UserModel> = {
        return Observable.combineLatest(name.asObservable(),
                                        id.asObservable(),
                                        email.asObservable(),
                                        comment.asObservable()) {
            (name, id ,email, comment) ->UserModel in
            return UserModel(key: "", id: id!, name: name!, email: email!, comment: comment)
            }
    }()
    
    lazy var registeredUser: Observable<Bool> = {
        return tapDoneBuutton
            .withLatestFrom(self.user) { $1 }
            .filter {
              [unowned self] (user) in
                return user.name.count >= 1
            }
            .flatMap {
              [unowned self] (user) in
                return self.usecase.register(user: user)
            }
    }()
    
    init(usecase: AddUserUseCase) {
        self.usecase = usecase
        
        super.init()
    }
    
}
