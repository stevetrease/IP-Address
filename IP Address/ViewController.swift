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
    @IBOutlet var linkLayerfilterSwitch: UISwitch!
    
        
    private var interfaces = Interface.allInterfaces()
    private var refresher: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        
        // setup pull to refresh
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString (string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(refreshAndSortAndFilterData), for: .valueChanged)
        
        // let hostname = "www.trease.eu"
        // let dns = DNSLookup.lookup(hostname)
        // print (hostname + ":" + dns)
        
        // let ip = "8.8.8.8"
        // let dnsName = DNSLookup.reverseLookup(ip)
        // print (ip + ":" + dnsName)
        
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
        
        return cell
    }
    
    
    // Toggle switches toggled
    @IBAction func switchToggled(_ sender: UISwitch) {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        if (sender == IPv6filterSwitch) {
            if (IPv6filterSwitch.isOn) {
                linkLayerfilterSwitch.isEnabled = true
            } else {
                linkLayerfilterSwitch.isEnabled = false
            }
        }
        refreshAndSortAndFilterData()
    }
    
    
    @objc func refreshAndSortAndFilterData () {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        interfaces = Interface.allInterfaces()
        
        var IPv4Interfaces = interfaces.filter { $0.family == .ipv4 }
        var IPv6Interfaces = interfaces.filter { $0.family == .ipv6 }
        
        print ("\(IPv4Interfaces.count) \(IPv6Interfaces.count) \(interfaces.count)")
        
        if (!IPv4filterSwitch.isOn) {
            IPv4Interfaces = []
        }
        if (!IPv6filterSwitch.isOn) {
            IPv6Interfaces = []
        } else {
            if (!linkLayerfilterSwitch.isOn) {
                IPv6Interfaces = IPv6Interfaces.filter { !($0.address?.hasPrefix ("fe80"))! }
            }
        }
        
        interfaces = IPv4Interfaces + IPv6Interfaces
        
        interfaces.sort {
            if $0.description == $1.description { return $0.address! < $1.address! }
            return $0.description < $1.description
        }
        
        print (interfaces.count)
        tableView.reloadData()
        refresher.endRefreshing()
    }
}
