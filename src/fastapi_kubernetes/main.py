from fastapi import Depends
from fastapi import FastAPI
from loguru import logger

from fastapi_kubernetes.authentication import authenticate_user

app = FastAPI()

# todo: add error/exeption handling (Exception Handler and raising exceptions)
# todo: connect to a database


from pydantic import BaseModel, EmailStr, Field
from typing import Optional

class User(BaseModel):
    name: str = Field(title="The name of the user", description="The name of the user. This is a required field.")
    email: EmailStr = Field(title="The email of the user", description="The email of the user. This is a required field and must be a valid email address.")
    age: Optional[int] = Field(None, title="The age of the user", description="The age of the user. This is an optional field.")

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

@app.post("/user", response_model=User)
async def create_user(user: User):
    logger.info(f"Creating user {user.name}...")
    # Here you can use the user object, which is guaranteed to match the User model
    # You can access the fields with user.name, user.email, and user.age
    # todo: connect to a database and save the user
    return user
