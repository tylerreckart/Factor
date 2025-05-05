#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"Haptic-Software.Ansel.iOS";

/// The "AccentColor" asset catalog color resource.
static NSString * const ACColorNameAccentColor AC_SWIFT_PRIVATE = @"AccentColor";

/// The "HapticLogo" asset catalog image resource.
static NSString * const ACImageNameHapticLogo AC_SWIFT_PRIVATE = @"HapticLogo";

/// The "ProfilePhoto" asset catalog image resource.
static NSString * const ACImageNameProfilePhoto AC_SWIFT_PRIVATE = @"ProfilePhoto";

#undef AC_SWIFT_PRIVATE
