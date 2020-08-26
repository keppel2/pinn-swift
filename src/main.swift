import os
import Foundation
//let x = Array.init(repeating: 1, count: 0xFFFFF_FFFF)
let fm = FileManager.default
//str.write

//exit(0)

do {
    try execute()
} catch let err where err is Perr {
    print((err as! Perr).string)
    exit(7)
}
