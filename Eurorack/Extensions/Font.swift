//
//  Font.swift
//  Eurorack
//
//  Created by Mattias Almén on 2025-08-09.
//

import Foundation
import SwiftUI

extension Font {
    
    public static var moduleTitle: Font {
        self.custom("DIN Condensed", size: 28)
    }
    
    public static var moduleSubtitle: Font {
        self.custom("DIN Condensed", size: 20)
    }
    
    public static var moduleDescription: Font {
        self.custom("DIN Condensed", size: 18)
    }
    
    public static var moduleQuiteSmall: Font {
        self.custom("DIN Condensed", size: 16)
    }
    
    public static var moduletTght: Font {
        self.system(size: 12)
    }
}

