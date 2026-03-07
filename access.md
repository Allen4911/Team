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
tmux attach -t 2
# 또는 전체 재구성
bash /mnt/c/Dev/Team/setup-team.sh
```

---

## Windows 포트포워딩 설정 (관리자 PowerShell)

WSL2 재시작 후 IP가 바뀌면 아래 스크립트로 재설정:

```powershell
# WSL2 현재 IP 자동 감지 후 포트포워딩 재설정
$wslIp = (wsl hostname -I).Trim().Split(" ")[0]

netsh interface portproxy delete v4tov4 listenport=2222 listenaddress=0.0.0.0
netsh interface portproxy add v4tov4 listenport=2222 listenaddress=0.0.0.0 connectport=22 connectaddress=$wslIp

netsh advfirewall firewall delete rule name="WSL2 SSH"
netsh advfirewall firewall add rule name="WSL2 SSH" dir=in action=allow protocol=TCP localport=2222

Write-Host "포트포워딩 완료: $wslIp -> 2222"
netsh interface portproxy show all
```

### 설정 확인
```powershell
netsh interface portproxy show all
netsh advfirewall firewall show rule name="WSL2 SSH"
```

---

## sudo 자동 실행 권한

아래 명령들은 비밀번호 없이 실행 가능하도록 설정 권장:

```bash
# /etc/sudoers.d/user-nopasswd 파일 생성 (WSL에서 실행)
echo "user ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/user-nopasswd
sudo chmod 440 /etc/sudoers.d/user-nopasswd
```

---

## SSH 서비스 관리

```bash
# 시작
sudo service ssh start

# 상태 확인
sudo service ssh status

# 재시작
sudo service ssh restart

# 설정 파일 위치
/etc/ssh/sshd_config
```

### 주요 SSH 설정 (sshd_config)
| 항목 | 값 |
|---|---|
| Port | 22 |
| PasswordAuthentication | yes |
| PermitRootLogin | prohibit-password |

---

## WSL2 재시작 후 체크리스트

1. `sudo service ssh start` — SSH 서비스 시작
2. `hostname -I` — 현재 WSL2 IP 확인
3. Windows 관리자 PowerShell에서 포트포워딩 재설정 (IP 변경 시)
4. `tmux attach -t 2` 또는 `bash /mnt/c/Dev/Team/setup-team.sh`

---

## 파일 구조

```
C:\Dev\Team\
├── README.md       ← 팀 구성 & TMUX 설정 가이드
├── access.md       ← 이 파일 (접근 권한 & SSH 설정)
└── setup-team.sh   ← 원클릭 팀 환경 자동 설정
```
