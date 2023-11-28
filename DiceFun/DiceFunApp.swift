//
//  DiceFunApp.swift
//  DiceFun
//
//  Created by Chuck Condron on 10/17/23.
//

import SwiftUI

@main
struct DiceFunApp: App {
  @State private var diceController = DiceController()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(diceController)
    }
  }
}
