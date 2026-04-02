# Portfolio Recording Runbook (Low Cost)

목표: 실험 결과 영상/스크린샷만 확보하고, 리소스를 즉시 내린다.

## Strategy

- 클러스터는 촬영/실험 시간에만 사용
- Grafana는 기본적으로 `port-forward`로 접속 (ALB 비용 회피)
- 실험 완료 즉시 namespace/monitoring/클러스터 정리

## 0) Session Checklist

- [ ] ECR 이미지 푸시 완료
- [ ] EKS 컨텍스트 연결 완료
- [ ] 화면 녹화 도구 준비 (OBS/QuickTime)
- [ ] 실험 시나리오 선택 (`steady`, `ramp-up`, `burst`)
- [ ] 결과 기록 파일 준비 (`docs/results/*.md`)

## 1) Bring Up (필요할 때만)

```bash
./scripts/session-up.sh <ECR_IMAGE_URI:TAG>
```

이 스크립트는 다음을 실행한다.

1. Metrics Server 설치
2. 앱/HPA 배포
3. Prometheus/Grafana 설치
4. Grafana `port-forward` 명령 안내

## 2) Recording

터미널 A (Grafana):

```bash
kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80
```

브라우저에서 `http://localhost:3000` 접속 후 대시보드 표시.

터미널 B (부하 실행):

```bash
./scripts/run-test.sh ramp-up http://<target-service-url>
./scripts/run-test.sh burst http://<target-service-url>
```

> EKS 내부 서비스 접근이 필요하면 `kubectl port-forward svc/target-service`를 이용.

## 3) Capture Targets (영상에서 꼭 보여주기)

- latency avg/p95/p99
- error rate
- replica 수 변화 (scale up/down)
- CPU usage
- burst 시작/종료 구간의 지표 변화

## 4) Save Evidence

- `docs/results/EXP-01.md` 형태로 수치 기록
- Grafana 화면 캡처 파일명 규칙:
  - `exp01_fixed_vs_hpa_YYYYMMDD.png`
  - `exp03_burst_YYYYMMDD.png`

## 5) Bring Down (즉시 비용 차단)

```bash
./scripts/session-down.sh
```

클러스터까지 삭제 운영이면 아래도 수행:

```bash
eksctl delete cluster --name <cluster-name> --region <region>
```

## Notes

- 도메인/ALB는 최종 데모가 꼭 필요할 때만 잠깐 사용
- 평소 실험/촬영은 로컬 포트포워딩이 가장 저렴
