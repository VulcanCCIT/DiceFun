//
//  DataController.swift
//  DiceFun
//
//  Created by Nigel Gee on 28/11/2023.
//  Modified by Chuck Condron on 11/28/2023
//

import SwiftUI
import UIKit

@Observable
class DiceController {
  var rollResults: [RollResult]
  
  var lastDiceColor = "Red"
  
  var isActive = false
  var timeRemaining = 0
  
  var rollTotal = 2
  var diceVal1 = 1
  var diceVal2 = 1
  
  var dice1OffsetValX: CGFloat = 0
  var dice1OffsetValY: CGFloat = -50
  var dice2OffsetValX: CGFloat = 0
  var dice2OffsetValY: CGFloat = -50
  
  var dice1OffsetValZ: CGFloat = 1
  var dice2OffsetValZ: CGFloat = 1
  
  var degree = 0.0
  var degree2 = 0.0
  var angle: Double = 0
  var bounce = false
  
  var soundOn = UserDefaults.standard.bool(forKey: "soundOn")
  var feedback = UIImpactFeedbackGenerator(style: .rigid)
  
  let fileName = "results.json"
  
  init() {
    do {
      rollResults = try FileManager().decode(from: fileName)
    } catch {
      rollResults = []
    }
  }
  
  func save() {
    do {
      try FileManager().encode(rollResults, to: fileName)
    } catch {
      print("Failed to encode results")
    }
  }
  
  func delete(_ offsets: IndexSet) {
    rollResults.remove(atOffsets: offsets)
    save()
  }
  
  func updateRolls() {
    rollTotal = diceVal1 + diceVal2
    rollResults.append(RollResult(lastDice1RollValue: diceVal1, lastDice2RollValue: diceVal2, lastRollTotal: rollTotal, lastDiceColor: lastDiceColor))
    print(lastDiceColor)
    
    save()
  }
  
  func diceOffset() {
    guard isActive else { return }
    
    if timeRemaining > 0 {
      timeRemaining -= 1
      diceVal1 = Int.random(in: 1...6)
      diceVal2 = Int.random(in: 1...6)
      
      dice1OffsetValX = CGFloat.random(in: -20...40)
      dice1OffsetValY = CGFloat.random(in: -100...100)
      dice2OffsetValX = CGFloat.random(in: -20...40)
      dice2OffsetValY = CGFloat.random(in: -100...100)
      
      dice1OffsetValZ = CGFloat.random(in: 1...2.0)
      dice2OffsetValZ = CGFloat.random(in: 1...2.0)
      
      if soundOn { feedback.impactOccurred() }
      
    }
    if timeRemaining == 1 {
      isActive = false
      dice1OffsetValZ = 1
      dice2OffsetValZ = 1
      print("timerstopped")
      updateRolls()
    }
  }
  
  func spin() {
    isActive = true
    timeRemaining = 10
    dice1OffsetValZ = 1
    dice2OffsetValZ = 1
    bounce.toggle()
    degree += 360
    degree2 += 360
    angle += 45
  }
}
