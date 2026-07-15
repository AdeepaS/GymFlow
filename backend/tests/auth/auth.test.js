import request from "supertest";

import app from "../../src/app.js";



describe("Authentication API", () => {



    const testUser = {

        firstName: "Test",

        lastName: "User",

        email: "testuser@gmail.com",

        password: "Password@123",

        role: "MEMBER"

    };



    test("Should register a new user", async () => {


        const response =
            await request(app)
                .post("/api/auth/register")
                .send(testUser);



        expect(response.statusCode)
            .toBe(201);



        expect(response.body.success)
            .toBe(true);



        expect(response.body.data)
            .toHaveProperty("email");

    });





    test("Should login existing user", async () => {



        const response =
            await request(app)
                .post("/api/auth/login")
                .send({

                    email:testUser.email,

                    password:testUser.password

                });



        expect(response.statusCode)
            .toBe(200);



        expect(response.body.success)
            .toBe(true);



        expect(response.body.data)
            .toHaveProperty(
                "accessToken"
            );



        expect(response.body.data)
            .toHaveProperty(
                "refreshToken"
            );


    });




});
