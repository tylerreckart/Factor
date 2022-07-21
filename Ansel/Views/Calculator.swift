//
//  Calculator.swift
//  Ansel
//
//  Created by Tyler Reckart on 7/20/22.
//

import SwiftUI

enum CalculatorButtonType {
    case text, icon
}

struct CalculatorButton: View {
    var type: CalculatorButtonType
    var icon: String = ""
    var text: String = ""
    var label: String = ""
    var background: Color
    var foreground: Color = Color.white
    var radius: UIRectCorner?

    var body: some View {
        VStack {
            if type == .text {
                Text(self.text)
            } else {
                Image(systemName: self.icon)
                if label.count > 0 {
                    Text(self.label)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .font(.headline)
        .background(self.background)
        .foregroundColor(self.foreground)
        .border(.black, width: 1)
        .cornerRadius(radius != nil ? 12 : 0, corners: [(radius != nil ? radius! : .allCorners)])
    }
}

struct CalculatorPad: View {
    var body: some View {
        VStack {
            Spacer()
    
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    CalculatorButton(type: .icon, icon: "camera", background: Color(.systemGray), radius: .topLeft)
                    CalculatorButton(type: .text, text: "(", background: Color(.systemGray))
                    CalculatorButton(type: .text, text: ")", background: Color(.systemGray))
                    CalculatorButton(type: .icon, icon: "star", background: Color(.systemGray), radius: .topRight)
                }
                
                HStack(spacing: 0) {
                    CalculatorButton(type: .text, text: "7", background: Color(.systemGray5), foreground: Color.black)
                    CalculatorButton(type: .text, text: "8", background: Color(.systemGray5), foreground: Color.black)
                    CalculatorButton(type: .text, text: "9", background: Color(.systemGray5), foreground: Color.black)
                    CalculatorButton(type: .text, text: "log", label: "Tools", background: Color(.systemBlue))
                }
                
                HStack(spacing: 0) {
                    CalculatorButton(type: .text, text: "4", background: Color(.systemGray5), foreground: Color.black)
                    CalculatorButton(type: .text, text: "5", background: Color(.systemGray5), foreground: Color.black)
                    CalculatorButton(type: .text, text: "6", background: Color(.systemGray5), foreground: Color.black)
                    CalculatorButton(type: .text, text: "n^x", label: "Tools", background: Color(.systemBlue))
                }
                
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        CalculatorButton(type: .text, text: "1", background: Color(.systemGray5), foreground: Color.black)
                        CalculatorButton(type: .text, text: "0", background: Color(.systemGray5), foreground: Color.black, radius: .bottomLeft)
                    }
                    
                    VStack(spacing: 0) {
                        CalculatorButton(type: .text, text: "2", background: Color(.systemGray5), foreground: Color.black)
                        CalculatorButton(type: .text, text: ".", background: Color(.systemGray5), foreground: Color.black)
                    }
                    
                    VStack(spacing: 0) {
                        CalculatorButton(type: .text, text: "2", background: Color(.systemGray5), foreground: Color.black)
                        CalculatorButton(type: .icon, icon: "delete.backward", background: Color(.systemRed), foreground: Color.white)
                    }
                    
                    CalculatorButton(type: .text, text: "=", background: Color(.systemOrange), radius: .bottomRight)
                }
                .frame(height: 160)
            }
            .frame(maxHeight: 400)
        }
        .background(.black)
    }
}

struct Calculator: View {
    var body: some View {
        CalculatorPad()
    }
}

struct Calculator_Previews: PreviewProvider {
    static var previews: some View {
        Calculator()
    }
}
