//
//  ContentView.swift
//  DiceFun
//
//  Created by Chuck Condron on 10/17/23.
//

//
//  ContentView.swift
//  DiceFun
//
//  Created by Chuck Condron on 10/17/23.
//

import AVFoundation
import SwiftUI

extension String {
  func capitalizingFirstLetter() -> String {
    return prefix(1).capitalized + dropFirst()
  }
  
  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}

struct ContentView: View {
  @Environment(DiceController.self) var diceController
  @StateObject private var viewModel = ViewModel()
  
  @Environment(\.scenePhase) var scenePhase
  @AppStorage("pickerColor") var pickerColor: PickerColor = .red
  
  var timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
  
  var body: some View {
    
    NavigationStack {
      VStack {
        Picker(selection: $pickerColor, content: {
          ForEach(PickerColor.allCases) { color in
            Text(color.description)
              .tag(color)
          }
        }, label: EmptyView.init)
        .pickerStyle(.segmented)
        .tint(pickerColor.color)
        .onAppear(perform: updatePickerColor)
        .onChange(of: pickerColor,
                  updatePickerColor)
        .padding(.bottom)
        
        Text("Roll Total: \(diceController.rollTotal)")
          .frame(width: 200)
          .background(.red)
          .foregroundColor(.white)
          .font(.title.bold())
          .ignoresSafeArea()
          .clipShape(Capsule())
        ZStack {
          Image("Leather4")
            .resizable()
            .shadow(color: .secondary.opacity(0.7), radius: 20)
            .padding()
          HStack {
            DiceView(diceVal: "\(pickerColor)\(diceController.diceVal1)", diceColor: pickerColor.color, degree: diceController.degree, offsetX: diceController.dice1OffsetValX, offsetY: diceController.dice1OffsetValY, offsetZ: diceController.dice1OffsetValZ)
            
            DiceView(diceVal: "\(pickerColor)\(diceController.diceVal2)", diceColor: pickerColor.color, degree: diceController.degree2, offsetX: diceController.dice2OffsetValX, offsetY: diceController.dice2OffsetValY, offsetZ: diceController.dice2OffsetValZ)
            
          } //HStack
        }//ZStack
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              viewModel.soundOn.toggle()
            } label: {
              Label("Sound On/Off",  systemImage: viewModel.soundOn ? "speaker.wave.3" :  "speaker.slash")
            }
          }
          ToolbarItemGroup(placement: .navigationBarTrailing) {
            NavigationLink(destination: DiceRollListView()){
              Image(systemName: "dice")
            }
            .padding()
          }
        }
      }//VStack
      .onReceive(timer) { time in
        diceController.diceOffset()
      }
      .onChange(of: scenePhase) { //newPhase in
        if scenePhase == .active {
          diceController.isActive = true
        } else {
          diceController.isActive = false
        }
      }
      Button("Roll Dice!", action: start)
        .padding()
        .background(.blue)
        .foregroundColor(.white)
        .clipShape(Capsule())
    }//Nav
  }//View
  
  func start() {
    viewModel.playSounds("DiceRollCustom1.wav")
    diceController.spin()
  }
  
  func updatePickerColor() {
    let appearance = UISegmentedControl.appearance(for: .current)
    appearance.selectedSegmentTintColor = UIColor(pickerColor.color)
    diceController.lastDiceColor = pickerColor.rawValue.capitalizingFirstLetter()
  }
}

#Preview {
  ContentView()
    .environment(DiceController())
}
