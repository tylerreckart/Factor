import Foundation
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "AlbumsAppIcon" asset catalog image resource.
    static let albumsAppIcon = DeveloperToolsSupport.ImageResource(name: "AlbumsAppIcon", bundle: resourceBundle)

    /// The "DisplayAppIcon" asset catalog image resource.
    static let displayAppIcon = DeveloperToolsSupport.ImageResource(name: "DisplayAppIcon", bundle: resourceBundle)

    /// The "SolarAppIcon" asset catalog image resource.
    static let solarAppIcon = DeveloperToolsSupport.ImageResource(name: "SolarAppIcon", bundle: resourceBundle)

}

