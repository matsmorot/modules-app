//
//  Appearance.swift
//  Eurorack
//
//  Created by Mattias Almén on 2025-08-02.
//

import Foundation
import UIKit
struct Appearance {
    static let sectionHeaderFont: UIFont = {
        let boldFontDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .largeTitle)
            .withSymbolicTraits(.traitBold)!
        return UIFont(descriptor: boldFontDescriptor, size: 0)
    }()
    
    static let postImageHeightRatio = 0.8
    
    static let titleFont: UIFont = {
        let descriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .title1)
            .withSymbolicTraits(.traitBold)!
        return UIFont(descriptor: descriptor, size: 0)
    }()
    
    static let subtitleFont: UIFont = {
        let descriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .title2)
            .withSymbolicTraits(.traitBold)!
        return UIFont(descriptor: descriptor, size: 0)
    }()
    
    static let likeCountFont: UIFont = {
        let descriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .subheadline)
            .withDesign(.monospaced)!
        return UIFont(descriptor: descriptor, size: 0)
    }()
}
