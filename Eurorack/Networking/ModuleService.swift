//
//  ModuleService.swift
//  Eurorack
//
//  Created by Mattias Almén on 2025-08-01.
//

import Foundation

class ModuleService {
        
    func getModules() async throws -> [Module] {
        do {
            let modules = try await FetchClient.shared.fetch(for: [Module].self, endpoint: ModuleEndpoint.getModules)
            return modules
        } catch {
            print("ModuleService error: Could not fetch modules: \(error.localizedDescription)")
            return [ModuleStore.placeholderModule]
        }
    }
    
    func getModule(moduleID: Int) async throws -> Module {
        do {
            return try await FetchClient.shared.fetch(for: Module.self, endpoint: ModuleEndpoint.getModule(id: moduleID))
        } catch {
            print("ModuleService error: Could not fetch module with ID \(moduleID): \(error.localizedDescription)")
            return ModuleStore.placeholderModule
        }
    }
}
