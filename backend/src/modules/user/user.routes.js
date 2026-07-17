import express from "express";

import authenticate from "../../middleware/authenticate.js";

import {
    getProfile
} from "./user.controller.js";


const router = express.Router();


router.get(
    "/me",
    authenticate,
    getProfile
);


export default router;