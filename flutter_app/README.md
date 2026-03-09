# PetFit AI Flutter Frontend

Flutter + Riverpod implementation of the PetFit AI mobile frontend.
`figma_tmp` is reference only; this directory is the production frontend codebase.

## Scope

- Frontend only (no backend/API integration)
- Mock data driven screens and transitions
- Figma-aligned mobile flow and UI structure

## Tech Stack

- Flutter 3.x
- Riverpod 2.x

## Directory Structure

- `lib/app`: app entry, router, theme, design tokens
- `lib/core`: shared models/widgets/state helpers
- `lib/features/*/presentation/pages`: screens
- `lib/features/*/presentation/widgets`: feature widgets
- `lib/features/*/data/mock`: mock sources
- `lib/features/*/application`: providers/state

## Run

```bash
cd flutter_app
flutter pub get
flutter run
```

## Quality Checks

```bash
flutter analyze
flutter test
```

## Demo States

In Home screen, top-right menu (`tune` icon) switches global demo state:

- `normal`
- `loading`
- `empty`
- `error`

This is reflected by unified async UI patterns in major screens.

## Backend Pending

- API integration for catalog, profile, notifications
- Auth/session handling
- Cart/order persistence
