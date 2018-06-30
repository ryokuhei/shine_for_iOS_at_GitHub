//
//  EditPresenter.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/28.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol EditInputs {
    
    // properties
    var key: Variable<String?> {get}
    var name: Variable<String?> {get}
    var id: Variable<String?> {get}
    var email: Variable<String?> {get}
    var comment: Variable<String?> {get}
    var icon: Variable<Data?> {get}
    var iconFileName: Variable<String?> {get}
    var group: Variable<String?> {get}
    var isUploadedIcon: Variable<Bool> {get}
    
    // Events
    var uploadIcon: PublishSubject<Data> {get}
    var tapDoneBuutton: PublishSubject<Void> {get}
    
    func setSubject(of user: UserModel, and icon: Data?)
}

protocol EditOutputs {

    var key: Variable<String?> {get}
    var name: Variable<String?> {get}
    var id: Variable<String?> {get}
    var email: Variable<String?> {get}
    var comment: Variable<String?> {get}
    var icon: Variable<Data?> {get}
    
    var isUpdating: Variable<Bool> {get}
    var updatedUser: Observable<Bool> {get}
}

protocol EditPresenter {
    var inputs: EditInputs {get set}
    var outputs: EditOutputs {get}
}

class EditPresenterImpl: BasePresetner,EditPresenter, EditInputs, EditOutputs {

    lazy var inputs: EditInputs = { self }()
    lazy var outputs: EditOutputs = { self }()
    
    var usecase: EditUseCase
    
    // properties
    var key = Variable<String?>("")
    var id = Variable<String?>("")
    var name = Variable<String?>("")
    var email = Variable<String?>("")
    var comment = Variable<String?>("")
    var group = Variable<String?>(nil)
    var icon = Variable<Data?>(nil)
    var iconFileName = Variable<String?>(nil)
    
    var isUploadedIcon = Variable<Bool>(false)
    var isUpdating = Variable<Bool>(false)

    // events
    var uploadIcon = PublishSubject<Data>()
    var tapDoneBuutton = PublishSubject<Void>()
    
    lazy var user: Observable<UserModel> = {
        return Observable.combineLatest(
                          key.asObservable(),
                          name.asObservable(),
                          id.asObservable(),
                          email.asObservable(),
                          comment.asObservable(),
                          icon.asObservable(),
                          iconFileName.asObservable(),
                          group.asObservable()) {
                            (key, name, id ,email, comment, icon, iconFileName, group) ->UserModel in
                            return UserModel(key: key!,
                                             id: id!,
                                             name: name!,
                                             email: email!,
                                             comment: comment,
                                             icon: icon,
                                             iconFileName: iconFileName,
                                             group: group)
                          }
    }()

    lazy var updatedUser: Observable<Bool> = {
        return tapDoneBuutton
            .withLatestFrom(self.user) { $1 }
            .filter {
                [unowned self] (user) in
                return user.name.count >= 1
            }
           .do(onNext: { _ in
               self.isUpdating.value = true
           })
            .flatMap {
                [unowned self] (user) in
                return self.usecase.update(user: user, self.isUploadedIcon.value)
            }
            .do(onNext:{ _ in
                self.isUpdating.value = false
            }, onError: { _ in
                self.isUpdating.value = false
            }, onCompleted: { () in
                self.isUpdating.value = false
            })
    }()
    
    init(usecase: EditUseCase) {
        self.usecase = usecase
        super.init()
    }
    
    func setSubject(of user: UserModel, and icon: Data? = nil) {
        self.key.value = user.key
        self.name.value = user.name
        self.email.value = user.email
        self.comment.value = user.comment
        self.iconFileName.value = user.iconFileName
        self.group.value = user.group
        self.icon.value = icon
    }
}
