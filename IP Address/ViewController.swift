//
//  ViewController.swift
//  IP Address
//
//  Created by Steve on 13/10/2017.
//  Copyright © 2017 Steve. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var IPv4filterSwitch: UISwitch!
    @IBOutlet var IPv6filterSwitch: UISwitch!
    @IBOutlet var linkLayerfilterSwitch: UISwitch!
    @IBOutlet var ssidLabel: UILabel!
    @IBOutlet var wifiUsageLabel: UILabel!
    
        
    private var interfaces = Interface.allInterfaces()
    private var refresher: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        
        ssidLabel.text = "none"
        ssidLabel.textColor = .lightGray
        wifiUsageLabel.text = ""
        wifiUsageLabel.textColor = .lightGray
        
        // setup pull to refresh
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString (string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(refreshSortAndFilterData), for: .valueChanged)
 
        refreshSortAndFilterData()
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
        cell.detailTextLabel?.text = interfaces[indexPath.row].address!

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
        refreshSortAndFilterData()
    }
    
    
    @objc func refreshSortAndFilterData () {
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
        
        print ("making unique")
        print (interfaces.count)
        var uniqueArray: [Interface] = []
        for interface in interfaces {
            var found = false
            for item in uniqueArray {
                if (interface.description == item.description && interface.address == item.address) {
                    found = true
                    break
                }
            }
            if (!found) {
                uniqueArray.append (interface)
            }
        }
        interfaces = uniqueArray
        
        interfaces.sort {
            if $0.description == $1.description { return $0.address! < $1.address! }
            return $0.description < $1.description
        }
        
        
        print (interfaces.count)
        tableView.reloadData()
        refresher.endRefreshing()
        
        ssidLabel.text = "none"
        if let interfaces = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                
                if let unsafeInterfaceData = unsafeInterfaceData as? Dictionary<AnyHashable, Any> {
                    ssidLabel.text = unsafeInterfaceData["SSID"] as? String
                    ssidLabel.textColor = .black
                }
            }
        }
        
        let formatter = ByteCountFormatter()
        let dataUsed = DataUsage.getDataUsage()
        let wifiUsedString = formatter.string(fromByteCount: Int64(dataUsed.wifiReceived + dataUsed.wifiSent))
        wifiUsageLabel.text = wifiUsedString
    }
}
