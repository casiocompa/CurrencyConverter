# Currency Converter

![Language](https://img.shields.io/badge/language-Swift%205-orange.svg)
[![Xcode](https://img.shields.io/badge/Xcode-16.0-brightgreen.svg)](https://developer.apple.com/xcode)
[![Framework](https://img.shields.io/badge/uikit-blue.svg)](https://developer.apple.com/xcode](https://developer.apple.com/documentation/uikit/))

## Description
Calculates money quick and easy way to see live foreign exchange rates.

## Features
- **Currency Selection**: Users can select two currencies — one for the source currency and one for the target currency.
- **Amount Input**: Users input the amount they wish to convert from the source currency to the target currency.
- **Automatic Conversion**:
  - Updates the converted amount automatically whenever there is a change in the source currency, target currency, or the amount entered.
  - Periodic updates occur every 10 seconds.
  - Exchange rates depend on the amount.
  - Exchange rates change in real-time.
- **API Integration**: Real-time conversion rates are fetched from a public API with no authentication required.
  
## Technical Implementation
- **Programming Language**: Swift 5
- **UI Framework**: UIKit.
- **Layout**: Responsive design for all device sizes, including iPads, using Auto Layout.

## Requirements
* iOS 15+
* Xcode 16+

## Installation & Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/currency-converter.git
   cd currency-converter
   ```
2. Open the project in Xcode:
   ```bash
   open CurrencyConverter.xcodeproj
   ```
3. Build and run the application:
   - Select a target device (iPhone/iPad) in Xcode.
   - Press `Cmd + R` to run the app.

## Usage
1. Select the source currency and target currency using the provided pickers.
2. Enter the amount to be converted using the keypad.
3. The converted amount will be displayed in real time.
