from fastapi import FastAPI

app = FastAPI(title="Python Template App")


@app.get("/")
def root():
    return {
        "message": "Hello from Python Template Apps",
        "service": "python-template"
    }


@app.get("/health")
def health():
    return {"status": "ok"}