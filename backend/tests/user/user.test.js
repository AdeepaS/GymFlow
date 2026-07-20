import request from "supertest";

import app from "../../src/app.js";

describe("User Management API", () => {

    const testUser = {
        firstName: "Profile",
        lastName: "Test",
        email: "profiletest@gmail.com",
        password: "Password@123",
        role: "MEMBER"
    };

    let accessToken;

    beforeAll(async () => {

        // Register user
        await request(app)
            .post("/api/auth/register")
            .send(testUser);

        // Login
        const loginResponse = await request(app)
            .post("/api/auth/login")
            .send({
                email: testUser.email,
                password: testUser.password,
            });

        accessToken = loginResponse.body.data.accessToken;
    });

    test("Should get logged in user's profile", async () => {

        const response = await request(app)
            .get("/api/users/me")
            .set("Authorization", `Bearer ${accessToken}`);

        expect(response.statusCode)
            .toBe(200);

        expect(response.body.success)
            .toBe(true);

        expect(response.body.data.email)
            .toBe(testUser.email);

        expect(response.body.data)
            .not.toHaveProperty("passwordHash");

        expect(response.body.data)
            .not.toHaveProperty("refreshToken");
    });

    test("Should return 401 when token is missing", async () => {

        const response = await request(app)
            .get("/api/users/me");

        expect(response.statusCode)
            .toBe(401);

        expect(response.body.success)
            .toBe(false);
    });

    test("Should return 401 for invalid token", async () => {

        const response = await request(app)
            .get("/api/users/me")
            .set("Authorization", "Bearer invalid-token");

        expect(response.statusCode)
            .toBe(401);

        expect(response.body.success)
            .toBe(false);
    });

});