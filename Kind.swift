//
//  Kind.swift
//  pinn
//
//  Created by Ryan Keppel on 11/14/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation

class Kind: Equatable {
    //
    enum Gtype {
        case gScalar, gArray, gMap, gSlice, gTuple
    }

    static func == (k1: Kind, k2: Kind) -> Bool {
        return k1.vtype == k2.vtype && k1.gtype == k2.gtype && k1.count == k2.count
    }
    init(_ vtype: Ptype.Type?, _ gtype: Gtype, _ count: Int? = nil) {
        self.vtype = vtype
        self.gtype = gtype
        switch gtype {
        case .gMap:
            self.count = 0
        case .gScalar:
            self.count = 1
        case .gSlice, .gArray:
            self.count = count
        default:
            de(ECASE)
        }
    }
    init(_ kar: [Kind]) {
        self.gtype = .gTuple
        self.count = kar.count
    }
    var ka = [Kind]()
    var vtype: Ptype.Type?
    var gtype: Gtype
    var count: Int?
    func kindEquivalent(_ k2: Kind) -> Bool {
        switch gtype {
        case .gArray, .gScalar:
            return self == k2
        case .gMap, .gSlice:
            return gtype == k2.gtype && vtype == k2.vtype
        case .gTuple:
            
            de(ECASE)
        }
    }
}
