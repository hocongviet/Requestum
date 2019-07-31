//
//  DiffUtil.swift
//  Requestum
//
//  Created by Cong Viet Ho on 8/1/19.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import UIKit

struct DiffUtil {
    
    static func getInsertionItems(oldValue: Int, newValue: Int) -> [IndexPath]? {
        if newValue == 0 {
            return [IndexPath()]
        } else {
            let from = oldValue
            let to = newValue - 1
            return Array(from...to).map { IndexPath(item: $0, section: 0) }
        }
    }
    
    static func getDeletionItems(oldValue: Int) -> [IndexPath]? {
        return Array(0...oldValue-1).map { IndexPath(item: $0, section: 0) }
    }
    
    static func reloadTableViewRows(_ tableView: UITableView, atIndexPaths indexPaths: [IndexPath], animation: UITableView.RowAnimation = .none) {
        tableView.performBatchUpdates({
            let oldVal = tableView.numberOfRows(inSection: 0)
            if oldVal != 0 {
                let paths = Array(0...oldVal-1).map { IndexPath(item: $0, section: 0) }
                tableView.deleteRows(at: paths, with: animation)
            }
            tableView.insertRows(at: indexPaths, with: animation)
        }, completion: nil)
    }
}
