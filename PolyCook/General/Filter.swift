//
//  Filter.swift
//  PolyCook
//
//  Created by Radu Bortan on 06/03/2022.
//

import Foundation

class Filter : ObservableObject {
    @Published var filters : [FilterItem]
    
    init(filters: [FilterItem]) {
        self.filters = filters
    }
}
