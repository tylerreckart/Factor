//
//  Theme.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

struct AppIcon: View {
    var icon: String
    
    var currentIcon = UIApplication.shared.alternateIconName

    var body: some View {
        Button(action: {
            if currentIcon == icon {
                UIApplication.shared.setAlternateIconName(nil) { (error) in
                    // FIXME: Handle error
                }
            } else {
                UIApplication.shared.setAlternateIconName(icon) { (error) in
                    // FIXME: Handle error
                }
            }
        }) {
            HStack {
                Image(uiImage: UIImage(named: icon)!)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 40, height: 40, alignment: .leading)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 4)
                
                Text(icon)
                    .foregroundColor(Color(.systemGray))
                
                if currentIcon == icon {
                    Spacer()

                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                }
            }
        }
    }
}

struct AppIconSettings: View {
    let accentIcons = ["Heinz - Light", "Chester - Light", "French's - Light", "Vlasic - Light", "Breyers - Light", "Levi's - Light", "Welch's - Light", "Smucker's - Light", "Pepto - Light"]
    let formalIcons = ["Black Tie", "White Tie"]
    let prideIcons = ["Pride - Light", "Pride - Dark"]
    let colorwayIcons = ["Heinz", "Chester", "French's", "Vlasic", "Breyers", "Levi's", "Welch's", "Smucker's", "Pepto"]
    let graphicIcons = ["Sunrise", "Daylight", "Sunset"]

    var body: some View {
        VStack {
            List {
                Section(header: Text("Standard").font(.system(size: 12))) {
                    AppIcon(icon: "Ansel")
                }
                
                Section(header: Text("Accent").font(.system(size: 12))) {
                    ForEach(0 ..< accentIcons.count) { index in
                        AppIcon(icon: accentIcons[index])
                    }
                }

                Section(header: Text("Formal").font(.system(size: 12))) {
                    ForEach(0 ..< formalIcons.count) { index in
                        AppIcon(icon: formalIcons[index])
                    }
                }
                
                Section(header: Text("Pride").font(.system(size: 12))) {
                    ForEach(0 ..< prideIcons.count) { index in
                        AppIcon(icon: prideIcons[index])
                    }
                }
                
                Section(header: Text("Colorway").font(.system(size: 12))) {
                    ForEach(0 ..< accentIcons.count) { index in
                        AppIcon(icon: colorwayIcons[index])
                    }
                }
                
                Section(header: Text("Unique").font(.system(size: 12))) {
                    ForEach(0 ..< 3) { index in
                        AppIcon(icon: graphicIcons[index])
                    }
                }
            }
        }
    }
}
