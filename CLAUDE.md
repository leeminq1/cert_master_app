# AI Coding Instructions (gstack 연동)

이 프로젝트는 `garrytan/gstack` 방법론을 로컬 프로젝트에서 사용합니다. 
관련된 모든 AI 스킬 템플릿과 방법론은 프로젝트 최상단의 `.gstack` 디렉토리에 있습니다.

사용자가 `gstack`의 특정 스킬(예: `/plan-ceo-review`, `/plan-eng-review`, `/review`, `/qa` 등) 실행을 요청할 경우, AI는 반드시 `.gstack/<해당 스킬 이름>/SKILL.md` 파일을 먼저 읽고(`view_file` 도구 사용) 해당 파일에 명시된 지침과 방법론을 엄격하게 준수하여 작업을 수행해야 합니다.

## 주요 스킬
- 기획 단계: `/plan-ceo-review`, `/plan-eng-review`, `/plan-design-review`, `/autoplan`
- 코드 리뷰 및 QA: `/review`, `/qa`, `/careful`
- 프로젝트 관리: `/retro`, `/ship`

AI는 이 지침을 기반으로 모든 개발 프로세스를 진행합니다.
