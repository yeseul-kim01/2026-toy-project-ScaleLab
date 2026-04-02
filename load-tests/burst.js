import http from "k6/http";
import { check, sleep } from "k6";

const BASE_URL = __ENV.TARGET_BASE_URL || "http://localhost:8080";

export const options = {
  scenarios: {
    baseline: {
      executor: "constant-arrival-rate",
      rate: 20,
      timeUnit: "1s",
      duration: "2m",
      preAllocatedVUs: 20,
      maxVUs: 80,
      exec: "lightPhase",
    },
    burst: {
      executor: "constant-arrival-rate",
      rate: 300,
      timeUnit: "1s",
      startTime: "2m",
      duration: "30s",
      preAllocatedVUs: 100,
      maxVUs: 400,
      exec: "burstPhase",
    },
    recover: {
      executor: "constant-arrival-rate",
      rate: 20,
      timeUnit: "1s",
      startTime: "2m30s",
      duration: "2m",
      preAllocatedVUs: 20,
      maxVUs: 80,
      exec: "lightPhase",
    },
  },
};

export function lightPhase() {
  const res = http.get(`${BASE_URL}/light`);
  check(res, { "status is 200": (r) => r.status === 200 });
  sleep(0.05);
}

export function burstPhase() {
  const res = http.get(`${BASE_URL}/mixed`);
  check(res, { "status is 200": (r) => r.status === 200 });
  sleep(0.02);
}
