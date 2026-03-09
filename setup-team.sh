#!/bin/bash
# ============================================================
# Claude Multi-Agent Team Setup Script
# 실행: bash /mnt/c/Dev/Team/setup-team.sh
# 업데이트: 2026-03-08
#   - Claude 다이얼로그 자동 처리 수정
#   - openclaw-claude-bridge (Telegram 연동) 통합
#   - 팀 pane별 메시지 라우팅 설정
# ============================================================

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}"
echo "  ╔══════════════════════════════════════╗"
echo "  ║   Claude Multi-Agent Team Setup      ║"
echo "  ╚══════════════════════════════════════╝"
echo -e "${NC}"

# ── 유틸리티 ────────────────────────────────────────────────
# 특정 문자열이 pane에 나타날 때까지 대기
wait_for_pane() {
    local pane="$1"
    local pattern="$2"
    local timeout="${3:-30}"
    local waited=0
    while [ $waited -lt $timeout ]; do
        if tmux capture-pane -t "$pane" -p 2>/dev/null | grep -q "$pattern"; then
            return 0
        fi
        sleep 1
        waited=$((waited + 1))
    done
    return 1
}

# Claude CLI 시작 + 두 단계 다이얼로그 자동 처리
start_claude_in_pane() {
    local pane="$1"
    local claude_bin
    claude_bin="$(command -v claude)"

    # 기존 입력 초기화
    tmux send-keys -t "$pane" C-c 2>/dev/null
    sleep 0.3
    tmux send-keys -t "$pane" C-u 2>/dev/null
    sleep 0.2

    # Claude 시작
    tmux send-keys -t "$pane" "cd /home/user && unset CLAUDECODE && $claude_bin --dangerously-skip-permissions" Enter

    # [다이얼로그 1] "Yes, I trust this folder" — 기본 선택(1번), Enter
    if wait_for_pane "$pane" "trust this folder" 20; then
        tmux send-keys -t "$pane" Enter
        sleep 1
    fi

    # [다이얼로그 2] "Yes, I accept" — 기본이 "No, exit"(1번)이므로 Down → Enter
    if wait_for_pane "$pane" "I accept" 20; then
        tmux send-keys -t "$pane" Down
        sleep 0.5
        tmux send-keys -t "$pane" Enter
        sleep 1
    fi

    # Claude 프롬프트(❯) 대기
    wait_for_pane "$pane" "❯" 30
}

SESSION="team"

# ── [1/6] 사전 요구사항 확인 ────────────────────────────────
echo -e "${YELLOW}[1/6] 사전 요구사항 확인...${NC}"

MISSING=()
command -v tmux   &>/dev/null || MISSING+=("tmux")
command -v claude &>/dev/null || MISSING+=("claude  →  npm install -g @anthropic-ai/claude-code")

if [ ${#MISSING[@]} -gt 0 ]; then
    echo -e "${RED}❌ 누락된 의존성:${NC}"
    for m in "${MISSING[@]}"; do echo "   - $m"; done
    exit 1
fi

echo "✅ tmux $(tmux -V | awk '{print $2}')"
echo "✅ claude $(claude --version 2>/dev/null | head -1)"
command -v openclaw &>/dev/null \
    && echo "✅ openclaw $(openclaw --version 2>/dev/null | head -1)" \
    || echo "⚠️  openclaw 미설치 (Telegram 브릿지 비활성)"

# ── [2/6] 기존 세션 정리 ────────────────────────────────────
echo -e "\n${YELLOW}[2/6] 세션 초기화...${NC}"

if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux kill-session -t "$SESSION"
    echo "  기존 '$SESSION' 세션 종료"
fi

# ── [3/6] 세션 & 레이아웃 생성 ──────────────────────────────
echo -e "\n${YELLOW}[3/6] TMUX 세션 & 레이아웃 구성...${NC}"

tmux new-session -d -s "$SESSION" -x 317 -y 85

# 우측 pane 5개 분할
tmux split-window -t "$SESSION:0.0" -h
tmux split-window -t "$SESSION:0.1" -v
tmux split-window -t "$SESSION:0.2" -v
tmux split-window -t "$SESSION:0.3" -v
tmux split-window -t "$SESSION:0.4" -v

# 레이아웃: 쭌(Pane 0) 왼쪽, 팀원(Pane 1~5) 오른쪽 균등 분할
tmux select-layout -t "$SESSION:0" main-vertical
tmux set-option -t "$SESSION" main-pane-width 158

# pane 제목 표시
tmux set-option -t "$SESSION" pane-border-status top
tmux set-option -t "$SESSION" pane-border-format " #{pane_title} "
tmux set-option -t "$SESSION" allow-rename off

echo "  ✅ 레이아웃 구성 완료 (6 panes)"

# ── [4/6] pane 이름 설정 ────────────────────────────────────
echo -e "\n${YELLOW}[4/6] 팀원 이름 설정...${NC}"

tmux select-pane -t "$SESSION:0.0" -T "쭌"
tmux select-pane -t "$SESSION:0.1" -T "민준 PM·아키텍트"
tmux select-pane -t "$SESSION:0.2" -T "지훈 리서쳐"
tmux select-pane -t "$SESSION:0.3" -T "디자이너 수아"
tmux select-pane -t "$SESSION:0.4" -T "서연 개발자"
tmux select-pane -t "$SESSION:0.5" -T "태양 리뷰어"

echo "  ✅ 쭌   (Pane 0) - 사용자/팀장"
echo "  ✅ 민준 (Pane 1) - PM·아키텍트"
echo "  ✅ 지훈 (Pane 2) - 리서쳐"
echo "  ✅ 수아 (Pane 3) - 디자이너"
echo "  ✅ 서연 (Pane 4) - 개발자"
echo "  ✅ 태양 (Pane 5) - 리뷰어"

# ── [5/6] Claude CLI 실행 ───────────────────────────────────
echo -e "\n${YELLOW}[5/6] Claude CLI 실행 중...${NC}"
echo "  (다이얼로그 자동 처리 — pane당 최대 1분 소요)"

MEMBER_NAMES=("쭌" "민준" "지훈" "수아" "서연" "태양")

for pane in 0 1 2 3 4 5; do
    echo -n "  Pane $pane (${MEMBER_NAMES[$pane]}): 시작 중..."
    start_claude_in_pane "$SESSION:0.$pane"

    if tmux capture-pane -t "$SESSION:0.$pane" -p 2>/dev/null | grep -q "❯"; then
        echo -e " ${GREEN}✅ 준비 완료${NC}"
    else
        echo -e " ${RED}⚠️  시간 초과 — tmux attach 후 수동 확인 필요${NC}"
    fi
done

# ── [6/6] Telegram 브릿지 설정 ──────────────────────────────
echo -e "\n${YELLOW}[6/6] Telegram 브릿지 설정...${NC}"

BRIDGE_DIR="$HOME/openclaw-claude-bridge"
BRIDGE_SCRIPT="$BRIDGE_DIR/setup-team.sh"

# 저장소가 없으면 클론
if [ ! -d "$BRIDGE_DIR" ]; then
    echo -n "  openclaw-claude-bridge 클론 중..."
    git clone https://github.com/bettep-dev/openclaw-claude-bridge.git "$BRIDGE_DIR" -q
    echo " ✅"
fi

if command -v openclaw &>/dev/null; then
    bash "$BRIDGE_SCRIPT" 2>/dev/null
    echo -e "\n  ${GREEN}✅ Telegram 브릿지 설정 완료${NC}"
    echo ""
    echo "  텔레그램 명령어:"
    echo "    @cc 메시지        → 쭌 (기본값, Pane 0)"
    echo "    @cc @민준 메시지  → 민준 (Pane 1)"
    echo "    @cc @지훈 메시지  → 지훈 (Pane 2)"
    echo "    @cc @수아 메시지  → 수아 (Pane 3)"
    echo "    @cc @서연 메시지  → 서연 (Pane 4)"
    echo "    @cc @태양 메시지  → 태양 (Pane 5)"
    echo "    @cc @all 메시지   → 전체 브로드캐스트"
    echo "    @ccn @멤버 메시지 → 컨텍스트 초기화 후 전달"
    echo "    @ccu              → 사용량 확인"
else
    echo -e "  ${RED}⚠️  openclaw 미설치 — Telegram 브릿지 건너뜀${NC}"
    echo "  openclaw 설치 후: bash ~/openclaw-claude-bridge/setup-team.sh"
fi

# ── 완료 ────────────────────────────────────────────────────
echo -e "\n${GREEN}${BOLD}"
echo "  ╔══════════════════════════════════════╗"
echo "  ║   ✅ 팀 설정 완료!                   ║"
echo "  ║   tmux attach -t team               ║"
echo "  ╚══════════════════════════════════════╝"
echo -e "${NC}"

# 터미널에서 직접 실행한 경우 자동 attach
if [ -t 1 ]; then
    tmux attach -t "$SESSION"
fi
