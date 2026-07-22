import * as userService from "./user.service.js";



// GET /me

export const getMyProfileController = async(req,res)=>{


    const user = await userService.getMyProfile(
        req.user.userId
    );


    res.json({

        success:true,

        data:user

    });

};




// GET /:id

export const getUserController = async(req,res)=>{


    const user = await userService.getUserById(
        req.params.id
    );


    res.json({

        success:true,

        data:user

    });

};




// GET /

export const getUsersController = async(req,res)=>{


    const users = await userService.getUsers(
        req.query
    );


    res.json({

        success:true,

        data:users

    });


};




// UPDATE

export const updateProfileController=async(req,res)=>{


    const user =
    await userService.updateProfile(

        req.params.id,

        req.body

    );


    res.json({

        success:true,

        data:user

    });


};




// ROLE

export const changeRoleController=async(req,res)=>{


    const user =
    await userService.changeRole(

        req.params.id,

        req.body.role

    );


    res.json({

        success:true,

        data:user

    });

};




// STATUS

export const changeStatusController=async(req,res)=>{


    const user =
    await userService.changeStatus(

        req.params.id,

        req.body.accountStatus

    );


    res.json({

        success:true,

        data:user

    });


};




// DELETE

export const deleteUserController=async(req,res)=>{


    await userService.removeUser(
        req.params.id
    );


    res.json({

        success:true,

        message:"User deleted successfully"

    });


};