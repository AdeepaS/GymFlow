import AppError from "../errors/AppError.js";


const validate = (schema) => {

    return (req,res,next)=>{

        const result = schema.safeParse(req.body);


        if(!result.success){
            console.log(result.error.issues);

            throw new AppError(
                "Validation failed",
                400
            );

        }


        req.body=result.data;


        next();

    };

};


export default validate;