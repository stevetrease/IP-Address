//
//  IPAddressInterfaceController.swift
//  IP Address WatchOS Extension
//
//  Created by Steve on 21/12/2017.
//  Copyright © 2017 Steve. All rights reserved.
//

import WatchKit
import Foundation


class IPAddressInterfaceController: WKInterfaceController {

    @IBOutlet var IPAddressesTable: WKInterfaceTable!
    
    private var interfaces = Interface.allInterfaces()
    

    

    override func awake(withContext context: Any?) {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        super.awake(withContext: context)
        
        self.updateView()
    }
    
    
    @IBAction func screenTappedTriggered(sender: AnyObject) {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        WKInterfaceDevice.current().play(.click)
        self.updateView()
    }
    
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        super.willActivate()
    }
    
    

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        super.didDeactivate()
    }
    
    
    
    func updateView () {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        refreshSortAndFilterData()
        
        IPAddressesTable.setNumberOfRows(interfaces.count, withRowType: "addressRowCell")
        
        for index in 0..<interfaces.count {
            guard let controller = IPAddressesTable.rowController(at: index) as? IPAddressRowController else { continue }
            controller.interface = interfaces[index]
        }
    }
    
    
    
    func refreshSortAndFilterData () {
        interfaces = Interface.allInterfaces()
        
        var IPv4Interfaces = interfaces.filter { $0.family == .ipv4 }
        var IPv6Interfaces = interfaces.filter { $0.family == .ipv6 }
        
        // print ("\(IPv4Interfaces.count) \(IPv6Interfaces.count) \(interfaces.count)")
        
        IPv6Interfaces = IPv6Interfaces.filter { !($0.address?.hasPrefix ("fe80"))! }
        
        interfaces = IPv4Interfaces + IPv6Interfaces
        
        interfaces.sort {
            if $0.description == $1.description { return $0.address! < $1.address! }
            return $0.description < $1.description
        }
        
        print ("Watch interfaces count = \(interfaces.count)")
    }
}
