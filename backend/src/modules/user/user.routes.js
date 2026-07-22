import express from "express";


import authenticate from "../../middleware/authenticate.js";

import authorize from "../../middleware/authorize.js";


import {

getMyProfileController,
getUserController,
getUsersController,
updateProfileController,
changeRoleController,
changeStatusController,
deleteUserController

} from "./user.controller.js";



const router=express.Router();



// logged user profile

router.get(
"/me",
authenticate,
getMyProfileController
);




// Admin get all users

router.get(
"/",
authenticate,
authorize(
"GYM_ADMIN",
"SUPER_ADMIN"
),
getUsersController
);




// Find user

router.get(
"/:id",
authenticate,
authorize(
"GYM_ADMIN",
"SUPER_ADMIN"
),
getUserController
);




// Update

router.patch(
"/:id",
authenticate,
updateProfileController
);




// Change role

router.patch(
"/:id/role",
authenticate,
authorize(
"SUPER_ADMIN",
"GYM_ADMIN"
),
changeRoleController
);




// Change status

router.patch(
"/:id/status",
authenticate,
authorize(
"SUPER_ADMIN",
"GYM_ADMIN"
),
changeStatusController
);




// Delete

router.delete(
"/:id",
authenticate,
authorize(
"SUPER_ADMIN"
),
deleteUserController
);



export default router;