# 자동 실행 설정 기록

## 개요

쭌(OpenClaw)이 앨런 지시에 따라 자동 실행 허용 목록을 관리합니다.
설정 파일: `.claude/settings.local.json`

---

## 자동 실행 허용 항목

| 항목 | 패턴 | 추가일 | 사유 |
|---|---|---|---|
| TMUX 명령 전체 | `Bash(tmux*)` | 2026-03-08 | 앨런 지시 — TMUX 명령은 매번 확인 없이 자동 실행 |

---

## 설정 방법

`.claude/settings.local.json`의 `permissions.allow` 배열에 패턴 추가:

```json
{
  "permissions": {
    "allow": [
      "Bash(tmux*)"
    ]
  }
}
```

---

## 변경 이력

| 날짜 | 변경 내용 | 지시자 |
|---|---|---|
| 2026-03-08 | `Bash(tmux*)` 자동 실행 허용 추가 | 앨런 |
| 2026-03-08 | RTK (Rust Token Killer) 설치 및 Claude Code 훅 연동 | 앨런 |
