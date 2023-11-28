//
//  FileManager-DocumentsDirectory.swift
//  DiceFun
//
//  Created by Chuck Condron on 10/17/23.
//

import Foundation

extension FileManager {
  private func getDocumentsDirectory() -> URL {
    let paths = self.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  func encode<T: Encodable>(_ input: T, to file: String) throws {
    let url = getDocumentsDirectory().appendingPathComponent(file)
    let encoder = JSONEncoder()
    
    let data = try encoder.encode(input)
    try data.write(to: url, options: [.atomic, .completeFileProtection])
  }
  
  func decode<T: Decodable>(_ type: T.Type = T.self,
                            from file: String,
                            dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                            keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
  )  throws -> T {
    let url = getDocumentsDirectory().appendingPathComponent(file)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = dateDecodingStrategy
    decoder.keyDecodingStrategy = keyDecodingStrategy
    
    let data = try Data(contentsOf: url)
    let loaded = try decoder.decode(T.self, from: data)
    return loaded
  }
}
