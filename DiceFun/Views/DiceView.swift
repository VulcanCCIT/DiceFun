//
//  DiceView.swift
//  DiceFun
//
//  Created by Chuck Condron on 11/24/23.
//

import SwiftUI

struct DiceView: View {
  var diceVal = "Red1"
  var diceColor: Color = .red
  var degree = 0.0
  var offsetX: CGFloat = 0
  var offsetY: CGFloat = -250
  var offsetZ: CGFloat = 1
  
    var body: some View {
      Image(diceVal)
        .resizable()
        .frame(width: 125, height:  125)
        .shadow(color: diceColor.opacity(0.4), radius: 10, x: 10, y: -12)
        .rotation3DEffect(.degrees(degree), axis: (x: 0, y: 0, z: 1))
        .offset(x: offsetX, y: offsetY)
       
        .animation(Animation.interpolatingSpring(stiffness: 50, damping: 15), value: diceVal)
        .scaleEffect(offsetZ)
    }
}

#Preview {
    DiceView()
}
