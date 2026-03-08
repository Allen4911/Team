# PM Skills 플러그인 설정

> Claude Code에 설치된 PM Skills 플러그인 목록 및 팀원별 활용 가이드  
> 소스: `C:\Dev\pm-skills-main` (GitHub: `phuryn/pm-skills`)  
> 설치일: 2026-03-08

---

## 마켓플레이스 등록

```bash
claude plugin marketplace add /mnt/c/Dev/pm-skills-main/pm-skills-main
```

마켓플레이스 이름: `pm-skills`  
설치 위치: `~/.claude/plugins/cache/pm-skills/`

---

## 설치된 플러그인 (5개)

```bash
claude plugin install pm-execution@pm-skills
claude plugin install pm-product-discovery@pm-skills
claude plugin install pm-product-strategy@pm-skills
claude plugin install pm-market-research@pm-skills
claude plugin install pm-toolkit@pm-skills
```

---

## 팀원별 활용 가이드

### 민준 (PM·아키텍트)

| 명령어 | 설명 |
|---|---|
| `/pm-execution:create-prd` | 기능/문제 기반 PRD 작성 |
| `/pm-execution:brainstorm-okrs` | 팀 OKR 브레인스토밍 |
| `/pm-execution:sprint-plan` | 스프린트 계획 (용량 산정, 스토리 선정) |
| `/pm-execution:retro` | 스프린트 회고 진행 |
| `/pm-execution:outcome-roadmap` | 기능 중심 → 결과 중심 로드맵 변환 |
| `/pm-execution:pre-mortem` | PRD·런칭 계획 리스크 사전 분석 |
| `/pm-execution:stakeholder-map` | 이해관계자 맵 + 커뮤니케이션 계획 |
| `/pm-product-strategy:product-strategy` | 9섹션 제품 전략 캔버스 작성 |
| `/pm-product-strategy:product-vision` | 팀·이해관계자 정렬을 위한 제품 비전 수립 |
| `/pm-product-strategy:lean-canvas` | 린 캔버스 기반 비즈니스 모델 탐색 |
| `/pm-product-discovery:identify-assumptions-existing` | 기능 가정 식별 및 리스크 분류 (Value/Usability/Viability/Feasibility) |
| `/pm-execution:summarize-meeting` | 회의 트랜스크립트 → 결정사항·액션아이템 정리 |

**자동 로드 스킬**: `prioritization-frameworks`, `opportunity-solution-tree`, `pre-mortem`, `sprint-plan`, `outcome-roadmap`

---

### 지훈 (리서쳐)

| 명령어 | 설명 |
|---|---|
| `/pm-market-research:user-personas` | 페르소나 작성 (리서치 데이터 기반) |
| `/pm-market-research:user-segmentation` | 유저 세그먼테이션 (행동·JTBD·니즈 기반) |
| `/pm-market-research:customer-journey-map` | 고객 여정 맵 (감정·페인포인트·터치포인트) |
| `/pm-market-research:market-segments` | 잠재 고객 세그먼트 식별 및 제품 적합성 분석 |
| `/pm-market-research:market-sizing` | TAM·SAM·SOM 시장 규모 추정 |
| `/pm-market-research:competitor-analysis` | 경쟁사 분석 (강점·약점·차별화 기회) |
| `/pm-market-research:sentiment-analysis` | NPS·피드백 데이터 감성 분석 및 테마 추출 |
| `/pm-product-discovery:interview-script` | 고객 인터뷰 스크립트 작성 (JTBD·Mom Test 기반) |
| `/pm-product-discovery:summarize-interview` | 인터뷰 트랜스크립트 구조화 요약 |
| `/pm-product-discovery:brainstorm-ideas-existing` | 기존 제품 대상 PM·디자이너·엔지니어 관점 아이디에이션 |
| `/pm-product-discovery:brainstorm-experiments-existing` | 가정 검증을 위한 실험 설계 (A/B 테스트, 프로토타입 등) |

**자동 로드 스킬**: `competitor-analysis`, `user-personas`, `market-sizing`, `sentiment-analysis`, `customer-journey-map`, `market-segments`

---

### 수아 (디자이너)

| 명령어 | 설명 |
|---|---|
| `/pm-market-research:user-personas` | 유저 페르소나 작성 (리서치 데이터 기반) |
| `/pm-market-research:customer-journey-map` | 고객 여정 맵 (감정·페인포인트·터치포인트) |
| `/pm-product-discovery:interview-script` | 사용자 인터뷰 스크립트 작성 (Mom Test 기반) |
| `/pm-product-discovery:summarize-interview` | 인터뷰 트랜스크립트 구조화 요약 |
| `/pm-product-discovery:brainstorm-ideas-existing` | 디자인 아이디에이션 (PM·디자이너·엔지니어 관점) |
| `/pm-product-strategy:value-proposition` | 가치 제안 설계 (JTBD 6파트 템플릿) |
| `/pm-product-discovery:analyze-feature-requests` | 사용자 요청 분석 및 테마별 우선순위 분류 |

**자동 로드 스킬**: `customer-journey-map`, `user-personas`, `user-segmentation`, `interview-script`, `value-proposition`

---

### 서연 (개발자)

| 명령어 | 설명 |
|---|---|
| `/pm-execution:user-stories` | 유저 스토리 작성 (3 C's + INVEST 기준) |
| `/pm-execution:job-stories` | 잡 스토리 작성 (When/I want/So I can) |
| `/pm-execution:wwas` | Why-What-Acceptance 형식 백로그 아이템 작성 |
| `/pm-execution:test-scenarios` | 유저 스토리 기반 테스트 시나리오 생성 |
| `/pm-execution:dummy-dataset` | 현실적인 더미 데이터셋 생성 (CSV/JSON/SQL) |
| `/pm-execution:release-notes` | 티켓·PRD·체인지로그 기반 릴리즈 노트 작성 |
| `/pm-execution:sprint-plan` | 스프린트 계획 참여 시 |

**자동 로드 스킬**: `user-stories`, `job-stories`, `test-scenarios`, `dummy-dataset`, `release-notes`

---

### 태양 (리뷰어)

| 명령어 | 설명 |
|---|---|
| `/pm-execution:pre-mortem` | PRD·기능 리스크 사전 분석 |
| `/pm-execution:test-scenarios` | 엣지 케이스·에러 처리 시나리오 검토 |
| `/pm-toolkit:grammar-check` | 문서 문법·논리·흐름 검토 및 수정 제안 |
| `/pm-execution:retro` | 회고 진행 및 개선사항 도출 |
| `/pm-product-discovery:prioritize-features` | 기능 우선순위 검토 (임팩트·노력·리스크·전략 정합성) |
| `/pm-product-discovery:analyze-feature-requests` | 피처 요청 분석 및 테마·전략 정합성 검토 |
| `/pm-execution:release-notes` | 릴리즈 노트 검토 및 최종 확인 |

**자동 로드 스킬**: `prioritization-frameworks`, `test-scenarios`, `pre-mortem`, `grammar-check`, `prioritize-features`

---

## 전체 팀 공통 명령어

| 명령어 | 설명 |
|---|---|
| `/pm-toolkit:grammar-check` | 문서 교정 (문법, 논리, 흐름) |
| `/pm-execution:summarize-meeting` | 회의록 자동 정리 |
| `/pm-execution:dummy-dataset` | 테스트용 더미 데이터 생성 |

---

## 스킬 강제 로드

스킬이 자동 로드되지 않을 경우 플러그인명:스킬명 형식으로 직접 호출:

```
/pm-execution:create-prd
/pm-execution:sprint-plan
/pm-product-discovery:opportunity-solution-tree
/pm-product-discovery:identify-assumptions-existing
/pm-product-strategy:product-vision
/pm-market-research:competitor-analysis
/pm-market-research:customer-journey-map
/pm-toolkit:grammar-check
```

---

## 추가 설치 가능 플러그인

| 플러그인 | 설치 명령어 | 용도 |
|---|---|---|
| `pm-data-analytics` | `claude plugin install pm-data-analytics@pm-skills` | SQL 생성, 코호트 분석, A/B 테스트 분석 |
| `pm-go-to-market` | `claude plugin install pm-go-to-market@pm-skills` | GTM 전략, 배틀카드, 성장 루프 설계 |
| `pm-marketing-growth` | `claude plugin install pm-marketing-growth@pm-skills` | 마케팅 아이디어, North Star 지표, 포지셔닝 |

---

## 참고

- 플러그인 소스 원본: `C:\Dev\pm-skills-main\pm-skills-main\`
- 65개 PM 스킬, 36개 체인 워크플로우 수록
- 기반 방법론: Teresa Torres (OST), Marty Cagan (INSPIRED), Alberto Savoia (Pretotype), Lean Canvas 등
