//
//  UserListCell.swift
//  shine_for-iOS
//
//  Created by ryoku on 2018/03/26.
//  Copyright © 2018 ryoku. All rights reserved.
//

import Foundation
import UIKit

class UserListCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var key: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ user: UserListModel) {
        self.key = user.key
        self.name.text = user.name
    }
    
}
