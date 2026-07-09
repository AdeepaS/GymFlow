const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");

const app = express();

const {
swaggerUi,
swaggerSpec
}=require("./config/swagger");


app.use(cors());
app.use(express.json());
app.use(helmet());
app.use(morgan("dev"));

app.use(
"/api-docs",
swaggerUi.serve,
swaggerUi.setup(swaggerSpec)
);

app.get("/", (req, res) => {
  res.json({
    message: "server is running"
  });
});

module.exports = app;