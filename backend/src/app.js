import express from "express";
import cors from "cors";
import routes from "./routes/index.js";
import errorHandler from "./middleware/errorHandler.js";

const app = express();


app.use(cors());

app.use(express.json());

app.use( "/api",routes);

app.use(errorHandler);

app.get("/", (req,res)=>{

    res.json({
        message:"GymFlow API running"
    });

});


export default app;