from daves_utilities.david_secrets import get_credentials
from fastapi import Depends
from fastapi import FastAPI
from fastapi import HTTPException
from fastapi import status
from fastapi.security import HTTPBasic
from fastapi.security import HTTPBasicCredentials

app = FastAPI()
security = HTTPBasic()


def authenticate_user(credentials: HTTPBasicCredentials = Depends(security)):
    crd = get_credentials("fastapi")

    if credentials.username != crd["usr"] or credentials.password != crd["pwd"]:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Basic"},
        )
    return credentials.username


@app.get("/", dependencies=[Depends(authenticate_user)])
async def root():
    return {"message": "Hello World"}
