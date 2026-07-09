-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('SUPER_ADMIN', 'GYM_ADMIN', 'TRAINER', 'MEMBER');

-- CreateEnum
CREATE TYPE "AccountStatus" AS ENUM ('ACTIVE', 'SUSPENDED', 'DELETED');

-- CreateEnum
CREATE TYPE "ApprovalStatus" AS ENUM ('PENDING_APPROVAL', 'APPROVED', 'REJECTED');

-- CreateEnum
CREATE TYPE "MembershipStatus" AS ENUM ('PENDING_PAYMENT', 'ACTIVE', 'EXPIRED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'PAID', 'FAILED');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('CASH', 'CARD', 'ONLINE', 'BANK_TRANSFER');

-- CreateTable
CREATE TABLE "gyms" (
    "id" UUID NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "code" VARCHAR(50) NOT NULL,
    "email" VARCHAR(255),
    "phone" VARCHAR(30),
    "address" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "deletedAt" TIMESTAMPTZ(6),
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "gyms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "username" VARCHAR(50) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "passwordHash" VARCHAR(255) NOT NULL,
    "role" "UserRole" NOT NULL,
    "status" "AccountStatus" NOT NULL DEFAULT 'ACTIVE',
    "lastLoginAt" TIMESTAMPTZ(6),
    "deletedAt" TIMESTAMPTZ(6),
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gym_admins" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "gym_admins_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "trainers" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "specialization" VARCHAR(150),
    "experienceYears" INTEGER,
    "joiningDate" DATE,
    "certifications" TEXT,
    "approvalStatus" "ApprovalStatus" NOT NULL DEFAULT 'PENDING_APPROVAL',
    "deletedAt" TIMESTAMPTZ(6),
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "trainers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "members" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "trainerId" UUID,
    "approvalStatus" "ApprovalStatus" NOT NULL DEFAULT 'PENDING_APPROVAL',
    "qrCode" VARCHAR(120) NOT NULL,
    "dateOfBirth" DATE,
    "gender" VARCHAR(30),
    "joinDate" DATE,
    "notes" TEXT,
    "deletedAt" TIMESTAMPTZ(6),
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "membership_plans" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "description" TEXT,
    "durationDays" INTEGER NOT NULL,
    "price" DECIMAL(12,2) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "deletedAt" TIMESTAMPTZ(6),
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "membership_plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "memberships" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "memberId" UUID NOT NULL,
    "membershipPlanId" UUID NOT NULL,
    "status" "MembershipStatus" NOT NULL DEFAULT 'PENDING_PAYMENT',
    "startDate" DATE,
    "endDate" DATE,
    "cancelledAt" TIMESTAMPTZ(6),
    "notes" TEXT,
    "deletedAt" TIMESTAMPTZ(6),
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "memberships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "membershipId" UUID NOT NULL,
    "amount" DECIMAL(12,2) NOT NULL,
    "currency" CHAR(3) NOT NULL DEFAULT 'LKR',
    "method" "PaymentMethod" NOT NULL,
    "status" "PaymentStatus" NOT NULL DEFAULT 'PENDING',
    "transactionRef" VARCHAR(120),
    "paidAt" TIMESTAMPTZ(6),
    "failureReason" TEXT,
    "deletedAt" TIMESTAMPTZ(6),
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exercises" (
    "id" UUID NOT NULL,
    "gymId" UUID,
    "name" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "muscleGroup" VARCHAR(120),
    "equipment" VARCHAR(120),
    "instructions" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "deletedAt" TIMESTAMPTZ(6),
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "exercises_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workout_plans" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "trainerId" UUID NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "goal" VARCHAR(120),
    "description" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "deletedAt" TIMESTAMPTZ(6),
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "workout_plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workout_plan_versions" (
    "id" UUID NOT NULL,
    "workoutPlanId" UUID NOT NULL,
    "versionNumber" INTEGER NOT NULL,
    "title" VARCHAR(150) NOT NULL,
    "notes" TEXT,
    "isCurrent" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "workout_plan_versions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workout_exercise_items" (
    "id" UUID NOT NULL,
    "workoutPlanVersionId" UUID NOT NULL,
    "exerciseId" UUID NOT NULL,
    "sequence" INTEGER NOT NULL,
    "sets" INTEGER NOT NULL,
    "reps" VARCHAR(30) NOT NULL,
    "weight" DECIMAL(8,2),
    "restSeconds" INTEGER,
    "notes" TEXT,
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "workout_exercise_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "member_workout_assignments" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "memberId" UUID NOT NULL,
    "workoutPlanVersionId" UUID NOT NULL,
    "assignedById" UUID NOT NULL,
    "assignedAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "unassignedAt" TIMESTAMPTZ(6),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "notes" TEXT,
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "member_workout_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "diet_plans" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "trainerId" UUID NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "goal" VARCHAR(120),
    "description" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "deletedAt" TIMESTAMPTZ(6),
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "diet_plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "diet_plan_versions" (
    "id" UUID NOT NULL,
    "dietPlanId" UUID NOT NULL,
    "versionNumber" INTEGER NOT NULL,
    "title" VARCHAR(150) NOT NULL,
    "calories" INTEGER,
    "protein" DECIMAL(8,2),
    "carbs" DECIMAL(8,2),
    "fats" DECIMAL(8,2),
    "notes" TEXT,
    "isCurrent" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "diet_plan_versions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "meals" (
    "id" UUID NOT NULL,
    "dietPlanVersionId" UUID NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "mealOrder" INTEGER,
    "calories" INTEGER,
    "protein" DECIMAL(8,2),
    "carbs" DECIMAL(8,2),
    "fats" DECIMAL(8,2),
    "notes" TEXT,
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "meals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "member_diet_assignments" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "memberId" UUID NOT NULL,
    "dietPlanVersionId" UUID NOT NULL,
    "assignedById" UUID NOT NULL,
    "assignedAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "unassignedAt" TIMESTAMPTZ(6),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "notes" TEXT,
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "member_diet_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "member_measurements" (
    "id" UUID NOT NULL,
    "memberId" UUID NOT NULL,
    "measuredAt" DATE NOT NULL,
    "heightCm" DECIMAL(5,2),
    "weightKg" DECIMAL(5,2),
    "bodyFatPercent" DECIMAL(5,2),
    "muscleMassKg" DECIMAL(5,2),
    "notes" TEXT,
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "member_measurements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "emergency_contacts" (
    "id" UUID NOT NULL,
    "memberId" UUID NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "relationship" VARCHAR(80),
    "phone" VARCHAR(30) NOT NULL,
    "email" VARCHAR(255),
    "priority" INTEGER NOT NULL DEFAULT 1,
    "isPrimary" BOOLEAN NOT NULL DEFAULT false,
    "notes" TEXT,
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "emergency_contacts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attendances" (
    "id" UUID NOT NULL,
    "memberId" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "attendanceDate" DATE NOT NULL,
    "checkInAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "checkOutAt" TIMESTAMPTZ(6),
    "source" VARCHAR(50),
    "notes" TEXT,
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "attendances_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refresh_tokens" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "token" TEXT NOT NULL,
    "expiresAt" TIMESTAMPTZ(6) NOT NULL,
    "revokedAt" TIMESTAMPTZ(6),
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "refresh_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "password_reset_tokens" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "token" TEXT NOT NULL,
    "expiresAt" TIMESTAMPTZ(6) NOT NULL,
    "used" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "password_reset_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "gyms_code_key" ON "gyms"("code");

-- CreateIndex
CREATE INDEX "gyms_isActive_idx" ON "gyms"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_role_status_idx" ON "users"("role", "status");

-- CreateIndex
CREATE UNIQUE INDEX "gym_admins_gymId_key" ON "gym_admins"("gymId");

-- CreateIndex
CREATE UNIQUE INDEX "gym_admins_userId_key" ON "gym_admins"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "trainers_userId_key" ON "trainers"("userId");

-- CreateIndex
CREATE INDEX "trainers_gymId_approvalStatus_idx" ON "trainers"("gymId", "approvalStatus");

-- CreateIndex
CREATE UNIQUE INDEX "members_userId_key" ON "members"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "members_qrCode_key" ON "members"("qrCode");

-- CreateIndex
CREATE INDEX "members_gymId_approvalStatus_idx" ON "members"("gymId", "approvalStatus");

-- CreateIndex
CREATE INDEX "members_trainerId_idx" ON "members"("trainerId");

-- CreateIndex
CREATE INDEX "membership_plans_gymId_isActive_idx" ON "membership_plans"("gymId", "isActive");

-- CreateIndex
CREATE UNIQUE INDEX "membership_plans_gymId_name_key" ON "membership_plans"("gymId", "name");

-- CreateIndex
CREATE INDEX "memberships_memberId_status_idx" ON "memberships"("memberId", "status");

-- CreateIndex
CREATE INDEX "memberships_gymId_status_idx" ON "memberships"("gymId", "status");

-- CreateIndex
CREATE INDEX "memberships_membershipPlanId_idx" ON "memberships"("membershipPlanId");

-- CreateIndex
CREATE UNIQUE INDEX "payments_membershipId_key" ON "payments"("membershipId");

-- CreateIndex
CREATE UNIQUE INDEX "payments_transactionRef_key" ON "payments"("transactionRef");

-- CreateIndex
CREATE INDEX "payments_gymId_status_idx" ON "payments"("gymId", "status");

-- CreateIndex
CREATE INDEX "exercises_name_idx" ON "exercises"("name");

-- CreateIndex
CREATE INDEX "exercises_gymId_isActive_idx" ON "exercises"("gymId", "isActive");

-- CreateIndex
CREATE UNIQUE INDEX "exercises_gymId_name_key" ON "exercises"("gymId", "name");

-- CreateIndex
CREATE INDEX "workout_plans_gymId_isActive_idx" ON "workout_plans"("gymId", "isActive");

-- CreateIndex
CREATE UNIQUE INDEX "workout_plans_gymId_trainerId_name_key" ON "workout_plans"("gymId", "trainerId", "name");

-- CreateIndex
CREATE INDEX "workout_plan_versions_workoutPlanId_isCurrent_idx" ON "workout_plan_versions"("workoutPlanId", "isCurrent");

-- CreateIndex
CREATE UNIQUE INDEX "workout_plan_versions_workoutPlanId_versionNumber_key" ON "workout_plan_versions"("workoutPlanId", "versionNumber");

-- CreateIndex
CREATE INDEX "workout_exercise_items_exerciseId_idx" ON "workout_exercise_items"("exerciseId");

-- CreateIndex
CREATE UNIQUE INDEX "workout_exercise_items_workoutPlanVersionId_sequence_key" ON "workout_exercise_items"("workoutPlanVersionId", "sequence");

-- CreateIndex
CREATE UNIQUE INDEX "workout_exercise_items_workoutPlanVersionId_exerciseId_key" ON "workout_exercise_items"("workoutPlanVersionId", "exerciseId");

-- CreateIndex
CREATE INDEX "member_workout_assignments_memberId_isActive_idx" ON "member_workout_assignments"("memberId", "isActive");

-- CreateIndex
CREATE INDEX "member_workout_assignments_workoutPlanVersionId_isActive_idx" ON "member_workout_assignments"("workoutPlanVersionId", "isActive");

-- CreateIndex
CREATE INDEX "diet_plans_gymId_isActive_idx" ON "diet_plans"("gymId", "isActive");

-- CreateIndex
CREATE UNIQUE INDEX "diet_plans_gymId_trainerId_name_key" ON "diet_plans"("gymId", "trainerId", "name");

-- CreateIndex
CREATE INDEX "diet_plan_versions_dietPlanId_isCurrent_idx" ON "diet_plan_versions"("dietPlanId", "isCurrent");

-- CreateIndex
CREATE UNIQUE INDEX "diet_plan_versions_dietPlanId_versionNumber_key" ON "diet_plan_versions"("dietPlanId", "versionNumber");

-- CreateIndex
CREATE INDEX "meals_dietPlanVersionId_idx" ON "meals"("dietPlanVersionId");

-- CreateIndex
CREATE UNIQUE INDEX "meals_dietPlanVersionId_mealOrder_key" ON "meals"("dietPlanVersionId", "mealOrder");

-- CreateIndex
CREATE INDEX "member_diet_assignments_memberId_isActive_idx" ON "member_diet_assignments"("memberId", "isActive");

-- CreateIndex
CREATE INDEX "member_diet_assignments_dietPlanVersionId_isActive_idx" ON "member_diet_assignments"("dietPlanVersionId", "isActive");

-- CreateIndex
CREATE INDEX "member_measurements_memberId_measuredAt_idx" ON "member_measurements"("memberId", "measuredAt");

-- CreateIndex
CREATE UNIQUE INDEX "member_measurements_memberId_measuredAt_key" ON "member_measurements"("memberId", "measuredAt");

-- CreateIndex
CREATE INDEX "emergency_contacts_memberId_idx" ON "emergency_contacts"("memberId");

-- CreateIndex
CREATE UNIQUE INDEX "emergency_contacts_memberId_priority_key" ON "emergency_contacts"("memberId", "priority");

-- CreateIndex
CREATE INDEX "attendances_gymId_attendanceDate_idx" ON "attendances"("gymId", "attendanceDate");

-- CreateIndex
CREATE UNIQUE INDEX "attendances_memberId_attendanceDate_key" ON "attendances"("memberId", "attendanceDate");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_token_key" ON "refresh_tokens"("token");

-- CreateIndex
CREATE INDEX "refresh_tokens_userId_revokedAt_idx" ON "refresh_tokens"("userId", "revokedAt");

-- CreateIndex
CREATE UNIQUE INDEX "password_reset_tokens_token_key" ON "password_reset_tokens"("token");

-- CreateIndex
CREATE INDEX "password_reset_tokens_userId_used_idx" ON "password_reset_tokens"("userId", "used");

-- AddForeignKey
ALTER TABLE "gym_admins" ADD CONSTRAINT "gym_admins_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gym_admins" ADD CONSTRAINT "gym_admins_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "trainers" ADD CONSTRAINT "trainers_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "trainers" ADD CONSTRAINT "trainers_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "members" ADD CONSTRAINT "members_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "members" ADD CONSTRAINT "members_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "members" ADD CONSTRAINT "members_trainerId_fkey" FOREIGN KEY ("trainerId") REFERENCES "trainers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "membership_plans" ADD CONSTRAINT "membership_plans_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "memberships" ADD CONSTRAINT "memberships_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "memberships" ADD CONSTRAINT "memberships_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "members"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "memberships" ADD CONSTRAINT "memberships_membershipPlanId_fkey" FOREIGN KEY ("membershipPlanId") REFERENCES "membership_plans"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_membershipId_fkey" FOREIGN KEY ("membershipId") REFERENCES "memberships"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exercises" ADD CONSTRAINT "exercises_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workout_plans" ADD CONSTRAINT "workout_plans_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workout_plans" ADD CONSTRAINT "workout_plans_trainerId_fkey" FOREIGN KEY ("trainerId") REFERENCES "trainers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workout_plan_versions" ADD CONSTRAINT "workout_plan_versions_workoutPlanId_fkey" FOREIGN KEY ("workoutPlanId") REFERENCES "workout_plans"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workout_exercise_items" ADD CONSTRAINT "workout_exercise_items_workoutPlanVersionId_fkey" FOREIGN KEY ("workoutPlanVersionId") REFERENCES "workout_plan_versions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workout_exercise_items" ADD CONSTRAINT "workout_exercise_items_exerciseId_fkey" FOREIGN KEY ("exerciseId") REFERENCES "exercises"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "member_workout_assignments" ADD CONSTRAINT "member_workout_assignments_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "member_workout_assignments" ADD CONSTRAINT "member_workout_assignments_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "members"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "member_workout_assignments" ADD CONSTRAINT "member_workout_assignments_workoutPlanVersionId_fkey" FOREIGN KEY ("workoutPlanVersionId") REFERENCES "workout_plan_versions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "member_workout_assignments" ADD CONSTRAINT "member_workout_assignments_assignedById_fkey" FOREIGN KEY ("assignedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "diet_plans" ADD CONSTRAINT "diet_plans_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "diet_plans" ADD CONSTRAINT "diet_plans_trainerId_fkey" FOREIGN KEY ("trainerId") REFERENCES "trainers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "diet_plan_versions" ADD CONSTRAINT "diet_plan_versions_dietPlanId_fkey" FOREIGN KEY ("dietPlanId") REFERENCES "diet_plans"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meals" ADD CONSTRAINT "meals_dietPlanVersionId_fkey" FOREIGN KEY ("dietPlanVersionId") REFERENCES "diet_plan_versions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "member_diet_assignments" ADD CONSTRAINT "member_diet_assignments_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "member_diet_assignments" ADD CONSTRAINT "member_diet_assignments_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "members"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "member_diet_assignments" ADD CONSTRAINT "member_diet_assignments_dietPlanVersionId_fkey" FOREIGN KEY ("dietPlanVersionId") REFERENCES "diet_plan_versions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "member_diet_assignments" ADD CONSTRAINT "member_diet_assignments_assignedById_fkey" FOREIGN KEY ("assignedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "member_measurements" ADD CONSTRAINT "member_measurements_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "members"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "emergency_contacts" ADD CONSTRAINT "emergency_contacts_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "members"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendances" ADD CONSTRAINT "attendances_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "members"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendances" ADD CONSTRAINT "attendances_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "password_reset_tokens" ADD CONSTRAINT "password_reset_tokens_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
