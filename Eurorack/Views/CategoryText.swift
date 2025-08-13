//
//  CategoryText.swift
//  Eurorack
//
//  Created by Mattias Almén on 2025-08-10.
//

import SwiftUI

struct CategoryText: View {
    var categories: [String]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), alignment: .leading) {
            ForEach(Array(zip(categories.indices, categories)), id: \.1) { index, element in
                Text(element)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.almostWhite)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color.sage)
                    .background(in: .rect(cornerRadius: 3))
            }
        }
        .frame(alignment: .bottom)
    }
}
