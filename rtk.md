# RTK — Rust Token Killer 설정 가이드

## 개요

RTK는 Claude Code의 Bash 명령어 출력을 LLM에 전달하기 전에 필터링·압축·중복제거하여
**60~90% 토큰 절감**을 달성하는 Rust 기반 CLI 프록시입니다.

- GitHub: https://github.com/rtk-ai/rtk
- 버전: v0.27.2
- 설치 위치: `~/.local/bin/rtk`

---

## 설치 상태

| 항목 | 내용 |
|---|---|
| 바이너리 | `~/.local/bin/rtk` |
| PATH | `~/.bashrc`에 `$HOME/.local/bin` 추가됨 |
| Claude Code 훅 | `~/.claude/hooks/rtk-wrapper.sh` → `rtk-rewrite.sh` |
| 훅 설정 | `~/.claude/settings.json` `PreToolUse` 에 등록 |
| RTK 문서 | `~/.claude/RTK.md` (자동 생성) |

---

## 작동 방식

Claude Code가 Bash 도구를 실행하기 전에 `PreToolUse` 훅이 발동합니다.

```
Claude Code → Bash("git status")
  → PreToolUse 훅 (rtk-wrapper.sh)
    → rtk rewrite "git status" → "rtk git status"
      → 실제 실행: rtk git status (토큰 최적화된 출력)
```

명령어를 직접 수정할 필요 없이 자동으로 변환됩니다.

---

## 설치 방법 (재설치 시)

```bash
# 셸 스크립트로 설치
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh

# PATH 추가 (미설정 시)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Claude Code 훅 등록
rtk init --global --auto-patch
```

---

## settings.json 훅 설정

`~/.claude/settings.json`에 추가된 내용:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{ "type": "command",
        "command": "/home/user/.claude/hooks/rtk-wrapper.sh"
      }]
    }]
  }
}
```

> **참고:** `rtk-rewrite.sh`는 RTK가 무결성 검사로 보호합니다.
> PATH 문제를 해결하기 위해 `rtk-wrapper.sh`로 래핑하여 사용합니다.

### rtk-wrapper.sh 내용

```bash
#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec "$HOME/.claude/hooks/rtk-rewrite.sh"
```

---

## 유용한 명령어

```bash
rtk --version         # 버전 확인
rtk gain              # 누적 토큰 절감 통계
rtk gain --graph      # 최근 30일 ASCII 그래프
rtk gain --history    # 명령어별 절감 내역
rtk discover          # 더 절감 가능한 명령어 분석
rtk verify            # 훅 무결성 검증
```

---

## 훅 무결성 주의사항

`rtk-rewrite.sh`는 RTK가 SHA256으로 무결성을 보호합니다.
직접 수정하면 `hook integrity check FAILED` 오류 발생.

복구 방법:
```bash
rtk init --global --auto-patch
rtk verify
```

---

## 변경 이력

| 날짜 | 내용 |
|---|---|
| 2026-03-08 | RTK v0.27.2 설치, Claude Code PreToolUse 훅 연동 완료 |
