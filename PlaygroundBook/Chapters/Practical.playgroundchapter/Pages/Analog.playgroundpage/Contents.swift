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
 # Analog
 ## It's not all just true and false
 
 Now that you've mastered circuits with digital values, it's time to go analog. Using the microcontroller, you can both read from and write analog values to a pin. Before trying analog programming, let's set up the circuit.
 
 * Callout(Task):
 Add a light sensor and a speaker. Wire them up to pins 1 and 2 respectively. To find the components, scroll right on the components list
 
 Now that you've set up the circuit, it's time to write some code. Remember, we first have to setup the controller
 * Callout(Task):
 Finish the code in the 'setup()' function to correctly configure pins 1 and 2
 
 Now for the loop function. The light sensor reads a floating point value between 0 and 1, and the speaker volume can be controlled by a floating point between 0 and 1.
 
 * Callout(Task):
 Finish the code in the 'loop()' function to set the speaker volume to equal the light intensity. You can control the light intensity by using the slider in the circuit builder.
 
 */

var mc = MicrocontrollerInterface()

func setup() {
    // Configure pins 1 and 2
    mc.configure(pin: /*#-editable-code Light Sensor Pin .*//*#-end-editable-code*/, type: .analogInput)
    mc.configure(pin: /*#-editable-code Speaker Pin .*//*#-end-editable-code*/, type: .analogOutput)
    
}

func loop() {
    // Read the light input
    var lightIntensity = mc.readAnalog(pin: /*#-editable-code Light Sensor Pin.*//*#-end-editable-code*/)
    mc.writeAnalog(pin: /*#-editable-code Speaker Pin.*//*#-end-editable-code*/, data: /*#-editable-code Volume.*//*#-end-editable-code*/)
}


//: Run your code once you are done. Try changing the value of the slider

//#-hidden-code
var correctResults = [".*/1", ".*/2", ".*/1", ".*/2", ".*/lightIntensity"]

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
2

public enum AssessmentResults {
    case pass(message: String)
    case fail(hints: [String], solution: String?)
}


public func makeAssessment(of input: String) -> PlaygroundPage.AssessmentStatus {
    let codeInputs = findUserCodeInputs(from: input)
    
    // validate the input; return .fail if needed
    if codeInputs[0] == correctResults[0] && codeInputs[1] == correctResults[1] && codeInputs[2] == correctResults[2] && codeInputs[3] == correctResults[3] && codeInputs[4] == correctResults[4]  {
        return .pass(message: "Great job! Move to the next page for more")
    }
    return .fail(hints: ["The following hints contain the solution to each editable code area", "1", "2", "1", "2", "lightIntensity"], solution: nil)
}

let input = PlaygroundPage.current.text
PlaygroundPage.current.assessmentStatus = makeAssessment(of: input)

setup()
var timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
    loop()
}
RunLoop.main.run(until: Date(timeIntervalSinceNow: 1800))

//#-end-hidden-code

