import prisma from "../../prisma/client.js";


// Create membership plan

export const createMembershipPlan = async (data) => {

    return await prisma.membershipPlan.create({

        data

    });

};



// Find plan by ID

export const findMembershipPlanById = async (id) => {

    return await prisma.membershipPlan.findUnique({

        where: {
            id
        }

    });

};



// Find plan by name inside a gym
// Used to prevent duplicate plan names

export const findMembershipPlanByName = async (
    gymId,
    name
) => {

    return await prisma.membershipPlan.findFirst({

        where: {

            gymId,

            name

        }

    });

};



// Get all membership plans

export const findMembershipPlans = async ({
    gymId,
    skip,
    take,
    includeInactive = false
}) => {


    return await prisma.membershipPlan.findMany({

        where: {

            gymId,

            ...(includeInactive
                ? {}
                : {
                    isActive: true,
                    deletedAt: null
                })

        },


        skip,

        take,


        orderBy: {

            createdAt: "desc"

        }

    });


};



// Count plans

export const countMembershipPlans = async ({
    gymId,
    includeInactive = false
}) => {


    return await prisma.membershipPlan.count({

        where: {

            gymId,


            ...(includeInactive
                ? {}
                : {
                    isActive:true,
                    deletedAt:null
                })

        }

    });


};



// Update membership plan

export const updateMembershipPlan = async (
    id,
    data
) => {


    return await prisma.membershipPlan.update({

        where:{
            id
        },


        data

    });


};



// Change active status

export const updateMembershipPlanStatus = async (
    id,
    isActive
) => {


    return await prisma.membershipPlan.update({

        where:{
            id
        },


        data:{
            isActive
        }

    });


};



// Soft delete

export const softDeleteMembershipPlan = async(id)=>{


    return await prisma.membershipPlan.update({

        where:{
            id
        },


        data:{

            deletedAt:new Date(),

            isActive:false

        }

    });


};