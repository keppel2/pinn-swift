import os
do {
    try execute()
} catch let err where err is Perr {
    print((err as! Perr).string)
    exit(7)
}
