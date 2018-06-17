//
//  UserDataStore.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/28.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseDatabase

protocol UserProfileDataStore {
    
    func fetch(by key: String) ->Single<UserProfileEntity>
    func write(user entity: UserProfileEntity) ->Single<UserProfileEntity>
    func update(user entity: UserProfileEntity) ->Single<UserProfileEntity>
    func remove(by key: String) ->Single<Bool>
}

class FBUserProfileDataStoreImpl: BaseDataStore, UserProfileDataStore {

    lazy var usersReference: DatabaseReference = {
        return Database.database().reference()
            .child("users")
            .child("profiles")
    }()

    func fetch(by key: String) ->Single<UserProfileEntity> {
    
        return Single.create {
          [unowned self] (observer) ->Disposable in
            self.usersReference.child(key)
                .observe(.value, with: {
                  (snapshot) in
                    let userEntity = UserProfileEntity(snapshot: snapshot)
                    observer(.success(userEntity))
                })
            return Disposables.create()
        }
    }
    

    func write(user entity: UserProfileEntity) ->Single<UserProfileEntity> {
        
        return Single.create { [unowned self] observer in
            self.usersReference
                .childByAutoId()
                .setValue(entity.toAnyObject()) {
                  (error, dataRef) in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    dataRef.observeSingleEvent(of: .value) {
                        (snapshot) in
                            let userEntity = UserProfileEntity(snapshot: snapshot)
                            observer(.success(userEntity))
                    }
                }

            return Disposables.create()
        }
    }
    
    func update(user entity: UserProfileEntity) ->Single<UserProfileEntity> {
        return Single.create {
          [unowned self] (observer) ->Disposable in
            self.usersReference
                .child(entity.key)
                .updateChildValues(entity.toAnyObject() as! [AnyHashable : Any]) {
                  (error, dataRef) in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    dataRef.observeSingleEvent(of: .value) {
                        (snapshot) in
                        let userEntity = UserProfileEntity(snapshot: snapshot)
                        observer(.success(userEntity))
                    }
            }
            
            return Disposables.create()
        }
    }
    
    func remove(by key: String) ->Single<Bool> {
        return Single.create {
            [unowned self] (observer) ->Disposable in
            self.usersReference
                .child(key)
                .removeValue {
                  (error, dataRef) in
                    if let error = error {
                      observer(.error(error))
                      return
                    }
                    observer(.success(true))
                }
            return Disposables.create()
        }
    }
    
}
