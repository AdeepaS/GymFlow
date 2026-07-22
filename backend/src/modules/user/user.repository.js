import prisma from "../../prisma/client.js";


export const findUserById = async (id) => {

    return prisma.user.findUnique({
        where:{
            id
        }
    });

};



export const findAllUsers = async ({
    skip,
    take,
    where
}) => {

    return prisma.user.findMany({

        skip,
        take,

        where,

        orderBy:{
            createdAt:"desc"
        }

    });

};



export const countUsers = async(where)=>{

    return prisma.user.count({
        where
    });

};



export const updateUser = async(id,data)=>{

    return prisma.user.update({

        where:{
            id
        },

        data

    });

};



export const deleteUser = async(id)=>{

    return prisma.user.update({

        where:{
            id
        },

        data:{
            accountStatus:"DELETED"
        }

    });

};