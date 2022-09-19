//
//  Theme.swift
//  Aspen
//
//  Created by Tyler Reckart on 8/25/22.
//

import SwiftUI

struct AppIcon: View {
    var icon: String
    
    var appIcon = UIApplication.shared.alternateIconName

    @Binding var currentIcon: String

    var body: some View {
        Button(action: {
            if (appIcon != nil) && appIcon == icon {
                UIApplication.shared.setAlternateIconName(nil)
            } else {
                UIApplication.shared.setAlternateIconName(icon)
                currentIcon = icon
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
    let prideIcons: [String?] = ["Pride"]
    let colorwayIcons: [String?] = ["Opposite Day", "Midnight", "Under The Radar", "Phantom", "Sixty Four", "Golden Flashes", "Smoky Mountains", "Jack O'Lantern"]
    let graphicIcons: [String?] = ["Sunrise", "Daylight", "Sunset"]
    
    @State private var currentIcon: String = ""

    var appIcon = UIApplication.shared.alternateIconName

    var body: some View {
        VStack {
            List {
                Section(header: Text("Standard").font(.system(size: 12))) {
                    AppIcon(icon: "Aspen", currentIcon: $currentIcon)
                }
                
                Section(header: Text("Colorway").font(.system(size: 12))) {
                    ForEach(0 ..< colorwayIcons.count) { index in
                        AppIcon(icon: colorwayIcons[index]!, currentIcon: $currentIcon)
                    }
                }

                Section(header: Text("Pride").font(.system(size: 12))) {
                    ForEach(0 ..< prideIcons.count) { index in
                        AppIcon(icon: prideIcons[index]!, currentIcon: $currentIcon)
                    }
                }
                
                Section(header: Text("Unique").font(.system(size: 12))) {
                    ForEach(0 ..< graphicIcons.count) { index in
                        AppIcon(icon: graphicIcons[index]!, currentIcon: $currentIcon)
                    }
                }
            }
            .onAppear {
                currentIcon = appIcon ?? "Aspen"
            }
        }
    }
}
