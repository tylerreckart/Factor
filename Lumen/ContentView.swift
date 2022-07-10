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

    var body: some View {
        let focal_length_binding = Binding<String>(get: {
            self.focal_length
        }, set: {
            self.focal_length = $0
            
            let current_extension = Int(self.bellows_draw) ?? 0;
            let focal_length = Int($0) ?? 1;
            
            let factor = Float(pow(Float(current_extension/focal_length), 2))
            
            if Int(self.bellows_draw) ?? 0 > 0 {
                // (Extension/FocalLength) **2
                if factor <= 1.0 {
                    self.extension_factor = "\(factor)"
                }
                self.calculated_factor = true
                
                let aperture_compensation = log(factor)/log(2)
                self.compensated_aperture = "\(aperture_compensation)"
            } else if self.calculated_factor == true {
                self.calculated_factor = false
            }
        })
        
        let bellows_draw_binding = Binding<String>(get: {
            self.bellows_draw
        }, set: {
            self.bellows_draw = $0
            
            let current_extension = Int($0) ?? 1;
            let focal_length = Int(self.focal_length) ?? 1;
            
            let factor = Float(pow(Float(current_extension/focal_length), 2))
            
            if Int(self.focal_length) ?? 0 > 0 {
                // (Extension/FocalLength) **2
                if factor <= 1.0 {
                    self.extension_factor = "\(factor)"
                }
                self.calculated_factor = true
                
                let aperture_compensation = log(factor)/log(2)
                self.compensated_aperture = "\(aperture_compensation * -(Float(aperture) ?? 1)!)"
            } else if self.calculated_factor == true {
                self.calculated_factor = false
            }
        })

        return NavigationView {
            VStack(alignment: .leading) {
                GroupBox {
                    Text("Exposure Data")
                        .font(.system(.caption))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                    TextField("Aperture", text: $aperture)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Shutter Speed", text: $shutter_speed)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(aperture.isEmpty)
                    TextField("Focal Length (mm)", text: focal_length_binding)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .disabled(shutter_speed.isEmpty)
                    TextField("Bellows Draw (mm)", text: bellows_draw_binding)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .disabled(focal_length.isEmpty)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Image(systemName: "sun.min.fill")
                            Text("Bellows Buddy")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                        }
                    }
                }
                
                if Int(bellows_draw) ?? 0 != 0 || Int(focal_length) ?? 0 != 0 {
                    GroupBox {
                        HStack {
                            if Int(focal_length) ?? 0 != 0 {
                                VStack {
                                    Text("Focal Length (mm)")
                                        .font(.system(.caption))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(.gray)
                                    Text(focal_length)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            
                            if Int(bellows_draw) ?? 0 != 0 {
                                VStack {
                                    Text("Bellows Draw (mm)")
                                        .font(.system(.caption))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(.gray)
                                    Text(bellows_draw)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
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
                        
                        VStack {
                            Text("Aperture Compensation")
                                .font(.system(.caption))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.gray)
                            Text(compensated_aperture)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.bottom)

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
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                HStack {
                    Image(systemName: "sun.min.fill")
                    Text("Title").font(.headline)
                }
            }
        }
    }
    
    static private func open_log() {
        // do something.
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
