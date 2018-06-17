//
//  GroupDataStore.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/29.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import Foundation
import RxCocoa
import RxSwift
import FirebaseDatabase
import FirebaseAuth

protocol UserGroupDataStore {
    
    func fetch(by key: String) ->Observable<UserGroupEntity>
    func append(user entity: UserProfileEntity, _ toKey: String) ->Completable
    func move(user entity: UserProfileEntity, _ fromKey: String, _ toKey: String) ->Completable
    func remove(user entity: UserProfileEntity, _ fromKey: String) ->Completable
}

class FBUserGroupDataStoreImpl: BaseDataStore, UserGroupDataStore {

    lazy var groupReference: DatabaseReference = {
        return Database.database()
            .reference()
            .child("users")
            .child("groups")
    }()
    
    func fetch(by key: String) ->Observable<UserGroupEntity> {

        return Observable.create {
          [unowned self] (observer) ->Disposable in
            self.groupReference
                .child(key)
                .queryOrdered(byChild: "name")
                .observe(.value, with: {
                  (snapshot) in
                    let groupEntity = UserGroupEntity(snapshot: snapshot)
                    observer.onNext(groupEntity)
                })
            
            return Disposables.create()
        }
    }
    
    func append(user entity: UserProfileEntity, _ toKey: String) ->Completable {

        return Completable.create {
          [unowned self] (observer) ->Disposable in

            self.groupReference
                .child(toKey)
                .child(entity.key)
                .setValue(self.convertJson(user: (key: entity.key, name: entity.name))) {
                  (error, ref) in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    observer(.completed)
            }

            return Disposables.create()
        }
        
    }
    
    func remove(user entity: UserProfileEntity, _ fromKey: String) ->Completable {
        return Completable.create {
          [unowned self] observer in
            self.groupReference.child(fromKey).child(entity.key).removeValue {
              (error, ref) in
                if let error = error {
                    observer(.error(error))
                    return
                }
                observer(.completed)
            }
            
            return Disposables.create()
        }
    }
    
    func move(user entity: UserProfileEntity, _ fromKey: String, _ toKey: String) ->Completable {
        
//        return self.remove(user: entity, fromKey)
//                   .concat(self.append(user: entity, toKey))
        return Completable.create { observer in
//            var removeCompletable = self.remove(user: entity, fromKey)
//            var appendCompletable = self.append(user: entity, toKey)
            _ = self.remove(user: entity, fromKey)
            _ = self.append(user: entity, toKey)
            
            observer(.completed)
            return Disposables.create()
        }
    }
    
    private func convertJson(user: (key: String, name: String)) ->Any {
        let json = ["name" : user.name]
        return json
    }

}
