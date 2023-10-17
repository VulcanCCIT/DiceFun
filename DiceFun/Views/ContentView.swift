//
//  ContentView.swift
//  DiceFun
//
//  Created by Chuck Condron on 10/17/23.
//

import AVFoundation
import SwiftUI


struct ContentView: View {
  @StateObject private var viewModel = ViewModel()
  
  @Environment(\.scenePhase) var scenePhase
  @AppStorage("soundOn") var soundOn = false
  @AppStorage("selectedDiceColor") var selectedDiceColor = "Red"
  
  let diceColor = ["Red", "Blue", "Green", "Yellow", "Purple"]
  
  var timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
  
  
  var body: some View {
    
    NavigationView {
      GeometryReader { geo in
        VStack {
          
          Picker("Dice Color", selection: $selectedDiceColor) {
            ForEach(diceColor, id: \.self) { type in
              Text("\(type)")
            }
          }
          .pickerStyle(.segmented)
          // this only seems to work when the view appears but does not change each time you click on the picker
          //          .onAppear() {
          //            print("This fired")
          //            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(color())
          //            }
          .frame(height: 50)
          Text("Roll Total: \(viewModel.rollTotal)")
            .frame(width: 200)
            .background(.red)
            .foregroundColor(.white)
            .font(.title.bold())
            .ignoresSafeArea()
            .clipShape(Capsule())
            .padding()
          HStack {
            Image("\(selectedDiceColor)\(viewModel.diceVal1)")
              .resizable()
              .frame(width: geo.size.width * 0.425, height:  geo.size.height * 0.265)
              .rotation3DEffect(.degrees(viewModel.degree), axis: (x: 0, y: 0, z: 1))
              .offset(x: viewModel.bounce ? 0 : viewModel.dice1OffsetValX, y: viewModel.bounce ? 100 : viewModel.dice1OffsetValY)
              .animation(Animation.interpolatingSpring(stiffness: 50, damping: 15), value: viewModel.diceVal1)
            
            Image("\(selectedDiceColor)\(viewModel.diceVal2)")
              .resizable()
              .frame(width: geo.size.width * 0.425, height:  geo.size.height * 0.265)
              .rotation3DEffect(.degrees(viewModel.degree2), axis: (x: 0, y: 0, z: 1))
              .offset(x: viewModel.bounce ? 0 : viewModel.dice2OffsetValX, y: viewModel.bounce ? 100 : viewModel.dice2OffsetValY)
              .animation(.interpolatingSpring(stiffness: 50, damping: 15), value: viewModel.diceVal2)
          } //HStack
          .frame(width: geo.frame(in: .local).maxX, height: geo.frame(in: .local).maxY)
        }
      }//nav
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            soundOn.toggle()
          } label: {
            Label("Sound On/Off",  systemImage: soundOn ? "speaker.wave.3" :  "speaker.slash")
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            viewModel.showingDiceRollList.toggle()
          } label: {
            Label("Show Roll List",  systemImage: "dice")
          }
          // is it better to use a NavigationLink here?
          .sheet(isPresented: $viewModel.showingDiceRollList) {
            DiceRollListView(diceRolls: viewModel.diceRolls)
          }
        }
      }
    }//geo
    .frame(width: 350, height: 650)
    .onReceive(timer) { time in
      print(viewModel.isActive)
      guard viewModel.isActive else { return }
      
      if viewModel.timeRemaining > 0 {
        viewModel.timeRemaining -= 1
        viewModel.diceVal1 = Int.random(in: 1...6)
        viewModel.diceVal2 = Int.random(in: 1...6)
        
        viewModel.dice1OffsetValX = CGFloat.random(in: -30...30)
        viewModel.dice1OffsetValY = CGFloat.random(in: -250...150)
        viewModel.dice2OffsetValX = CGFloat.random(in: -30...30)
        viewModel.dice2OffsetValY = CGFloat.random(in: -250...150)
        
        if soundOn { viewModel.feedback.impactOccurred() }
        
        print(viewModel.timeRemaining)
        print(viewModel.dice1OffsetValX)
        print(viewModel.dice1OffsetValY)
      }
      if viewModel.timeRemaining == 1 { viewModel.isActive = false
        
        print("timerstopped")
        viewModel.updateRolls()
      }
    }
    .onChange(of: scenePhase) { //newPhase in
      if scenePhase == .active {
        viewModel.isActive = true
      } else {
        viewModel.isActive = false
      }
    }
    
    Spacer()
    
    Button("Roll Dice!") {
      viewModel.isActive = true
      viewModel.dice1OffsetValX = CGFloat.random(in: -40...40)
      viewModel.dice1OffsetValY = CGFloat.random(in: -275...275)
      viewModel.dice1OffsetValX = CGFloat.random(in: -40...40)
      viewModel.dice1OffsetValY = CGFloat.random(in: -275...275)
      
      spin()
      viewModel.bounce.toggle()
      viewModel.degree += 360
      viewModel.degree2 += 360
      viewModel.angle += 45
    }
    .padding()
    .background(.blue)
    .foregroundColor(.white)
    .clipShape(Capsule())
  }
  
  func spin() {
    
    if soundOn { playSounds("DiceRollCustom1.wav") }
    viewModel.timeRemaining = 10
    print(viewModel.timeRemaining)
  }
  
  func playSounds(_ soundFileName : String) {
    guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: nil) else {
      fatalError("Unable to find \(soundFileName) in bundle")
    }
    
    do {
      viewModel.diceRollSound = try AVAudioPlayer(contentsOf: soundURL)
    } catch {
      print(error.localizedDescription)
    }
    viewModel.diceRollSound.play()
  }
  
  func color() -> Color {
    switch selectedDiceColor {
      case "Red":
        return .red
      case "Blue":
        return .blue
      case "Green":
        return .green
      case "Yellow":
        return .yellow
      case "Purple":
        return .purple
      default:
        return .red
    }
  }
}

#Preview {
  ContentView()
}
