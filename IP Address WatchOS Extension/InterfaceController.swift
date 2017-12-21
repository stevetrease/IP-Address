//
//  InterfaceController.swift
//  IP Address WatchOS Extension
//
//  Created by Steve on 21/12/2017.
//  Copyright © 2017 Steve. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    private var interfaces = Interface.allInterfaces()
    

    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        
        refreshSortAndFilterData ()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        
    }
    
    
    
    func refreshSortAndFilterData () {
        interfaces = Interface.allInterfaces()
        
        var IPv4Interfaces = interfaces.filter { $0.family == .ipv4 }
        var IPv6Interfaces = interfaces.filter { $0.family == .ipv6 }
        
        print ("\(IPv4Interfaces.count) \(IPv6Interfaces.count) \(interfaces.count)")
        
        IPv6Interfaces = IPv6Interfaces.filter { !($0.address?.hasPrefix ("fe80"))! }
        
        interfaces = IPv4Interfaces // + IPv6Interfaces
        
        interfaces.sort {
            if $0.description == $1.description { return $0.address! < $1.address! }
            return $0.description < $1.description
        }
        
        print ("Watch interfaces count = \(interfaces.count)")
    }
}
