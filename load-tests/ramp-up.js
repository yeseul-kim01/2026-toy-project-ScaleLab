import http from "k6/http";
import { check, sleep } from "k6";

const BASE_URL = __ENV.TARGET_BASE_URL || "http://localhost:8080";

export const options = {
  stages: [
    { duration: "1m", target: 10 },
    { duration: "1m", target: 50 },
    { duration: "1m", target: 100 },
    { duration: "1m", target: 200 },
    { duration: "1m", target: 0 },
  ],
  thresholds: {
    http_req_failed: ["rate<0.02"],
    http_req_duration: ["p(95)<1000", "p(99)<2000"],
  },
};

export default function () {
  const res = http.get(`${BASE_URL}/cpu-heavy`);
  check(res, { "status is 200": (r) => r.status === 200 });
  sleep(0.2);
}
