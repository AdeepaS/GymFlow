import express from "express";

import {
    createMembershipPlanController,
    getMembershipPlansController,
    getMembershipPlanByIdController,
    updateMembershipPlanController,
    changeMembershipPlanStatusController,
    deleteMembershipPlanController
} from "./membershipPlan.controller.js";

import authenticate from "../../middleware/authenticate.js";
import authorize from "../../middleware/authorize.js";
import validate from "../../middleware/errorHandler.js";
import asyncHandler from "../../utils/asyncHandler.js";

import {
    createMembershipPlanSchema,
    updateMembershipPlanSchema,
    changeMembershipPlanStatusSchema
} from "./membershipPlan.validation.js";

const router = express.Router();


// ======================================
// Create Membership Plan
// ======================================

router.post(
    "/",
    authenticate,
    authorize("SUPER_ADMIN", "GYM_ADMIN"),
    validate(createMembershipPlanSchema),
    asyncHandler(createMembershipPlanController)
);


// ======================================
// Get All Membership Plans
// ======================================

router.get(
    "/",
    authenticate,
    authorize("SUPER_ADMIN", "GYM_ADMIN"),
    asyncHandler(getMembershipPlansController)
);


// ======================================
// Get Membership Plan By ID
// ======================================

router.get(
    "/:id",
    authenticate,
    authorize("SUPER_ADMIN", "GYM_ADMIN"),
    asyncHandler(getMembershipPlanByIdController)
);


// ======================================
// Update Membership Plan
// ======================================

router.patch(
    "/:id",
    authenticate,
    authorize("SUPER_ADMIN", "GYM_ADMIN"),
    validate(updateMembershipPlanSchema),
    asyncHandler(updateMembershipPlanController)
);


// ======================================
// Change Plan Status
// ======================================

router.patch(
    "/:id/status",
    authenticate,
    authorize("SUPER_ADMIN", "GYM_ADMIN"),
    validate(changeMembershipPlanStatusSchema),
    asyncHandler(changeMembershipPlanStatusController)
);


// ======================================
// Soft Delete Membership Plan
// ======================================

router.delete(
    "/:id",
    authenticate,
    authorize("SUPER_ADMIN"),
    asyncHandler(deleteMembershipPlanController)
);

export default router;