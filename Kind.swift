//
//  Kind.swift
//  pinn
//
//  Created by Ryan Keppel on 11/14/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation

class Kind {


    
    init(_ vtype: Ptype.Type) {
        self.vtype = vtype
        self.gtype = .gScalar
        self.count = 1
    }

    init(_ k: Kind?, _ gtype: Gtype, _ count: Int? = nil) {
        self.gtype = gtype
        switch gtype {
        case .gScalar, .gTuple:
            de(ECASE)
        case .gPointer:
            ade(k == nil)
            ade(count == nil)
            
            self.count = 0
        case .gMap:
            ade(count == nil)
            self.count = 0
            self.k = k
        case .gArray, .gSlice:
            self.count = count!
            self.k = k
        }
    }
    init(_ karin: [Kind]) {
        gtype = .gTuple
        var kar = karin
        self.count = kar.count
                    for (k, v) in kar.enumerated() {
                        if v.vtype == Nil.self  {
                            gtype = .gPointer
                            kar[k] = self
                        }
                    }
        ka = kar
    }
    
    var ka: [Kind]?
    var k: Kind?
    var vtype: Ptype.Type?
    var gtype: Gtype
    var count: Int

    
    
    func kindEquivalent(_ k2: Kind) -> Bool {
//        return true
        if gtype == .gPointer {
            return k2.gtype == self.gtype
        }
        if let v = vtype {
            ade(gtype == .gScalar && k2.gtype == .gScalar)
            return v == k2.vtype!
        }
        if let ki = k {
            switch gtype {
            case .gArray:
                return ki.kindEquivalent(k2.k!) && gtype == k2.gtype && count == k2.count
            case .gMap, .gSlice:
                return ki.kindEquivalent(k2.k!) && gtype == k2.gtype
            case .gTuple, .gScalar, .gPointer:
                de(ECASE)
            }
        }

        return ka!.elementsEqual(k2.ka!, by: {
//            if $0 == nil && $1 == nil {
//                return true
//            }
            return $0.kindEquivalent($1)
            
        })
    }
}
