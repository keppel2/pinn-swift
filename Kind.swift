//
//  Kind.swift
//  pinn
//
//  Created by Ryan Keppel on 11/14/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation

class Kind {
    enum Gtype {
        case gScalar, gArray, gMap, gSlice, gTuple
    }

    /*
    func equal(_ k2: Kind) -> Bool {
        if vtype == nil {
            return ka!.elementsEqual(k2.ka!, by: {$0.equal($1)})
        }
        return vtype == k2.vtype && gtype == k2.gtype && count == k2.count
    }
 */
    
    init(_ vtype: Ptype.Type) {
        self.vtype = vtype
        self.gtype = .gScalar
        self.count = 1
    }
//    init(kind: Kind, _ gtype: Gtype, _ count: Int? = nil) {
//        self.gtype = gtype
//        switch gtype {
//        case .gScalar, .gTuple:
//            de(ECASE)
//        }
//    }
    init(_ k: Kind, _ gtype: Gtype, _ count: Int? = nil) {
        self.gtype = gtype
        switch gtype {
        case .gScalar, .gTuple:
            de(ECASE)
        case .gMap:
            ade(count == nil)
            self.count = 0
            self.k = k
        case .gArray, .gSlice:
            self.count = count!
            self.k = k
        }
    }
    init(_ kar: [Kind]) {
        self.gtype = .gTuple
        self.count = kar.count
        ka = kar
    }
    var ka: [Kind]?
    var k: Kind?
    var vtype: Ptype.Type?
    var gtype: Gtype
    var count: Int

    
    
    func kindEquivalent(_ k2: Kind) -> Bool {
        return true
//        if let v = vtype {
//            switch gtype {
//            case .gArray, .gScalar:
//                return v == k2.vtype! && gtype == k2.gtype && count == k2.count
//            case .gMap, .gSlice:
//                return gtype == k2.gtype && v == k2.vtype!
//            case .gTuple:
//                de(ECASE)
//            }
//        }
//        if let ki = k {
//            switch gtype {
//            case .gArray:
//                return ki.kindEquivalent(k2.k!) && gtype == k2.gtype && count == k2.count
//            case .gMap, .gSlice:
//                return ki.kindEquivalent(k2.k!) && gtype == k2.gtype
//            case .gTuple, .gScalar:
//                de(ECASE)
//            }
//        }
//
//        return ka!.elementsEqual(k2.ka!, by: {$0.kindEquivalent($1)})
    }
}
