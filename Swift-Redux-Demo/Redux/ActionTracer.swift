//
//  ActionTracer.swift
//  Swift-Redux-Demo
//
//  Created by h.yamaguchi on 2025/09/10.
//

import CustomDump

struct ActionTracer {
    static func trace<State: Redux.State>(before: State, after: State, action: Redux.Action, newAction: Redux.Action) {
#if DEBUG
        var log = ""
        
        if let action = action as? Redux.ThunkAction<State> {
            log += "\n➡️ ThunkAction: \(action.caller())"
            log += "\n➡️➡️ New Action: \(type(of: newAction)).\(newAction)"
        } else {
            log += "\n➡️ Action: \(type(of: action)).\(action)"
        }
        
        log = log.replacingOccurrences(of: "Swift_Redux_Demo.", with: "")
        
        if let diff = diff(before, after) {
            log += "\n✅ State change \n\(diff)"
        } else {
            log += "\n✅ State change \nNo difference"
        }
        print(log)
#endif
    }
}
