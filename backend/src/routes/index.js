import express from "express";
import userRoutes from "../modules/user/user.routes.js";
import authRoutes from "../modules/auth/auth.routes.js";
import membershipPlanRoutes from "../modules/membership-plan/membershipPlan.routes.js";

const router = express.Router();

router.use(
    "/users",
    userRoutes
);


router.use(
    "/auth",
    authRoutes
);


router.use(
    "/api/membership-plans",
    membershipPlanRoutes
);

export default router;