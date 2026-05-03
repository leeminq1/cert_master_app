// screens-2.jsx — Quiz, Explanation, 1-min concept

// ── 4. QUIZ — 문제 풀이 (탭하면 정답·해설 펼쳐짐) ──────────
function QuizScreen({ revealed = false }) {
  const q = SAMPLE_Q;
  const diffColor = T.diff1;
  return (
    <Phone>
      {/* Top bar with progress */}
      <div style={{ padding: '8px 12px 8px', flexShrink: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <Icon d={icons.x} size={20}/>
          <div style={{ flex: 1, display: 'flex', alignItems: 'center', gap: 8 }}>
            <ProgressBar value={q.num / q.total} color={T.lime} h={4} />
            <span style={{ fontSize: 11, fontFamily: T.mono, color: T.textDim, minWidth: 56, textAlign: 'right' }}>
              <span style={{ color: T.text, fontWeight: 700 }}>{q.num}</span>/{q.total}
            </span>
          </div>
          <Icon d={icons.bookmark} size={18}/>
        </div>
      </div>

      <div style={{ flex: 1, overflowY: 'auto', padding: '8px 16px 12px' }}>
        {/* meta */}
        <div style={{ display: 'flex', gap: 6, marginBottom: 14, alignItems: 'center' }}>
          <Chip mono>Q.{q.num}</Chip>
          <Chip color={`${diffColor}1a`} text={diffColor}>● 난이도 하</Chip>
          {q.tags.map(t => <Chip key={t} color={T.surface3} text={T.textDim}>#{t}</Chip>)}
        </div>

        {/* question */}
        <div style={{
          fontSize: 19, fontWeight: 600, lineHeight: 1.55, letterSpacing: -0.3,
          color: T.text, marginBottom: 16, textWrap: 'pretty',
        }}>
          {q.question}
        </div>

        {/* tap-to-reveal area */}
        {!revealed ? (
          <div style={{
            border: `1.5px dashed ${T.borderHi}`, borderRadius: 16,
            padding: '32px 16px', textAlign: 'center',
            background: T.surface,
          }}>
            <div style={{
              width: 44, height: 44, borderRadius: 22, background: `${T.lime}1a`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              margin: '0 auto 10px',
            }}>
              <Icon d={icons.zap} size={20} stroke={T.lime} fill={T.lime} sw={1.4}/>
            </div>
            <div style={{ fontSize: 14, fontWeight: 600, marginBottom: 4 }}>먼저 머릿속으로 답해보세요</div>
            <div style={{ fontSize: 12, color: T.textDim, marginBottom: 14, lineHeight: 1.5 }}>
              탭하면 정답과 해설이<br/>아래에 펼쳐집니다
            </div>
            <div style={{
              display: 'inline-flex', alignItems: 'center', gap: 6,
              padding: '8px 16px', borderRadius: 100,
              background: T.lime, color: T.bg, fontSize: 13, fontWeight: 700,
            }}>
              <Icon d={icons.chevDown} size={14} stroke={T.bg} sw={2.4}/>
              정답 보기
            </div>
          </div>
        ) : (
          <>
            {/* Answer */}
            <div style={{
              background: `${T.lime}10`, border: `1px solid ${T.lime}33`,
              borderRadius: 14, padding: 14, marginBottom: 12,
            }}>
              <div style={{
                display: 'flex', alignItems: 'center', gap: 6,
                fontSize: 11, fontWeight: 700, color: T.lime,
                fontFamily: T.mono, letterSpacing: 1, marginBottom: 8,
              }}>
                <Icon d={icons.check} size={12} stroke={T.lime} sw={2.4}/>
                ANSWER · 정답
              </div>
              <div style={{ fontSize: 14, lineHeight: 1.65, color: T.text, textWrap: 'pretty' }}>
                {q.answer}
              </div>
            </div>

            {/* AI explanation accordions */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
              <ExplainRow open icon="📚" tone={T.blue} label="배경" tag="background">
                {q.ai_explanation.background}
              </ExplainRow>
              <ExplainRow icon="💡" tone={T.lime} label="핵심 개념" tag="concept" />
              <ExplainRow icon="🎯" tone={T.amber} label="시험 포인트" tag="exam_tip" />
              <ExplainRow icon="🧠" tone={T.rose} label="암기 팁" tag="memory_tip" />
            </div>
          </>
        )}
      </div>

      {/* Self-grade footer */}
      <div style={{
        padding: '10px 14px 12px', borderTop: `1px solid ${T.border}`,
        flexShrink: 0, display: 'flex', gap: 8,
      }}>
        {revealed ? (
          <>
            <GradeBtn color={T.rose} label="다시" sub="모르겠음" />
            <GradeBtn color={T.amber} label="애매" sub="다시 볼래" />
            <GradeBtn color={T.lime} label="확실" sub="외웠음" primary />
          </>
        ) : (
          <>
            <div style={{
              flex: 1, padding: '12px 16px', borderRadius: 12,
              background: T.surface2, color: T.textDim, fontSize: 13, fontWeight: 600,
              textAlign: 'center',
            }}>건너뛰기</div>
            <div style={{
              flex: 2, padding: '12px 16px', borderRadius: 12,
              background: T.lime, color: T.bg, fontSize: 14, fontWeight: 700,
              textAlign: 'center',
            }}>정답 확인</div>
          </>
        )}
      </div>
    </Phone>
  );
}

function ExplainRow({ icon, tone, label, tag, open, children }) {
  return (
    <div style={{
      background: T.surface, borderRadius: 12,
      border: `1px solid ${open ? `${tone}33` : T.border}`,
      overflow: 'hidden',
    }}>
      <div style={{ padding: '12px 14px', display: 'flex', alignItems: 'center', gap: 10 }}>
        <span style={{ fontSize: 16 }}>{icon}</span>
        <span style={{ flex: 1, fontSize: 13, fontWeight: 600 }}>{label}</span>
        <span style={{ fontSize: 9, fontFamily: T.mono, color: T.textMute, letterSpacing: 1 }}>{tag}</span>
        <Icon d={open ? icons.chevDown : icons.chev} size={14} stroke={T.textDim}/>
      </div>
      {open && children && (
        <div style={{ padding: '0 14px 14px', fontSize: 13, lineHeight: 1.6, color: T.textDim, borderTop: `1px solid ${T.border}`, paddingTop: 12, textWrap: 'pretty' }}>
          {children}
        </div>
      )}
    </div>
  );
}

function GradeBtn({ color, label, sub, primary }) {
  return (
    <div style={{
      flex: 1, padding: '10px 8px', borderRadius: 12,
      background: primary ? color : `${color}1a`,
      color: primary ? T.bg : color,
      border: primary ? 'none' : `1px solid ${color}40`,
      textAlign: 'center',
    }}>
      <div style={{ fontSize: 14, fontWeight: 700 }}>{label}</div>
      <div style={{ fontSize: 10, opacity: 0.8, marginTop: 1 }}>{sub}</div>
    </div>
  );
}

// ── 5. AI EXPLANATION — 모든 아코디언 펼친 상태 ───────────
function ExplanationScreen() {
  const q = SAMPLE_Q;
  return (
    <Phone>
      <TopBar
        title="AI 해설"
        sub={`Q.${q.num} · 지게차운전기능사`}
        left={<Icon d={icons.back} size={20}/>}
        right={<Icon d={icons.bookmark} size={18}/>}
      />
      <div style={{ flex: 1, overflowY: 'auto', padding: '0 16px 16px' }}>
        {/* Question recap */}
        <div style={{
          background: T.surface, borderRadius: 12, padding: 12, marginBottom: 12,
          border: `1px solid ${T.border}`,
        }}>
          <div style={{ fontSize: 10, color: T.textMute, fontFamily: T.mono, letterSpacing: 1, marginBottom: 6 }}>QUESTION</div>
          <div style={{ fontSize: 14, fontWeight: 500, lineHeight: 1.55 }}>{q.question}</div>
        </div>

        <div style={{
          background: `${T.lime}10`, border: `1px solid ${T.lime}33`,
          borderRadius: 12, padding: 12, marginBottom: 14,
        }}>
          <div style={{
            display: 'flex', alignItems: 'center', gap: 6,
            fontSize: 10, fontWeight: 700, color: T.lime, fontFamily: T.mono, letterSpacing: 1, marginBottom: 6,
          }}>
            <Icon d={icons.check} size={11} stroke={T.lime} sw={2.4}/>
            ANSWER
          </div>
          <div style={{ fontSize: 13, lineHeight: 1.6 }}>{q.answer}</div>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 10 }}>
          <div style={{
            width: 22, height: 22, borderRadius: 6,
            background: `linear-gradient(135deg, ${T.lime}, ${T.blue})`,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontSize: 10, fontWeight: 800, color: T.bg, fontFamily: T.mono,
          }}>AI</div>
          <span style={{ fontSize: 13, fontWeight: 600 }}>해설</span>
          <span style={{ fontSize: 10, color: T.textMute, fontFamily: T.mono, marginLeft: 'auto' }}>4 sections</span>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          <ExplainOpen icon="📚" tone={T.blue} label="배경" tag="background">{q.ai_explanation.background}</ExplainOpen>
          <ExplainOpen icon="💡" tone={T.lime} label="핵심 개념" tag="concept">{q.ai_explanation.concept}</ExplainOpen>
          <ExplainOpen icon="🎯" tone={T.amber} label="시험 포인트" tag="exam_tip" highlight>{q.ai_explanation.exam_tip}</ExplainOpen>
          <ExplainOpen icon="🧠" tone={T.rose} label="암기 팁" tag="memory_tip">{q.ai_explanation.memory_tip}</ExplainOpen>
        </div>

        {/* Related */}
        <div style={{ marginTop: 18 }}>
          <div style={{ fontSize: 11, color: T.textDim, fontFamily: T.mono, letterSpacing: 1, marginBottom: 8 }}>RELATED · 유사 개념</div>
          {[
            { n: 3, t: '경사지에서 적재물 운반 시 기어 변속과 주행 방향' },
            { n: 7, t: '포크의 적정 지상고와 마스트 경사각' },
          ].map(r => (
            <div key={r.n} style={{
              background: T.surface, borderRadius: 10, padding: 12, marginBottom: 6,
              border: `1px solid ${T.border}`, display: 'flex', gap: 10, alignItems: 'center',
            }}>
              <span style={{ fontSize: 11, fontFamily: T.mono, color: T.textMute, minWidth: 24 }}>Q.{r.n}</span>
              <span style={{ fontSize: 12, lineHeight: 1.45, flex: 1 }}>{r.t}</span>
              <Icon d={icons.chev} size={12} stroke={T.textMute}/>
            </div>
          ))}
        </div>
      </div>
    </Phone>
  );
}

function ExplainOpen({ icon, tone, label, tag, children, highlight }) {
  return (
    <div style={{
      background: highlight ? `${tone}10` : T.surface,
      border: `1px solid ${highlight ? `${tone}40` : T.border}`,
      borderRadius: 12, overflow: 'hidden',
    }}>
      <div style={{
        padding: '11px 14px', display: 'flex', alignItems: 'center', gap: 10,
        borderBottom: `1px solid ${highlight ? `${tone}26` : T.border}`,
      }}>
        <span style={{
          width: 24, height: 24, borderRadius: 6, background: `${tone}26`,
          display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 13,
        }}>{icon}</span>
        <span style={{ flex: 1, fontSize: 13, fontWeight: 600, color: highlight ? tone : T.text }}>{label}</span>
        <span style={{ fontSize: 9, fontFamily: T.mono, color: T.textMute, letterSpacing: 1 }}>{tag}</span>
      </div>
      <div style={{ padding: '12px 14px', fontSize: 13, lineHeight: 1.65, color: T.textDim, textWrap: 'pretty' }}>
        {children}
      </div>
    </div>
  );
}

// ── 6. ONE-MINUTE CONCEPT — 자동 스토리 ────────────────
function OneMinuteScreen() {
  return (
    <Phone>
      {/* Header */}
      <div style={{ padding: '8px 14px 10px', flexShrink: 0, display: 'flex', alignItems: 'center', gap: 10 }}>
        <Icon d={icons.x} size={20}/>
        <div style={{ flex: 1, display: 'flex', gap: 3 }}>
          {[1,1,1,0.6,0,0,0,0].map((v,i) => (
            <div key={i} style={{ flex: 1, height: 3, background: T.surface3, borderRadius: 2, overflow: 'hidden' }}>
              <div style={{ width: `${v*100}%`, height: '100%', background: T.text }} />
            </div>
          ))}
        </div>
        <span style={{ fontSize: 11, fontFamily: T.mono, color: T.textDim }}>4/8</span>
      </div>

      {/* Story card */}
      <div style={{ flex: 1, padding: '4px 14px 14px', display: 'flex' }}>
        <div style={{
          flex: 1, borderRadius: 20, overflow: 'hidden',
          background: T._mode === 'light'
            ? `linear-gradient(170deg, ${T.surface}, ${T.surface2} 60%)`
            : `linear-gradient(170deg, #1a2240, #0E1116 60%)`,
          border: `1px solid ${T.border}`,
          padding: '24px 22px', display: 'flex', flexDirection: 'column',
          position: 'relative',
        }}>
          {/* category */}
          <div style={{
            display: 'inline-flex', alignSelf: 'flex-start', alignItems: 'center', gap: 6,
            padding: '4px 10px', borderRadius: 100,
            background: `${T.amber}1a`, color: T.amber,
            fontSize: 10, fontWeight: 700, fontFamily: T.mono, letterSpacing: 1,
          }}>⚡ 1MIN · CORE</div>

          {/* number */}
          <div style={{ marginTop: 22, fontSize: 64, fontWeight: 800, fontFamily: T.mono, letterSpacing: -2, color: T.lime, lineHeight: 1 }}>
            04
            <span style={{ fontSize: 18, color: T.textMute, marginLeft: 6 }}>/08</span>
          </div>

          {/* concept */}
          <div style={{ marginTop: 18 }}>
            <div style={{ fontSize: 11, fontFamily: T.mono, color: T.textDim, letterSpacing: 1, marginBottom: 10 }}>
              경사지 주행 · 핵심
            </div>
            <div style={{ fontSize: 26, fontWeight: 700, lineHeight: 1.35, letterSpacing: -0.6, textWrap: 'pretty' }}>
              짐은 무조건<br/>
              <span style={{ color: T.lime }}>산(높은 곳)</span>을<br/>
              본다.
            </div>
            <div style={{
              marginTop: 16, padding: 12,
              background: T._mode === 'light' ? 'rgba(20,25,35,0.04)' : 'rgba(255,255,255,0.04)',
              borderRadius: 12,
              border: `1px solid ${T.border}`,
            }}>
              <div style={{ display: 'flex', gap: 10, marginBottom: 6, alignItems: 'center' }}>
                <span style={{ width: 6, height: 6, borderRadius: 3, background: T.lime }} />
                <span style={{ fontSize: 13, color: T.text }}>오르막 → <b>전진</b></span>
              </div>
              <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
                <span style={{ width: 6, height: 6, borderRadius: 3, background: T.amber }} />
                <span style={{ fontSize: 13, color: T.text }}>내리막 → <b>후진</b> + 저속</span>
              </div>
            </div>
          </div>

          <div style={{ flex: 1 }} />

          {/* mnemonic */}
          <div style={{
            background: `${T.lime}1a`, border: `1px dashed ${T.lime}66`,
            borderRadius: 12, padding: 12,
          }}>
            <div style={{ fontSize: 10, color: T.lime, fontFamily: T.mono, letterSpacing: 1, marginBottom: 4, fontWeight: 700 }}>
              🧠 MNEMONIC
            </div>
            <div style={{ fontSize: 14, fontWeight: 600, color: T.text }}>
              "오전내후" — 오르막 전진, 내리막 후진
            </div>
          </div>
        </div>
      </div>

      {/* tap zones hint */}
      <div style={{
        padding: '0 14px 12px', flexShrink: 0,
        display: 'flex', justifyContent: 'space-between', alignItems: 'center',
      }}>
        <span style={{ fontSize: 10, color: T.textMute, fontFamily: T.mono }}>‹ 이전</span>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, color: T.textDim }}>
          <Icon d={icons.clock} size={12} stroke={T.textDim}/>
          <span style={{ fontSize: 11, fontFamily: T.mono }}>0:32 / 1:00</span>
        </div>
        <span style={{ fontSize: 10, color: T.textMute, fontFamily: T.mono }}>다음 ›</span>
      </div>
    </Phone>
  );
}

Object.assign(window, { QuizScreen, ExplanationScreen, OneMinuteScreen });
