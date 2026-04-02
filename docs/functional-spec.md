# ScaleLab Functional Specification (MVP)

## 1. Product Definition

ScaleLab은 실험 대상 API에 대해 부하를 생성하고, 오토스케일링 정책별 시스템 반응을 비교하기 위한 실험 플랫폼입니다.

## 2. In Scope (MVP)

- 단일 테스트 서비스 배포
- 4개 엔드포인트 제공: `/light`, `/cpu-heavy`, `/io-heavy`, `/mixed`
- k6 시나리오 실행: steady, ramp-up, burst, spike/drop
- HPA 정책 적용 및 replica 증감 확인
- 실험 중 핵심 지표 관찰

## 3. Out of Scope (MVP)

- 멀티 클러스터 운영
- 사용자 인증/권한
- 정식 웹 대시보드
- 자동 리포트 PDF 생성

## 4. Functional Requirements

### FR-01. Target Endpoint Selection

- 실험 실행 시 대상 URL 지정 가능해야 한다.
- 기본 대상은 `TARGET_BASE_URL` 환경변수로 지정한다.

### FR-02. Load Scenario Execution

- 운영자는 predefined 시나리오를 실행할 수 있어야 한다.
- 시나리오는 k6 스크립트 파일 단위로 관리한다.

### FR-03. API Behavior by Workload Type

- `/light`: 즉시 JSON 반환
- `/cpu-heavy`: 반복 계산으로 CPU 부하 발생
- `/io-heavy`: 의도된 I/O 대기(지연) 발생
- `/mixed`: CPU + I/O 혼합 부하

### FR-04. Autoscaling Validation

- HPA가 CPU 기준으로 pod replica를 자동 조정해야 한다.
- 실험자는 min/max replica, target utilization을 조정할 수 있어야 한다.

### FR-05. Observability

아래 지표를 수집/확인할 수 있어야 한다.

- CPU usage
- Memory usage
- Pod replica count
- Request rate
- Average latency
- p95 latency
- p99 latency
- Error rate
- Scale up/down 시점

## 5. Non-Functional Requirements

- 재현 가능성: 동일 시나리오 반복 시 유사 경향 관측 가능
- 단순성: 문서 기반으로 단일 개발자가 1일 내 초기 실행 가능
- 확장성: KEDA, queue 기반 scaling 실험으로 확장 가능한 구조

## 6. Acceptance Criteria (MVP)

아래 조건이 충족되면 MVP 완료로 판단한다.

1. EKS 상에서 target-service와 HPA가 정상 동작한다.
2. k6 시나리오 4종이 실행된다.
3. 부하 증가 시 replica 증가가 확인된다.
4. 최소 1개 실험에서 fixed replica 대비 HPA의 latency 개선이 관찰된다.
