export const userMapper = (user)=>{


    return {

        id:user.id,

        firstName:user.firstName,

        lastName:user.lastName,

        email:user.email,

        role:user.role,

        accountStatus:user.accountStatus,

        approvalStatus:user.approvalStatus,

        createdAt:user.createdAt,

        updatedAt:user.updatedAt

    };


};