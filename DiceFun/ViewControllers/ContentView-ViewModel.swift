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
    
    //@AppStorage("pickerColor") var pickerColor: PickerColor = .red
    @AppStorage("soundOn") var soundOn = false
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedRolls.json")
    
    @Published var feedback = UIImpactFeedbackGenerator(style: .rigid)
    
    //@Published private(set) var diceRolls: [RollResult]
    @Published var diceRolls: [RollResult]
    @Published var showingDiceRollList = false
        
    @Published var rollTotal = 2
    @Published var degree = 0.0
    @Published var degree2 = 0.0
    @Published var angle: Double = 0
    @Published var bounce = false
    
    @Published var dice1OffsetValX: CGFloat = 0
    @Published var dice1OffsetValY: CGFloat = -250
    @Published var dice2OffsetValX: CGFloat = 0
    @Published var dice2OffsetValY: CGFloat = -250
    
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
      //print(diceRolls)
      
      save()
    }
    
    func playSounds(_ soundFileName : String) {
      guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: nil) else {
        fatalError("Unable to find \(soundFileName) in bundle")
      }
      
      do {
        diceRollSound = try AVAudioPlayer(contentsOf: soundURL)
      } catch {
        print(error.localizedDescription)
      }
      diceRollSound.play()
    }
    
    func spin() {
      isActive = true
      if soundOn { playSounds("DiceRollCustom1.wav") }
      timeRemaining = 10
      print("time remaining: \(timeRemaining)")
      bounce.toggle()
      degree += 360
      degree2 += 360
      angle += 45
    }
    
    func diceOffset() {
      //print("diceOffSet Called")
      //print(isActive)
      guard isActive else { return }
      
      if timeRemaining > 0 {
        timeRemaining -= 1
        diceVal1 = Int.random(in: 1...6)
        diceVal2 = Int.random(in: 1...6)
        
        dice1OffsetValX = CGFloat.random(in: -20...40)
        dice1OffsetValY = CGFloat.random(in: -400...30)
        dice2OffsetValX = CGFloat.random(in: -20...40)
        dice2OffsetValY = CGFloat.random(in: -400...30)
        
        if soundOn { feedback.impactOccurred() }
        
        print("Time Remaining is: \(timeRemaining)")
        print("ValX \(dice1OffsetValX)")
        print("ValY \(dice1OffsetValY)")
        print("Bounce State is \(bounce)")
      }
      if timeRemaining == 1 { isActive = false
        
        print("timerstopped")
        //bounce.toggle()
        updateRolls()
      }
    }
  }
}
