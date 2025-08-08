# Changelog

All notable changes to the Alice Voice Assistant package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-01-XX

### Added
- 🎯 **Priority-based message queue system** with high, normal, and low priority support
- 🔊 **Real-time amplitude simulation** for visual audio indicators with configurable parameters
- ⚙️ **Comprehensive configuration system** with predefined development and production configs
- 🌍 **Full cross-platform support** for Android, iOS, Web, Windows, macOS, and Linux
- 📱 **Modern Dart implementation** with null safety and immutable data structures
- 🧪 **Extensive unit test coverage** for all core functionality
- 📚 **Rich API documentation** with detailed examples and use cases
- 🔄 **Automatic queue processing** with interruption support for high priority messages
- 🎚️ **Dynamic volume control** with validation and error handling
- 🚫 **Comprehensive error handling** with structured logging system
- 📊 **Queue management features** including length monitoring and clearing capabilities
- 🎵 **Flexible audio message system** supporting custom messages and metadata
- 🔧 **Singleton pattern implementation** with reset capability for testing
- ⏱️ **Configurable amplitude simulation** with customizable update intervals and parameters
- 📱 **Backward compatibility** with existing taxi app convenience methods

### Features
- `AliceVoiceAssistant` - Main class providing audio playback with queue management
- `AudioMessage` - Immutable message representation with priority and metadata
- `PlaybackState` - Real-time state information with amplitude and error reporting
- `AliceConfiguration` - Comprehensive configuration with factory constructors
- `AmplitudeSimulationConfig` - Detailed amplitude simulation customization
- `AliceLogger` - Structured logging system with different severity levels
- `MessagePriority` - Enum for message priority handling

### API
- `playAudio()` - Flexible audio playback with priority and immediate options
- `playMessage()` - Structured message playback with AudioMessage objects
- `setVolume()` - Dynamic volume control with validation
- `clearQueue()` - Queue management and clearing
- `stop()` - Stop playback and clear queue
- `dispose()` - Resource cleanup and disposal
- Stream-based `playbackState` for real-time monitoring
- Properties for `currentMessage`, `queueLength`, `isPlaying`, and `config`

### Convenience Methods (Backward Compatibility)
- `playAnswerIncreasedDemand()` - High demand notifications
- `playAnswerPassengerMessage()` - Passenger communication
- `playAnswerNewOrder()` - New order alerts (high priority)
- `playAnswerOrderCompleted()` - Order completion notifications
- `playAnswerNoParkingWarning()` - Parking warnings (high priority)
- `playAnswerRouteBuilt()` - Route information
- And 14 more taxi-specific convenience methods

### Configuration Options
- `maxQueueSize` - Maximum number of queued messages (default: 10)
- `interruptOnHighPriority` - High priority message interruption (default: true)
- `autoPlayQueue` - Automatic queue processing (default: true)
- `defaultVolume` - Initial volume level (default: 1.0)
- `enableLogging` - Debug logging control (default: kDebugMode)
- `amplitudeSimulation` - Comprehensive amplitude simulation configuration

### Dependencies
- `just_audio: ^0.9.36` - Cross-platform audio playback
- `rxdart: ^0.27.7` - Reactive stream management

### Platform Support
- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

### Documentation
- Comprehensive README with usage examples
- Inline code documentation for all public APIs
- Advanced example application demonstrating all features
- Configuration guide with predefined setups
- Performance and platform support information

### Testing
- Unit tests for all core classes and functionality
- Configuration testing with various scenarios
- Message priority and queue management testing
- State management and error handling testing
- Singleton pattern and resource cleanup testing