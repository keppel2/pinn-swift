//
//  Kind.swift
//  pinn
//
//  Created by Ryan Keppel on 11/14/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation


enum Kinde {
    case vt(Ptype.Type)
    case k(Kind)
    case km([Kind])
    
    func getVt() -> Ptype.Type {
        if case .vt(let pw) = self {
            return pw
        }
        de(ECASE)
    }
        func getK() -> Kind {
            if case .k(let ar) = self {
                return ar
            }
            de(ECASE)
        }
        func getKm() -> [Kind] {
            if case .km(let map) = self {
                return map
            }
            de(ECASE)
        }
    
    
    
    
}

    
class Kind {


    
    init(_ vtype: Ptype.Type) {
        ke = .vt(vtype)
        gtype = .gScalar
        count = 1
    }

    init(_ k: Kind?, _ gtype: Gtype, _ count: Int? = nil) {
        self.gtype = gtype
        switch gtype {
        case .gScalar, .gTuple, .gPointer:
            de(ECASE)
//        case .gPointer:
//            ade(k == nil)
//            ade(count == nil)
//            self.count = 0
//            ke = .vt(Nil.self)
//
        case .gMap:
            ade(count == nil)
            self.count = 0
            ke = .k(k!)
        case .gArray, .gSlice:
            self.count = count!
            ke = .k(k!)
        }
    }
    init(_ ka: [Kind]) {
        gtype = .gTuple
        var kar = ka
        self.count = kar.count
        ke = .vt(Nil.self)
                    for (k, v) in kar.enumerated() {
                            if case .vt(let vt) = v.ke {
                                if vt == Nil.self {
                                    gtype = .gPointer
                                    kar[k] = self
                                }

                                
                            }
                    }
        ke = .km(kar)
    }
    var ke: Kinde
  
    var gtype: Gtype
    var count: Int
    func isNil() -> Bool {
        return gtype == .gScalar && ke.getVt() == Nil.self
    }
    func isPointer() -> Bool {
        return gtype == .gPointer
    }
    
    func kindEquivalent(_ k2: Kind, _ sg: Bool ) -> Bool {
//        return true
        if isNil() && k2.isPointer() || isPointer() && k2.isNil() {
            return true
        }
        if gtype == .gPointer && !sg{
            return gtype == k2.gtype
        }
        switch ke {
        case .vt(let vt):
            ade(gtype == .gScalar && k2.gtype == .gScalar)
            return vt == k2.ke.getVt()
        case .k(let k):
            switch gtype {
            case .gArray:
                return k.kindEquivalent(k2.ke.getK(), true) && gtype == k2.gtype && count == k2.count
            case .gMap, .gSlice:
                return k.kindEquivalent(k2.ke.getK(), true) && gtype == k2.gtype
            case .gTuple, .gScalar, .gPointer:
                de(ECASE)
            }
        case .km(let km):
            return km.elementsEqual(k2.ke.getKm(), by: {
                    return $0.kindEquivalent($1, false)
            })
        }
    }
}
