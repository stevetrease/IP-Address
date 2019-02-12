//
//  DataUsage.swift
//  IP Address
//
//  Created by Steve on 12/02/2019.
//  Copyright © 2019 Steve. All rights reserved.
//

import Foundation



struct DataUsageInfo {
    var wifiReceived: UInt32 = 0
    var wifiSent: UInt32 = 0
    var wirelessWanDataReceived: UInt32 = 0
    var wirelessWanDataSent: UInt32 = 0
    
    mutating func updateInfoByAdding(info: DataUsageInfo) {
        wifiSent += info.wifiSent
        wifiReceived += info.wifiReceived
        wirelessWanDataSent += info.wirelessWanDataSent
        wirelessWanDataReceived += info.wirelessWanDataReceived
    }
}

class DataUsage {
    
    private static let wwanInterfacePrefix = "pdp_ip"
    private static let wifiInterfacePrefix = "en"
    
    class func getDataUsage() -> DataUsageInfo {
        var interfaceAddresses: UnsafeMutablePointer<ifaddrs>? = nil
        
        var dataUsageInfo = DataUsageInfo()
        
        guard getifaddrs(&interfaceAddresses) == 0 else { return dataUsageInfo }
        
        var pointer = interfaceAddresses
        while pointer != nil {
            guard let info = getDataUsageInfo(from: pointer!) else {
                pointer = pointer!.pointee.ifa_next
                continue
            }
            dataUsageInfo.updateInfoByAdding(info: info)
            pointer = pointer!.pointee.ifa_next
        }
        
        freeifaddrs(interfaceAddresses)
        
        return dataUsageInfo
    }
    
    private class func getDataUsageInfo(from infoPointer: UnsafeMutablePointer<ifaddrs>) -> DataUsageInfo? {
        let pointer = infoPointer
        
        let name: String! = String(cString: infoPointer.pointee.ifa_name)
        let addr = pointer.pointee.ifa_addr.pointee
        guard addr.sa_family == UInt8(AF_LINK) else { return nil }
        
        return dataUsageInfo(from: pointer, name: name)
    }
    
    private class func dataUsageInfo(from pointer: UnsafeMutablePointer<ifaddrs>, name: String) -> DataUsageInfo {
        var networkData: UnsafeMutablePointer<if_data>? = nil
        var dataUsageInfo = DataUsageInfo()
        
        if name.hasPrefix(wifiInterfacePrefix) {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            dataUsageInfo.wifiSent += networkData?.pointee.ifi_obytes ?? 0
            dataUsageInfo.wifiReceived += networkData?.pointee.ifi_ibytes ?? 0
        } else if name.hasPrefix(wwanInterfacePrefix) {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            dataUsageInfo.wirelessWanDataSent += networkData?.pointee.ifi_obytes ?? 0
            dataUsageInfo.wirelessWanDataReceived += networkData?.pointee.ifi_ibytes ?? 0
        }
        
        return dataUsageInfo
    }
}
