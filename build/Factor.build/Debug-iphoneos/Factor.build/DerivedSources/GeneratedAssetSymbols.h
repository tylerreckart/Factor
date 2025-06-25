#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "AlbumsAppIcon" asset catalog image resource.
static NSString * const ACImageNameAlbumsAppIcon AC_SWIFT_PRIVATE = @"AlbumsAppIcon";

/// The "DisplayAppIcon" asset catalog image resource.
static NSString * const ACImageNameDisplayAppIcon AC_SWIFT_PRIVATE = @"DisplayAppIcon";

/// The "SolarAppIcon" asset catalog image resource.
static NSString * const ACImageNameSolarAppIcon AC_SWIFT_PRIVATE = @"SolarAppIcon";

#undef AC_SWIFT_PRIVATE
