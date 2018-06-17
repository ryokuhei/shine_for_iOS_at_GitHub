//
//  IconRepository.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/04/20.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol IconRepository {
    func save(_ data: Data, of fileName: String, to directory: StorageDirectory) ->Completable
    func copy(_ fileName: String, to directory: StorageDirectory, from fromDrectory: StorageDirectory) ->Completable
    func load(_ fileName: String, from directory: StorageDirectory) ->Single<Data>
    func delete(_ fileName: String, from directory: StorageDirectory) ->Completable
}

class IconRepositoryImpl: BaseRepository, IconRepository {

    let icon: IconDataStore
    
    init(icon: IconDataStore) {
        self.icon = icon
    }
    
    func save(_ data: Data, of fileName: String, to directory: StorageDirectory) ->Completable {
        return self.icon.save(data, of: fileName, to: directory)
    }
    
    func copy(_ fileName: String, to toDirectory: StorageDirectory, from fromDirectory: StorageDirectory) ->Completable {

        return Completable.create { observer in
            self.icon.load(of: fileName, from: fromDirectory)
                .subscribe(onSuccess: {
                  (data) in
                    self.icon.save(data, of: fileName, to: toDirectory)
                        .subscribe(onCompleted: {
                            () in
                            observer(.completed)
                        }
                         , onError: {
                            (error) in
                            observer(.error(error))
                        }
                    ).dispose()
                }, onError: {
                    (error) in
                        observer(.error(error))
                }).dispose()
            return Disposables.create()
        }
    }
    
    func load(_ fileName: String, from directory: StorageDirectory) ->Single<Data> {
        return self.icon.load(of: fileName, from : directory)
    }
    
    func delete(_ fileName: String, from directory: StorageDirectory) ->Completable {
        return self.icon.delete(of: fileName, from : directory)
    }
    
}
