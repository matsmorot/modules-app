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
            return modules ?? []
        } catch {
            print("ModuleService error: What we've got here is failure to communicate")
            return [ModuleStore.placeholderModule]
        }
    }
    
    func getModule(moduleID: Int) async throws -> Module? {
        do {
            let response = try await FetchClient.shared.fetch(for: Module.self, endpoint: ModuleEndpoint.getModule(id: moduleID))
            return response
        } catch {
            return ModuleStore.placeholderModule
        }
    }
}
