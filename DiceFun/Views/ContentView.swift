//
//  ContentView.swift
//  DiceFun
//
//  Created by Chuck Condron on 10/17/23.
//

import AVFoundation
import SwiftUI

enum PickerColor: String, Hashable, Identifiable, CustomStringConvertible, CaseIterable {
  case red
  case yellow
  case green
  case blue
  case purple
  
  var id: String { rawValue }
  var description: String { rawValue.capitalized }
  
  var color: Color {
    switch self {
      case .red: .red
      case .yellow: .yellow
      case .green: .green
      case .blue: .blue
      case .purple: .purple
    }
  }
}

struct ContentView: View {
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
        .tint(pickerColor.color)                                        .onAppear(perform: updatePickerColor)
        .onChange(of: pickerColor,
                  updatePickerColor)
        .padding()
        
        Text("Roll Total: \(viewModel.rollTotal)")
          .frame(width: 200)
          .background(.red)
          .foregroundColor(.white)
          .font(.title.bold())
          .ignoresSafeArea()
          .clipShape(Capsule())
          .padding([.leading, .trailing, .bottom])
        Spacer()
        HStack {
          DiceView(diceVal: "\(pickerColor)\(viewModel.diceVal1)", diceColor: pickerColor.color, degree: viewModel.degree, offsetX: viewModel.dice1OffsetValX, offsetY: viewModel.dice1OffsetValY)
          
          DiceView(diceVal: "\(pickerColor)\(viewModel.diceVal2)", diceColor: pickerColor.color, degree: viewModel.degree2, offsetX: viewModel.dice2OffsetValX, offsetY: viewModel.dice2OffsetValY)
          
        } //HStack
        .padding()
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
      }//nav
      .onReceive(timer) { time in
        viewModel.diceOffset()
      }
      .onChange(of: scenePhase) { //newPhase in
        if scenePhase == .active {
          viewModel.isActive = true
        } else {
          viewModel.isActive = false
        }
      }
      
      Button("Roll Dice!") {
        viewModel.spin()
      }
      .padding()
      .background(.blue)
      .foregroundColor(.white)
      .clipShape(Capsule())
    }//VStack
  }//View

  func updatePickerColor() {
    let appearance = UISegmentedControl.appearance(for: .current)
    appearance.selectedSegmentTintColor = UIColor(pickerColor.color)
  }
}

#Preview {
  ContentView()
}
