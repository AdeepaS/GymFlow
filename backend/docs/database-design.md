# GymFlow Database Design

## ER Diagram Overview

GymFlow uses a single `User` table for authentication and identity, with role-based behavior driven by `User.role` and `User.status`.

The core structure is:

- `Gym` owns all gym-scoped data.
- `User` represents every authenticated account: super admin, gym admin, trainer, and member.
- `MembershipPlan` defines purchasable plans.
- `Membership` stores historical membership purchases and status transitions.
- `Payment` stores one payment per membership.
- `MemberTrainerAssignment` preserves trainer assignment history.
- `WorkoutPlan` and `WorkoutExercise` model reusable workout templates.
- `MemberWorkoutAssignment` preserves workout assignment history.
- `DietPlan` and `Meal` model reusable diet templates.
- `MemberDietAssignment` preserves diet assignment history.
- `MemberMeasurement` stores progress tracking snapshots.
- `EmergencyContact` stores up to three member contacts.
- `Attendance` stores daily check-ins.

## Design Goals

- Normalize the schema to 3NF.
- Preserve historical records instead of overwriting old rows.
- Use UUID primary keys everywhere.
- Support current single-gym usage while remaining ready for multi-gym scaling.
- Keep application-enforced business rules out of the schema where DB constraints would become brittle.

## Tables

### Gym

Stores the gym entity for future multi-gym support.

- `id` UUID primary key
- `name` string
- `code` unique short identifier
- `email`, `phone`, `address` optional contact fields
- `isActive` boolean
- `adminUserId` unique foreign key to `User`
- `deletedAt`, `createdAt`, `updatedAt`

### User

Stores all accounts.

- `id` UUID primary key
- `gymId` nullable foreign key
- `username` unique
- `email` unique
- `passwordHash`
- `role` enum: `SUPER_ADMIN`, `GYM_ADMIN`, `TRAINER`, `MEMBER`
- `status` enum: `PENDING_APPROVAL`, `ACTIVE`, `REJECTED`, `SUSPENDED`, `DELETED`
- profile fields: `firstName`, `lastName`, `phone`, `avatarUrl`
- audit fields: `lastLoginAt`, `deletedAt`, `createdAt`, `updatedAt`

### MembershipPlan

Defines the membership products a gym can sell.

- `id` UUID primary key
- `gymId` foreign key
- `name`
- `description`
- `durationDays`
- `price`
- `isActive`
- `deletedAt`, `createdAt`, `updatedAt`

### Membership

Stores one membership purchase per period. Historical rows are never updated into new periods.

- `id` UUID primary key
- `gymId` foreign key
- `userId` foreign key
- `membershipPlanId` foreign key
- `status` enum: `PENDING_PAYMENT`, `ACTIVE`, `EXPIRED`, `CANCELLED`
- `startDate`, `endDate`
- `cancelledAt`, `notes`
- `deletedAt`, `createdAt`, `updatedAt`

### Payment

One-time payment per membership.

- `id` UUID primary key
- `gymId` foreign key
- `membershipId` unique foreign key
- `amount`, `currency`
- `method` enum: `CASH`, `CARD`, `ONLINE`, `BANK_TRANSFER`
- `status` enum: `PAID`, `FAILED`
- `transactionRef` unique optional reference
- `paidAt`, `failureReason`
- `deletedAt`, `createdAt`, `updatedAt`

### MemberTrainerAssignment

Preserves trainer assignment history.

- `id` UUID primary key
- `gymId` foreign key
- `memberId` foreign key to `User`
- `trainerId` foreign key to `User`
- `assignedAt`, `unassignedAt`
- `isActive`
- `notes`
- `createdAt`, `updatedAt`

### Exercise

Reusable exercise library.

- `id` UUID primary key
- `gymId` nullable foreign key
- `name`
- `description`
- `muscleGroup`
- `equipment`
- `instructions`
- `isActive`, `deletedAt`, `createdAt`, `updatedAt`

### WorkoutPlan

Reusable workout template created by trainers.

- `id` UUID primary key
- `gymId` foreign key
- `trainerId` foreign key
- `name`
- `description`
- `goal`
- `durationDays`
- `isTemplate`
- `isActive`
- `deletedAt`, `createdAt`, `updatedAt`

### WorkoutExercise

Bridge table between workout plans and exercises.

- `id` UUID primary key
- `workoutPlanId` foreign key
- `exerciseId` foreign key
- `sequence`
- `sets`
- `reps`
- `weight`
- `restSeconds`
- `notes`
- `createdAt`, `updatedAt`

### MemberWorkoutAssignment

Historical assignment of workout plans to members.

- `id` UUID primary key
- `gymId` foreign key
- `memberId` foreign key
- `workoutPlanId` foreign key
- `assignedById` foreign key to `User`
- `assignedAt`, `unassignedAt`
- `isActive`
- `notes`
- `createdAt`, `updatedAt`

### DietPlan

Reusable diet template created by trainers.

- `id` UUID primary key
- `gymId` foreign key
- `trainerId` foreign key
- `name`
- `description`
- `calories`
- `protein`, `carbs`, `fats`
- `isActive`, `deletedAt`, `createdAt`, `updatedAt`

### Meal

Meals inside a diet plan.

- `id` UUID primary key
- `dietPlanId` foreign key
- `name`
- `mealOrder`
- `calories`
- `protein`, `carbs`, `fats`
- `notes`
- `createdAt`, `updatedAt`

### MemberDietAssignment

Historical assignment of diet plans to members.

- `id` UUID primary key
- `gymId` foreign key
- `memberId` foreign key
- `dietPlanId` foreign key
- `assignedById` foreign key
- `assignedAt`, `unassignedAt`
- `isActive`
- `notes`
- `createdAt`, `updatedAt`

### MemberMeasurement

Stores body progress snapshots.

- `id` UUID primary key
- `memberId` foreign key
- `measuredAt` date
- `heightCm`
- `weightKg`
- `bodyFatPercent`
- `muscleMassKg`
- `notes`
- `createdAt`, `updatedAt`

### EmergencyContact

Stores emergency contacts for members.

- `id` UUID primary key
- `memberId` foreign key
- `fullName`
- `relationship`
- `phone`
- `email`
- `priority`
- `isPrimary`
- `notes`
- `createdAt`, `updatedAt`

### Attendance

Stores one attendance row per member per day.

- `id` UUID primary key
- `memberId` foreign key
- `gymId` foreign key
- `attendanceDate` date
- `checkInAt`, `checkOutAt`
- `source`
- `notes`
- `createdAt`, `updatedAt`

## Relationships

- One `Gym` has many `User` records.
- One `Gym` has many `MembershipPlan` records.
- One `Gym` has many `Membership`, `Payment`, `WorkoutPlan`, `DietPlan`, `Attendance`, and assignment rows.
- One `User` can have many `Membership` rows over time.
- One `Membership` has exactly one `Payment`.
- One member can have many trainer assignments over time, but only one active assignment should exist at a time.
- One workout plan has many workout exercises.
- One exercise can belong to many workout plans through `WorkoutExercise`.
- One diet plan has many meals.
- One member can have many workout assignments and diet assignments over time.
- One member can have many measurements.
- One member can have up to three emergency contacts.

## Constraints

Implemented in Prisma schema:

- UUID primary keys on all tables.
- Unique `username` and `email` on `User`.
- Unique `code` on `Gym`.
- Unique `membershipId` on `Payment`.
- Unique `(memberId, attendanceDate)` on `Attendance`.
- Unique `(workoutPlanId, sequence)` and `(workoutPlanId, exerciseId)` on `WorkoutExercise`.
- Unique `(dietPlanId, mealOrder)` on `Meal`.
- Unique `(memberId, measuredAt)` on `MemberMeasurement`.
- Unique `(memberId, priority)` on `EmergencyContact`.

Recommended application-level constraints:

- Only one active `Membership` per member at a time.
- Only one active `MemberTrainerAssignment` per member at a time.
- Only one active `MemberWorkoutAssignment` per member at a time if your business logic requires a single workout plan.
- Only one active `MemberDietAssignment` per member at a time if your business logic requires a single diet plan.
- Emergency contacts should be capped at three per member.
- Members may check in only when membership rules allow it, including the 7-day grace period after expiry.

## Business Logic Notes

Some rules are better enforced in the application layer or with database triggers:

- The 7-day post-expiry attendance grace period depends on comparing attendance dates against the latest active or expired membership.
- Membership lifecycle transitions should happen only through service logic so the payment and status update remain consistent.
- Trainer and member approval status should be coordinated with user role changes.
- A trainer cannot manage workouts, diets, or assignments for members outside their gym; this is a tenant-scoping rule.

## Prisma Recommendation

- Keep the schema in `backend/prisma/schema.prisma`.
- Use generated Prisma client code under `backend/src/generated/prisma`.
- Add indexes for all foreign keys that are queried frequently.
- Add database migrations for future changes instead of editing tables manually.
- Consider PostgreSQL partial unique indexes later for rules like “one active membership per member” if you want database-enforced exclusivity.

## Assumptions

- A member belongs to exactly one gym at a time.
- A trainer belongs to exactly one gym.
- The current system is single-gym in use, but the schema is gym-scoped everywhere it matters.
- `SUPER_ADMIN` accounts are not tied to a gym.
- The current design stores membership pricing on `MembershipPlan`; actual payment rows preserve the paid amount.

## Suggested Improvements

- Add PostgreSQL triggers or service checks for “only one active row” rules if you want stronger DB enforcement.
- Add soft-delete handling in application queries so deleted records do not appear in normal UI flows.
- If you later need rich exercise metadata, add a dedicated `exercise_media` table rather than overloading `Exercise`.
