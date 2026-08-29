from fastapi import FastAPI
app = FastAPI()

@app.get("/")
def read_root(user_id: Optional[str] = None):
    return {"Hello": "World"}
