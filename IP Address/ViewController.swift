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
        
    var interfaces = Interface.allInterfaces()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        interfaces = Interface.allInterfaces()
        interfaces.sort {
            if $0.description == $1.description { return $0.address! < $1.address! }
            return $0.description < $1.description
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print (interfaces.count)
        return interfaces.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.text = interfaces[indexPath.row].description
        cell.detailTextLabel?.text = interfaces[indexPath.row].address
        
        // print ("\(interfaces[indexPath.row].debugDescription)")
        
        return cell
    }
    
    
    // screen tap to refresh 
    @IBAction func screenTappedTriggered(sender: AnyObject) {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        interfaces = Interface.allInterfaces()
        interfaces.sort {
            if $0.description == $1.description { return $0.address! < $1.address! }
            return $0.description < $1.description
        }
        self.tableView.reloadData()
    }
}
