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
    
    func fetch(by key: Group) ->Observable<UserGroupEntity>
    func append(user entity: UserProfileEntity, to group: Group) ->Completable
    func move(user entity: UserProfileEntity, to toGroup: Group, from fromGroup: Group) ->Completable
    func remove(user entity: UserProfileEntity, from group: Group) ->Completable
}

class FBUserGroupDataStoreImpl: BaseDataStore, UserGroupDataStore {

    lazy var groupReference: DatabaseReference = {
        return Database.database()
            .reference()
            .child("users")
            .child("groups")
    }()
    
    func fetch(by key: Group) ->Observable<UserGroupEntity> {

        return Observable.create {
          [unowned self] (observer) ->Disposable in
            self.groupReference
                .child(key.byKey())
                .queryOrdered(byChild: "name")
                .observe(.value, with: {
                  (snapshot) in
                    let groupEntity = UserGroupEntity(snapshot: snapshot)
                    observer.onNext(groupEntity)
                })
            
            return Disposables.create()
        }
    }
    
    func append(user entity: UserProfileEntity, to group: Group) ->Completable {

        return Completable.create {
          [unowned self] (observer) ->Disposable in

            self.groupReference
                .child(group.byKey())
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
    
    func remove(user entity: UserProfileEntity, from group: Group) ->Completable {
        
        return Completable.create {
            [unowned self] observer in
            self.groupReference
                .child(group.byKey())
                .child(entity.key)
                .removeValue {
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
    
    func move(user entity: UserProfileEntity, to group: Group, from currentGroup: Group) ->Completable {
        
        return Completable.create { observer in
            
           _ = self.remove(user: entity, from: currentGroup)
            .subscribe(onCompleted: {
               _ = self.append(user: entity, to: group)
                .subscribe(onCompleted: { observer(.completed)
                }, onError: { error in observer(.error(error))})
            }, onError: { error in observer(.error(error))})

            return Disposables.create()
        }
    }
    
    private func convertJson(user: (key: String, name: String)) ->Any {
        let json = ["name" : user.name]
        return json
    }

}
