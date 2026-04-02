import math
import os
import time

from fastapi import FastAPI

app = FastAPI(title="ScaleLab Target Service", version="0.1.0")

CPU_ITERATIONS = int(os.getenv("CPU_ITERATIONS", "120000"))
IO_DELAY_MS = int(os.getenv("IO_DELAY_MS", "120"))


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}


@app.get("/light")
def light() -> dict:
    return {"endpoint": "light", "message": "quick response"}


@app.get("/cpu-heavy")
def cpu_heavy() -> dict:
    acc = 0.0
    for i in range(1, CPU_ITERATIONS):
        acc += math.sqrt(i % 1000)
    return {"endpoint": "cpu-heavy", "result": round(acc, 2)}


@app.get("/io-heavy")
def io_heavy() -> dict:
    time.sleep(IO_DELAY_MS / 1000)
    return {"endpoint": "io-heavy", "delay_ms": IO_DELAY_MS}


@app.get("/mixed")
def mixed() -> dict:
    acc = 0.0
    for i in range(1, CPU_ITERATIONS // 2):
        acc += math.sqrt(i % 1000)
    time.sleep(IO_DELAY_MS / 1000)
    return {"endpoint": "mixed", "result": round(acc, 2), "delay_ms": IO_DELAY_MS}
