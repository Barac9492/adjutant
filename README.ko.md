# adjutant

*미해결 결정을 행동으로 바꾸고 흩어진 노트를 정리하기 위한, 포크 가능한 Claude Code 운영체제.*

[English](README.md)

> **상태: 공개 프리베타.** Adjutant는 한 사람의 실제 워크플로에서 추출하고
> 개인 정보를 제거한, 의도적으로 의견이 담긴 템플릿입니다. 로컬 핵심 기능은 바로
> 시험할 수 있지만 외부 연동과 스케줄 자동화는 각자 설정해야 합니다. 호스팅형
> 비서나 원클릭 자동화 제품은 아닙니다.

![가상의 결정에 대해 보드가 논쟁하는 모습. 실제 모델 출력, 가상의 시나리오.](docs/assets/demo.gif)

*완전히 지어낸 "Jordan" 시나리오에 대해 보드가 논쟁하는 장면입니다. 실제 누군가의
결정이 아닙니다. 텍스트는 각본이 아니라 `os/agents/board-*.md` 프롬프트가 만든
실제 출력이며, 생성되는 회의록은 `docs/decision-format.md`의 단일 파일 포맷을
따릅니다.*

![Telegram으로 전달된 아침 브리핑. 실제 모델 출력, 가상의 시나리오.](docs/assets/briefing.png)

*이 화면도 가상의 "Jordan" 시나리오와
`os/skills/briefing-morning/SKILL.md`의 실제 출력을 사용합니다. 진짜 브리핑은
대시보드가 아니라 짧은 메시지 하나입니다.*

## 이게 뭔가

Adjutant는 Claude Code에 지속적인 의사결정과 실행 리듬을 부여합니다.

- 지난번에 던진 과제를 기억하는 3인 어드버서리얼 보드
- 정보 부족이 아니라 결단 부족일 때 같은 분석을 반복하지 못하게 막는 결단 원장
- 저렴한 정찰, 강한 계획, 저렴한 구현, 새 맥락의 리뷰로 구성된 바벨 딜리버리
  파이프라인

표준 Claude Code와 로컬 Markdown 파일 위에서 작동합니다. 포크한 뒤 도움이 되는
부분은 남기고, 나머지는 자기 일에 맞게 바꾸는 구조입니다.

## 누구에게 도움이 되나

다음에 해당하면 잘 맞습니다.

- 이미 Claude Code를 쓰고 로컬 폴더를 설정하는 데 거부감이 없다.
- Markdown 노트를 쓰고 있거나, 시스템이 읽을 노트 폴더를 지정할 수 있다.
- 중요한 결정을 끝내거나 실행을 정직하게 점검받고 싶다.

반대로 캘린더, 이메일, Telegram 자동화가 별도 연결 없이 즉시 돌아가야 한다면 아직
맞지 않습니다. 이 저장소의 해당 기능은 연동 구현물이 아니라 워크플로 프로토콜입니다.

## 빠른 시작

필수 준비물은 Claude Code와 Git입니다. 로컬 Markdown 노트 볼트는 선택 사항이지만
`/today`와 `/briefing`에는 필요합니다. `/decide`에는 필요하지 않습니다.

```bash
git clone https://github.com/Barac9492/adjutant.git adjutant
cd adjutant
./install.sh
```

설치기는 기존 파일을 덮어쓰지 않고 스킬과 에이전트를 `~/.claude`에 복사합니다. 또한
이미 같은 파일이 없는 경우 이 저장소 루트에 `CLAUDE.md`를 복사합니다. 그래야 Claude
Code가 이 프로젝트에서 운영 원칙을 읽을 수 있습니다.

그다음 이 디렉토리에서 Claude Code를 열고 실행하세요.

```
/setup
```

외부 연결 없이도 첫 결과를 얻으려면 `/decide add`부터 시작하세요. 노트 볼트를 설정한
후에는 `/today`를 써보면 됩니다.

## 지금 되는 것과 별도 설정이 필요한 것

| 기능 | 이 저장소에 포함됨 | 추가로 필요한 것 |
| --- | --- | --- |
| `/decide` | 결단 파일과 재분석 차단 규칙 | `/setup`이 만든 결단 원장 |
| `/board convene` | 세 명의 에이전트와 로컬 append-only 메모리 | 미해결 결정과 `/setup`의 원장 경로 |
| `/today`, `/briefing` | 로컬 Markdown 워크플로 | 읽을 수 있는 Markdown 노트 볼트 |
| 바벨 딜리버리 파이프라인 | `CLAUDE.md`, scout, implementer, reviewer, 품질 게이트 | 복제한 저장소에서 작업하거나 원칙을 자기 프로젝트에 병합 |
| 스케줄 스킬 | 7개 워크플로 프로토콜과 결단 원장의 주간 리뷰 | 스케줄러와 각 루틴의 수동 실행 검증 |
| 이메일, 캘린더, Telegram | 안전한 워크플로 지침만 제공 | 직접 검증한 커넥터 또는 어댑터. Adjutant에는 포함되어 있지 않음 |

커넥터 의존 기능을 켜기 전에는 [연동 가이드](docs/cookbook/integrations.md)를,
cron 작업을 만들기 전에는 [스케줄링 가이드](docs/cookbook/scheduling.md)를 읽으세요.

## 왜 설치가 아니라 포크인가

이건 설치해 두고 잊는 라이브러리보다 dotfiles에 가깝습니다. 읽고, 필요 없는 부분을
잘라내고, 자기 삶과 일에 맞을 때까지 나머지를 바꾸는 것이 목적입니다. `/setup`
마법사는 쓸 만한 출발점을 만들고, 이후의 포크는 의도적으로 당신의 것이 됩니다.

## 분야에 맞게 바꾸기

`examples/verticals/`에는 벤처캐피털 버티컬 예시가 하나 있습니다. 다른 분야의 예시는
PR로 환영합니다. 시작점으로는 보드의 베테랑 좌석이 가장 좋습니다.
`board.veteran.domain`을 바꾸고, 정말 다른 목소리가 필요할 때만
`os/agents/board-veteran.md`를 수정하세요.

## 개인정보와 안전

- `config/os.config.yaml`은 gitignore되어 있습니다. 개인 경로, chat ID, 커넥터
  시크릿은 로컬 설정에서만 관리하세요.
- 타인에게 영향을 주는 동작은 초안 전용 또는 확인 우선으로 설계되어 있습니다.
  `email-triage`는 이메일을 절대 발송하지 않습니다.
- `scripts/check-sanitization.sh`는 로컬과 GitHub Actions의 push/PR에서 실행됩니다.
  이것은 방어막이 아니라 경보 장치입니다. 공개 전에는 모든 데모 이미지와 diff를
  직접 읽어야 합니다.

PR을 열기 전에는 [정제 체크리스트](docs/cookbook/sanitization-checklist.md)와
[CONTRIBUTING.md](CONTRIBUTING.md)를 확인하세요.

## 라이선스

[MIT](LICENSE).
