//
//  IPAddressRowController.swift
//  IP Address WatchOS Extension
//
//  Created by Steve on 21/12/2017.
//  Copyright © 2017 Steve. All rights reserved.
//

import WatchKit

class IPAddressRowController: NSObject {
    @IBOutlet var interfaceLabel: WKInterfaceLabel!
    @IBOutlet var IPAddressLabel: WKInterfaceLabel!
    
    var interface: Interface? {
        didSet {
            guard let interface = interface else { return }
            
            interfaceLabel.setText(interface.description)
            IPAddressLabel.setText(interface.address)
        }
    }
}
