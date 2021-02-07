//
//  filesData.swift
//  macAnalysis
//
//  Created by Mahmoud Hassan on 1/30/21.
//  Copyright © 2021 Mahmoud Hassan. All rights reserved.
//

import Foundation
import Cocoa
class filesData{
    
    var name:String = ""
    var url = URL(string: "https://www.avanderlee.com")!
    var size : Float = 0
    var duplicated: Bool = false
    var isChecked = false;
    var fileType : String = ""
    
    
    
    
    // MARK: find mac address
    
     func GetMACAddress(_ intfIterator : io_iterator_t) -> [UInt8]? {

         var macAddress : [UInt8]?

         var intfService = IOIteratorNext(intfIterator)
         while intfService != 0 {

             var controllerService : io_object_t = 0
             if IORegistryEntryGetParentEntry(intfService, kIOServicePlane, &controllerService) == KERN_SUCCESS {

                 let dataUM = IORegistryEntryCreateCFProperty(controllerService, "IOMACAddress" as CFString, kCFAllocatorDefault, 0)
                 if dataUM != nil {
                     let data = (dataUM!.takeRetainedValue() as! CFData) as Data
                     macAddress = [0, 0, 0, 0, 0, 0]
                     data.copyBytes(to: &macAddress!, count: macAddress!.count)
                 }
                 IOObjectRelease(controllerService)
             }

             IOObjectRelease(intfService)
             intfService = IOIteratorNext(intfIterator)
         }

         return macAddress
     }

    func FindEthernetInterfaces() -> io_iterator_t? {

          let matchingDictUM = IOServiceMatching("IOEthernetInterface");
          // Note that another option here would be:
          // matchingDict = IOBSDMatching("en0");
          // but en0: isn't necessarily the primary interface, especially on systems with multiple Ethernet ports.

          if matchingDictUM == nil {
              return nil
          }

          let matchingDict = matchingDictUM! as NSMutableDictionary
          matchingDict["IOPropertyMatch"] = [ "IOPrimaryInterface" : true]

          var matchingServices : io_iterator_t = 0
          if IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, &matchingServices) != KERN_SUCCESS {
              return nil
          }

          return matchingServices
      }


     func getMacAddress() -> String? {
         var macAddressAsString : String?
         if let intfIterator = FindEthernetInterfaces() {
             if let macAddress = GetMACAddress(intfIterator) {
                 macAddressAsString = macAddress.map( { String(format:"%02x", $0) } ).joined(separator: ":")
                 print("mac address: \(macAddressAsString!)")
             }

             IOObjectRelease(intfIterator)
         }
         return macAddressAsString
     }
     
    
    //MARK: Active Apps:
    
    ///
       func activeApps()
       {
           // Get all running applications
           let workspace = NSWorkspace.shared
           let applications = workspace.runningApplications
           
           for app in applications {
               print(app)
           }
           
       }
    
}
