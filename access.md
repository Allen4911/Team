# 접근 권한 및 인증 정보

## 시스템 계정

| 항목 | 값 |
|---|---|
| OS 사용자 | `user` |
| sudo 비밀번호 | `user` |
| SSH 포트 (WSL 내부) | `22` |
| SSH 포트 (외부 접속) | `2222` |
| WSL2 IP | `172.23.66.222` (재시작 시 변경될 수 있음) |
| Windows IP | `192.168.1.15` |

---

## Telegram 설정

| 항목 | 값 |
|---|---|
| Chat ID | `56518471` |
| Bot Token | `8702519581:AAG...Vvqo` (openclaw config에 저장) |
| OpenClaw 채널 | `telegram` |

### 텔레그램 명령어 요약

| 명령어 | 대상 |
|--------|------|
| `@cc 메시지` | Pane 0 쭌 (기본값) |
| `@cc @민준 메시지` | Pane 1 민준 |
| `@cc @지훈 메시지` | Pane 2 지훈 |
| `@cc @수아 메시지` | Pane 3 수아 |
| `@cc @서연 메시지` | Pane 4 서연 |
| `@cc @태양 메시지` | Pane 5 태양 |
| `@cc @all 메시지` | 전체 브로드캐스트 |
| `@ccn @멤버 메시지` | 컨텍스트 초기화 후 전달 |
| `@ccu` | 사용량 확인 |

### 브릿지 관련 경로

```
~/.openclaw/bridge-scripts/     ← pane 라우팅 스크립트
~/.openclaw/plugins/claude-bridge/  ← OpenClaw 플러그인
~/openclaw-claude-bridge/       ← 소스 저장소
```

### 브릿지 재설치

```bash
bash ~/openclaw-claude-bridge/setup-team.sh
```

---

## SSH 접속 정보

### 외부에서 접속

```bash
ssh user@192.168.1.15 -p 2222
# 비밀번호: user
```

### WSL 내부에서 접속

```bash
ssh user@172.23.66.222
# 비밀번호: user
```

### TMUX 팀 세션 복구

```bash
tmux attach -t team
# 또는 전체 재구성
bash /mnt/c/Dev/Team/setup-team.sh
```

---

## Windows 포트포워딩 설정 (관리자 PowerShell)

WSL2 재시작 후 IP가 바뀌면 아래 스크립트로 재설정:

```powershell
$wslIp = (wsl hostname -I).Trim().Split(" ")[0]

netsh interface portproxy delete v4tov4 listenport=2222 listenaddress=0.0.0.0
netsh interface portproxy add v4tov4 listenport=2222 listenaddress=0.0.0.0 connectport=22 connectaddress=$wslIp

netsh advfirewall firewall delete rule name="WSL2 SSH"
netsh advfirewall firewall add rule name="WSL2 SSH" dir=in action=allow protocol=TCP localport=2222

Write-Host "포트포워딩 완료: $wslIp -> 2222"
netsh interface portproxy show all
```

---

## sudo 자동 실행 권한

```bash
echo "user ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/user-nopasswd
sudo chmod 440 /etc/sudoers.d/user-nopasswd
```

---

## SSH 서비스 관리

```bash
sudo service ssh start    # 시작
sudo service ssh status   # 상태 확인
sudo service ssh restart  # 재시작
```

---

## WSL2 재시작 후 체크리스트

1. `sudo service ssh start` — SSH 서비스 시작
2. `hostname -I` — WSL2 IP 확인 (변경 시 Windows 포트포워딩 재설정)
3. `bash /mnt/c/Dev/Team/setup-team.sh` — 팀 환경 + Telegram 브릿지 재설정
