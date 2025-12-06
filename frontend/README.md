# Flutter Web Frontend

Flutter web application for the gRPC-based SaaS platform.

## Prerequisites

- Flutter SDK (3.10+)
- Dart SDK (3.0+)
- Protocol Buffers compiler (`protoc`)
- Dart protoc plugin

## Setup

### 1. Install Dart protoc plugin

```bash
dart pub global activate protoc_plugin
```

Make sure `~/.pub-cache/bin` is in your PATH:

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Generate proto files

```bash
./generate_protos.sh
```

## Development

### Run the app

```bash
flutter run -d chrome
```

### Generate code (DI, etc.)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Watch mode for code generation

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Project Structure

```
lib/
├── core/
│   ├── di/              # Dependency injection setup
│   ├── network/         # gRPC client configuration
│   ├── theme/           # App theming
│   └── router/          # Navigation/routing
├── features/
│   └── auth/
│       ├── data/        # Data layer (repositories, data sources)
│       ├── domain/      # Business logic (entities, use cases)
│       └── presentation/
│           ├── bloc/    # State management
│           ├── pages/   # UI screens
│           └── widgets/ # Reusable widgets
├── generated/           # Generated proto files
└── main.dart
```

## Architecture

This app follows Clean Architecture principles with BLoC for state management:

- **Presentation Layer**: UI + BLoC
- **Domain Layer**: Business logic, entities, use cases
- **Data Layer**: API clients, repositories

## Key Dependencies

- `flutter_bloc` - State management
- `get_it` + `injectable` - Dependency injection
- `formz` - Form validation
- `grpc` - gRPC client
- `go_router` - Navigation
- `google_fonts` - Typography
