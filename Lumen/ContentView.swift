//
//  ContentView.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/9/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var aperture: String = ""
    @State private var iso: String = ""
    @State private var shutter_speed: String = ""
    @State private var bellows_draw: String = ""
    @State private var focal_length: String = ""
    @State private var extension_factor: String = "No compensation necessary"
    @State private var calculated_factor: Bool = false
    @State private var compensated_aperture: String = ""
    @State private var priority_mode: String = "aperture"

    var body: some View {
        return NavigationView {
            VStack(alignment: .leading) {
                GroupBox {
                    TextField("Aperture", text: $aperture)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Shutter Speed", text: $shutter_speed)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(aperture.isEmpty)
                    TextField("Focal Length (mm)", text: $focal_length)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .disabled(shutter_speed.isEmpty)
                    TextField("Bellows Draw (mm)", text: $bellows_draw)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .disabled(focal_length.isEmpty)
                    
                    VStack {
                        HStack {
                            Button(action: {
                                self.priority_mode = "aperture"
                            }) {
                                Image(systemName: "camera.aperture")
                                    .imageScale(.small)
                                Text("Aperture Priority")
                                    .font(.system(.caption))
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(self.priority_mode == "aperture" ? .white : .blue)
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(self.priority_mode == "aperture" ? .blue : .clear)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(.blue, lineWidth: 1)
                            )


                            Button(action: {
                                self.priority_mode = "shutter"
                            }) {
                                Image(systemName: "camera.shutter.button")
                                    .imageScale(.small)
                                Text("Shutter Priority")
                                    .font(.system(.caption))
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(self.priority_mode == "shutter" ? .white : .blue)
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(self.priority_mode == "shutter" ? .blue : .clear)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(.blue, lineWidth: 1)
                            )
                        }

                        Button(action: calculate) {
                            Image(systemName: "equal.square")
                                .imageScale(.small)
                            Text("Calculate")
                                .font(.system(.caption))
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(.black)
                        .cornerRadius(6)
                    }
                }
    
                if self.calculated_factor == true {
                    GroupBox {
                        VStack {
                            Text("Bellows Extension Factor")
                                .font(.system(.caption))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.gray)
                            Text(extension_factor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.bottom)
                        
                        if (self.priority_mode == "aperture") {
                            VStack {
                                Text("Aperture Compensation")
                                    .font(.system(.caption))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.gray)
                                Text(compensated_aperture)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.bottom)
                        }

                        if (self.priority_mode == "shutter") {
                            VStack {
                                Text("Shutter Compensation")
                                    .font(.system(.caption))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.gray)
                                Text("32 seconds")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Bellows Buddy", displayMode: .large)
        }
    }
    
    public func calculate() {
        let bellows_draw = Int(self.bellows_draw) ?? 1;
        let focal_length = Int(self.focal_length) ?? 1;
        
        // (Extension/FocalLength) **2
        let factor = Float(pow(Float(bellows_draw/focal_length), 2))
        
        if focal_length > 0 && bellows_draw > 0 {
            self.extension_factor = "\(factor)"
            self.calculated_factor = true
            
            let aperture_compensation = log(factor)/log(2)

            self.compensated_aperture = "\(aperture_compensation * (Float(aperture) ?? 1)!)"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
