import prisma from "../../prisma/client";


export const findUserById = async (userId) => {
    return prisma.user.findUnique({
        where: {
            id: userId,
        },
    });
};