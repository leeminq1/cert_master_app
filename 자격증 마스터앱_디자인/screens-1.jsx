// screens-1.jsx — Home, Cert Detail, Search

// ── 1. HOME — 자격증 23개 목록 ─────────────────────────
function HomeScreen({ layout = 'list' }) {
  const groups = {};
  CERTS.forEach(c => { (groups[c.group] = groups[c.group] || []).push(c); });
  const totalProg = CERTS.reduce((a,c) => a + c.progress, 0) / CERTS.length;
  const activeStreak = Math.max(...CERTS.map(c => c.streak));

  return (
    <Phone>
      {/* App Header */}
      <div style={{ padding: '8px 16px 12px', flexShrink: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div>
            <div style={{ fontSize: 11, color: T.textDim, fontFamily: T.mono, letterSpacing: 1 }}>CERT MASTER</div>
            <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: -0.6, marginTop: 2 }}>
              안녕하세요,<br/>오늘도 합격을 향해.
            </div>
          </div>
          <div style={{
            width: 40, height: 40, borderRadius: 12, background: T.surface2,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <Icon d={icons.bell} size={18} stroke={T.text} />
            <div style={{ position: 'absolute', width: 6, height: 6, borderRadius: 3, background: T.rose, marginTop: -10, marginLeft: 10 }} />
          </div>
        </div>
      </div>

      {/* Streak / progress strip */}
      <div style={{ padding: '0 16px 14px', flexShrink: 0 }}>
        <div style={{
          background: `linear-gradient(135deg, ${T.surface2}, ${T.surface})`,
          border: `1px solid ${T.border}`,
          borderRadius: 16, padding: 14,
          display: 'flex', gap: 12, alignItems: 'center',
        }}>
          <div style={{
            width: 44, height: 44, borderRadius: 12,
            background: `${T.amber}1a`, color: T.amber,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <Icon d={icons.flame} size={22} stroke={T.amber} fill={T.amber} sw={1.4}/>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 11, color: T.textDim }}>연속 학습</div>
            <div style={{ fontSize: 18, fontWeight: 700, fontFamily: T.mono, color: T.amber }}>{activeStreak}일째</div>
          </div>
          <div style={{ width: 1, height: 28, background: T.border }} />
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 11, color: T.textDim }}>전체 진도</div>
            <div style={{ fontSize: 18, fontWeight: 700, fontFamily: T.mono }}>{Math.round(totalProg * 100)}%</div>
          </div>
        </div>
      </div>

      {/* Search bar */}
      <div style={{ padding: '0 16px 14px', flexShrink: 0 }}>
        <div style={{
          background: T.surface, borderRadius: 12, padding: '10px 14px',
          display: 'flex', alignItems: 'center', gap: 10,
          border: `1px solid ${T.border}`,
        }}>
          <Icon d={icons.search} size={16} stroke={T.textDim} />
          <span style={{ fontSize: 13, color: T.textMute, flex: 1 }}>자격증·문제·태그 검색</span>
          <span style={{ fontSize: 10, color: T.textMute, fontFamily: T.mono, padding: '2px 6px', border: `1px solid ${T.border}`, borderRadius: 4 }}>⌘K</span>
        </div>
      </div>

      {/* Cert list, scrollable */}
      <div style={{ flex: 1, overflowY: 'auto', padding: '0 16px 16px' }}>
        {Object.entries(groups).map(([group, list]) => (
          <div key={group} style={{ marginBottom: 18 }}>
            <div style={{
              display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
              marginBottom: 10,
            }}>
              <div style={{ fontSize: 13, fontWeight: 600, color: T.textDim }}>{group}</div>
              <div style={{ fontSize: 11, color: T.textMute, fontFamily: T.mono }}>{list.length}개</div>
            </div>
            {layout === 'grid' ? (
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
                {list.map(c => <CertGridCard key={c.id} c={c} />)}
              </div>
            ) : (
              <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
                {list.map(c => <CertListRow key={c.id} c={c} />)}
              </div>
            )}
          </div>
        ))}
      </div>

      <TabBar active="home" />
    </Phone>
  );
}

function CertListRow({ c }) {
  const color = groupColor(c.group);
  return (
    <div style={{
      background: T.surface, borderRadius: 12, padding: 12,
      display: 'flex', alignItems: 'center', gap: 12,
      border: `1px solid ${T.border}`,
    }}>
      <CertBadge code={c.code} color={color} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 14, fontWeight: 600, letterSpacing: -0.2 }}>{c.name}</div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 6 }}>
          <ProgressBar value={c.progress} color={color} h={3} />
          <span style={{ fontSize: 10, color: T.textDim, fontFamily: T.mono, minWidth: 30, textAlign: 'right' }}>
            {Math.round(c.progress * 100)}%
          </span>
        </div>
      </div>
      {c.streak > 0 && (
        <div style={{ display: 'flex', alignItems: 'center', gap: 2, color: T.amber, fontSize: 11, fontWeight: 600, fontFamily: T.mono }}>
          <Icon d={icons.flame} size={11} stroke={T.amber} fill={T.amber} sw={1.5} />
          {c.streak}
        </div>
      )}
    </div>
  );
}

function CertGridCard({ c }) {
  const color = groupColor(c.group);
  return (
    <div style={{
      background: T.surface, borderRadius: 12, padding: 12,
      border: `1px solid ${T.border}`, minHeight: 110,
      display: 'flex', flexDirection: 'column', justifyContent: 'space-between',
    }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <CertBadge code={c.code} color={color} size={32} />
        {c.streak > 0 && (
          <Icon d={icons.flame} size={12} stroke={T.amber} fill={T.amber} sw={1.5} />
        )}
      </div>
      <div>
        <div style={{ fontSize: 12, fontWeight: 600, letterSpacing: -0.2, marginBottom: 6, lineHeight: 1.3 }}>{c.name}</div>
        <ProgressBar value={c.progress} color={color} h={3} />
        <div style={{ fontSize: 10, color: T.textDim, fontFamily: T.mono, marginTop: 4 }}>
          {Math.round(c.progress * 100)}% · {c.items}문항
        </div>
      </div>
    </div>
  );
}

// ── 2. CERT DETAIL — 기능 허브 ─────────────────────────
function CertDetailScreen() {
  const c = CERTS[0]; // 지게차
  const color = groupColor(c.group);
  return (
    <Phone>
      <TopBar
        title=""
        left={<Icon d={icons.back} size={20}/>}
        right={<Icon d={icons.more} size={20}/>}
      />
      {/* Hero */}
      <div style={{ padding: '0 16px 18px', flexShrink: 0 }}>
        <div style={{
          background: `linear-gradient(160deg, ${color}26, ${T.surface})`,
          border: `1px solid ${color}33`,
          borderRadius: 18, padding: 16,
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 14 }}>
            <CertBadge code={c.code} color={color} size={48} />
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 11, color: T.textDim }}>{c.group}</div>
              <div style={{ fontSize: 18, fontWeight: 700, letterSpacing: -0.3 }}>{c.name}</div>
            </div>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 8 }}>
            <span style={{ fontSize: 12, color: T.textDim }}>학습 진도</span>
            <span style={{ fontSize: 12, fontFamily: T.mono, color: T.text, fontWeight: 600 }}>
              154 / {c.items} <span style={{ color, marginLeft: 4 }}>{Math.round(c.progress*100)}%</span>
            </span>
          </div>
          <ProgressBar value={c.progress} color={color} h={6} />
          <div style={{ display: 'flex', gap: 6, marginTop: 14, flexWrap: 'wrap' }}>
            <Chip color={`${T.amber}1a`} text={T.amber} mono>🔥 {c.streak}일 연속</Chip>
            <Chip mono>D-32</Chip>
            <Chip mono>오답 12</Chip>
          </div>
        </div>
      </div>

      {/* Continue button */}
      <div style={{ padding: '0 16px 14px', flexShrink: 0 }}>
        <div style={{
          background: T.lime, borderRadius: 14, padding: '14px 16px',
          display: 'flex', alignItems: 'center', gap: 12,
          color: '#0E1116',
        }}>
          <div style={{
            width: 36, height: 36, borderRadius: 10, background: 'rgba(0,0,0,0.12)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <Icon d={icons.play} size={16} stroke="#0E1116" fill="#0E1116" sw={2}/>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 11, opacity: 0.7, fontWeight: 600 }}>이어서 학습</div>
            <div style={{ fontSize: 14, fontWeight: 700 }}>문제 #155 · 안전수칙</div>
          </div>
          <Icon d={icons.chev} size={18} stroke="#0E1116" sw={2.4}/>
        </div>
      </div>

      {/* Feature grid */}
      <div style={{ flex: 1, overflowY: 'auto', padding: '0 16px 16px' }}>
        <div style={{ fontSize: 11, color: T.textDim, fontWeight: 600, marginBottom: 10, fontFamily: T.mono, letterSpacing: 1 }}>STUDY MODES</div>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8, marginBottom: 16 }}>
          <FeatureTile icon={icons.layers} label="전체 기출" sub="365문항" tone={T.lime} />
          <FeatureTile icon={icons.zap} label="1분 핵심" sub="몰아보기" tone={T.amber} highlight />
          <FeatureTile icon={icons.brain} label="유사 개념" sub="묶음 학습" tone={T.blue} />
          <FeatureTile icon={icons.bookmark} label="오답·북마크" sub="12문항" tone={T.rose} />
          <FeatureTile icon={icons.shuffle} label="난이도별" sub="상·중·하" tone={'#C4A6FF'} />
          <FeatureTile icon={icons.clock} label="모의고사" sub="60분 60문항" tone={T.text} />
        </div>

        <div style={{ fontSize: 11, color: T.textDim, fontWeight: 600, marginBottom: 10, fontFamily: T.mono, letterSpacing: 1 }}>CATEGORIES</div>
        {[
          { name: '주행·작동', n: 82, p: 0.62 },
          { name: '엔진·동력전달', n: 94, p: 0.40 },
          { name: '안전·법규', n: 68, p: 0.28 },
          { name: '유압장치', n: 71, p: 0.15 },
        ].map(cat => (
          <div key={cat.name} style={{
            background: T.surface, borderRadius: 10, padding: '10px 12px',
            marginBottom: 6, border: `1px solid ${T.border}`,
            display: 'flex', alignItems: 'center', gap: 12,
          }}>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 13, fontWeight: 500 }}>{cat.name}</div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 4 }}>
                <ProgressBar value={cat.p} color={color} h={2} />
                <span style={{ fontSize: 10, color: T.textDim, fontFamily: T.mono, minWidth: 36 }}>{cat.n}문항</span>
              </div>
            </div>
            <Icon d={icons.chev} size={14} stroke={T.textMute}/>
          </div>
        ))}
      </div>
    </Phone>
  );
}

function FeatureTile({ icon, label, sub, tone, highlight }) {
  return (
    <div style={{
      background: highlight ? `${tone}1a` : T.surface,
      border: `1px solid ${highlight ? `${tone}40` : T.border}`,
      borderRadius: 12, padding: 12, minHeight: 88,
      display: 'flex', flexDirection: 'column', justifyContent: 'space-between',
    }}>
      <div style={{
        width: 30, height: 30, borderRadius: 8,
        background: `${tone}1a`, color: tone,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <Icon d={icon} size={16} stroke={tone} sw={1.8}/>
      </div>
      <div>
        <div style={{ fontSize: 13, fontWeight: 600, letterSpacing: -0.2 }}>{label}</div>
        <div style={{ fontSize: 10, color: T.textDim, fontFamily: T.mono, marginTop: 2 }}>{sub}</div>
      </div>
    </div>
  );
}

// ── 3. SEARCH ──────────────────────────────────────────
function SearchScreen() {
  return (
    <Phone>
      <div style={{ padding: '8px 12px 10px', flexShrink: 0, display: 'flex', gap: 8, alignItems: 'center' }}>
        <div style={{ width: 28, display: 'flex', alignItems: 'center' }}><Icon d={icons.back} size={20}/></div>
        <div style={{
          flex: 1, background: T.surface2, borderRadius: 10, padding: '8px 12px',
          display: 'flex', alignItems: 'center', gap: 8,
        }}>
          <Icon d={icons.search} size={14} stroke={T.textDim} />
          <span style={{ fontSize: 13, color: T.text, flex: 1 }}>마스트<span style={{ color: T.lime, marginLeft: 1, animation: 'blink 1s infinite' }}>|</span></span>
          <Icon d={icons.x} size={14} stroke={T.textDim} sw={1.5}/>
        </div>
      </div>

      <div style={{ padding: '0 12px', flexShrink: 0 }}>
        <div style={{ display: 'flex', gap: 6, overflowX: 'auto', paddingBottom: 8 }}>
          {['전체', '문제', '핵심개념', '태그', '자격증'].map((t,i) => (
            <span key={t} style={{
              padding: '6px 12px', borderRadius: 100,
              background: i===1 ? T.text : T.surface2,
              color: i===1 ? T.bg : T.text,
              fontSize: 12, fontWeight: 600, whiteSpace: 'nowrap',
            }}>{t}</span>
          ))}
        </div>
      </div>

      <div style={{ flex: 1, overflowY: 'auto', padding: '8px 16px 16px' }}>
        <div style={{ fontSize: 11, color: T.textDim, fontFamily: T.mono, letterSpacing: 1, marginBottom: 8 }}>
          12개 결과 · "마스트"
        </div>
        {[
          { q: '지게차의 화물 운반 방법으로 가장 적절한 것은?', cat: '주행·작동', cert: '지게차운전기능사', hi: '마스트' },
          { q: '마스트의 후경각이란 무엇인가?', cat: '구조·이론', cert: '지게차운전기능사', hi: '마스트' },
          { q: '틸트 실린더가 마스트에 미치는 영향은?', cat: '유압장치', cert: '지게차운전기능사', hi: '마스트' },
          { q: '마스트의 종류 3가지를 쓰시오.', cat: '구조·이론', cert: '지게차운전기능사', hi: '마스트' },
        ].map((r, i) => (
          <div key={i} style={{
            background: T.surface, borderRadius: 12, padding: 12, marginBottom: 8,
            border: `1px solid ${T.border}`,
          }}>
            <div style={{ fontSize: 13, fontWeight: 500, lineHeight: 1.5, marginBottom: 8 }}>
              {r.q.split(r.hi).map((p, k, arr) => (
                <React.Fragment key={k}>
                  {p}
                  {k < arr.length - 1 && <span style={{ background: `${T.lime}33`, color: T.lime, padding: '0 2px', borderRadius: 3 }}>{r.hi}</span>}
                </React.Fragment>
              ))}
            </div>
            <div style={{ display: 'flex', gap: 6 }}>
              <Chip color={T.surface3} mono>{r.cert}</Chip>
              <Chip color={T.surface3} text={T.textDim}>{r.cat}</Chip>
            </div>
          </div>
        ))}

        <div style={{ fontSize: 11, color: T.textDim, fontFamily: T.mono, letterSpacing: 1, marginTop: 16, marginBottom: 8 }}>
          최근 검색
        </div>
        {['브레이크', '안전수칙', '유압', '경사지'].map(t => (
          <div key={t} style={{
            display: 'flex', alignItems: 'center', justifyContent: 'space-between',
            padding: '10px 0', borderBottom: `1px solid ${T.border}`,
          }}>
            <span style={{ display: 'flex', alignItems: 'center', gap: 10, fontSize: 13, color: T.textDim }}>
              <Icon d={icons.clock} size={13} stroke={T.textMute}/>
              {t}
            </span>
            <Icon d={icons.x} size={12} stroke={T.textMute} sw={1.5}/>
          </div>
        ))}
      </div>
    </Phone>
  );
}

Object.assign(window, { HomeScreen, CertDetailScreen, SearchScreen });
