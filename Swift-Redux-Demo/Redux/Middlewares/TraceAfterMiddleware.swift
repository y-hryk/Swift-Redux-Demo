//
//  LoggerAfterMiddleware.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/15.
//

import CustomDump

extension Middlewares {
//    static let loggerAfter: AfterMiddleware<AppState> = { before, after, action, newAction in
//        print(">> loggerAfter")
//        var log = ""
//        
//        if let action = actionContainer.baseAction as? MapAction,
//           let thunkAction = action.originalAction as? ThunkAction {
//            log += "\n⬜ Caller: \(actionContainer.caller.replacingOccurrences(of: "MovieAppDemo/", with: ""))"
//            log += "\n➡️ Action: \(type(of: thunkAction))(\(thunkAction.caller()))"
//            log += "\n➡️➡️ New Action: \(type(of: newActionContainer.action)).\(newActionContainer.action)"
//        } else if let action = actionContainer.baseAction as? ThunkAction {
//            log += "\n⬜ Caller: \(actionContainer.caller.replacingOccurrences(of: "MovieAppDemo/", with: ""))"
//            log += "\n➡️ Action: \(type(of: action))(\(action.caller()))"
//            log += "\n➡️➡️ New Action: \(type(of: newActionContainer.action)).\(newActionContainer.action)"
//        } else {
//            log += "\n⬜ Caller: \(actionContainer.caller.replacingOccurrences(of: "MovieAppDemo/", with: ""))"
//            log += "\n➡️ Action: \(type(of: actionContainer.action)).\(actionContainer.action)"
//        }
//        
//        if let diff = diff(before, after) {
//            log += "\n✅ State change \n\(diff)"
//        } else {
//            log += "\n✅ State change \nNo difference"
//        }
//        print(log)
//    }
}

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
