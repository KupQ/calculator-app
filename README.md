# Calculator - iOS App

A beautiful, minimal calculator app built with SwiftUI. Automatically built and deployed to TestFlight via GitHub Actions.

## Features
- Clean dark gradient design
- Smooth press animations
- Standard calculator operations (+, −, ×, ÷)
- Percentage and sign toggle
- Auto-scaling display text

## Setup Guide

### Prerequisites
- Apple Developer Account ($99/year)
- App registered in App Store Connect

### Step 1: Create App in App Store Connect
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **My Apps** → **+** → **New App**
3. Fill in: Name = "Calculator", Bundle ID = `com.calckatorys.app`, SKU = `calculator001`

### Step 2: Create App Store Connect API Key
1. Go to [App Store Connect → Users & Access → Keys](https://appstoreconnect.apple.com/access/api)
2. Click **+** to generate a new key
3. Name: `GitHubActions`, Access: `App Manager`
4. Download the `.p8` file (you can only download once!)
5. Note the **Key ID** and **Issuer ID**

### Step 3: Create Distribution Certificate & Profile
1. Go to [Apple Developer → Certificates](https://developer.apple.com/account/resources/certificates/list)
2. Create an **Apple Distribution** certificate
3. Download and install it in Keychain Access (on a Mac)
4. Export as `.p12` from Keychain Access
5. Go to [Provisioning Profiles](https://developer.apple.com/account/resources/profiles/list)
6. Create an **App Store Distribution** profile for `com.calckatorys.app`
7. Download the `.mobileprovision` file

### Step 4: Add GitHub Secrets
Go to your repo → Settings → Secrets → Actions, and add:

| Secret Name | Value |
|---|---|
| `BUILD_CERTIFICATE_BASE64` | `base64 -i certificate.p12` output |
| `P12_PASSWORD` | Password you set when exporting .p12 |
| `BUILD_PROVISION_PROFILE_BASE64` | `base64 -i profile.mobileprovision` output |
| `KEYCHAIN_PASSWORD` | Any random password (e.g., `temp123`) |
| `TEAM_ID` | Your 10-character Apple Team ID |
| `PROVISIONING_PROFILE_NAME` | Name of your provisioning profile |
| `ASC_KEY_ID` | App Store Connect API Key ID |
| `ASC_ISSUER_ID` | App Store Connect API Issuer ID |
| `ASC_PRIVATE_KEY` | Contents of the `.p8` file |

### Step 5: Push & Deploy
```bash
git push origin main
```
GitHub Actions will automatically build and upload to TestFlight!

## Local Development
To build locally (requires Mac with Xcode):
```bash
brew install xcodegen
xcodegen generate
open Calculator.xcodeproj
```
