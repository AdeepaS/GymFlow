require("dotenv").config();

const app = require("./app");
const redisClient = require("./config/redis");


const PORT = process.env.PORT || 5000;


redisClient.connect()
.then(()=>{

    console.log("Redis connected");

    app.listen(PORT,()=>{
        console.log(
            `Server running on ${PORT}`
        );
    });

});