import prisma from "../../prisma/client.js";

// Find user by email

export const findUserByEmail = async (email) => {

    return prisma.user.findUnique({

        where: {
            email
        }

    });

};



// Create user

export const createUser = async (userData) => {

    return prisma.user.create({

        data: userData

    });

};



// Create refresh token

export const createRefreshToken = async (data) => {

    return prisma.refreshToken.create({

        data

    });

};



// Find refresh token

export const findRefreshToken = async (token) => {

    return prisma.refreshToken.findUnique({

        where:{
            token
        }

    });

};



// Delete refresh token

export const deleteRefreshToken = async (token) => {

    return prisma.refreshToken.delete({

        where:{
            token
        }

    });

};