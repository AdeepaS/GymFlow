import {
    getMyProfile
} from "./user.service.js";


export const getProfile = async (req, res) => {

    const user = await getMyProfile(
        req.user.userId
    );


    res.status(200).json({
        success: true,
        data: user,
    });
};