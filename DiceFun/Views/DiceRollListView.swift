//
//  DiceRollListView.swift
//  DiceFun
//
//  Created by Chuck Condron on 10/17/23.
//

import SwiftUI

struct DiceRollListView: View {
  @Environment(\.dismiss) var dismiss
  var diceRolls: [RollResult]
  
  var body: some View {
    HStack {
      Button {
        dismiss()
      } label: {
        Image(systemName: "arrow.left")
          .padding(.leading)
        Text("Back")
        
      }
      Spacer()
    }
    Text("Past Dice Results")
      .font(.title2).bold()
    
    List(diceRolls) { roll in
      HStack {
        Text("Dice 1: ")
          .fontWeight(.bold)
        Text("\(roll.lastDice1RollValue)")
          .font(.title2)
          .foregroundColor(.blue)
          .fontWeight(.bold)
        
        Text("Dice 2: ")
          .fontWeight(.bold)
        Text("\(roll.lastDice2RollValue)")
          .font(.title2)
          .foregroundColor(.green)
          .fontWeight(.bold)
        
        Text("Roll Total: ")
          .fontWeight(.bold)
        Text("\(roll.lastRollTotal)")
          .font(.title2)
          .foregroundColor(.red)
          .fontWeight(.bold)
        
      }
    }
  }
}

#Preview {
  DiceRollListView(diceRolls: [RollResult(lastDice1RollValue: 3, lastDice2RollValue:4, lastRollTotal: 7)])
}
