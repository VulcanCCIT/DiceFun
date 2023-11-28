//
//  PickerColor.swift
//  DiceFun
//
//  Created by Nigel Gee on 28/11/2023.
//

import SwiftUI

enum PickerColor: String, Hashable, Identifiable, CustomStringConvertible, CaseIterable {
  case red
  case yellow
  case green
  case blue
  case purple

  var id: String { rawValue }
  var description: String { rawValue.capitalized }

  var color: Color {
    switch self {
      case .red: .red
      case .yellow: .yellow
      case .green: .green
      case .blue: .blue
      case .purple: .purple
    }
  }
}
