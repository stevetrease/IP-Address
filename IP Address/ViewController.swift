//
//  ViewController.swift
//  IP Address
//
//  Created by Steve on 13/10/2017.
//  Copyright © 2017 Steve. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var IPv4filterSwitch: UISwitch!
    @IBOutlet var IPv6filterSwitch: UISwitch!
    
        
    var interfaces = Interface.allInterfaces()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshAndSortAndFilterData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interfaces.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.text = interfaces[indexPath.row].description
        cell.detailTextLabel?.text = interfaces[indexPath.row].address
        
        // print ("\(interfaces[indexPath.row].debugDescription)")
        
        return cell
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        refreshAndSortAndFilterData()
        self.tableView.reloadData()
    }
    
    
    // screen tap to refresh 
    @IBAction func screenTappedTriggered(sender: AnyObject) {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        refreshAndSortAndFilterData()
        self.tableView.reloadData()
    }
    
    
    func refreshAndSortAndFilterData () {
        interfaces = Interface.allInterfaces()
        
        let IPv4Interfaces = interfaces.filter { $0.family == .ipv4 }
        let IPv6Interfaces = interfaces.filter { $0.family == .ipv6 }
        
        print ("\(IPv4Interfaces.count) \(IPv6Interfaces.count) \(interfaces.count)")
        
        interfaces = []
        if (IPv4filterSwitch.isOn) {
            interfaces = interfaces + IPv4Interfaces
        }
        if (IPv6filterSwitch.isOn) {
            interfaces = interfaces + IPv6Interfaces
        }
        
        print (interfaces.count)
        
        interfaces.sort {
            if $0.description == $1.description { return $0.address! < $1.address! }
            return $0.description < $1.description
        }
    }
}
