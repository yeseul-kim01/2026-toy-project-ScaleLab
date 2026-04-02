# ScaleLab

> EKS 기반 트래픽 시뮬레이션 및 오토스케일링 성능 분석 플랫폼

---

##  Overview

ScaleLab은 Kubernetes 환경에서 다양한 트래픽 패턴을 재현하고,
오토스케일링 전략(HPA)의 동작과 한계를 분석하기 위한 실험 플랫폼입니다.

특히 burst traffic 상황에서의 **scale-out 지연**, **tail latency(p95/p99)**,
그리고 **시스템 안정화 과정**을 시각적으로 확인하는 데 초점을 맞추고 있습니다.

---

##  Key Features

* k6 기반 트래픽 시뮬레이션

  * steady / ramp-up / burst / spike-drop
* Kubernetes HPA 기반 오토스케일링 실험
* Prometheus + Grafana 기반 관측 (Observability)
* latency (avg / p95 / p99) 분석
* pod scaling 타이밍 분석

---

##  What This Project Shows

이 프로젝트는 단순히 "오토스케일링을 적용했다"가 아니라,

 **오토스케일링의 한계와 동작 특성까지 분석**합니다.

### 핵심 인사이트

* HPA는 즉각적인 반응이 아니라 **지연된 반응**을 보인다
* burst traffic에서 **tail latency(p95/p99)가 급격히 증가**한다
* scale-out 이후 시스템은 점진적으로 안정화된다

---

##  Architecture

```text
User (k6)
   ↓
Service (ClusterIP)
   ↓
FastAPI (target-service)
   ↓
HPA (CPU 기반)
   ↓
Pods (scale-out)

+ Prometheus (metrics)
+ Grafana (visualization)
```

---

##  Repository Structure

```text
scalelab/
├─ docs/
├─ infra/
│  ├─ k8s/
│  ├─ ingress/
│  └─ monitoring/
├─ target-service/
├─ load-tests/
└─ scripts/
```

---

## ⚡ Quick Start

### 1. Service 실행 (Local)

```bash
./scripts/session-down.sh
```

---

### 2. k6 실행

```bash
TARGET_BASE_URL=http://localhost:8080 k6 run load-tests/steady.js
```

---

##  AWS (EKS) 실행

```bash
./scripts/session-up.sh <ECR_IMAGE_URI:TAG>
```

---

### Grafana 접속

```bash
kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80
```

→ [http://localhost:3000](http://localhost:3000)

---

### 서비스 접속

```bash
kubectl -n scalelab port-forward svc/target-service 8080:80
```

→ [http://localhost:8080](http://localhost:8080)

---

##  Load Test 실행

```bash
./scripts/run-test.sh burst http://localhost:8080
```

---

##  Metrics (관찰 포인트)

### Grafana

* CPU usage
* Pod count
* HPA replicas

### k6

* avg latency
* p95 / p99 latency
* error rate
* dropped iterations

---

##  Experiment Example (EXP-01)

### 결과 요약

* Avg latency: 1.52s
* p95 latency: 4.07s
* Max replicas: 5
* Scale delay: ~20~30s

### 핵심 결론

> burst traffic 상황에서 HPA 기반 autoscaling은 즉각적인 대응이 아니라 지연된 반응을 보이며,
> 그 사이 구간에서 tail latency(p95/p99)가 크게 증가한다.


---

##  Cost Optimization

실험 종료 후 반드시 실행:

```bash
./scripts/session-down.sh
```

클러스터까지 삭제:

```bash
eksctl delete cluster --name scalelab-eks --region ap-northeast-2
```

---

##  Future Work

* KEDA 기반 event-driven autoscaling
* SQS 기반 queue scaling
* AI API 플랫폼 (API key + usage tracking)
* Snowflake 기반 로그 분석

---

##  Conclusion



---

## Author

김예슬
