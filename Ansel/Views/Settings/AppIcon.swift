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

                    Image(systemName: "check.circle.fill")
                        .font(.title)
                }
            }
        }
    }
}

struct AppIconSettings: View {
    let whiteIcons = ["WhiteCyan", "WhiteRed", "WhitePink"]
    let solidIcons = ["Green", "Cyan", "Pink", "Red"]
    let graphicIcons = ["Sunrise", "Daylight", "Sunset"]

    var body: some View {
        VStack {
            List {
                Section(header: Text("Standard").font(.system(size: 12))) {
                    AppIcon(icon: "Ansel")
                }
                
                Section(header: Text("Accent").font(.system(size: 12))) {
                    ForEach(0 ..< whiteIcons.count) { index in
                        AppIcon(icon: whiteIcons[index])
                    }
                }
                
                Section(header: Text("Colorway").font(.system(size: 12))) {
                    ForEach(0 ..< solidIcons.count) { index in
                        AppIcon(icon: solidIcons[index])
                    }
                }
                
                Section(header: Text("Unique").font(.system(size: 12))) {
                    ForEach(0 ..< graphicIcons.count) { index in
                        AppIcon(icon: graphicIcons[index])
                    }
                }
            }
        }
    }
}
