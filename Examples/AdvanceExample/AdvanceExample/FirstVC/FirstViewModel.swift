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
        let city1 = City(title: "San Diego", description: "Surfs up city")
        let city2 = City(title: "Los Angeles", description: "A city with a lot of traffic")
        let city3 = City(title: "San Francisco", description: "Tech tech tech city")
        let city4 = City(title: "Seattle", description: "Coffee city")
        let city5 = City(title: "New York City", description: "The city that never sleeps")
        let city6 = City(title: "Washington DC", description: "Capital city")
        let city7 = City(title: "Las Vegas", description: "Gambling city")
        
        cities.append(contentsOf: [city1, city2, city3, city4, city5, city6, city7])
    }
}

struct City {
    let title: String
    let description: String
}
