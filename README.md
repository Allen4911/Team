# Claude Multi-Agent Team Setup

> 언제든지 이 문서를 따라 동일한 TMUX + Claude 팀 환경을 재현할 수 있습니다.

---

## 지시 흐름

```
앨런 (실제 사용자)
  → 텔레그램 (@cc @멤버 메시지)
    → OpenClaw 플러그인 (claude-bridge)
      → TMUX team 세션 (해당 pane)
        → Claude CLI 처리
          → 응답 → 텔레그램 🔗
```

---

## 팀 구성

| Pane | 이름 | 역할 | 설명 |
|------|------|------|------|
| — | **앨런** | 실제 사용자 | 텔레그램으로 지시 |
| Pane 0 | **쭌** | 사용자/팀장 | Claude — 팀 총괄 (기본 라우팅 대상) |
| Pane 1 | 민준 | PM · 아키텍트 | 프로젝트 관리, 시스템 설계 |
| Pane 2 | 지훈 | 리서쳐 | 정보 수집, 기술 조사 |
| Pane 3 | 수아 | 디자이너 | UI/UX, 사용자 경험 설계 |
| Pane 4 | 서연 | 개발자 | 코드 구현, 기능 개발 |
| Pane 5 | 태양 | 리뷰어 | 코드 리뷰, 품질 검토 |

---

## 환경 정보

| 항목 | 값 |
|------|-----|
| OS | Ubuntu 24.04 (WSL2) |
| TMUX | 3.4 |
| Claude Code | 2.1.71 |
| OpenClaw | 2026.3.2 |
| RTK | 0.27.2 (`~/.local/bin/rtk`) |
| 텔레그램 chat ID | 56518471 |
| 브릿지 스크립트 | `~/.openclaw/bridge-scripts/` |
| 브릿지 플러그인 | `~/.openclaw/plugins/claude-bridge/` |

---

## 빠른 시작 (원클릭 셋업)

```bash
bash /mnt/c/Dev/Team/setup-team.sh
```

TMUX 세션 + Claude CLI(Pane 1~5) + Telegram 브릿지를 한 번에 설정합니다.

---

## 텔레그램 명령어

| 명령어 | 대상 |
|--------|------|
| `@cc 메시지` | Pane 0 쭌 (기본값) |
| `@cc @쭌 메시지` | Pane 0 쭌 |
| `@cc @민준 메시지` | Pane 1 민준 |
| `@cc @지훈 메시지` | Pane 2 지훈 |
| `@cc @수아 메시지` | Pane 3 수아 |
| `@cc @서연 메시지` | Pane 4 서연 |
| `@cc @태양 메시지` | Pane 5 태양 |
| `@cc @all 메시지` | 전체 브로드캐스트 (모든 pane) |
| `@ccn @멤버 메시지` | 해당 pane 컨텍스트 초기화 후 전달 |
| `@ccu` | Claude 사용량 확인 |

> `/cc`도 `@cc`와 동일하게 동작합니다.

---

## 레이아웃 구성도

```
┌─────────────────────────┬─────────────────────────┐
│                         │   민준 PM·아키텍트  [1]  │
│                         ├─────────────────────────┤
│      쭌 (팀장) [0]      │   지훈 리서쳐       [2]  │
│      Claude CLI         ├─────────────────────────┤
│      158 x 84           │   수아 디자이너     [3]  │
│                         ├─────────────────────────┤
│                         │   서연 개발자       [4]  │
│                         ├─────────────────────────┤
│                         │   태양 리뷰어       [5]  │
└─────────────────────────┴─────────────────────────┘
```

---

## 수동 설정 방법

### 1. 사전 요구사항 확인

```bash
tmux -V
claude --version
openclaw --version
```

### 2. TMUX 세션 생성

```bash
tmux new-session -d -s team -x 317 -y 85
```

### 3. 레이아웃 구성

```bash
tmux split-window -t team:0.0 -h
tmux split-window -t team:0.1 -v
tmux split-window -t team:0.2 -v
tmux split-window -t team:0.3 -v
tmux split-window -t team:0.4 -v

tmux select-layout -t team:0 main-vertical
tmux set-option -t team main-pane-width 158
tmux set-option -t team pane-border-status top
tmux set-option -t team pane-border-format " #{pane_title} "
tmux set-option -t team allow-rename off
```

### 4. pane 이름 설정

```bash
tmux select-pane -t team:0.0 -T "쭌"
tmux select-pane -t team:0.1 -T "민준 PM·아키텍트"
tmux select-pane -t team:0.2 -T "지훈 리서쳐"
tmux select-pane -t team:0.3 -T "디자이너 수아"
tmux select-pane -t team:0.4 -T "서연 개발자"
tmux select-pane -t team:0.5 -T "태양 리뷰어"
```

### 5. Claude CLI 실행 (각 pane)

```bash
# 각 pane에서 실행 (pane 1~5)
# 다이얼로그 1: Enter (Yes, I trust this folder)
# 다이얼로그 2: 아래 방향키 → Enter (Yes, I accept)
for pane in 1 2 3 4 5; do
    tmux send-keys -t "team:0.$pane" \
        "cd /home/user && unset CLAUDECODE && claude --dangerously-skip-permissions" Enter
done
```

### 6. Telegram 브릿지 설정

```bash
# 저장소가 없으면 클론
git clone https://github.com/bettep-dev/openclaw-claude-bridge.git ~/openclaw-claude-bridge

# 팀 브릿지 설치 (스크립트, 플러그인, CLAUDE.md, openclaw.json 자동 설정)
bash ~/openclaw-claude-bridge/setup-team.sh
```

### 7. 세션 접속

```bash
tmux attach -t team
```

---

## 팀 운영 — 터미널에서 직접 pane 제어

### 특정 pane에 메시지 보내기

```bash
tmux send-keys -t team:0.2 '지훈, ○○에 대해 조사해줘' Enter
tmux send-keys -t team:0.4 '서연, ○○ 기능 구현해줘' Enter
```

### 브릿지 스크립트 직접 실행

```bash
# pane N에 메시지 전송
bash ~/.openclaw/bridge-scripts/claude-send.sh 2 "지훈, 조사 부탁해"

# 전체 브로드캐스트
bash ~/.openclaw/bridge-scripts/claude-team-broadcast.sh "모두 현황 보고해줘"
```

---

## 파일 구조

```
C:\Dev\Team\
├── README.md            ← 팀 구성 & 설정 가이드 (이 파일)
├── access.md            ← 접근 권한 & SSH & Telegram 설정
├── setup-team.sh        ← 원클릭 자동 설정 (TMUX + Claude + Telegram)
├── auto-settings.md     ← 자동화 설정 참고
└── rtk.md               ← RTK (Rust Token Killer) 설정 가이드

~/.openclaw/
├── bridge-scripts/      ← pane 라우팅 쉘 스크립트
│   ├── claude-send.sh           (특정 pane에 전송)
│   ├── claude-new-session.sh    (컨텍스트 초기화 후 전송)
│   ├── claude-team-broadcast.sh (전체 브로드캐스트)
│   ├── claude-session.sh        (세션 keepalive)
│   └── claude-usage.sh          (사용량 확인)
└── plugins/claude-bridge/   ← OpenClaw 플러그인 (메시지 감지 & 라우팅)

~/openclaw-claude-bridge/   ← 브릿지 소스 (github.com/bettep-dev/openclaw-claude-bridge)
└── setup-team.sh            ← 브릿지 단독 재설치 스크립트
```
