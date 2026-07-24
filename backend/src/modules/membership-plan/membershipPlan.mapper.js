export const membershipPlanMapper = (membershipPlan) => {

    if (!membershipPlan) {
        return null;
    }


    return {

        id: membershipPlan.id,

        gymId: membershipPlan.gymId,

        name: membershipPlan.name,

        description: membershipPlan.description,

        durationDays: membershipPlan.durationDays,


        // Prisma Decimal -> Number
        price: Number(membershipPlan.price),


        isActive: membershipPlan.isActive,


        createdAt: membershipPlan.createdAt,

        updatedAt: membershipPlan.updatedAt

    };

};