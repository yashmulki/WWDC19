//#-hidden-code
import PlaygroundSupport
import UIKit
import Book_Sources

var dataBuffer: [Int: PlaygroundValue] = [:]

class MessageHandler: PlaygroundRemoteLiveViewProxyDelegate {
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundSupport.PlaygroundRemoteLiveViewProxy) {
    }
    
    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundSupport.PlaygroundRemoteLiveViewProxy, received message: PlaygroundSupport.PlaygroundValue) {
        if case let .dictionary(dict) = message {
            if case let .integer(pin) = dict["Pin"]! {
                dataBuffer[pin] = dict["Value"]!
            }
        }
    }
}

guard let remoteView = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
    fatalError("Always-on live view not configured in this page's LiveView.swift.")
}

var handler = MessageHandler()
remoteView.delegate = handler

class MicrocontrollerInterface {
    func configure(pin: Int, type: PinType) {
        if pin <= 5 && pin > 0 {
            if type == .analogInput {
                dataBuffer[pin] = .floatingPoint(0.0)
            } else if type == .digitalInput {
                dataBuffer[pin] = .boolean(false)
            } else {
                dataBuffer[pin] = .floatingPoint(0.0)
            }
            remoteView.send(.dictionary(["Type" : .string("Configure"), "Pin" : .integer(pin), "PinType" : .string(type.rawValue)]))
        }
    }
    
    
    func writeDigital(pin: Int, data: Bool) {
        if pin <= 5 && pin > 0 {
            remoteView.send(.dictionary(["Type" : .string("WriteBool"), "Pin" : .integer(pin), "Data" : .boolean(data)]))
        }
    }
    
    func writeAnalog(pin: Int, data: Double) {
        if pin <= 5 && pin > 0 {
            remoteView.send(.dictionary(["Type" : .string("WriteDouble"), "Pin" : .integer(pin), "Data" : .floatingPoint(data)]))
        }
    }
    
    
    
    func readDigital(pin: Int) -> Bool {
        if pin <= 5 && pin > 0 {
            remoteView.send(.dictionary(["Type" : .string("ReadBool"), "Pin" : .integer(pin)]))
            
            guard let myVal = dataBuffer[pin] else {return false}
            
            if case let .boolean(value) = myVal {
                return value
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func readAnalog(pin: Int) -> Double {
        if pin <= 5 && pin > 0 {
            remoteView.send(.dictionary(["Type" : .string("ReadDouble"), "Pin" : .integer(pin)]))
            
            guard let myVal = dataBuffer[pin] else {return 0.0}
            
            if case let .floatingPoint(value) = myVal {
                return value
            } else {
                return 0.0
            }
        } else {
            return 0.0
        }
    }
}
//#-end-hidden-code

/*:
 # Sandbox
 ## What can you make?
 
 You can now try to make anything you'd like with the things you have learned. When you are done, move to the next page
 
 Remember, to configure a pin you use the mc.configure(pin: Int, type: PinType) function
 To write a digital value you use the mc.writeDigital(pin: Int, value: Bool) function
 To write an analog value you use the mc.writeDigital(pin: Int, value: Double) function
 To read a digital value you use the mc.readDigital(pin: Int) -> Bool function
 To read an analog value you use the mc.readAnalog(pin: Int) -> Double function

 PinType is an enum with cases .digitalInput, .digitalOutput, .analogInput, .analogOutput
 
*/

var mc = MicrocontrollerInterface()

func setup() {
    
    
}

func loop() {
    
}

/*:
 ### Credits
 I used the following resources in my app
 Background Music: bensound.com
 Sound Effects: freesfx.co.uk
 Arduino Images: arduino.cc
 Airpods Image: flaticon.com
 Smog Image: 
 */

//#-hidden-code

setup()
var timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
    loop()
}
RunLoop.main.run(until: Date(timeIntervalSinceNow: 1800))

//#-end-hidden-code

