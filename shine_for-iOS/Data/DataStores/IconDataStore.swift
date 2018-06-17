//
//  IconDataStore.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/04/20.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseStorage

protocol IconDataStore {
    func save(_ data: Data, of fileName: String, to directory: StorageDirectory) ->Completable
    func load(of fileName: String, from directory: StorageDirectory) ->Single<Data>
    func delete(of fileName: String, from directory: StorageDirectory) ->Completable
}

class FBIconDataStoreImpl: BaseRepository, IconDataStore {

    lazy var iconReference: StorageReference = {
        return Storage.storage()
            .reference(forURL: "gs://shine-for-ios.appspot.com")
            .child("images")
            .child("icon")
    }()

    func save(_ data: Data, of fileName: String, to directory: StorageDirectory) ->Completable {
        return Completable.create {
          [unowned self] observer in
            let uploadReference = self.iconReference.child(directory.rawValue).child(fileName)
            let uploadTask = uploadReference.putData(data)
            uploadTask.observe(.success) { snapshot in
                observer(.completed)
            }
            uploadTask.observe(.failure) { snapshot in
                observer(.error(snapshot.error!))
                
            }
            return Disposables.create()
        }
    }
    
    func load(of fileName: String, from directory: StorageDirectory) ->Single<Data> {
        return Single.create {
            [unowned self] observer in
              let uploadReference = self.iconReference.child(directory.rawValue).child(fileName)
            uploadReference.getData(maxSize: 5 * 1024 * 1024, completion: {
                (data, error) in
                if let error = error {
                    observer(.error(error))
                    return
                }
                guard let data = data else {
                    observer(.error(NSError(domain: "not exist file", code: -1, userInfo: nil)))
                    return
                }
                observer(.success(data))
              })
            return Disposables.create()
        }
    }
    
    func delete(of fileName: String, from directory: StorageDirectory) ->Completable {
        
        return Completable.create {
            [unowned self] observer in
            let uploadReference = self.iconReference.child(directory.rawValue).child(fileName)
            uploadReference.delete(completion: {
                (error) in
                if let error = error {
                    observer(.error(error))
                    return
                }
                observer(.completed)
            })
            return Disposables.create()
        }
    }
}
