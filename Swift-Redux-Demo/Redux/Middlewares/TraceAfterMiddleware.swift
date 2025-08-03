//
//  LoggerAfterMiddleware.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/15.
//

import CustomDump

extension Redux {
    static func traceAfterMiddleware<S: Redux.State>() -> Redux.AfterMiddleware<S> {
        return { before, after, action, newAction in
            var log = ""
            
            if let action = action as? Redux.ThunkAction<S> {
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
        }
    }
}
