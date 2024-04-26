from fastapi import Depends
from fastapi import FastAPI
from loguru import logger

from fastapi_kubernetes.authentication import authenticate_user

app = FastAPI()


@app.on_event("startup")
async def startup_event():
    logger.info("Starting up...")


@app.on_event("shutdown")
async def shutdown_event():
    logger.info("Shutting down...")


@app.get("/", dependencies=[Depends(authenticate_user)])
async def root():
    logger.info("Handling root path request...")
    return {"message": "Hello World"}
