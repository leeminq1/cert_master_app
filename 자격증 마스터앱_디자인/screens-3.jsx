// screens-3.jsx — 오답노트, 통계, 설정 (로컬 DB 기반)

// ── 7. NOTEBOOK — 오답노트/북마크 ─────────────────────
function NotebookScreen() {
  return (
    <Phone>
      <div style={{ padding: '8px 16px 4px', flexShrink: 0 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: -0.4 }}>오답노트</div>
          <Icon d={icons.filter} size={18}/>
        </div>
        <div style={{ fontSize: 12, color: T.textDim, marginTop: 2 }}>지게차운전기능사 · 12문항</div>
      </div>

      <div style={{ padding: '12px 16px 8px', flexShrink: 0 }}>
        <div style={{ background: T.surface2, borderRadius: 10, padding: 3, display: 'flex', gap: 2 }}>
          {[
            { l: '오답', n: 12, on: true },
            { l: '북마크', n: 8, on: false },
            { l: '모름', n: 5, on: false },
          ].map((t,i) => (
            <div key={i} style={{
              flex: 1, padding: '7px 0', textAlign: 'center', borderRadius: 8,
              background: t.on ? T.surface : 'transparent',
              color: t.on ? T.text : T.textDim,
              fontSize: 12, fontWeight: 600,
            }}>{t.l} <span style={{ fontFamily: T.mono, opacity: 0.6, marginLeft: 2 }}>{t.n}</span></div>
          ))}
        </div>
      </div>

      <div style={{ padding: '4px 16px 8px', flexShrink: 0, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div style={{ display: 'flex', gap: 6 }}>
          <Chip color={T.surface3}>전체 카테고리</Chip>
          <Chip color={T.surface3} text={T.textDim}>최근 순</Chip>
        </div>
        <span style={{ fontSize: 11, color: T.lime, fontWeight: 600 }}>모두 풀기</span>
      </div>

      <div style={{ flex: 1, overflowY: 'auto', padding: '0 16px 16px' }}>
        {[
          { n: 14, q: '브레이크 페달의 자유 간극이 너무 클 때 일어나는 현상은?', cat: '제동장치', wrong: 2, when: '2일 전' },
          { n: 27, q: '유압 회로에서 캐비테이션이 발생하는 원인 중 가장 거리가 먼 것은?', cat: '유압장치', wrong: 3, when: '3일 전' },
          { n: 42, q: '지게차의 안정도 시험에서 전후 안정도의 기준값은?', cat: '안전·법규', wrong: 1, when: '5일 전' },
          { n: 58, q: '디젤기관의 노킹 방지법으로 적합하지 않은 것은?', cat: '엔진', wrong: 2, when: '6일 전' },
        ].map(r => (
          <div key={r.n} style={{
            background: T.surface, borderRadius: 12, padding: 12, marginBottom: 8,
            border: `1px solid ${T.border}`, display: 'flex', gap: 10,
          }}>
            <div style={{
              width: 4, alignSelf: 'stretch', borderRadius: 2,
              background: r.wrong >= 3 ? T.rose : r.wrong >= 2 ? T.amber : T.diff1,
            }}/>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 6 }}>
                <span style={{ fontSize: 11, fontFamily: T.mono, color: T.textDim }}>Q.{r.n}</span>
                <span style={{ fontSize: 10, color: T.textMute }}>{r.when}</span>
              </div>
              <div style={{ fontSize: 13, lineHeight: 1.5, marginBottom: 8, textWrap: 'pretty' }}>{r.q}</div>
              <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
                <Chip color={T.surface3} text={T.textDim}>{r.cat}</Chip>
                <span style={{ fontSize: 10, color: T.rose, fontFamily: T.mono, fontWeight: 600 }}>✗ {r.wrong}회 오답</span>
              </div>
            </div>
          </div>
        ))}
      </div>
      <TabBar active="note" />
    </Phone>
  );
}

// ── 8. STATS ───────────────────────────────────────────
function StatsScreen() {
  return (
    <Phone>
      <div style={{ padding: '8px 16px 8px', flexShrink: 0 }}>
        <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: -0.4 }}>학습 통계</div>
        <div style={{ fontSize: 12, color: T.textDim, marginTop: 2 }}>지게차운전기능사</div>
      </div>

      <div style={{ flex: 1, overflowY: 'auto', padding: '8px 16px 16px' }}>
        <div style={{
          background: `linear-gradient(135deg, ${T.surface2}, ${T.surface})`,
          border: `1px solid ${T.border}`, borderRadius: 18, padding: 18, marginBottom: 12,
        }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <div>
              <div style={{ fontSize: 11, color: T.textDim, fontFamily: T.mono, letterSpacing: 1 }}>SCORE PREDICTION</div>
              <div style={{ fontSize: 44, fontWeight: 800, fontFamily: T.mono, letterSpacing: -1.5, color: T.lime, marginTop: 4, lineHeight: 1 }}>
                72<span style={{ fontSize: 22, color: T.textDim }}>점</span>
              </div>
              <div style={{ fontSize: 11, color: T.lime, marginTop: 4 }}>+8점 (지난 주 대비)</div>
            </div>
            <div style={{ padding: '4px 10px', borderRadius: 100, background: `${T.lime}1a`, color: T.lime, fontSize: 11, fontWeight: 700 }}>합격권 ✓</div>
          </div>
          <div style={{ marginTop: 14, height: 1, background: T.border }}/>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 12 }}>
            {[
              { l: '정답률', v: '78%', c: T.lime },
              { l: '학습일', v: '21일', c: T.amber },
              { l: '평균시간', v: '24초', c: T.blue },
            ].map(s => (
              <div key={s.l}>
                <div style={{ fontSize: 10, color: T.textDim }}>{s.l}</div>
                <div style={{ fontSize: 16, fontWeight: 700, fontFamily: T.mono, color: s.c, marginTop: 2 }}>{s.v}</div>
              </div>
            ))}
          </div>
        </div>

        <div style={{ background: T.surface, border: `1px solid ${T.border}`, borderRadius: 14, padding: 14, marginBottom: 12 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 10 }}>
            <span style={{ fontSize: 12, fontWeight: 600 }}>학습 활동</span>
            <span style={{ fontSize: 10, color: T.textDim, fontFamily: T.mono }}>최근 12주</span>
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(12, 1fr)', gap: 3 }}>
            {Array.from({length: 84}).map((_, i) => {
              const v = (i*37 + i%7*11) % 5;
              const colors = [T.surface3, `${T.lime}33`, `${T.lime}66`, `${T.lime}aa`, T.lime];
              return <div key={i} style={{ aspectRatio: '1', borderRadius: 2, background: colors[v] }}/>;
            })}
          </div>
          <div style={{ display: 'flex', justifyContent: 'flex-end', alignItems: 'center', gap: 4, marginTop: 8, fontSize: 9, color: T.textDim, fontFamily: T.mono }}>
            적음
            {[T.surface3, `${T.lime}33`, `${T.lime}66`, `${T.lime}aa`, T.lime].map((c,i) => (
              <div key={i} style={{ width: 10, height: 10, background: c, borderRadius: 2 }}/>
            ))}
            많음
          </div>
        </div>

        <div style={{ background: T.surface, border: `1px solid ${T.border}`, borderRadius: 14, padding: 14, marginBottom: 12 }}>
          <div style={{ fontSize: 12, fontWeight: 600, marginBottom: 12 }}>카테고리별 정답률</div>
          {[
            { n: '주행·작동', v: 0.86, c: T.lime },
            { n: '엔진·동력', v: 0.72, c: T.lime },
            { n: '안전·법규', v: 0.58, c: T.amber },
            { n: '유압장치', v: 0.34, c: T.rose },
          ].map(r => (
            <div key={r.n} style={{ marginBottom: 10 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
                <span style={{ fontSize: 12 }}>{r.n}</span>
                <span style={{ fontSize: 11, fontFamily: T.mono, color: r.c, fontWeight: 600 }}>{Math.round(r.v*100)}%</span>
              </div>
              <ProgressBar value={r.v} color={r.c} h={4}/>
            </div>
          ))}
        </div>

        <div style={{ background: `${T.rose}10`, border: `1px solid ${T.rose}33`, borderRadius: 14, padding: 14 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
            <span style={{ fontSize: 14 }}>⚠️</span>
            <span style={{ fontSize: 12, fontWeight: 700, color: T.rose }}>약점 집중 학습 추천</span>
          </div>
          <div style={{ fontSize: 12, color: T.textDim, lineHeight: 1.55, marginBottom: 10 }}>
            유압장치 카테고리 정답률이 34%입니다. 1분 핵심으로 빠르게 복습해보세요.
          </div>
          <div style={{ display: 'inline-flex', padding: '8px 14px', borderRadius: 100, background: T.rose, color: T.bg, fontSize: 12, fontWeight: 700, alignItems: 'center', gap: 4 }}>
            지금 복습하기 →
          </div>
        </div>
      </div>
      <TabBar active="stats" />
    </Phone>
  );
}

// ── 9. SETTINGS — 로컬 DB 기반, 사용자 정보 없음 ───────
function SettingsScreen() {
  return (
    <Phone>
      <div style={{ padding: '8px 16px 16px', flexShrink: 0 }}>
        <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: -0.4 }}>설정</div>
        <div style={{ fontSize: 12, color: T.textDim, marginTop: 2 }}>모든 기록은 이 기기에만 저장됩니다</div>
      </div>

      <div style={{ flex: 1, overflowY: 'auto', padding: '0 16px 16px' }}>

        {/* 학습 요약 (사용자 정보 X, 학습 데이터 O) */}
        <div style={{
          background: T.surface, borderRadius: 14, padding: 14, marginBottom: 14,
          border: `1px solid ${T.border}`,
        }}>
          <div style={{ fontSize: 11, color: T.textDim, fontFamily: T.mono, letterSpacing: 1, marginBottom: 10 }}>MY STUDY</div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 10 }}>
            <div>
              <div style={{ fontSize: 10, color: T.textDim }}>누적 학습일</div>
              <div style={{ fontSize: 18, fontWeight: 700, fontFamily: T.mono, color: T.amber, marginTop: 2 }}>34일</div>
            </div>
            <div>
              <div style={{ fontSize: 10, color: T.textDim }}>푼 문항</div>
              <div style={{ fontSize: 18, fontWeight: 700, fontFamily: T.mono, color: T.lime, marginTop: 2 }}>1,247</div>
            </div>
            <div>
              <div style={{ fontSize: 10, color: T.textDim }}>학습중</div>
              <div style={{ fontSize: 18, fontWeight: 700, fontFamily: T.mono, color: T.blue, marginTop: 2 }}>5개</div>
            </div>
          </div>
        </div>

        {/* 배지 */}
        <div style={{
          background: T.surface, borderRadius: 14, padding: 14, marginBottom: 14,
          border: `1px solid ${T.border}`,
        }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 12 }}>
            <span style={{ fontSize: 12, fontWeight: 600 }}>학습 성취 배지</span>
            <span style={{ fontSize: 10, color: T.textDim, fontFamily: T.mono }}>4 / 12</span>
          </div>
          <div style={{ display: 'flex', gap: 10, justifyContent: 'space-between' }}>
            {[
              { e: '🔥', l: '21일' },
              { e: '🎯', l: '정답왕' },
              { e: '⚡', l: '스피드' },
              { e: '📚', l: '완독' },
              { e: '🌙', l: '?', dim: true },
              { e: '👑', l: '?', dim: true },
            ].map((b,i) => (
              <div key={i} style={{ textAlign: 'center', opacity: b.dim ? 0.3 : 1 }}>
                <div style={{
                  width: 36, height: 36, borderRadius: 10,
                  background: b.dim ? T.surface2 : `${T.amber}1a`,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  fontSize: 18, marginBottom: 4,
                }}>{b.e}</div>
                <div style={{ fontSize: 9, color: T.textDim, fontFamily: T.mono }}>{b.l}</div>
              </div>
            ))}
          </div>
        </div>

        {/* 학습 알림 — 로컬 푸시 */}
        <div style={{ fontSize: 11, color: T.textDim, fontFamily: T.mono, letterSpacing: 1, margin: '4px 0 8px' }}>NOTIFICATIONS · 로컬 알림</div>
        <SettingRow icon="🔔" label="학습 리마인더" value="매일 21:00" toggle on />
        <SettingRow icon="📅" label="복습 알림" value="3일 미접속 시" toggle on />
        <SettingRow icon="🎯" label="일일 목표" value="20문항" />

        {/* 학습 환경 */}
        <div style={{ fontSize: 11, color: T.textDim, fontFamily: T.mono, letterSpacing: 1, margin: '14px 0 8px' }}>APPEARANCE</div>
        <SettingRow icon="🌙" label="다크 모드" value="ON" toggle on />
        <SettingRow icon="Aa" label="글자 크기" value="중간" />
        <SettingRow icon="🔊" label="효과음·진동" value="OFF" toggle />

        {/* 데이터 관리 — 로컬 DB 핵심 */}
        <div style={{ fontSize: 11, color: T.textDim, fontFamily: T.mono, letterSpacing: 1, margin: '14px 0 8px' }}>DATA · 로컬 저장소</div>
        <SettingRow icon="💾" label="저장 공간" value="2.4 / 50 MB" />
        <SettingRow icon="📥" label="자격증 콘텐츠 관리" value="" arrow />
        <SettingRow icon="📤" label="학습 기록 내보내기" sub="JSON 파일로 백업" arrow highlight />
        <SettingRow icon="📂" label="기록 불러오기" sub="백업 파일 복원" arrow />
        <SettingRow icon="🔄" label="기출 데이터 업데이트" value="2026-04-12" arrow />

        {/* 위험 영역 */}
        <div style={{ fontSize: 11, color: T.rose, fontFamily: T.mono, letterSpacing: 1, margin: '14px 0 8px' }}>DANGER ZONE</div>
        <SettingRow icon="↺" label="자격증별 진도 초기화" arrow danger />
        <SettingRow icon="⚠" label="모든 학습 기록 삭제" arrow danger />

        {/* 앱 정보 */}
        <div style={{ fontSize: 11, color: T.textDim, fontFamily: T.mono, letterSpacing: 1, margin: '14px 0 8px' }}>ABOUT</div>
        <SettingRow icon="ℹ" label="앱 버전" value="v1.0.0" />
        <SettingRow icon="📜" label="오픈소스 라이선스" arrow />
        <SettingRow icon="✉" label="피드백 보내기" arrow />

        <div style={{
          marginTop: 16, padding: '10px 12px',
          background: T.surface, borderRadius: 10, border: `1px solid ${T.border}`,
          fontSize: 11, color: T.textDim, lineHeight: 1.5,
        }}>
          🔒 이 앱은 회원가입이나 계정이 없습니다. 모든 학습 기록은 이 기기에만 저장되며, 외부 서버로 전송되지 않습니다. 앱 삭제 전 <span style={{ color: T.lime, fontWeight: 600 }}>학습 기록 내보내기</span>로 백업하세요.
        </div>
      </div>
      <TabBar active="me" />
    </Phone>
  );
}

function SettingRow({ icon, label, value, sub, toggle, on, arrow, danger, highlight }) {
  return (
    <div style={{
      background: highlight ? `${T.lime}10` : T.surface,
      borderRadius: 10, padding: '10px 12px', marginBottom: 4,
      border: `1px solid ${highlight ? `${T.lime}33` : T.border}`,
      display: 'flex', alignItems: 'center', gap: 12,
    }}>
      <div style={{
        width: 28, height: 28, borderRadius: 8,
        background: danger ? `${T.rose}1a` : highlight ? `${T.lime}1a` : T.surface2,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontSize: 14, fontWeight: 700,
        color: danger ? T.rose : highlight ? T.lime : T.text,
      }}>{icon}</div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 13, color: danger ? T.rose : T.text }}>{label}</div>
        {sub && <div style={{ fontSize: 10, color: T.textDim, marginTop: 1 }}>{sub}</div>}
      </div>
      {value && <span style={{ fontSize: 12, color: T.textDim, fontFamily: T.mono }}>{value}</span>}
      {toggle && (
        <div style={{
          width: 36, height: 20, borderRadius: 10,
          background: on ? T.lime : T.surface3, position: 'relative', flexShrink: 0,
        }}>
          <div style={{
            position: 'absolute', top: 2, left: on ? 18 : 2,
            width: 16, height: 16, borderRadius: 8, background: '#fff',
            transition: 'left .15s',
          }}/>
        </div>
      )}
      {arrow && <Icon d={icons.chev} size={14} stroke={T.textMute}/>}
    </div>
  );
}

Object.assign(window, { NotebookScreen, StatsScreen, SettingsScreen });
