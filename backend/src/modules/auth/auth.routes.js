import express from "express";

import {
    registerController,
    loginController
} from "./auth.controller.js";


import {
    registerSchema,
    loginSchema
} from "./auth.validaton.js";


import validate from "../../middleware/validate.js";

import asyncHandler from "../../utils/asyncHandler.js";


const router = express.Router();



// Register route

router.post(
    "/register",
    validate(registerSchema),
    asyncHandler(registerController)
);



// Login route

router.post(
    "/login",
    validate(loginSchema),
    asyncHandler(loginController)
);



export default router;