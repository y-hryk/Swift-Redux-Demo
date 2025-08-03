//
//  MaintenanceViewStateAction.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/21.
//

import UIKit


struct MaintenancePageActionCreator<State: Redux.State> {
    @Injected(\.maintenanceRepository) private var maintenanceRepository: MaintenanceRepository
    
    func signIn() async -> Redux.ThunkAction<State> {
        Redux.ThunkAction(function: { store, action in
            do {
                let status = try await maintenanceRepository.getStatus()
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
