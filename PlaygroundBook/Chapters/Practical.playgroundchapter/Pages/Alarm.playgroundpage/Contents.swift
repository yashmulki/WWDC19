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
 # Applications
 ## Build a smog detector to see how microcontrollers can be useful
 
 In many cities, poor air quality is a significant issue, especially as more and more cars get on roads. Using an air quality probe, you will build an air quality monitor that turns on an alarm and a red light if there is a significant amount of smog.
 
 * Callout(Task):
 Add an air probe, a speaker and a red LED to pins 1, 2 and 3 respectively
 
 Setup the microcontroller
 
 * Callout(Task):
 Finish the code in the 'setup()' by correctly configuring pins 1, 2 and 3
 
 The air probe is an analog component with 0 representing no smog and 1 representing a lot of smog. The alarm should go off when the detector returns a value of 0.2. The amount of smog can be controlled with the slider in the circuit builder.
 
 * Callout(Task):
 Finish the code in the 'loop()' function to turn on the red LED and set the speaker to full volume when the smog level is over 0.2
 
 */

var mc = MicrocontrollerInterface()

func setup() {
    // Configure pins 1, 2 and 3
    mc.configure(pin: /*#-editable-code Air Probe Pin.*//*#-end-editable-code*/, type: .analogInput)
    mc.configure(pin: /*#-editable-code Speaker Pin.*//*#-end-editable-code*/, type: .analogOutput)
    mc.configure(pin: /*#-editable-code Red LED Pin.*//*#-end-editable-code*/, type: .digitalOutput)
}

func loop() {
    // Read the smog level input
    var smog = mc.readAnalog(pin: /*#-editable-code Air Probe Pin.*//*#-end-editable-code*/)
    
    // Check if the smog level is above 0.2
    if smog > /*#-editable-code Condition.*//*#-end-editable-code*/{
        // Set speaker to full volume
        mc.writeAnalog(pin: /*#-editable-code Speaker Pin.*//*#-end-editable-code*/, data: 1.0)
        mc.writeDigital(pin: /*#-editable-code Red LED Pin.*//*#-end-editable-code*/, data: true)
    } else {
        // Set speaker to no volume
        mc.writeAnalog(pin: /*#-editable-code Speaker Pin.*//*#-end-editable-code*/, data: 0.0)
        mc.writeDigital(pin: /*#-editable-code Red LED Pin.*//*#-end-editable-code*/, data: false)
    }
}


//: Run your code once you are done. Try moving the smog slider

//#-hidden-code
var correctResults = [".*/1", ".*/2", ".*/3", ".*/1", ".*/0.2", ".*/2", ".*/3", ".*/2", ".*/3"]

// Validation stuff
public func findUserCodeInputs(from input: String) -> [String] {
    var inputs: [String] = []
    let scanner = Scanner(string: input)
    
    while scanner.scanUpTo(".*/", into: nil) {
        var userInput: NSString? = ""
        //scanner.scanUpTo("\n", into: nil)
        scanner.scanUpTo("/*#-end-editable-code", into: &userInput)
        
        if userInput != nil {
            inputs.append(String(userInput!))
        }
    }
    
    return inputs
}


public enum AssessmentResults {
    case pass(message: String)
    case fail(hints: [String], solution: String?)
}


public func makeAssessment(of input: String) -> PlaygroundPage.AssessmentStatus {
    let codeInputs = findUserCodeInputs(from: input)
    
    // validate the input; return .fail if needed
    if codeInputs[0] == correctResults[0] && codeInputs[1] == correctResults[1] && codeInputs[2] == correctResults[2] && codeInputs[3] == correctResults[3] && codeInputs[4] == correctResults[4] && codeInputs[5] == correctResults[5] && codeInputs[6] == correctResults[6] && codeInputs[7] == correctResults[7] && codeInputs[8] == correctResults[8] {
        return .pass(message: "Great job! Move to the next page for more")
    }
    return .fail(hints: ["The following hints contain the solution to each editable code area", "1", "2", "3", "1", "0.2", "2", "3", "2", "3"], solution: nil)
}

let input = PlaygroundPage.current.text
PlaygroundPage.current.assessmentStatus = makeAssessment(of: input)

setup()
var timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
    loop()
}
RunLoop.main.run(until: Date(timeIntervalSinceNow: 1800))

//#-end-hidden-code

