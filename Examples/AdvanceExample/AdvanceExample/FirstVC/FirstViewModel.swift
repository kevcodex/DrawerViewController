//
//  FirstViewModel.swift
//  AdvanceExample
//
//  Created by Chen, Kevin on 2/24/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import Foundation

class FirstViewModel {
    var cities: [City] = []
    
    func city(at index: Int) -> City? {
        return cities[safe: index]
    }
    
    func populate() {
        let city1 = City(title: "San Diego", description: "An awesome city")
        let city2 = City(title: "San Diego", description: "An awesome city")
        let city3 = City(title: "San Diego", description: "An awesome city")
        let city4 = City(title: "San Diego", description: "An awesome city")
        let city5 = City(title: "San Diego", description: "An awesome city")
        let city6 = City(title: "San Diego", description: "An awesome city")
        let city7 = City(title: "San Diego", description: "An awesome city")
        let city8 = City(title: "San Diego", description: "An awesome city")
        
        cities.append(contentsOf: [city1, city2, city3, city4, city5, city6, city7, city8])
    }
}

struct City {
    let title: String
    let description: String
}
