import {findUserById,findAllUsers,countUsers,updateUser,deleteUser} from "./user.repository.js";

import {userMapper} from "./user.mapper.js";



// Get single user

export const getUserById = async(id)=>{


    const user = await findUserById(id);


    if(!user){

        throw new Error("User not found");

    }


    return userMapper(user);

};




// Get current user

export const getMyProfile = async(userId)=>{

    return getUserById(userId);

};




// Get all users

export const getUsers = async(query)=>{


    const page = Number(query.page)||1;

    const limit = Number(query.limit)||20;


    const skip=(page-1)*limit;



    const where={};



    if(query.role){

        where.role=query.role;

    }



    if(query.status){

        where.accountStatus=query.status;

    }



    const users = await findAllUsers({

        skip,

        take:limit,

        where

    });



    const total=await countUsers(where);



    return {

        users:users.map(userMapper),

        pagination:{

            page,

            limit,

            total

        }

    };


};




// Update profile

export const updateProfile=async(id,data)=>{


    const user=await updateUser(id,data);


    return userMapper(user);

};




// Change role

export const changeRole=async(id,role)=>{


    const user=await updateUser(id,{

        role

    });


    return userMapper(user);

};




// Change status

export const changeStatus=async(id,status)=>{


    const user=await updateUser(id,{

        accountStatus:status

    });


    return userMapper(user);

};




// Delete

export const removeUser=async(id)=>{

    return deleteUser(id);

};