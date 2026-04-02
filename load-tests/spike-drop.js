import http from "k6/http";
import { check, sleep } from "k6";

const BASE_URL = __ENV.TARGET_BASE_URL || "http://localhost:8080";

export const options = {
  stages: [
    { duration: "90s", target: 20 },
    { duration: "15s", target: 300 },
    { duration: "45s", target: 20 },
    { duration: "30s", target: 0 },
  ],
};

export default function () {
  const res = http.get(`${BASE_URL}/io-heavy`);
  check(res, { "status is 200": (r) => r.status === 200 });
  sleep(0.1);
}
