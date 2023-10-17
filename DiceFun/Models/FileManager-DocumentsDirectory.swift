//
//  FileManager-DocumentsDirectory.swift
//  DiceFun
//
//  Created by Chuck Condron on 10/17/23.
//

import Foundation

extension FileManager {
  static var documentsDirectory: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}
