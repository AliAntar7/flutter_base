# Architecture

## Overview

This project follows a **Feature-First** architecture with a practical approach to Clean Architecture.

The architecture is designed to be:

* Easy to understand.
* Easy to maintain.
* Easy to scale.
* AI-friendly.
* Consistent across the entire codebase.

This project intentionally avoids unnecessary abstractions while keeping clear boundaries between application layers.

---

# Core Principles

## 1. Feature First

Application code is organized by features instead of technical layers.

Every business functionality lives inside its own feature.

---

## 2. Practical Clean Architecture

Architectural layers are introduced only when they provide real value.

A feature does **not** need a `domain` layer unless business logic becomes complex.

Avoid creating empty folders and unnecessary abstractions.

---

## 3. One Obvious Way

Every common task has exactly one recommended implementation.

Examples:

* Networking
* Navigation
* Local Storage
* State Management
* Dependency Injection
* Dialogs
* Bottom Sheets
* Logging

Avoid multiple ways of solving the same problem.

---

## 4. Readability First

Readable code is preferred over clever code.

Every class should have a single clear responsibility.

---

## 5. Documentation Driven

Documentation explains architectural decisions and project conventions.

Whenever architecture changes, documentation must be updated.

---

# Project Structure

```text
lib/
│
├── app/
├── bootstrap/
├── config/
├── core/
├── shared/
└── features/
```

---

# Folder Responsibilities

## app

Contains the application root.

Responsibilities:

* App widget
* Router initialization
* Theme initialization
* Localization initialization
* Global Bloc providers

No business logic should exist here.

---

## bootstrap

Responsible for preparing the application before calling `runApp()`.

Examples:

* Initialize Flutter bindings
* Load environment variables
* Initialize Firebase
* Register dependencies
* Initialize local storage
* Configure logging
* Initialize notifications

---

## config

Contains application configuration.

Examples:

* Environments
* Flavors
* API URLs
* Feature flags
* App constants

No runtime business logic.

---

## core

Contains infrastructure shared by the entire application.

Examples:

* Network
* Storage
* Dependency Injection
* Logger
* Error Handling
* Services

Core should never depend on Features.

---

## shared

Contains reusable UI and helper components.

Examples:

* Widgets
* Extensions
* Utilities
* Validators
* Formatters
* Common Models
* Design System

Shared must not contain business logic.

---

## features

Contains all application features.

Each feature should be isolated from other features.

Features communicate through shared infrastructure, not by importing each other.

---

# Dependency Rules

Allowed:

```
Features
    ↓
Shared
    ↓
Core
```

```
App
    ↓
Features
```

```
Bootstrap
    ↓
Core
```

Not Allowed:

* Feature → Feature
* Core → Feature
* Shared → Feature
* Config → Feature

Business logic must never exist inside Core or Shared.

---

# Feature Structure

Every feature starts simple.

```text
feature_name/

data/

presentation/
```

When business logic becomes complex:

```text
feature_name/

data/

domain/

presentation/
```

Do not create empty architectural layers.

---

# Core Modules

The project core consists of:

* Config
* Dependency Injection
* Logger
* Storage
* Network
* Router
* Theme
* Localization
* Firebase
* Notifications

Each module has one responsibility.

Each module will have its own documentation under:

```text
docs/modules/
```

---

# Technology Stack

State Management

* flutter_bloc

Routing

* go_router

Networking

* dio

Dependency Injection

* get_it

Local Storage

* shared_preferences
* flutter_secure_storage

Serialization

* json_serializable

Equality

* equatable

Localization

* easy_localization

Logging

* logger

Environment

* flutter_dotenv

Firebase

* firebase_core
* firebase_auth (when needed)
* firebase_messaging
* firebase_analytics
* firebase_crashlytics

---

# Engineering Rules

## State Management

Cubit is the default choice.

Use Bloc only when handling complex event-driven workflows.

---

## Navigation

Only GoRouter is used.

Do not use Navigator directly outside the routing layer unless absolutely necessary.

---

## Networking

All HTTP requests must go through the Network module.

Never instantiate Dio outside the network layer.

---

## Storage

Never use SharedPreferences directly.

Always use the Storage module.

---

## Dependency Injection

All dependencies are registered through GetIt.

Manual dependency creation is discouraged outside bootstrap.

---

## Logging

Use the Logger module.

Avoid print() in production code.

---

## Error Handling

Errors should be mapped into application-specific failures.

Do not expose DioException directly to the presentation layer.

---

## Naming Conventions

Folders

* snake_case

Files

* snake_case.dart

Classes

* PascalCase

Variables

* camelCase

Private members

* _camelCase

Constants

* camelCase unless they are compile-time globals.

---

# AI Development Rules

Before implementing new code:

1. Read PROJECT.md.
2. Read ARCHITECTURE.md.
3. Follow the existing project structure.
4. Reuse existing modules before creating new ones.
5. Never introduce a second implementation for an existing responsibility.
6. Do not create abstractions without a clear purpose.
7. Keep implementations consistent with the rest of the project.
8. If unsure, extend an existing module instead of creating a parallel one.

---

# Engineering Decisions

| ID     | Decision                         | Status   |
| ------ | -------------------------------- | -------- |
| ED-001 | Feature First Architecture       | Accepted |
| ED-002 | Practical Clean Architecture     | Accepted |
| ED-003 | One Obvious Way                  | Accepted |
| ED-004 | Documentation Driven Development | Accepted |
| ED-005 | Cubit by Default                 | Accepted |
| ED-006 | Domain Layer Only When Needed    | Accepted |
| ED-007 | AI-Friendly Architecture         | Accepted |
