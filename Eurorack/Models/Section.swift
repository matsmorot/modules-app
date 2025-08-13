//
//  Section.swift
//  Eurorack
//
//  Created by Mattias Almén on 2025-08-10.
//

import Foundation

struct Section: Identifiable, Hashable {
    
    enum Identifier: String, CaseIterable {
        case main = "Main"
    }
    
    var id: Identifier
    var modules: [Module.ID]
}
