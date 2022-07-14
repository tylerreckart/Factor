//
//  FormInput.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import Foundation
import SwiftUI

struct FormInput: View {
    @Binding var text: String

    var placeholder: String
    
    @State private var focused: Bool = false

    var body: some View {
        return TextField("", text: $text, onEditingChanged: { edit in
            self.focused = edit
        })
            .padding(14)
            .background(Color(.systemGray6))
            .cornerRadius(25)
            .modifier(PlaceholderStyle(text: $text, focused: $focused, placeholder: placeholder))
            .multilineTextAlignment(.leading)
            .padding(.bottom, 4)
            .foregroundColor(.primary)
            .keyboardType(.numberPad)
    }
}

struct FormInput_Previews: PreviewProvider {
    static var previews: some View {
        FormInput(text: Binding.constant(""), placeholder: "string")
    }
}
