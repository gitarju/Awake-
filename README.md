# TTT Alarm (Tic-Tac-Toe Alarm)

**TTT Alarm** is a Flutter-based smart alarm application designed to ensure you wake up by forcing you to win a game of Tic-Tac-Toe against an AI. It features strict "Invincible" modes, sleep insights, and customizable themes.

## Features

### 1. Smart Alarm with Game Wake-Up
*   **Game-Based Dismissal**: To stop the alarm, you must play a game of Tic-Tac-Toe.
*   **Difficulty Levels**:
    *   **Easy**: Simple opponent.
    *   **Medium**: Standard difficulty.
    *   **Hard**: Challenging opponent.
    *   **Invincible (Unbeatable)**: The AI plays perfectly. You cannot win easily.

### 2. Invincible Mode (Strict Mode)
*   **No Escape**: The "Back" button is disabled while the alarm is ringing.
*   **Max Volume Enforcement**: Volume is forced to 100% and cannot be lowered.
*   **Snooze Penalty**: If you lose or draw 6 times in a row against the Invincible AI, the alarm snoozes for 5 minutes (stops and closes app) to give you a break before it rings again.
*   **Warning System**: A warning dialog alerts you before enabling this difficulty.

### 3. Alarm Management
*   **Custom Sounds**: Pick any audio file from your device storage.
*   **Recurring Alarms**: Schedule alarms for specific days of the week.
*   **Labels**: Name your alarms (e.g., "Work", "Workout").

### 4. Sleep Insights
*   **Gyro & Accelerometer Tracking**: The app monitors phone movement for 10 seconds after the alarm stops to guess if you went back to sleep or stayed awake.
*   **Logs**: View your wake-up history in the Insights tab.

### 5. Settings & Customization
*   **App Themes**: Choose between Light, Dark, or System themes.
*   **Test Game**: Practice your Tic-Tac-Toe skills without setting a real alarm.

## Technical Details

*   **Framework**: Flutter (Dart)
*   **State Management**: `flutter_bloc`
*   **Navigation**: `go_router`
*   **Local Database**: `sqflite` (for storing alarm settings and logs)
*   **Audio**: `audioplayers`
*   **Background Tasks**: `android_alarm_manager_plus` & `flutter_local_notifications`
*   **Permissions**: Handles Android 13+ notification and exact alarm permissions.

## Installation

**Easy Install (APK provided):**
You can install the app directly using the APK file included in this repository:
-   [**Download APK**](releases/ttt_alarm.apk)
-   Transfer to your Android device and install.

### Build from Source
1.  **Requirements**: Android Device (Android 10+ recommended).
    *   *Note: iOS is not supported without a Mac build environment.*
2.  **Permissions**:
    *   Allow "Notifications".
    *   Allow "Alarms & Reminders" (Exact Alarm).
    *   On Xiaomi/Redmi devices: Enable "Start in Background" or "Auto Start" for best reliability.

## Developer Notes

*   **Project Structure**: Follows Clean Architecture principles (Feature-based).
*   **Key Files**:
    *   `lib/features/alarm/presentation/pages/alarm_ring_page.dart`: Core logic for alarm ringing and game interaction.
    *   `lib/core/services/alarm_scheduler_service.dart`: Handles background alarm scheduling.
    *   `lib/features/game/presentation/bloc/game_bloc.dart`: Tic-Tac-Toe game logic.

## Usage

1.  Tap `+` to create a new alarm.
2.  Set the time, days, and difficulty.
3.  **Pro Tip**: Test the "Invincible" mode in "Settings -> Test Game" first!
