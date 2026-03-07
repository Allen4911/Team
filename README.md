# Claude Multi-Agent Team Setup

> 언제든지 이 문서를 따라 동일한 TMUX + Claude 팀 환경을 재현할 수 있습니다.

---

## 지시 흐름

```
앨런 (실제 사용자)
  → OpenClaw / 쭌 (전달 채널)
    → 다은 (팀장, Claude — Pane 0)
      → 팀원들 (Pane 1~5)
```

---

## 팀 구성

| 파인 | 이름 | 역할 | 설명 |
|---|---|---|---|
| — | **앨런** | 실제 사용자 | 최종 지시자, OpenClaw로 전달 |
| — | **쭌 / OpenClaw** | 전달 채널 | 앨런 → 다은 사이 메시지 전달 도구 |
| Pane 0 | **다은** | **팀장 (Claude)** | 팀 총괄, 팀원 지시 및 조율 |
| Pane 1 | 민준 | PM · 아키텍트 | 프로젝트 관리, 시스템 설계 |
| Pane 2 | 지훈 | 리서쳐 | 정보 수집, 기술 조사 |
| Pane 3 | 수아 | 디자이너 | UI/UX, 사용자 경험 설계 |
| Pane 4 | 서연 | 개발자 | 코드 구현, 기능 개발 |
| Pane 5 | 태양 | 리뷰어 | 코드 리뷰, 품질 검토 |

---

## 환경 정보

- **OS**: Ubuntu 24.04 (WSL2)
- **TMUX**: 3.4
- **Claude Code**: 2.1.71
- **Model**: Claude Sonnet 4.6
- **OpenClaw**: 2026.3.2

---

## 빠른 시작 (원클릭 셋업)

```bash
bash /mnt/c/Dev/Team/setup-team.sh
```

---

## 수동 설정 방법

### 1. 사전 요구사항 확인

```bash
tmux -V
claude --version
```

### 2. TMUX 세션 생성

```bash
tmux new-session -d -s team -x 317 -y 85
```

### 3. 레이아웃 구성

```bash
# 우측 파인 5개 분할
tmux split-window -t team:0.0 -h
tmux split-window -t team:0.1 -v
tmux split-window -t team:0.2 -v
tmux split-window -t team:0.3 -v
tmux split-window -t team:0.4 -v

# 메인 파인 너비 50%
tmux resize-pane -t team:0.0 -x 158

# 파인 제목 표시
tmux set-option -t team pane-border-status top
tmux set-option -t team pane-border-format " #{pane_title} "
tmux set-option -t team allow-rename off
```

### 4. 파인 이름 설정

```bash
tmux select-pane -t team:0.0 -T "다은 (팀장)"
tmux select-pane -t team:0.1 -T "민준 PM·아키텍트"
tmux select-pane -t team:0.2 -T "지훈 리서쳐"
tmux select-pane -t team:0.3 -T "수아 디자이너"
tmux select-pane -t team:0.4 -T "서연 개발자"
tmux select-pane -t team:0.5 -T "태양 리뷰어"
```

### 5. 각 파인에서 Claude 실행

```bash
for pane in 0 1 2 3 4 5; do
  tmux send-keys -t "team:0.$pane" 'claude' Enter
  sleep 2
  tmux send-keys -t "team:0.$pane" '' Enter
  sleep 3
done
```

### 6. 세션 attach

```bash
tmux attach -t team
```

---

## 레이아웃 구성도

```
┌─────────────────────────┬─────────────────────────┐
│                         │   민준 PM·아키텍트       │
│                         ├─────────────────────────┤
│     다은 (팀장)          │   지훈 리서쳐            │
│     Claude — Pane 0     ├─────────────────────────┤
│       158 x 84          │   수아 디자이너           │
│                         ├─────────────────────────┤
│                         │   서연 개발자             │
│                         ├─────────────────────────┤
│                         │   태양 리뷰어             │
└─────────────────────────┴─────────────────────────┘
        ↑
앨런 → OpenClaw/쭌 → 다은
```

---

## 팀 운영 방법

### 개별 파인에 지시 보내기
```bash
tmux send-keys -t team:0.2 '지훈, ○○에 대해 조사해주세요' Enter
tmux send-keys -t team:0.4 '서연, ○○ 기능을 구현해주세요' Enter
```

### 모든 팀원에게 동시 전달
```bash
for pane in 1 2 3 4 5; do
  tmux send-keys -t "team:0.$pane" '전달할 메시지' Enter
done
```

---

## 파일 구조

```
C:\Dev\Team\
├── README.md       ← 팀 구성 & TMUX 설정 가이드 (이 파일)
├── access.md       ← 접근 권한 & SSH 설정
└── setup-team.sh   ← 원클릭 자동 설정 스크립트
```
