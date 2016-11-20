//
//  ViewController.swift
//  SimpleGithubRepositorySearch
//
//  Created by Kei Takahashi on 2016/11/20.
//  Copyright © 2016年 dameleon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var disposeBag: DisposeBag! = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rx
            .setDelegate(self)
            .addDisposableTo(self.disposeBag)
        
        let searchResult = self.searchBar.rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .map { $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "" }
            .flatMapLatest { query -> Observable<[String]> in
                if (query.isEmpty) {
                    return Observable.just([])
                } else {
                    let url = URL(string: "https://api.github.com/search/repositories?q=\(query)")!
                    return URLSession.shared.rx.json(url: url)
                        .map {
                            let res = $0 as AnyObject
                            let items = res.object(forKey: "items")! as? [AnyObject] ?? []
                            return items.map { $0.object(forKey: "full_name") as! String }
                        }
                }
            }
        
        searchResult
            .observeOn(MainScheduler.instance)
            .bindTo(self.tableView.rx.items(cellIdentifier: "GithubRepositoryItemCell", cellType: GithubRepositoryItemCell.self)) { (row, element, cell) in
                cell.setName(name: element)
            }
            .addDisposableTo(self.disposeBag)
    }
}
