//
//  DiceRollListView.swift
//  DiceFun
//
//  Created by Chuck Condron on 10/17/23.
//

import SwiftUI

struct DiceRollListView: View {
  @Environment(DiceController.self) var dataController
  
  @State private var showingAlert = false
  
  var body: some View {
    Text("Past Dice Results")
      .font(.title2).bold()
    
    List {
      ForEach(dataController.rollResults) { roll in
        HStack {
          Image("\(roll.lastDiceColor)\(roll.lastDice1RollValue)")
            .resizable()
            .scaledToFit()
            .frame(width: 50)
            .padding(.horizontal)
          
          Image("\(roll.lastDiceColor)\(roll.lastDice2RollValue)")
            .resizable()
            .scaledToFit()
            .frame(width: 50)
          
          Spacer()
          Text("Roll Total: ")
            .fontWeight(.bold)
          Text("\(roll.lastRollTotal)")
            .font(.title2)
            .foregroundColor(.red)
            .fontWeight(.bold)
          
        }//HStack
      }//List
      .onDelete(perform: dataController.delete)
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
            dataController.rollResults = []
            print("Deleting...")
            if dataController.rollResults.isEmpty {
              dataController.save()
            }
          },
          secondaryButton: .cancel()
        )
      }
      }//tb
    }
  }//View
}

#Preview {
  DiceRollListView()
    .environment(DiceController())
}
