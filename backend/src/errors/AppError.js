class AppError extends Error {
  constructor(message, statusCode = 500) {
    super(message);

    this.name = "AppError";
    this.statusCode = statusCode;
    this.success = false;

    // Used to identify expected errors
    this.isOperational = true;

    Error.captureStackTrace(this, this.constructor);
  }
}

export default AppError;