import { z } from "zod";


// ======================================
// Create Membership
// ======================================

export const createMembershipSchema = z.object({

    memberId: z.string().uuid({
        message: "Invalid member id"
    }),


    membershipPlanId: z.string().uuid({
        message: "Invalid membership plan id"
    }),


    startDate: z.string()
        .datetime()
        .optional(),


    notes: z.string()
        .max(500)
        .optional()

});