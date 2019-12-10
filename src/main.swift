//
//  main.swift
//  pinn
//
//  Created by Ryan Keppel on 10/19/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//
import os

do {
    try execute()
} catch let err where err is Perr {
    print((err as! Perr).string)
    exit(7)
}
