# Overview

This is a full-stack web application that provides a key generation and verification system for Roblox integration. The application follows a step-based workflow where users complete verification tasks to generate temporary access keys that can be validated by external Roblox scripts. The system is built with a React frontend using shadcn/ui components and an Express.js backend with PostgreSQL database storage.

# User Preferences

Preferred communication style: Simple, everyday language.

# System Architecture

## Frontend Architecture
- **Framework**: React with TypeScript and Vite for development and building
- **UI Library**: shadcn/ui components built on Radix UI primitives with Tailwind CSS styling
- **State Management**: TanStack Query for server state management and caching
- **Routing**: Wouter for lightweight client-side routing
- **Styling**: Tailwind CSS with CSS custom properties for theming

## Backend Architecture
- **Framework**: Express.js with TypeScript
- **API Design**: RESTful endpoints for key generation and verification
- **Request Handling**: JSON body parsing with custom logging middleware for API requests
- **Development**: Hot reloading with tsx and Vite integration for seamless development experience

## Data Storage
- **Database**: PostgreSQL with Neon Database serverless driver
- **ORM**: Drizzle ORM for type-safe database operations
- **Schema Management**: Drizzle migrations with schema definitions in shared directory
- **Backup Storage**: Replit Database as fallback storage option with automatic cleanup of expired keys

## Key Management System
- **Key Generation**: 16-character alphanumeric keys with 24-hour expiration
- **Verification**: Stateless verification endpoint returning status (valid/expired/invalid)
- **Data Validation**: Zod schemas for runtime type checking and API validation
- **Expiration Handling**: Automatic cleanup of expired keys with configurable intervals

## External Dependencies
- **Database**: Neon Database (PostgreSQL) for primary storage
- **Backup Storage**: Replit Database for development and fallback scenarios
- **UI Components**: Radix UI primitives for accessible component foundation
- **Validation**: Zod for schema validation and type safety
- **Development Tools**: Replit-specific plugins for cartographer and error overlay integration