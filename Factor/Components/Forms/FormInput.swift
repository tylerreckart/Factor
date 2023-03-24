//
//  FormInput.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import Foundation
import SwiftUI

struct FormInput: View {
    @AppStorage("useDarkMode") var useDarkMode: Bool = false

    @Binding var text: String

    var placeholder: String
    
    @State private var focused: Bool = false

    var body: some View {
        return TextField(placeholder, text: $text, onEditingChanged: { edit in
            self.focused = edit
        })
        .padding(.horizontal)
        .frame(height: 55, alignment: .center)
        .foregroundColor(.primary)
        .background(!useDarkMode ? .white : Color(.systemGray6))
    }
}

struct FormInput_Previews: PreviewProvider {
    static var previews: some View {
        FormInput(text: Binding.constant(""), placeholder: "string")
    }
}
