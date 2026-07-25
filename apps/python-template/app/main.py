import os

from fastapi import FastAPI


app = FastAPI(title="Python Template App")


@app.get("/")
def root() -> dict[str, str]:
    return {
        "message": os.getenv(
            "API_MESSAGE",
            "Hello from Python Template App",
        ),
        "service": "python-template",
        "environment": os.getenv("APP_ENV", "local"),
    }


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}