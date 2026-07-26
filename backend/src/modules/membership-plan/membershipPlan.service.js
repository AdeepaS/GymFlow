import {
    createMembershipPlan,
    findMembershipPlanById,
    findMembershipPlanByName,
    findMembershipPlans,
    countMembershipPlans,
    updateMembershipPlan,
    updateMembershipPlanStatus,
    softDeleteMembershipPlan
} from "./membershipPlan.repository.js";

import { membershipPlanMapper } from "./membershipPlan.mapper.js";


// ======================================
// Create Membership Plan
// ======================================

export const createMembershipPlanService = async (data) => {

    const existingPlan = await findMembershipPlanByName(
        data.gymId,
        data.name
    );

    if (existingPlan && !existingPlan.deletedAt) {
        throw new Error("Membership plan already exists.");
    }

    const membershipPlan = await createMembershipPlan(data);

    return membershipPlanMapper(membershipPlan);

};


// ======================================
// Get Membership Plan by ID
// ======================================

export const getMembershipPlanByIdService = async (id) => {

    const membershipPlan = await findMembershipPlanById(id);

    if (!membershipPlan || membershipPlan.deletedAt) {
        throw new Error("Membership plan not found.");
    }

    return membershipPlanMapper(membershipPlan);

};


// ======================================
// Get All Membership Plans
// ======================================

export const getMembershipPlansService = async ({
    gymId,
    page = 1,
    limit = 10,
    includeInactive = false
}) => {

    page = Number(page);
    limit = Number(limit);

    const skip = (page - 1) * limit;

    const plans = await findMembershipPlans({
        gymId,
        skip,
        take: limit,
        includeInactive
    });

    const total = await countMembershipPlans({
        gymId,
        includeInactive
    });

    return {

        membershipPlans: plans.map(membershipPlanMapper),

        pagination: {

            page,

            limit,

            total,

            totalPages: Math.ceil(total / limit)

        }

    };

};


// ======================================
// Update Membership Plan
// ======================================

export const updateMembershipPlanService = async (
    id,
    data
) => {

    const membershipPlan = await findMembershipPlanById(id);

    if (!membershipPlan || membershipPlan.deletedAt) {
        throw new Error("Membership plan not found.");
    }

    if (
        data.name &&
        data.name !== membershipPlan.name
    ) {

        const duplicate = await findMembershipPlanByName(
            membershipPlan.gymId,
            data.name
        );

        if (
            duplicate &&
            duplicate.id !== id &&
            !duplicate.deletedAt
        ) {

            throw new Error(
                "Membership plan name already exists."
            );

        }

    }

    const updatedMembershipPlan =
        await updateMembershipPlan(id, data);

    return membershipPlanMapper(updatedMembershipPlan);

};


// ======================================
// Change Plan Status
// ======================================

export const changeMembershipPlanStatusService = async (
    id,
    isActive
) => {

    const membershipPlan = await findMembershipPlanById(id);

    if (!membershipPlan || membershipPlan.deletedAt) {
        throw new Error("Membership plan not found.");
    }

    const updatedMembershipPlan =
        await updateMembershipPlanStatus(
            id,
            isActive
        );

    return membershipPlanMapper(updatedMembershipPlan);

};


// ======================================
// Soft Delete
// ======================================

export const deleteMembershipPlanService = async (
    id
) => {

    const membershipPlan = await findMembershipPlanById(id);

    if (!membershipPlan || membershipPlan.deletedAt) {
        throw new Error("Membership plan not found.");
    }

    await softDeleteMembershipPlan(id);

};