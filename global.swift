//
//  global.swift
//  pinn
//
//  Created by Ryan Keppel on 11/23/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation
let EPARAM_LENGTH = "Parameter length mismatch"
let ESTATEMENT = "Wrong statement"
let ETYPE      = "Wrong type"
let ERANGE          = "Out of range"
let ECASE           = "Case unimplemented"
let EREDECLARE = "Redeclared"
let EUNDECLARED = "Undeclared"
let ETEST_FAIL = "Test failed"
let EPARSE_FAIL = "Parse failed"
let EASSERT = "Assertion failed"
let EUI = "Unimplemented"

enum Gtype {
    case gScalar, gArray, gMap, gSlice, gTuple, gPointer
}
