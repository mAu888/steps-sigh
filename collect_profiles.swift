#!/usr/bin/swift

import Foundation

let args = NSProcessInfo.processInfo().arguments
let fm = NSFileManager.defaultManager()
guard let path = args.last where fm.fileExistsAtPath(path) else {
  print("Missing temporary directory that contains provisioning profiles.")
  exit(1)
}

let url = NSURL(fileURLWithPath: path)
guard let items = try? fm.contentsOfDirectoryAtURL(url, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions()) else {
  print("Could not collect contents of provisioning profiles directory.")
  exit(1)
}

let pathWithTrailingSlash = path.hasSuffix("/") ? path : "\(path)/"
let profiles = items
  .filter { $0.absoluteString.hasSuffix(".mobileprovision") }
  .map { $0.absoluteString }

guard profiles.count > 0 else {
  print("No provisioning profiles found in directory.")
  exit(1)
}

print(profiles.joinWithSeparator("|"))
