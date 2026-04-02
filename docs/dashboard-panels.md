# Grafana Dashboard Panels (Portfolio Set)

포트폴리오용으로는 아래 8개 패널이 있으면 충분합니다.

## Dashboard Variables

- `namespace`: default `scalelab`
- `deployment`: default `target-service`
- `scenario`: steady / ramp-up / burst / spike-drop

## Panels

1. **Request Rate (RPS)**
   - 목적: 트래픽 강도 확인
   - 데이터 소스: Prometheus

2. **Latency - Avg / p95 / p99**
   - 목적: tail latency 비교 (핵심)
   - 데이터 소스: k6 metric or app histogram metric

3. **Error Rate**
   - 목적: 안정성 평가
   - 데이터 소스: `http_req_failed` 또는 `5xx rate`

4. **Replica Count**
   - 목적: HPA 스케일 동작 시점 확인
   - 데이터 소스: kube-state-metrics

5. **CPU Usage (pod/deployment)**
   - 목적: HPA 트리거와 상관성 확인

6. **Memory Usage**
   - 목적: 리소스 병목 확인

7. **HPA Current vs Target Utilization**
   - 목적: threshold 적절성 확인

8. **Scale Events Timeline**
   - 목적: scale-up/down 지연 시점 분석

## Portfolio Capture Checklist

- 동일 시나리오에 대해 `fixed` vs `HPA` 그래프 1장씩
- p95/p99가 가장 크게 갈리는 구간 캡처
- burst 시작/종료 시점 + replica 변화가 같이 보이는 캡처
- 결과 해석 3줄: 왜 좋아졌는지 / 한계가 뭔지 / 다음 개선점
