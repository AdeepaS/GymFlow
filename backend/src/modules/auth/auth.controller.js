import {
    register,
    login
} from "./auth.service.js";

import {
    successResponse
} from "../../utils/response.js";


// ===============================
// Register Controller
// ===============================

export const registerController = async (req, res) => {

    const user = await register(req.body);


    return successResponse(
        res,
        "User registered successfully",
        user,
        201
    );

};



// ===============================
// Login Controller
// ===============================

export const loginController = async (req, res) => {


    const {
        email,
        password
    } = req.body;



    const result = await login(
        email,
        password
    );


    return successResponse(
        res,
        "Login successful",
        result,
        200
    );

};