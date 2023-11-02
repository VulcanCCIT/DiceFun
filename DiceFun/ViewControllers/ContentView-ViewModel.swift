//
//  ContentView-ViewModel.swift
//  DiceFun
//
//  Created by Chuck Condron on 10/17/23.
//

import AVFoundation
import Foundation
import SwiftUI
import UIKit

extension ContentView {
  @MainActor class ViewModel: ObservableObject {
    
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedRolls.json")
    
    @Published var feedback = UIImpactFeedbackGenerator(style: .rigid)
    
    @Published private(set) var diceRolls: [RollResult]
    @Published var showingDiceRollList = false
    
    //@Published var segmentColor: UIColor = .blue
    
    @Published var rollTotal = 2
    @Published var degree = 0.0
    @Published var degree2 = 0.0
    @Published var angle: Double = 0
    @Published var bounce = false
    
    @Published var dice1OffsetValX: CGFloat = 0
    @Published var dice1OffsetValY: CGFloat = 0
    @Published var dice2OffsetValX: CGFloat = 0
    @Published var dice2OffsetValY: CGFloat = 0
    
    @Published var diceVal1 = 1
    @Published var diceVal2 = 1
    
    @Published var timeRemaining = 0
    @Published var isActive = false
    
    @Published var diceRollSound: AVAudioPlayer!
    
    init() {
      do {
        let data = try Data(contentsOf: savePath)
        diceRolls = try JSONDecoder().decode([RollResult].self, from: data)
      } catch {
        diceRolls = []
      }
    }
    
    func save() {
      do {
        let data = try JSONEncoder().encode(diceRolls)
        try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
      } catch {
        print("Unable to save data.")
      }
    }
    
    func updateRolls() {
      rollTotal = diceVal1 + diceVal2
      diceRolls.append(RollResult(lastDice1RollValue: diceVal1, lastDice2RollValue: diceVal2, lastRollTotal: rollTotal))
      print(diceRolls)
      
      save()
    }
  }
}
