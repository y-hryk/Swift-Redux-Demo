//
//  MaintenanceViewStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/21.
//

import UIKit

struct MaintenancePageStateActionCreator<S: ApplicationState>: Injectable {
    struct Dependency {
        let maintenanceRepository: MaintenanceRepository
    }
    private let dependency: Dependency
    
    init(with dependency: Dependency) {
        self.dependency = dependency
    }
    
    func signIn() async -> ThunkAction<S> {
        ThunkAction(function: { store, action in
            do {
                let status = try await dependency.maintenanceRepository.getStatus()
                switch status {
                case .InProgress:
                    return GlobalStateAction.update(startScreen: .maintenance)
                case .completion:
                    return GlobalStateAction.update(startScreen: .splash)
                }
            } catch let error {
                return GlobalStateAction.didReceiveError(error)
            }
        },
        className: "\(type(of: self))")
    }
}
