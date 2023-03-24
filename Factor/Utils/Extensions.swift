//
//  Extensions.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/11/22.
//

import SwiftUI
import Foundation
import UIKit

extension UIApplication {
    var icon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary,
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? NSDictionary,
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? NSArray,
            // First will be smallest for the device class, last will be the largest for device class
            let lastIcon = iconFiles.lastObject as? String,
            let icon = UIImage(named: lastIcon) else {
                return nil
        }

        return icon
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

extension Date {
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.endEditing(force)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

struct Draggable: ViewModifier {
    let condition: Bool
    let data: () -> NSItemProvider

    @ViewBuilder
    func body(content: Content) -> some View {
        if condition {
            content.onDrag(data)
        } else {
            content
        }
    }
}
    
extension View {
    public func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
    
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat, corners: UIRectCorner) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: 0)
        return clipShape(RoundedCorner(radius: cornerRadius, corners: corners))
             .overlay(roundedRect.strokeBorder(content, lineWidth: width).cornerRadius(cornerRadius, corners: corners))
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
    
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    
    func drag(if condition: Bool, data: @escaping () -> NSItemProvider) -> some View {
        self.modifier(Draggable(condition: condition, data: data))
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

extension Color: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = Data(base64Encoded: rawValue) else{
            self = .black
            return
        }
        
        do{
            let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? .black
            self = Color(color)
        }catch{
            self = .black
        }
        
    }

    public var rawValue: String {
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
            
        }catch{
            return ""
        }
        
    }
}

extension Array: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = Data(base64Encoded: rawValue),
              let result = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Element]
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false) as Data
            return data.base64EncodedString()
        } catch {
            return ""
        }
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
