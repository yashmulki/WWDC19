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
 # Basics
 ## Learn how a microcontroller gets input and controls components
 
 Welcome! On the right is a circuit builder interface where you will be adding components and connecting them to the microcontroller. To add components, tap, hold and drag a component from the scrollable view at the bottom. To connect the components to the microcontroller, tap and drag from the triangles (connectors) on the components to the red blocks (pins) numbered 1-5 on the microcontroller. You can also move around the components to organize your workspace even after connecting them to the microcontroller. Note: You can remove a component by dragging it to the bin.

 * Callout(Task):
 Add a switch and a red LED to the scene. Wire them up to pins 1 and 2

 Now that you've set up the circuit, it's time to write some code. The 'setup()' function is where you will configure each pin/input on the microcontroller. For now, inputs can be either .digitalInput or .digitalOutput, so they can read or output true or false values.

 * Callout(Task):
 Finish the code in the setup() function below with the correct pins

 The loop() function runs continuously and is where you can write code to perform logical operations and control the electric components. You can use two functions to interact with the components: writeDigital (sends a true or false value to a pin) and readDigital (reads a true or false value from an input pin).

 * Callout(Task):
 Finish the code in the loop() function below to turn on the red LED when the switch is on, and turn it off when the switch is off.
 
 */

var mc = MicrocontrollerInterface()

func setup() {
    // Configure pins 1 and 2. The first is done for you
    mc.configure(pin: /*#-editable-code Switch Pin .*/1/*#-end-editable-code*/, type: .digitalInput)
    mc.configure(pin: /*#-editable-code Red LED Pin .*//*#-end-editable-code*/, type: .digitalOutput)
}

func loop() {
    // Read the switch input
    var switchInput = mc.readDigital(pin: /*#-editable-code Switch Pin.*//*#-end-editable-code*/)
    
    // If switch is on (true), turn red LED on, and do the opposite otherwise
    if switchInput == /*#-editable-code Condition .*//*#-end-editable-code*/{
        mc.writeDigital(pin: /*#-editable-code Red LED Pin.*//*#-end-editable-code*/, data: true)
    } else {
        mc.writeDigital(pin: /*#-editable-code Red LED Pin.*//*#-end-editable-code*/, data: false)
    }
}


//: Run your code and tap the switch to see what happens

//#-hidden-code
var correctResults = [".*/1", ".*/2", ".*/1", ".*/true", ".*/2", ".*/2"]

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
    if codeInputs[0] == correctResults[0] && codeInputs[1] == correctResults[1] && codeInputs[2] == correctResults[2] && codeInputs[3] == correctResults[3] && codeInputs[4] == correctResults[4] && codeInputs[5] == correctResults[5] {
        return .pass(message: "Great job! Move to the next page for more")
    }
    return .fail(hints: ["The following hints contain the solution to each editable code area", "1", "2", "1", "true", "2", "2"], solution: nil)
}

let input = PlaygroundPage.current.text
PlaygroundPage.current.assessmentStatus = makeAssessment(of: input)

setup()
var timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
    loop()
}
RunLoop.main.run(until: Date(timeIntervalSinceNow: 1800))

//#-end-hidden-code

