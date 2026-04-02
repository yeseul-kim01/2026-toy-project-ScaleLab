# Experiment Plan (Portfolio)

## EXP-01 Fixed Replica vs HPA

- 목적: autoscaling이 latency 및 error를 개선하는지 검증
- 조건 A: fixed replica = 1 (HPA 미적용)
- 조건 B: HPA min=1 max=5 targetCPU=70
- 시나리오: `load-tests/ramp-up.js`
- 수집 지표: avg/p95/p99, error rate, max replicas
- 기대 결과: HPA에서 p95/p99와 error율 감소

## EXP-02 HPA Target 50 vs 70

- 목적: HPA 민감도와 효율 비교
- 조건 A: targetCPU=50
- 조건 B: targetCPU=70
- 시나리오: `load-tests/steady.js`, `load-tests/burst.js`
- 수집 지표: scale-up 시작 시점, latency spike, CPU/replica

## EXP-03 Burst Handling

- 목적: 급격한 트래픽 변화 대응력 검증
- 조건: base=20RPS, burst=300RPS, recover
- 시나리오: `load-tests/burst.js`
- 수집 지표: p99, failed request ratio, scale-out 완료 시간

## Result Logging Template

각 실험 후 `docs/results/`에 아래 파일을 생성:

- `EXP-01.md`
- `EXP-02.md`
- `EXP-03.md`

각 파일에는 실행 날짜, 설정값, 핵심 수치, 캡처 링크를 기록합니다.
