//
//  GroupRepository.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/31.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation


import Foundation
import Foundation
import RxCocoa
import RxSwift
import FirebaseDatabase
import FirebaseAuth

protocol GroupDataStore {
    
    func fetchAll() ->Single<[GroupEntity]>
}

class FBGroupDataStoreImpl: BaseDataStore, GroupDataStore {
    
    lazy var groupReference: DatabaseReference = {
        return Database.database().reference().child("groups")
    }()
    
    func fetchAll() ->Single<[GroupEntity]> {
        
        return Single.create {
            [unowned self] (observer) ->Disposable in
            self.groupReference
                .queryOrderedByKey()
                .observe(.value, with: {
                  (snapshot) in
                    var groupEntityList: [GroupEntity] = []

                    let children = snapshot.children
                    while let groupSnapshot = children.nextObject() as? DataSnapshot {

                        if groupSnapshot.value as! Bool {
                            
                            let groupEntity = GroupEntity(snapshot: groupSnapshot)
                            groupEntityList.append(groupEntity)
                        }
                    }
                    observer(.success(groupEntityList))
                })

            return Disposables.create()
        }
    }
    
}
