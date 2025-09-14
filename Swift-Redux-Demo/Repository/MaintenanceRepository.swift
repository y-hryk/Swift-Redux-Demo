//
//  MaintenanceRepository.swift
//  MovieAppDemo
//
//  Created by h.yamaguchi on 2024/09/21.
//

import Foundation

protocol MaintenanceRepository: Sendable {
    func getStatus() async throws -> MaintenanceStatus
}

struct MaintenanceRepositoryImpl: MaintenanceRepository {
    func getStatus() async throws -> MaintenanceStatus {
        .completion
    }
}
