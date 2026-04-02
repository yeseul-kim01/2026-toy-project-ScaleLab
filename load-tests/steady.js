import http from "k6/http";
import { check, sleep } from "k6";

const BASE_URL = __ENV.TARGET_BASE_URL || "http://localhost:8080";

export const options = {
  scenarios: {
    steady_load: {
      executor: "constant-arrival-rate",
      rate: 50,
      timeUnit: "1s",
      duration: "5m",
      preAllocatedVUs: 30,
      maxVUs: 100,
    },
  },
  thresholds: {
    http_req_failed: ["rate<0.01"],
    http_req_duration: ["p(95)<500", "p(99)<1000"],
  },
};

export default function () {
  const res = http.get(`${BASE_URL}/light`);
  check(res, { "status is 200": (r) => r.status === 200 });
  sleep(0.1);
}
