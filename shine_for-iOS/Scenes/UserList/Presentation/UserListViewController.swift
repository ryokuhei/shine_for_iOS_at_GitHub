//
//  UserListViewController.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/05.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class UserListViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var wireFrame: UserListWireFrame?
    var presenter: UserListPresenter?
    var disposeBag = DisposeBag()
    
    var group: Group?
    
    var userList = [UserListModel]()

    func inject(group: Group?, wireFrame: UserListWireFrame, presenter: UserListPresenter) {
        self.group = group
        
        self.wireFrame = wireFrame
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.setOutputObservable()
        self.setInputObservable()
    }
    
    func setInputObservable() {
        if let group = self.group {
            self.presenter?.inputs.selectUserList.onNext(group)
        }
    }
    
    func setOutputObservable() {
        
        self.presenter?.outputs.showUserDetail
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext:{ [unowned self] userKey in
                self.wireFrame?.showUserDetail(userKey: userKey, menu: self.group!)
            })
            .disposed(by: disposeBag)
        
        self.presenter?.outputs.reloadUserList
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [unowned self] userList in
                self.userList = userList
                self.tableView.reloadData()
                
            })
            .disposed(by: disposeBag)
    }
    
}

extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell") as! UserListCell
        cell.configure(userList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

extension UserListViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let key = userList[indexPath.row].key
        presenter?.inputs.tapUserCell.onNext(key)
    }

}
