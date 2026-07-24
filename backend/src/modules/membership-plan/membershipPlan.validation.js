import { z } from "zod";


// ================================
// Create Membership Plan
// ================================

export const createMembershipPlanSchema = z.object({

    gymId: z.string().uuid({
        message: "Invalid gym id"
    }),


    name: z.string()
        .min(2, {
            message:"Plan name must contain at least 2 characters"
        })
        .max(120),


    description: z.string()
        .max(500)
        .optional(),


    durationDays: z.number()
        .int({
            message:"Duration must be a whole number"
        })
        .positive({
            message:"Duration must be greater than zero"
        }),


    price: z.number()
        .positive({
            message:"Price must be greater than zero"
        })

});



// ================================
// Update Membership Plan
// ================================

export const updateMembershipPlanSchema = z.object({

    name: z.string()
        .min(2)
        .max(120)
        .optional(),


    description: z.string()
        .max(500)
        .optional(),


    durationDays: z.number()
        .int()
        .positive()
        .optional(),


    price: z.number()
        .positive()
        .optional()

});



// ================================
// Change Plan Status
// ================================

export const changeMembershipPlanStatusSchema = z.object({

    isActive: z.boolean()

});