# ScaleLab Architecture

## High-Level

```text
[Operator]
   |
   v
[Scenario Config / CLI]
   |
   v
[k6 Runner]
   |
   v
[EKS Service -> Target API Pods]
   |
   +--> [HPA Controller adjusts replicas]
   |
   +--> [Prometheus collects metrics]
             |
             v
          [Grafana Dashboard]
```

## Components

### 1) Target Service

- FastAPI 기반 실험 대상 API
- workload 성격이 다른 endpoint 제공

### 2) Load Generator

- k6 스크립트 기반 트래픽 생성
- steady/ramp-up/burst/spike-drop 시나리오 제공

### 3) Autoscaling Layer

- Kubernetes HPA (CPU 기준)
- min/max replica 및 target utilization 비교 실험

### 4) Observability Layer

- Prometheus: 메트릭 수집
- Grafana: latency, error rate, replica, CPU 시각화

## Deployment View (MVP)

```text
Namespace: scalelab
├─ Deployment: target-service
├─ Service: target-service
├─ HPA: target-service-hpa
└─ (External) k6 runner from local or Job
```

## Experiment Data Flow

1. 운영자가 시나리오 선택
2. k6가 요청 전송
3. 서비스 부하 증가
4. Metrics Server/Prometheus가 변화 수집
5. HPA가 replica 조정
6. Grafana에서 latency/p95/p99와 scale timing 비교
