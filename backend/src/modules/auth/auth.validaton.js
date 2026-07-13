import { z } from "zod";


// Reusable password validation schema
const passwordSchema = z
    .string()
    .min(
        8,
        "Password must contain at least 8 characters"
    )
    .regex(
        /[A-Z]/,
        "Password must contain at least one uppercase letter"
    )
    .regex(
        /[^A-Za-z0-9]/,
        "Password must contain at least one special character"
    );


// Register validation

export const registerSchema = z.object({

    firstName: z
        .string()
        .min(
            2,
            "First name must contain at least 2 characters"
        )
        .max(
            50,
            "First name is too long"
        ),


    lastName: z
        .string()
        .min(
            2,
            "Last name must contain at least 2 characters"
        )
        .max(
            50,
            "Last name is too long"
        ),


    email: z
        .string()
        .email(
            "Invalid email format"
        )
        .toLowerCase(),


    password: passwordSchema

});


// Login validation

export const loginSchema = z.object({

    email: z
        .string()
        .email(
            "Invalid email format"
        )
        .toLowerCase(),


    password: z
        .string()
        .min(
            1,
            "Password is required"
        )

});