//
//  MomentsViewController.swift
//  YoYo
//
//  Created by CavanSu on 2019/8/7.
//  Copyright © 2019 Agora. All rights reserved.
//

import UIKit

class MomentsViewController: UITableViewController {
    private lazy var list = [Moment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 55
    }
    
    func append(content: String, from user: User) {
        let moment = Moment(user: user, content: content)
        list.insert(moment, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .none)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentCell", for: indexPath) as! MomentCell
        let moment = list[indexPath.row]
        cell.update(moment)
        return cell
    }
}
