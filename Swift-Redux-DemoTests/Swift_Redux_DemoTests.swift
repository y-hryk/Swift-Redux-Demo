//
//  Swift_Redux_DemoTests.swift
//  Swift-Redux-DemoTests
//
//  Created by h.yamaguchi on 2024/12/31.
//

import Testing
import XCTest
@testable import Swift_Redux_Demo

struct Swift_Redux_DemoTests {
    @Test func store_serialize() async throws {
        let reduxThunkMiddleware: Middleware<AppState> = thunkMiddleware()
        let store = ReduxStore(
            reducer: AppState.reducer,
            middlewares: [
                reduxThunkMiddleware,
                Middlewares.errorToast,
                Middlewares.webApiErrorHandle
            ],
            afterMiddlerare: Middlewares.loggerAfter
        )
        let actionCreator = ActionCreator<AppState>()
        let taskDetached = Task.detached {
            await store.dispatch(actionCreator.testAction(number: 1, time: 4, screen: .splash))
            await store.dispatch(actionCreator.testAction(number: 2, time: 1, screen: .maintenance))
            await store.dispatch(actionCreator.testAction(number: 3, time: 1, screen: .maintenance))
            await store.dispatch(actionCreator.testAction(number: 4, time: 1, screen: .maintenance))
            await store.dispatch(actionCreator.testAction(number: 5, time: 1, screen: .root))
        }

        await taskDetached.value
        let result = await store.state.globalState.startScreen
        XCTAssertEqual(result, .root)
        
        struct ActionCreator<S: ApplicationState> {
            func testAction(number: Int, time: Int, screen: StartScreen) async -> ThunkAction<S> {
                ThunkAction(function: { store, action in
                    do {
                        print("number: \(number)")
                        try await Task.sleep(for: .seconds(time))
                        return GlobalStateAction.show(screen)
                    } catch let error {
                        return GlobalStateAction.errorReceived(error)
                    }
                }, className: "\(type(of: self))")
            }
        }
    }
    
    @Test func store_exclusive_control() async throws {
        
        let reduxThunkMiddleware: Middleware<TestState> = thunkMiddleware()
        let store = ReduxStore(
            reducer: TestState.reducer,
            middlewares: [
                reduxThunkMiddleware,
            ],
            afterMiddlerare: nil
        )
        
        let task = Task {
            for _ in 0..<100 {
                await store.dispatch(TestAction.increment)
            }
        }
        let taskDetached = Task.detached {
            for _ in 0..<100 {
                await store.dispatch(TestAction.increment)
            }
        }
        
        await task.value
        await taskDetached.value
        
        let result = await store.state.count
        print(result)
        
        struct TestState: ApplicationState {
            var count = 0
            static let reducer: Reducer<Self> = { state, actionContainer in
                var state = state
                switch actionContainer.baseAction {
                case TestAction.increment:
                    state.count += 1
                default: break
                }
                return state
            }
        }
        
        enum TestAction: Action {
            case increment
        }
    }
}
