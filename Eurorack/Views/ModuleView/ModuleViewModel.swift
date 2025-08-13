//
//  CollectionViewCellModel.swift
//  Eurorack
//
//  Created by Mattias Almén on 2025-08-02.
//

import Foundation
import SwiftUI

class ModuleViewModel: ObservableObject {
    var id: Int
    @Published var module: Module?
    
    private let moduleService = ModuleService()
    
    init(id: Int) {
        self.id = id
        Task { try await fetchModule(moduleID: id) }
    }
    
    func fetchModule(moduleID: Int) async throws {
        do {
            let module = try await moduleService.getModule(moduleID: moduleID)
            await MainActor.run {
                self.module = module
            }
        } catch {
            print("DEBUG ERROR: Couldn't get module from service")
        }
    }
    
}
