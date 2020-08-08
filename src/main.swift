import os
import Foundation
//let x = Array.init(repeating: 1, count: 0xFFFFF_FFFF)
let fm = FileManager.default
let str: String = fm.currentDirectoryPath
print(str)
print(str)

print(str)
//str.write

print("here")
//exit(0)

do {
    try execute()
} catch let err where err is Perr {
    print((err as! Perr).string)
    exit(7)
}
