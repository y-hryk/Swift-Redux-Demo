//
//  MaintenanceViewStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/21.
//

import UIKit


struct MaintenancePageActionCreator<State: Redux.State> {
    @Injected(\.maintenanceRepository) private var maintenanceRepository: MaintenanceRepository
    
    func maintenanceCheckRequested() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                let status = try await maintenanceRepository.getStatus()
                switch status {
                case .InProgress:
                    return ApplicationAction.startScreenChanged(startScreen: .maintenance)
                case .completion:
                    return ApplicationAction.startScreenChanged(startScreen: .splash)
                }
            } catch let error {
                return ApplicationAction.errorReceived(error)
            }
        },
        className: "\(type(of: self))")
    }
}
