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
    static func == (k1: Kind, k2: Kind) -> Bool {
        return k1.vtype == k2.vtype && k1.gtype == k2.gtype && k1.count == k2.count
    }
    init(vtype: Ptype.Type, gtype: Gtype, count: Int?) {
        self.vtype = vtype
        self.gtype = gtype
        self.count = count
    }
    var vtype: Ptype.Type
    var gtype: Gtype
    var count: Int?
    func kindEquivalent(_ k2: Kind) -> Bool {
        switch gtype {
        case .gArray, .gScalar:
            return self == k2
        case .gMap, .gSlice:
            return gtype == k2.gtype && vtype == k2.vtype
        }
    }
    //    }
}
