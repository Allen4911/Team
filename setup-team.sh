#!/bin/bash
# ============================================================
# Claude Multi-Agent Team Setup Script
# 실행: bash /mnt/c/Dev/Team/setup-team.sh
# ============================================================

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}"
echo "  ╔══════════════════════════════════════╗"
echo "  ║   Claude Multi-Agent Team Setup      ║"
echo "  ╚══════════════════════════════════════╝"
echo -e "${NC}"

# ── 사전 요구사항 확인 ──────────────────────────────────────
echo -e "${YELLOW}[1/5] 사전 요구사항 확인...${NC}"

if ! command -v tmux &> /dev/null; then
    echo "❌ tmux가 설치되어 있지 않습니다."
    echo "   설치: sudo apt-get install tmux"
    exit 1
fi

if ! command -v claude &> /dev/null; then
    echo "❌ Claude Code가 설치되어 있지 않습니다."
    echo "   설치: npm install -g @anthropic-ai/claude-code"
    exit 1
fi

echo "✅ tmux $(tmux -V | awk '{print $2}')"
echo "✅ claude $(claude --version 2>/dev/null | head -1)"

# ── 기존 세션 정리 ──────────────────────────────────────────
SESSION="team"
echo -e "\n${YELLOW}[2/5] 세션 초기화...${NC}"

if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux kill-session -t "$SESSION"
    echo "  기존 '$SESSION' 세션 종료"
fi

# ── 세션 & 레이아웃 생성 ────────────────────────────────────
echo -e "\n${YELLOW}[3/5] TMUX 세션 & 레이아웃 구성...${NC}"

# 세션 생성
tmux new-session -d -s "$SESSION" -x 317 -y 85

# 우측 파인 분할 (Pane 1~5)
tmux split-window -t "$SESSION:0.0" -h
tmux split-window -t "$SESSION:0.1" -v
tmux split-window -t "$SESSION:0.2" -v
tmux split-window -t "$SESSION:0.3" -v
tmux split-window -t "$SESSION:0.4" -v

# 메인 파인 너비 조정 (50%)
tmux resize-pane -t "$SESSION:0.0" -x 158

# 파인 경계선 제목 표시
tmux set-option -t "$SESSION" pane-border-status top
tmux set-option -t "$SESSION" pane-border-format " #{pane_title} "
tmux set-option -t "$SESSION" allow-rename off

echo "  ✅ 레이아웃 구성 완료 (6 panes)"

# ── 파인 이름 설정 ──────────────────────────────────────────
echo -e "\n${YELLOW}[4/5] 팀원 이름 설정...${NC}"

tmux select-pane -t "$SESSION:0.0" -T "쭌"
tmux select-pane -t "$SESSION:0.1" -T "민준 PM·아키텍트"
tmux select-pane -t "$SESSION:0.2" -T "지훈 리서쳐"
tmux select-pane -t "$SESSION:0.3" -T "디자이너 수아"
tmux select-pane -t "$SESSION:0.4" -T "서연 개발자"
tmux select-pane -t "$SESSION:0.5" -T "태양 리뷰어"

echo "  ✅ 쭌 (Pane 0) - 사용자/팀장"
echo "  ✅ 민준 (Pane 1) - PM·아키텍트"
echo "  ✅ 지훈 (Pane 2) - 리서쳐"
echo "  ✅ 수아 (Pane 3) - 디자이너"
echo "  ✅ 서연 (Pane 4) - 개발자"
echo "  ✅ 태양 (Pane 5) - 리뷰어"

# ── Claude 실행 & 인사 ──────────────────────────────────────
echo -e "\n${YELLOW}[5/5] Claude 실행 중...${NC}"

declare -A GREETINGS
GREETINGS[1]="안녕하세요 팀 여러분! 저는 민준입니다. PM이자 아키텍트 역할을 맡았습니다. 프로젝트 전체 구조와 일정을 책임지겠습니다. 잘 부탁드립니다!"
GREETINGS[2]="안녕하세요! 저는 지훈입니다. 리서쳐 역할을 맡았습니다. 필요한 정보와 기술 인사이트를 빠르게 제공하겠습니다. 잘 부탁드립니다!"
GREETINGS[3]="안녕하세요! 저는 수아입니다. 디자이너 역할을 맡았습니다. 사용자 경험을 최우선으로 생각하는 디자인을 만들겠습니다. 잘 부탁드립니다!"
GREETINGS[4]="안녕하세요! 저는 서연입니다. 개발자 역할을 맡았습니다. 탄탄한 코드로 프로젝트를 완성하겠습니다. 잘 부탁드립니다!"
GREETINGS[5]="안녕하세요 팀 여러분! 저는 태양입니다. 리뷰어 역할을 맡았습니다. 코드 품질과 완성도를 꼼꼼히 검토하겠습니다. 잘 부탁드립니다!"

for pane in 1 2 3 4 5; do
    tmux send-keys -t "$SESSION:0.$pane" 'claude' Enter
    sleep 2
    # 신뢰 확인 자동 승인
    tmux send-keys -t "$SESSION:0.$pane" '' Enter
    sleep 3
    # 인사
    tmux send-keys -t "$SESSION:0.$pane" "${GREETINGS[$pane]}" Enter
    echo "  ✅ Pane $pane: Claude 실행 & 인사 완료"
    sleep 2
done

# ── 완료 ────────────────────────────────────────────────────
echo -e "\n${GREEN}"
echo "  ╔══════════════════════════════════════╗"
echo "  ║   ✅ 팀 설정 완료!                   ║"
echo "  ║   tmux attach -t team               ║"
echo "  ╚══════════════════════════════════════╝"
echo -e "${NC}"

tmux attach -t "$SESSION"
