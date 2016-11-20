//
//  GithubRepositoryItemCell.swift
//  SimpleGithubRepositorySearch
//
//  Created by Kei Takahashi on 2016/11/20.
//  Copyright © 2016年 dameleon. All rights reserved.
//

import UIKit

class GithubRepositoryItemCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    
    func setName(name: String) {
        self.name.text = name
    }
}
