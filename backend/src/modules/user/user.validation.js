import {z} from "zod";


export const updateProfileSchema=z.object({

    firstName:z.string()
        .min(2)
        .optional(),

    lastName:z.string()
        .min(2)
        .optional(),

    phone:z.string()
        .optional(),

    address:z.string()
        .optional()

});



export const changeRoleSchema=z.object({

    role:z.enum([
        "MEMBER",
        "TRAINER",
        "GYM_ADMIN",
        "SUPER_ADMIN"
    ])

});



export const changeStatusSchema=z.object({

    accountStatus:z.enum([
        "ACTIVE",
        "INACTIVE",
        "SUSPENDED"
    ])

});