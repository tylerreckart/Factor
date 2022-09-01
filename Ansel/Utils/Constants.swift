//
//  Constants.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/18/22.
//

import SwiftUI

let f_stops: [Double] = [1.0, 1.1, 1.2, 1.4, 1.6, 1.7, 1.8, 2.0, 2.2, 2.4, 2.5, 2.8, 3.2, 3.3, 3.5, 4, 4.5, 4.8, 5, 5.6, 6.3, 6.7, 7.1, 8.0, 9.0, 9.5, 10.0, 11.0, 13.0, 14.0, 16.0, 18.0, 19.0, 20.0, 22.0, 25.0, 27.0, 29.0, 32.0, 36.0, 38.0, 40.0, 45.0, 51.0, 54.0, 57.0, 64.0]

let reciprocity_options = [
    ReciprocityDropdownOption(key: "SFX (>1 Second)", value: 1.43),
    ReciprocityDropdownOption(key: "Pan F+ (>1 Second)", value: 1.33),
    ReciprocityDropdownOption(key: "Delta 100 (>1 Second)", value: 1.26),
    ReciprocityDropdownOption(key: "Delta 400 (>1 Second)", value: 1.41),
    ReciprocityDropdownOption(key: "Delta 3200 (>1 Second)", value: 1.33),
    ReciprocityDropdownOption(key: "FP4+ (>1 Second)", value: 1.26),
    ReciprocityDropdownOption(key: "HP5+ (>1 Second)", value: 1.31),
    ReciprocityDropdownOption(key: "XP2 (>1 Second)", value: 1.31),
    ReciprocityDropdownOption(key: "K100 (>1 Second)", value: 1.26),
    ReciprocityDropdownOption(key: "K400 (>1 Second)", value: 1.30),
    ReciprocityDropdownOption(key: "Portra 160 (>1 Second)", value: 1.33),
    ReciprocityDropdownOption(key: "E100 (>10 Seconds)", value: 1.33),
    ReciprocityDropdownOption(key: "Rollei IR 400 (>1 Second)", value: 1.31)
]

let dashboard_tiles = [
    DashboardTile(
        key: "notes",
        label: "Notes",
        icon: "bookmark.circle.fill",
        background: Color(.systemYellow),
        destination: AnyView(Notes()),
        url: "Ansel://notes"
    ),
    DashboardTile(
        key: "reciprocity_factor",
        label: "Reciprocity Factor",
        icon: "moon.stars.circle.fill",
        background: Color(.systemPurple),
        destination: AnyView(Reciprocity()),
        url: "Ansel://reciprocityFactor"

    ),
    DashboardTile(
        key: "bellows_extension_factor",
        label: "Bellows Extension Factor",
        icon: "arrow.up.backward.and.arrow.down.forward.circle.fill",
        background: Color(.systemBlue),
        destination: AnyView(BellowsExtension()),
        url: "Ansel://bellowsExtension"

    ),
    DashboardTile(
        key: "filter_factor",
        label: "Filter Factor",
        icon: "cloud.circle.fill",
        background: Color(.systemGreen),
        destination: AnyView(FilterFactor()),
        url: "Ansel://filterFactor"

    ),
]

//    DashboardTile(
//        key: "spot_meter",
//        label: "Spot Meter",
//        icon: "camera.circle.fill",
//        background: Color(.systemRed),
//        destination: AnyView(SpotMeter()),
//        url: "Ansel://spotMeter"
//    ),
