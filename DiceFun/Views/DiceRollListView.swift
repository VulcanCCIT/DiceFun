//
//  DiceRollListView.swift
//  DiceFun
//
//  Created by Chuck Condron on 10/17/23.
//

import SwiftUI

struct DiceRollListView: View {
  @Environment(\.scenePhase) var scenePhase
  @StateObject private var viewModel = ContentView.ViewModel()
  @State private var showingAlert = false
  
  var body: some View {
    Text("Past Dice Results")
      .font(.title2).bold()
    
    List {
      ForEach(viewModel.diceRolls) { roll in
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
          
        }//HStack
      }//List
      .onDelete(perform: removeRolls)
    }//ForEach
    .toolbar {
      ToolbarItem(placement: .destructiveAction) {
        Button {
          showingAlert.toggle()
          print("button pressed.......")
        }
      label: {
        Image(systemName: "trash.circle")
      }
      .alert(isPresented:$showingAlert) {
        Alert(
          title: Text("Delete All Rolls?"),
          message: Text("There is no undo"),
          primaryButton: .destructive(Text("Delete")) {
            viewModel.diceRolls = []
            print("Deleting...")
            viewModel.save()
          },
          secondaryButton: .cancel()
        )
      }
      }//tb
    }
    .onChange(of: scenePhase) { //newPhase in
      if scenePhase == .active {
        viewModel.isActive = true
      } else {
        viewModel.isActive = false
      }
    }
  }//View
  
  func removeRolls(at offsets: IndexSet) {
    viewModel.diceRolls.remove(atOffsets: offsets)
    viewModel.save()
    print("DiceRollListView Save was called")
  }
  
}

#Preview {
  //DiceRollListView(diceRolls: [RollResult(lastDice1RollValue: 3, lastDice2RollValue:4, lastRollTotal: 7)])
  DiceRollListView()
}
