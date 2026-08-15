# CyberSafe Lebanon
CyberSafe Lebanon is a dynamic cyber-safety platform offering adolescent and young-adult users real-time risk assessment, AI-assisted safety guidance (CyberBuddy), dynamic reporting and playbooks, learning modules, and community feedback mechanisms.

## Project Structure
This monorepo is built using Turborepo and contains the following applications and packages:
- `apps/mobile`: Expo mobile app (React Native + Expo Router)
- `apps/admin`: Next.js admin app (TypeScript + TailwindCSS)
- `apps/api`: NestJS main API server
- `apps/worker`: NestJS worker service (for asynchronous jobs)
- `packages/contracts`: Shared TypeScript types and Zod schemas
- `packages/config`: Shared configuration (ESLint, Prettier, TypeScript)

## Local Setup
### Prerequisites
- Node.js (v18+)
- Docker and Docker Compose

### Starting the Infrastructure
Run `docker-compose up -d` to start PostgreSQL (with pgvector), Redis, MinIO, and ClamAV.

### Installation
Install dependencies from the root directory using `npm install`.

### Running the Services
To run all apps in development mode, use Turborepo scripts or run them individually in their respective directories.

## Development Milestone 0
- Monorepo initialized.
- Expo mobile app initialized.
- NestJS API and worker initialized with health endpoints.
- Next.js admin app initialized.
- Shared contracts package added.
- Docker Compose configured for Postgres, Redis, MinIO, ClamAV.
- Prisma set up with baseline schema migration.
