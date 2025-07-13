# Factor

> A comprehensive exposure calculator and light meter for film photographers

Factor is a specialized iOS app designed for film photographers who need precise exposure calculations under challenging conditions. It combines a real-time light meter with sophisticated calculators for common exposure problems encountered in analog photography.

## Features

### 📸 Light Meter
- **Real-time light metering** using device camera sensor
- Calculates proper exposure values (EV) for your target ISO and aperture
- Point-and-shoot simplicity with professional accuracy
- Automatic camera permission handling

### 🎞️ Film Stock Database
- **Comprehensive database** of popular film stocks with their characteristics
- Includes films from Ilford, Kodak, Rollei, and Fujifilm
- **Reciprocity factors** for accurate long exposure calculations
- ISO ratings from 50 to 3200

### ⏱️ Reciprocity Failure Calculator
- **Compensates for reciprocity failure** during long exposures
- Uses film-specific reciprocity characteristics
- Automatic threshold detection for when correction is needed
- Essential for exposures longer than 1 second

### 🔍 Filter Factor Calculator
- **Compensates for light loss** when using neutral density or other filters
- Two priority modes: Aperture Priority and Shutter Priority
- Supports both decimal and fractional filter factors
- Smart conversion between exposure formats

### 📐 Bellows Extension Factor Calculator
- **Compensates for light loss** in macro photography with bellows extensions
- Formula-based calculation: `(bellows_draw / focal_length)²`
- Dual compensation modes for aperture or shutter priority
- Only applies correction when factor ≥ 2 for significant light loss

### 🎨 Customization
- **Dark mode support** with user preference storage
- **Customizable accent colors** for personalized interface
- **Rounded font design** for modern, clean aesthetics

## Technical Specifications

### Requirements
- iOS 14.0+
- Camera permission for light meter functionality
- iPhone or iPad with rear camera

### Architecture
- **SwiftUI** for modern iOS interface
- **AVFoundation** for camera integration and light metering
- **Core Data** for film stock database management
- **Combine** framework for reactive programming
- **KVO** for real-time camera parameter monitoring

### Key Components
- `LightMeterEngine.swift`: Real-time light metering with camera sensor
- `FilmStock.swift`: Film database with reciprocity characteristics
- `Persistence.swift`: Core Data stack for database management
- `Math.swift`: Photography-specific mathematical utilities
- `Constants.swift`: Standard photography values (f-stops, shutter speeds, ISOs)

## Installation

### From Source
1. Clone the repository:
   ```bash
   git clone https://github.com/tylerreckart/factor.git
   ```

2. Open `Factor.xcodeproj` in Xcode

3. Build and run on your iOS device or simulator

### Requirements
- Xcode 14.0+
- iOS 14.0+ deployment target
- Apple Developer account for device testing

## Usage

### Basic Light Metering
1. Open the app and tap **Light Meter**
2. Point your camera at the subject
3. Set your target ISO and aperture
4. Tap **Capture** to get the recommended shutter speed

### Reciprocity Failure Calculation
1. Select **Reciprocity Failure** from the dashboard
2. Choose your film stock from the database
3. Enter your calculated shutter speed
4. Get the corrected exposure time for long exposures

### Filter Factor Calculation
1. Select **Filter Factor** from the dashboard
2. Choose Aperture or Shutter Priority mode
3. Enter your base exposure settings
4. Input your filter factor (e.g., 2.0 for 1-stop ND filter)
5. Get the compensated exposure settings

### Bellows Extension Calculation
1. Select **Bellows Extension Factor** from the dashboard
2. Enter your lens focal length
3. Input your bellows extension distance
4. Choose priority mode and base exposure
5. Get the compensated settings for macro photography

## Film Stock Database

The app includes a comprehensive database of popular film stocks:

**Black & White Films:**
- Ilford HP5+ (ISO 400)
- Ilford FP4+ (ISO 125)
- Ilford Delta 100, 400, 3200
- Kodak Tri-X 400
- Kodak T-Max 100, 400
- Rollei RPX 25, 100, 400

**Color Films:**
- Kodak Portra 160, 400, 800
- Kodak Ektar 100
- Fujifilm Velvia 50, 100
- Fujifilm Provia 100F

Each film includes specific reciprocity factors and threshold values for accurate long exposure calculations.

## License

This project is licensed under the MIT License.

## Acknowledgments

- Built for the film photography community
- Inspired by the need for accurate exposure calculations in analog photography
- Special thanks to contributors and beta testers
