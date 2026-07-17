import { findUserById } from "./user.repository.js";
import { mapUserResponse } from "./user.mapper.js";


export const getMyProfile = async (userId) => {

    const user = await findUserById(userId);

    if (!user) {
        throw new Error("User not found");
    }


    return mapUserResponse(user);
};