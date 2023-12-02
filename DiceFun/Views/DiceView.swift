//
//  DiceView.swift
//  DiceFun
//
//  Created by Chuck Condron on 11/24/23.
//

import SwiftUI

enum Dice {
  case diceOne, diceTwo
}

struct DiceView: View {
  @AppStorage("pickerColor") var pickerColor: PickerColor = .red
  @Environment(DiceController.self) var diceController
  
  let dice: Dice
  
  var diceVal: String { dice == .diceOne ? "\(pickerColor)\(diceController.diceVal1)" : "\(pickerColor)\(diceController.diceVal2)" }
  var degree: Double { dice == .diceOne ? diceController.degree : diceController.degree2 }
  var offsetX: CGFloat { dice == .diceOne ? diceController.dice1OffsetValX : diceController.dice2OffsetValX }
  var offsetY: CGFloat { dice == .diceOne ? diceController.dice1OffsetValY : diceController.dice2OffsetValY }
  var offsetZ: CGFloat { dice == .diceOne ? diceController.dice1OffsetValZ : diceController.dice2OffsetValZ }
  
  
  var body: some View {
    Image(diceVal)
      .resizable()
      .frame(width: 100, height:  100)
      .shadow(color: Color(pickerColor.rawValue).opacity(0.4), radius: 10, x: 10, y: -12)
      .rotation3DEffect(.degrees(degree), axis: (x: 0, y: 0, z: 1))
      .offset(x: offsetX, y: offsetY)
    
      .animation(Animation.interpolatingSpring(stiffness: 50, damping: 15), value: diceVal)
      .scaleEffect(offsetZ)
  }
  
  init(for dice: Dice) {
          self.dice = dice
      }
}

#Preview {
  DiceView(for: .diceOne)
    .environment(DiceController())
}
