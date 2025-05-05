//
//  Constants.swift
//  Factor
//
//  Created by Tyler Reckart on 8/18/22.
//

import SwiftUI

// Standard Full-Stop Aperture Values
let f_stops: [Double] = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11.0, 16.0, 22.0, 32.0, 45.0, 64.0]

// Standard Shutter Speeds (in seconds) - More comprehensive list
let standard_shutter_speeds: [Double] = [
    1/8000.0, 1/4000.0, 1/2000.0, 1/1000.0, 1/500.0, 1/250.0, 1/125.0,
    1/60.0, 1/30.0, 1/15.0, 1/8.0, 1/4.0, 1/2.0, 1.0,
    2.0, 4.0, 8.0, 15.0, 30.0, 60.0, 120.0, 240.0
]

// Available ISOs for Picker
let availableISOs: [Float] = [25, 50, 100, 125, 160, 200, 400, 800, 1600, 3200, 6400]
