import os
//let x = Array.init(repeating: 1, count: 0xFFFFF_FFFF)
do {
    try execute()
} catch let err where err is Perr {
    print((err as! Perr).string)
    exit(7)
}
