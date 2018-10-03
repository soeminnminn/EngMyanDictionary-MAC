//
//  AppDelegate.swift
//  engmyan
//
//  Created by Soe Minn Minn on 7/10/18.
//  Copyright © 2018 S16. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if #available(OSX 10.12.2, *) {
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    var contentViewController: NSViewController? {
        get {
            return NSApplication.shared.mainWindow?.contentViewController
        }
    }
    
    @IBAction func toggleSourceList(_ sender: Any) {
        if let mainViewController = self.contentViewController as? MainViewController {
            mainViewController.onToggleSourceList(sender)
            if let menuItem = sender as? NSMenuItem {
                menuItem.title = mainViewController.isSidebarCollapsed ? "Show Sidebar" : "Hide Sidebar"
            }
        }
        
    }
    
    @IBAction func manageBookmarks(_ sender: Any) {
        if let mainViewController = self.contentViewController as? MainViewController {
            mainViewController.onManageBookmarks(sender)
        }
    }
    
    @IBAction func recents(_ sender: Any) {
        if let mainViewController = self.contentViewController as? MainViewController {
            mainViewController.onRecents(sender)
        }
    }
 
    @IBAction func copy(_ sender: Any) {
        if let mainViewController = self.contentViewController as? MainViewController {
            mainViewController.onCopy(sender)
        }
    }
}

