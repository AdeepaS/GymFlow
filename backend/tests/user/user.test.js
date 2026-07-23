import request from "supertest";
import app from "../src/app.js";
import prisma from "../src/prisma/client.js";

describe("User Management API", () => {

    let adminToken;
    let memberToken;

    let adminId;
    let memberId;

    beforeAll(async () => {

        // Clean database
        await prisma.user.deleteMany();

        // -------------------------
        // Register Admin
        // -------------------------

        await request(app)
            .post("/api/auth/register")
            .send({
                firstName: "Admin",
                lastName: "User",
                email: "admin@gmail.com",
                password: "Password@123",
                role: "SUPER_ADMIN"
            });

        // Login Admin

        const adminLogin = await request(app)
            .post("/api/auth/login")
            .send({
                email: "admin@gmail.com",
                password: "Password@123"
            });

        adminToken = adminLogin.body.data.accessToken;
        adminId = adminLogin.body.data.user.id;

        // -------------------------
        // Register Member
        // -------------------------

        await request(app)
            .post("/api/auth/register")
            .send({
                firstName: "Normal",
                lastName: "Member",
                email: "member@gmail.com",
                password: "Password@123",
                role: "MEMBER"
            });

        const memberLogin = await request(app)
            .post("/api/auth/login")
            .send({
                email: "member@gmail.com",
                password: "Password@123"
            });

        memberToken = memberLogin.body.data.accessToken;
        memberId = memberLogin.body.data.user.id;

    });

    afterAll(async () => {
        await prisma.user.deleteMany();
        await prisma.$disconnect();
    });

    // =====================================================
    // GET /users/me
    // =====================================================

    describe("GET /api/users/me", () => {

        it("should return logged user profile", async () => {

            const res = await request(app)
                .get("/api/users/me")
                .set("Authorization", `Bearer ${memberToken}`);

            expect(res.statusCode).toBe(200);
            expect(res.body.success).toBe(true);
            expect(res.body.data.email).toBe("member@gmail.com");

        });

    });

    // =====================================================
    // GET /users
    // =====================================================

    describe("GET /api/users", () => {

        it("Admin should get all users", async () => {

            const res = await request(app)
                .get("/api/users")
                .set("Authorization", `Bearer ${adminToken}`);

            expect(res.statusCode).toBe(200);
            expect(res.body.success).toBe(true);

        });

        it("Member should not get all users", async () => {

            const res = await request(app)
                .get("/api/users")
                .set("Authorization", `Bearer ${memberToken}`);

            expect(res.statusCode).toBe(403);

        });

    });

    // =====================================================
    // GET USER BY ID
    // =====================================================

    describe("GET /api/users/:id", () => {

        it("Admin should get user by id", async () => {

            const res = await request(app)
                .get(`/api/users/${memberId}`)
                .set("Authorization", `Bearer ${adminToken}`);

            expect(res.statusCode).toBe(200);
            expect(res.body.success).toBe(true);

        });

    });

    // =====================================================
    // UPDATE PROFILE
    // =====================================================

    describe("PATCH /api/users/:id", () => {

        it("Should update member profile", async () => {

            const res = await request(app)
                .patch(`/api/users/${memberId}`)
                .set("Authorization", `Bearer ${memberToken}`)
                .send({
                    firstName: "Updated"
                });

            expect(res.statusCode).toBe(200);
            expect(res.body.data.firstName).toBe("Updated");

        });

    });

    // =====================================================
    // CHANGE ROLE
    // =====================================================

    describe("PATCH /api/users/:id/role", () => {

        it("Admin should change role", async () => {

            const res = await request(app)
                .patch(`/api/users/${memberId}/role`)
                .set("Authorization", `Bearer ${adminToken}`)
                .send({
                    role: "TRAINER"
                });

            expect(res.statusCode).toBe(200);
            expect(res.body.data.role).toBe("TRAINER");

        });

    });

    // =====================================================
    // CHANGE STATUS
    // =====================================================

    describe("PATCH /api/users/:id/status", () => {

        it("Admin should change account status", async () => {

            const res = await request(app)
                .patch(`/api/users/${memberId}/status`)
                .set("Authorization", `Bearer ${adminToken}`)
                .send({
                    accountStatus: "INACTIVE"
                });

            expect(res.statusCode).toBe(200);
            expect(res.body.data.accountStatus).toBe("INACTIVE");

        });

    });

    // =====================================================
    // DELETE USER
    // =====================================================

    describe("DELETE /api/users/:id", () => {

        it("Super admin should delete user", async () => {

            const res = await request(app)
                .delete(`/api/users/${memberId}`)
                .set("Authorization", `Bearer ${adminToken}`);

            expect(res.statusCode).toBe(200);
            expect(res.body.success).toBe(true);

        });

    });

});