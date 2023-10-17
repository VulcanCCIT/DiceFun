//
//  DiceData.swift
//  DiceFun
//
//  Created by Chuck Condron on 10/17/23.
//

import SwiftUI

struct RollResult: Identifiable, Codable {
  var id = UUID()
  var lastDice1RollValue: Int
  var lastDice2RollValue: Int
  var lastRollTotal: Int
  
  init(lastDice1RollValue: Int, lastDice2RollValue: Int, lastRollTotal: Int) {
    self.lastDice1RollValue = lastDice1RollValue
    self.lastDice2RollValue = lastDice2RollValue
    self.lastRollTotal = lastRollTotal
  }
}
