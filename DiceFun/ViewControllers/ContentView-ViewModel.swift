//
//  ContentView-ViewModel.swift
//  DiceFun
//
//  Created by Chuck Condron on 10/17/23.
//

import AVFoundation
import SwiftUI

extension ContentView {
  @MainActor class ViewModel: ObservableObject {
    
    @AppStorage("soundOn") var soundOn = false
    
    @Published var showingDiceRollList = false
    
    @Published var diceRollSound: AVAudioPlayer!
    
    
    func playSounds(_ soundFileName : String) {
      guard soundOn else { return }
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
  }
}
