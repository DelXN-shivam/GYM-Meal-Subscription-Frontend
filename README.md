# Gym Meal Subscription App

A Flutter application for gym meal subscription management with comprehensive profile data tracking.

## Features

- **User Authentication**: Signup and login functionality
- **Profile Management**: Complete user profile data collection
- **Meal Preferences**: Dietary restrictions, allergies, and meal plan customization
- **Subscription Management**: Plan selection and payment processing
- **Location Services**: Delivery address management
- **Data Logging**: Comprehensive logging of all profile data across page navigation

## Profile Data Logging

The app now includes comprehensive logging functionality that tracks all user data as they navigate through the application. The `ProfileDataProvider` automatically logs all stored data whenever a user moves from one page to the next.

### Logged Data Categories

1. **Signup Data**
   - Full name, email, phone number
   - Age, gender, height, weight
   - Home, office, and college addresses

2. **Location Data**
   - Current location
   - Latitude and longitude coordinates
   - Delivery addresses

3. **Meal Preferences**
   - Fitness goals (lose weight, maintain, muscle gain)
   - Activity level (sedentary, moderate, active)
   - Dietary preferences (veg, non-veg, vegan)
   - Allergies and dietary restrictions

4. **Subscription Details**
   - Plan duration and meals per day
   - Selected meal types
   - Plan length and start date
   - Delivery address preferences
   - Subscription status and dates

### Navigation Flow with Logging

The app logs data at the following navigation points:

1. **Signup Screen** → Set Preferences Screen
   - Logs all signup form data

2. **Set Preferences Screen** → Sample Meal Screen
   - Logs meal preferences and goals

3. **Sample Meal Screen** → Subscription Details Screen
   - Logs current profile state

4. **Subscription Details Screen** → Subscription Plans Screen
   - Logs subscription configuration

5. **Change Location Screen** → Subscription Plans Screen
   - Logs location and delivery preferences

6. **Subscription Plans Screen** → Payment Processing
   - Logs final subscription selection

### Viewing Logs

All logs are output to the console using Flutter's `log()` function. You can view them in:
- Flutter DevTools console
- IDE debug console
- Terminal when running `flutter run`

### Example Log Output

```
=== PROFILE DATA LOG (Signup Screen) ===
SIGNUP DATA:
  Full Name: John Doe
  Email: john.doe@example.com
  Phone Number: +1234567890
  Password: [HIDDEN]
  Date of Birth: null
  Gender: Male
  Age: 25
  Height: 175.0 cm
  Weight: 75.0 kg
  Home Address: 123 Main St
  Office Address: 456 Work Ave
  College Address: null
LOCATION DATA:
  Current Location: null
  Latitude: null
  Longitude: null
  Address: null
MEAL PREFERENCES:
  Goal: null
  Activity Level: null
  Dietary Preference: null
  Dietary Restrictions: []
  Meal Preferences: []
  Allergies: []
  Meal Plan Type: null
SUBSCRIPTION DETAILS:
  Subscription Type: null
  Plan Duration: null
  Meals Per Day: null
  Selected Meal Types: []
  Plan Length: null
  Start Date: null
  Default Delivery Address: null
  Custom Address: null
  Subscription Start Date: null
  Subscription End Date: null
  Is Subscribed: false
=== END PROFILE DATA LOG ===
```

## Getting Started

1. Clone the repository
2. Install dependencies: `flutter pub get`
3. Run the app: `flutter run`

## Dependencies

- Flutter SDK
- Provider (for state management)
- Firebase (for authentication and backend)
- Flutter SVG (for vector graphics)
- Google Fonts (for typography)

## Project Structure

```
lib/
├── config/
│   └── routes.dart
├── providers/
│   ├── auth_provider.dart
│   └── profile_data_provider.dart
├── screens/
│   ├── auth/
│   ├── home/
│   ├── onboarding/
│   ├── process/
│   └── profile/
├── services/
└── widgets/
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.
