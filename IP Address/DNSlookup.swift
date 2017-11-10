//
//  DNSlookup.swift
//  IP Address
//
//  Created by Steve on 02/11/2017.
//  Copyright © 2017 Steve. All rights reserved.
//

import Foundation
#if swift(>=3.2)
    import Darwin
#else
    import ifaddrs
#endif




public class DNSLookup {
    open static func lookup(_ hostname: String) -> String {
        var address:String = ""
        let host = CFHostCreateWithName(nil,hostname as CFString).takeRetainedValue()
        CFHostStartInfoResolution(host, .addresses, nil)
        var success: DarwinBoolean = false
        if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?,
            let theAddress = addresses.firstObject as? NSData {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length),
                           &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                let numAddress = String(cString: hostname)
                address = numAddress
            }
        }
        return (address)
    }
    
    open static func reverseLookup(_ ip: String) -> String {
        
        /*
        var sin = sockaddr_in(
            sin_len: UInt8(MemoryLayout<sockaddr_in>.size),
            sin_family: sa_family_t(AF_INET),
            sin_port: in_port_t(0),
            sin_addr: in_addr(s_addr: inet_addr(ip)),
            sin_zero: (0,0,0,0,0,0,0,0)
        )
        let data = Data(bytes: &sin, count: MemoryLayout<sockaddr_in>.size)
        let host = CFHostCreateWithAddress(nil, data as CFData).takeRetainedValue()
        CFHostStartInfoResolution(host, .names, nil)
        
        var success: DarwinBoolean = false
        if let names = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?,
            let theHostname = names.firstObject as? NSData {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(theHostname.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theHostname.length),
                           &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                let address = String(cString: hostname)
                print (address)
            }
        }*/
        
        return ("hostname")
    }
}
