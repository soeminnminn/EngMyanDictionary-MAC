//
//  ManageBookmarksViewController.swift
//  engmyan
//
//  Created by Soe Minn Minn on 10/3/18.
//  Copyright © 2018 S16. All rights reserved.
//

import Cocoa

class ManageBookmarksViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension ManageBookmarksViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 0
    }
    
}

extension ManageBookmarksViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 24.0
    }
    
}
