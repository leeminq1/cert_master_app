// phone.jsx — Custom dark Android frame for our app
// 360x780 — works inside DCArtboard 380x800

function Phone({ children, hideNav = false, statusDark = false }) {
  return (
    <div style={{
      width: 360, height: 780, background: T.bg, color: T.text,
      fontFamily: T.font, display: 'flex', flexDirection: 'column',
      position: 'relative', overflow: 'hidden',
    }}>
      <PhoneStatusBar />
      <div style={{ flex: 1, overflow: 'hidden', position: 'relative' }}>
        {children}
      </div>
      {!hideNav && <PhoneNav />}
    </div>
  );
}

function PhoneStatusBar() {
  return (
    <div style={{
      height: 28, padding: '0 20px',
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      fontSize: 13, fontWeight: 600, color: T.text, fontFamily: T.mono,
      flexShrink: 0,
    }}>
      <span>9:30</span>
      <div style={{
        position: 'absolute', left: '50%', top: 6, transform: 'translateX(-50%)',
        width: 14, height: 14, borderRadius: 8, background: '#000',
      }} />
      <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
        <svg width="14" height="11" viewBox="0 0 14 11" fill={T.text}><path d="M7 11l7-7a10 10 0 00-14 0l7 7z"/></svg>
        <svg width="14" height="11" viewBox="0 0 14 11" fill={T.text}><rect x="0" y="6" width="3" height="5" rx="0.5"/><rect x="4" y="3" width="3" height="8" rx="0.5"/><rect x="8" y="0" width="3" height="11" rx="0.5"/></svg>
        <span style={{ fontSize: 11 }}>87</span>
      </div>
    </div>
  );
}

function PhoneNav() {
  return (
    <div style={{
      height: 16, display: 'flex', alignItems: 'center', justifyContent: 'center',
      flexShrink: 0,
    }}>
      <div style={{ width: 110, height: 4, borderRadius: 2, background: T.textDim }} />
    </div>
  );
}

// ── Reusable bits ───────────────────────────────────────────

function TopBar({ title, left, right, sub }) {
  return (
    <div style={{ padding: '6px 16px 12px', flexShrink: 0 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, minHeight: 36 }}>
        <div style={{ width: 32, display: 'flex', alignItems: 'center' }}>{left}</div>
        <div style={{ flex: 1, fontSize: 16, fontWeight: 600, textAlign: 'center', letterSpacing: -0.2 }}>{title}</div>
        <div style={{ width: 32, display: 'flex', alignItems: 'center', justifyContent: 'flex-end' }}>{right}</div>
      </div>
      {sub && <div style={{ fontSize: 12, color: T.textDim, textAlign: 'center', marginTop: -4 }}>{sub}</div>}
    </div>
  );
}

function Icon({ d, size = 18, stroke = 'currentColor', sw = 1.8, fill = 'none' }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill={fill} stroke={stroke} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round">
      <path d={d} />
    </svg>
  );
}

const icons = {
  back: 'M15 18L9 12L15 6',
  search: 'M21 21l-4.35-4.35M11 19a8 8 0 100-16 8 8 0 000 16z',
  bookmark: 'M19 21l-7-5-7 5V5a2 2 0 012-2h10a2 2 0 012 2z',
  bookmarkFill: 'M19 21l-7-5-7 5V5a2 2 0 012-2h10a2 2 0 012 2z',
  flame: 'M12 2s4 4 4 8a4 4 0 01-8 0c0-1 .5-2 1-2-1 3 1 4 1 4s-1-3 2-7c1 2 0 4 0 4z',
  more: 'M5 12h.01M12 12h.01M19 12h.01',
  chev: 'M9 18l6-6-6-6',
  chevDown: 'M6 9l6 6 6-6',
  check: 'M20 6L9 17l-5-5',
  x: 'M18 6L6 18M6 6l12 12',
  filter: 'M3 6h18M7 12h10M11 18h2',
  layers: 'M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5',
  zap: 'M13 2L3 14h9l-1 8 10-12h-9l1-8z',
  brain: 'M9 3a3 3 0 016 0v1a3 3 0 013 3 3 3 0 010 6 3 3 0 01-3 3v1a3 3 0 01-6 0v-1a3 3 0 01-3-3 3 3 0 010-6 3 3 0 013-3V3z',
  chart: 'M3 3v18h18M7 14l3-3 4 4 6-6',
  settings: 'M12 15a3 3 0 100-6 3 3 0 000 6zM19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 01-2.83 2.83l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 008.91 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06a1.65 1.65 0 00.33-1.82 1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 8.91a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06a1.65 1.65 0 001.82.33H9a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06a1.65 1.65 0 00-.33 1.82V9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z',
  home: 'M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z',
  bell: 'M18 8a6 6 0 00-12 0c0 7-3 9-3 9h18s-3-2-3-9M13.73 21a2 2 0 01-3.46 0',
  edit: 'M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7M18.5 2.5a2.12 2.12 0 113 3L12 15l-4 1 1-4z',
  play: 'M5 3l14 9-14 9V3z',
  trophy: 'M8 21h8M12 17v4M7 4h10v5a5 5 0 01-10 0V4zM5 4H3v3a3 3 0 003 3M19 4h2v3a3 3 0 01-3 3',
  plus: 'M12 5v14M5 12h14',
  shuffle: 'M16 3h5v5M4 20L21 3M21 16v5h-5M15 15l6 6M4 4l5 5',
  clock: 'M12 22a10 10 0 100-20 10 10 0 000 20zM12 6v6l4 2',
  star: 'M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z',
};

function Chip({ children, color = T.surface3, text = T.text, border, mono }) {
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 4,
      padding: '4px 10px', borderRadius: 100,
      background: color, color: text,
      fontSize: 11, fontWeight: 500, lineHeight: 1.2,
      fontFamily: mono ? T.mono : T.font,
      border: border ? `1px solid ${border}` : 'none',
    }}>{children}</span>
  );
}

function ProgressBar({ value, color = T.lime, bg = T.surface3, h = 4 }) {
  return (
    <div style={{ height: h, background: bg, borderRadius: h, overflow: 'hidden', width: '100%' }}>
      <div style={{ width: `${Math.round(value * 100)}%`, height: '100%', background: color, borderRadius: h, transition: 'width .3s' }} />
    </div>
  );
}

function CertBadge({ code, color, size = 40 }) {
  return (
    <div style={{
      width: size, height: size, borderRadius: 10,
      background: `${color}1a`,
      border: `1px solid ${color}33`,
      color, fontFamily: T.mono, fontWeight: 700,
      fontSize: size * 0.28, letterSpacing: -0.3,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      flexShrink: 0,
    }}>{code}</div>
  );
}

// Color per group
function groupColor(g) {
  return ({
    '건설기계':   T.amber,
    '전기·전자':  T.blue,
    '정보·IT':    T.lime,
    '산업·안전':  T.rose,
    '조리·서비스': '#C4A6FF',
  })[g] || T.lime;
}

// Bottom tab bar
function TabBar({ active = 'home' }) {
  const tabs = [
    { id: 'home',  label: '홈',     d: icons.home },
    { id: 'study', label: '학습',   d: icons.layers },
    { id: 'note',  label: '오답노트', d: icons.bookmark },
    { id: 'stats', label: '통계',   d: icons.chart },
    { id: 'me',    label: '내 정보', d: icons.settings },
  ];
  return (
    <div style={{
      display: 'flex', borderTop: `1px solid ${T.border}`,
      background: T.bg, padding: '6px 4px 4px',
      flexShrink: 0,
    }}>
      {tabs.map(t => {
        const on = t.id === active;
        return (
          <div key={t.id} style={{
            flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 2,
            padding: '6px 0', color: on ? T.lime : T.textMute,
          }}>
            <Icon d={t.d} size={20} sw={on ? 2 : 1.6} />
            <span style={{ fontSize: 10, fontWeight: on ? 600 : 500 }}>{t.label}</span>
          </div>
        );
      })}
    </div>
  );
}

Object.assign(window, {
  Phone, TopBar, Icon, icons, Chip, ProgressBar, CertBadge, groupColor, TabBar,
});
