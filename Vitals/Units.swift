//
//  Units.swift
//  Vitals
//
//  Created by Mariecor Maranoc on 11/19/19.
//  Copyright © 2019 009252542SalvadorRodriguez. All rights reserved.
//

import Foundation

class UnitConverterPace: UnitConverter {
    
    private let coefficient: Double
    
    
    
    init(coefficient: Double) {
        
        self.coefficient = coefficient
        
    }
    
    
    
    override func baseUnitValue(fromValue value: Double) -> Double {
        
        return reciprocal(value * coefficient)
        
    }
    
    
    
    override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
        
        return reciprocal(baseUnitValue * coefficient)
        
    }
    
    
    
    private func reciprocal(_ value: Double) -> Double {
        
        guard value != 0 else { return 0 }
        
        return 1.0 / value
        
    }
    
}

extension UnitSpeed {
    
    class var metersPerSec: UnitSpeed {
        
        return UnitSpeed(symbol: "m/sec", converter: UnitConverterPace(coefficient: 1))
        
    }
    
    
    
    class var kilometersPerMin: UnitSpeed {
        
        return UnitSpeed(symbol: "km/min", converter: UnitConverterPace(coefficient: 1000.0 / 60.0))
        
    }
    
    
    
    class var milesPerMin: UnitSpeed {
        
        return UnitSpeed(symbol: "mi/min", converter: UnitConverterPace(coefficient: 1609.34 / 60.0))
        
    }
    
}
