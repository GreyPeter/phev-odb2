//
//  ObdPeripheral.swift
//  phev-odb2
//
//  Created by Peter Harry on 8/3/20.
//  Copyright © 2020 Peter Harry. All rights reserved.
//

import UIKit
import CoreBluetooth

class ObdPeripheral: NSObject {

    /// MARK: - Particle LED services and charcteristics Identifiers
    
    public static let UUID0 = CBUUID.init(string: "e7810a71-73ae-499d-8c15-faa9aef0c3f2")
    
    public static let bedroom = CBUUID.init(string: "5AE36F39-8C4F-FB09-8625-F42432B27599")
    public static let PetesAppleWatch = CBUUID.init(string: "F55FBDFC-74A9-03D0-FF4D-A452FCC19790")
    public static let iPad = CBUUID.init(string: "BBBDC5D0-00F7-5DF0-664F-882F23326CB5")
    public static let PetesiMac = CBUUID.init(string: "5EDC98D1-9099-33CD-DDBA-7EE360AAC5AE")
    public static let PetersMacBookPro = CBUUID.init(string: "608C1D21-DD7A-615D-6578-6DE004A9082D")
    public static let Lounge = CBUUID.init(string: "0B699152-1078-D2D3-366A-61F762490BDC")
    public static let AppleWatch = CBUUID.init(string: "780D5549-ED2F-AA96-CA1C-1CB62544A678")
    public static let iPhone5S = CBUUID.init(string: "8724BC17-52E7-128B-03F5-3CB48D5DE39C")
    public static let PetesiPhoneXR = CBUUID.init(string: "1A1EB635-0557-999B-990E-31173DC069F6")
    public static let myCharacteristicUUIDs = [UUID0,bedroom,PetesAppleWatch,iPad,PetesiMac,PetersMacBookPro,Lounge,AppleWatch,iPhone5S,PetesiPhoneXR]
    public static let myArray = NSArray.init(array: [UUID0,bedroom,PetesAppleWatch,iPad,PetesiMac,PetersMacBookPro,Lounge,AppleWatch,iPhone5S,PetesiPhoneXR])
    
    public static let OBD2adpter1 = UUID.init(uuidString: "0000fff0-0000-1000-8000-00805f9b34fb")
    public static let OBD2adpter2 = UUID.init(uuidString: "0000ffe0-0000-1000-8000-00805f9b34fb")
    public static let OBD2adpter3 = UUID.init(uuidString: "0000beef-0000-1000-8000-00805f9b34fb")
    public static let OBD2adpter4 = UUID.init(uuidString: "e7810a71-73ae-499d-8c15-faa9aef0c3f2")
    public static let bedroom1 = UUID.init(uuidString: "5AE36F39-8C4F-FB09-8625-F42432B27599")
    public static let PetesAppleWatch1 = UUID.init(uuidString: "F55FBDFC-74A9-03D0-FF4D-A452FCC19790")
    public static let PetersMacBookPro1 = UUID.init(uuidString: "608C1D21-DD7A-615D-6578-6DE004A9082D")
    public static let PetesiMac1 = UUID.init(uuidString: "5EDC98D1-9099-33CD-DDBA-7EE360AAC5AE")

    public static let myUUIDarray = [OBD2adpter1,OBD2adpter2,OBD2adpter3,OBD2adpter4,PetesiMac1]

}
/*
 Discovered:  Optional("Bedroom") 5AE36F39-8C4F-FB09-8625-F42432B27599 RSSI:  -77
 Discovered:  Optional("PetesAppleWatch") F55FBDFC-74A9-03D0-FF4D-A452FCC19790 RSSI:  -61
 Discovered:  nil 20EEF969-094B-7A0D-FB25-0722099D01B6 RSSI:  -72
 Discovered:  Optional("iPad") BBBDC5D0-00F7-5DF0-664F-882F23326CB5 RSSI:  -63
 Discovered:  nil 826A40E6-A9EB-06D9-7B67-58F86C48466D RSSI:  -56
 Discovered:  Optional("Pete’s iMac") 5EDC98D1-9099-33CD-DDBA-7EE360AAC5AE RSSI:  -91
 Discovered:  Optional("Peter’s MacBook Pro") 608C1D21-DD7A-615D-6578-6DE004A9082D RSSI:  -55
 Discovered:  Optional("Lounge (2)") 0B699152-1078-D2D3-366A-61F762490BDC RSSI:  -57
 Discovered:  Optional("Apple Watch") 780D5549-ED2F-AA96-CA1C-1CB62544A678 RSSI:  -74
 Discovered:  Optional("iPhone 5S") 8724BC17-52E7-128B-03F5-3CB48D5DE39C RSSI:  -55
 Discovered:  nil 349A3FD6-E436-4F06-F203-E559EE7490AA RSSI:  -69
 Discovered:  Optional("PetesiPhoneXR") 1A1EB635-0557-999B-990E-31173DC069F6 RSSI:  -41
  */
