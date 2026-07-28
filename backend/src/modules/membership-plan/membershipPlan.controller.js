import {
    createMembershipPlanService,
    getMembershipPlanByIdService,
    getMembershipPlansService,
    updateMembershipPlanService,
    changeMembershipPlanStatusService,
    deleteMembershipPlanService
} from "./membershipPlan.service.js";


// ======================================
// Create Membership Plan
// POST /api/membership-plans
// ======================================

export const createMembershipPlanController = async (req, res) => {

    const membershipPlan = await createMembershipPlanService(req.body);

    return res.status(201).json({
        success: true,
        message: "Membership plan created successfully.",
        data: membershipPlan
    });

};


// ======================================
// Get All Membership Plans
// GET /api/membership-plans
// ======================================

export const getMembershipPlansController = async (req, res) => {

    const membershipPlans = await getMembershipPlansService(req.query);

    return res.status(200).json({
        success: true,
        data: membershipPlans
    });

};


// ======================================
// Get Membership Plan By ID
// GET /api/membership-plans/:id
// ======================================

export const getMembershipPlanByIdController = async (req, res) => {

    const membershipPlan = await getMembershipPlanByIdService(
        req.params.id
    );

    return res.status(200).json({
        success: true,
        data: membershipPlan
    });

};


// ======================================
// Update Membership Plan
// PATCH /api/membership-plans/:id
// ======================================

export const updateMembershipPlanController = async (req, res) => {

    const membershipPlan =
        await updateMembershipPlanService(
            req.params.id,
            req.body
        );

    return res.status(200).json({
        success: true,
        message: "Membership plan updated successfully.",
        data: membershipPlan
    });

};


// ======================================
// Change Membership Plan Status
// PATCH /api/membership-plans/:id/status
// ======================================

export const changeMembershipPlanStatusController = async (req, res) => {

    const membershipPlan =
        await changeMembershipPlanStatusService(
            req.params.id,
            req.body.isActive
        );

    return res.status(200).json({
        success: true,
        message: "Membership plan status updated successfully.",
        data: membershipPlan
    });

};


// ======================================
// Delete Membership Plan
// DELETE /api/membership-plans/:id
// ======================================

export const deleteMembershipPlanController = async (req, res) => {

    await deleteMembershipPlanService(req.params.id);

    return res.status(200).json({
        success: true,
        message: "Membership plan deleted successfully."
    });

};