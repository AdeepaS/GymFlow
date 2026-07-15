import AppError from "../../errors/AppError.js";

import {
    findUserByEmail,
    createUser,
    createRefreshToken
} from "./auth.repository.js";

import {
    hashPassword,
    comparePassword
} from "../../utils/password.js";

import {
    generateAccessToken,
    generateRefreshToken
} from "../../utils/jwt.js";



// ===============================
// Register New User
// ===============================

export const register = async (userData) => {


    const existingUser =
        await findUserByEmail(userData.email);



    if (existingUser) {

        throw new AppError(
            "Email already exists",
            409
        );

    }



    const hashedPassword =
        await hashPassword(
            userData.password
        );



    const user = await createUser({

        email: userData.email,

        passwordHash: hashedPassword,

        role: userData.role

    });



    return {

        id: user.id,

        firstName: userData.firstName,
        lastName: userData.lastName,

        email: user.email,

        role: user.role

    };

};





// ===============================
// Login User
// ===============================

export const login = async (
    email,
    password
) => {


    const user =
        await findUserByEmail(email);



    if (!user) {

        throw new AppError(
            "Invalid email or password",
            401
        );

    }



    const isPasswordCorrect =
        await comparePassword(
            password,
            user.passwordHash
        );



    if (!isPasswordCorrect) {

        throw new AppError(
            "Invalid email or password",
            401
        );

    }



    const accessToken =
        generateAccessToken(user);



    const refreshToken =
        generateRefreshToken(user);



    await createRefreshToken({

        token: refreshToken,

        userId: user.id,

        expiresAt:
            new Date(
                Date.now()
                +
                7 * 24 * 60 * 60 * 1000
            )

    });



    return {

        accessToken,

        refreshToken,

        user: {

            id: user.id,

            email: user.email,

            role: user.role

        }

    };

};
