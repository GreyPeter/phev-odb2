//
//  ViewController.swift
//  OBD2-Swift-lib-example
//
//  Created by Max Vitruk on 25/04/2017.
//  Copyright © 2017 Lemberg. All rights reserved.
//

import UIKit
import OBD2
import CoreBluetooth


class ViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    static var host = "192.168.0.10"
    static var port = 35000
    
    //var scanTool = ELM327(host: host , port: port)
    let obd = OBD2()
    
    // Properties
    private var centralManager: CBCentralManager!
    private var _adapter: CBPeripheral!
    private var _reader: CBCharacteristic!
    private var _writer: CBCharacteristic!

    private var _identifier: [UUID]!
    private var _serviceUUIDs:[CBUUID]!
    private var _possibleAdapters = NSMutableArray()
        
    @IBOutlet weak var dtcButton: UIButton!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var vinButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var statusLabel: UILabel!
    

    // If we're powered on, start scanning
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        
        if central.state != .poweredOn {
            print("Central is not powered on")
            connectButton.isHidden = true
            indicator.startAnimating()
            statusLabel.text = "Opening connection"
            return
        }
        _serviceUUIDs = ObdPeripheral.myCharacteristicUUIDs
        let myCBUUIDs:[CBUUID] = ObdPeripheral.myArray as! [CBUUID]
        _identifier = (ObdPeripheral.myUUIDarray as! [UUID])
        
        var peripherals = centralManager.retrieveConnectedPeripherals(withServices: _serviceUUIDs)
        
        if (peripherals.count != 0) {
                print("Connected already ", _adapter as Any)
                if (_adapter.state == CBPeripheralState.connected) {
                    _adapter = peripherals.first!
                    _adapter.delegate = self
                    self .peripheral(_adapter, didDiscoverServices: nil)
                } else {
                    _possibleAdapters.add(peripherals.first!)
                    //[self centralManager:central didDiscoverPeripheral:peripherals.firstObject advertisementData:@{} RSSI:@127];
//                    self .centralManager(central, didDiscover: peripherals.first, advertisementData: nil, rssi: 127)
                }
                return
            }
        
        if(_identifier != nil) {
            peripherals = centralManager.retrievePeripherals(withIdentifiers: _identifier)
        }

            if (peripherals.count==0) {
                print("Central scanning for any peripherals");
                centralManager.scanForPeripherals(withServices: nil, options: nil)
                return
            }
            
            _adapter = peripherals.first
            _adapter.delegate = self
            centralManager.connect(_adapter, options: nil)

    }
    
    // Handles the result of the scan
        func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

            if(_adapter != nil){
//                print("[IGNORING] DISCOVER ", peripheral, " (RSSI=", RSSI ,")  w/ advertisement ", advertisementData)
                print("Ignoring ", peripheral.identifier)
                return
            }
            connectButton.isHidden = true
            indicator.startAnimating()
            statusLabel.text = "Opening connection"
            
            print("Discovered: ",peripheral.name, peripheral.identifier.uuidString,"RSSI: ",RSSI)
            _possibleAdapters.add(peripheral)
            peripheral.delegate = self
            centralManager.connect(peripheral, options: nil)
        }
    
    // The handler if we do connect succesfully
        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            if peripheral == self._adapter {
                indicator.stopAnimating()
                statusLabel.text = "Connected"
                updateUI(connected: true)
                print("Connected to ", peripheral)
                peripheral.discoverServices(_serviceUUIDs)
            }
        }
    
    // Handles discovery event
        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            
            if (_adapter != nil){
                print("Ignoring Services ", peripheral, peripheral.services)
                return
            }
            if (error != nil) {
                print("Could not discover services ", error)
            }
            if (peripheral.services?.count == 0) {
                print("Peripheral does not offer requested services")
                centralManager.cancelPeripheralConnection(peripheral)
                _possibleAdapters.remove(peripheral)
                return
            }
            _adapter = peripheral
            _adapter.delegate = self
            
            if(centralManager.isScanning) {
                centralManager.stopScan()
            }
            
        }
    
    // Handling discovery of characteristics
        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    if(characteristic.properties.contains(CBCharacteristicProperties.notify)) {
                        //CBCharacteristicProperties.notify
                        print("Did see notify characteristic")
                        _reader = characteristic
                        peripheral.setNotifyValue(true, for: characteristic)
                    }
                    
                    if(characteristic.properties.contains(CBCharacteristicProperties.write)){
                        print("Did see write characteristic")
                        _writer = characteristic
                    }
                }
            }
            
            if (_reader != nil && _writer != nil){
                connectionAttemptSucceeded()
            } else {
                connectionAttemptFaied()
            }
        }
    
    func connectionAttemptSucceeded() {
           print("Connection attempt succeeded")
       }
    
    func connectionAttemptFaied() {
            print("Connection attempt failed")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
 //       centralManager = CBCentralManager(delegate: self, queue: nil)

        //scanTool.sensorScanTargets = [0x0C, 0x0D]
        updateUI(connected: false)
        let observer = Observer<Command.Mode01>()
        
        observer.observe(command: .pid(number: 12)) { (descriptor) in
            let respStr = descriptor?.shortDescription
            print("Observer : \(String(describing: respStr))")
        }
        
        ObserverQueue.shared.register(observer: observer)
        
        obd.stateChanged = { (state) in
            
            OperationQueue.main.addOperation { [weak self] in
                self?.onOBD(change: state)
            }
        }
    }
    
    func onOBD(change state:ScanState) {
        switch state {
        case .none:
            indicator.stopAnimating()
            statusLabel.text = "Not Connected"
            updateUI(connected: false)
            break
        case .connected:
            indicator.stopAnimating()
            statusLabel.text = "Connected"
            updateUI(connected: true)
            break
        case .openingConnection:
            connectButton.isHidden = true
            indicator.startAnimating()
            statusLabel.text = "Opening connection"
            break
        case .initializing:
            statusLabel.text = "Initializing"
            break
        }
    }
    
    func updateUI(connected: Bool) {
        dtcButton.isEnabled = connected
        speedButton.isEnabled = connected
        vinButton.isEnabled = connected
        connectButton.isHidden = connected
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func connect( _ sender : UIButton){
        centralManager = CBCentralManager(delegate: self, queue: nil)
        //obd.requestTroubleCodes()
        obd.connect { [weak self] (success, error) in
            OperationQueue.main.addOperation({
                if let error = error {
                    print("OBD connection failed with \(error)")
                    self?.statusLabel.text = "Connection failed with error \(error)"
                    self?.updateUI(connected: false)
                }
            })
        }
    }
    
    
    @IBAction func requestSpeed( _ sender : UIButton) {
        
        let command = Command.Mode01.pid(number: 12)
        if obd.isRepeating(repeat: command) {
            sender.setTitle("Start repeat speed", for: .normal)
            obd.stop(repeat: command)
        } else {
            sender.setTitle("Stop repeat", for: .normal)
            obd.request(repeat: command)
        }
    }
    
    @IBAction func request( _ sender : UIButton) {
        //obd.requestTroubleCodes()
        obd.request(command: Command.Mode03.troubleCode) { (descriptor) in
            let respStr = descriptor?.getTroubleCodes()
            print(respStr ?? "No value")
        }
    }
    
    @IBAction func pause( _ sender : UIButton) {
        obd.pauseScan()
    }
    
    @IBAction func resume( _ sender : UIButton) {
        obd.resumeScan()
    }
    
    @IBAction func requestVIN( _ sender : UIButton) {
        //obd.requestVIN()
        obd.request(command: Command.Mode09.vin) { (descriptor) in
            let respStr = descriptor?.VIN()
            print(respStr ?? "No value")
        }
        
        obd.request(command: Command.Custom.string("0902")) { (descr) in
            print("Response \(String(describing: descr?.getResponse()))")
        }
    }
    
}

func btconnect() {
    return
}
