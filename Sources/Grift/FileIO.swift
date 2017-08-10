#if os(Linux)
  // Linux uses Glibc
  import struct Glibc.FILE
  import func   Glibc.fopen
  import func   Glibc.fgets
  import func   Glibc.fclose
#else
  // OS X uses Darwin
  import struct Darwin.C.FILE
  import func   Darwin.C.fopen
  import func   Darwin.C.fgets
  import func   Darwin.C.fclose
#endif

import Foundation

//Read the contents of a UTF8 file into a string
public func readFile(path: String) -> String? {
  let filePointer = fopen(path, "r")

  guard filePointer != nil else {
    return nil
  }

  // Read in 256b chunks
  let length = 256
  var result = String()
  let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: length)
  while fgets(buffer, Int32(length), filePointer) != nil {

    result += String.init(validatingUTF8: buffer) ?? ""
  }
  fclose(filePointer)
  return result
}

// Convert String to UInt8 bytes
private func bytesFromString(string: String) -> [UInt8] {
  return Array(string.utf8)
}

// Convert UInt8 bytes to String
private func stringFromBytes(bytes: UnsafeMutablePointer<UInt8>, count: Int) -> String {
  return String((0 ..< count).map({
    Character(UnicodeScalar(bytes[$0]))
  }))
}

// Write the contents of a string to a file in UTF8

public func writeStringToFile(string: String, path: String) -> Bool {

  let filePointer = fopen(path, "w")
  defer { fclose(filePointer) }

  let byteArray = bytesFromString(string: string)

  let count = fwrite(byteArray, 1, byteArray.count, filePointer)

  return count == string.utf8.count
}
