// tokens.jsx — Design tokens for 자격증 마스터
// Calm dark mode. Cool ink-blue base, lime accent (correct/progress), amber (warn/streak).

// Theme palettes — same accents, different surfaces
const THEMES = {
  dark: {
    bg:'#0E1116', surface:'#161A22', surface2:'#1E232E', surface3:'#272D3A',
    border:'rgba(255,255,255,0.06)', borderHi:'rgba(255,255,255,0.12)',
    text:'#E7ECF3', textDim:'#9AA3B2', textMute:'#5F6878',
    lime:'#B6F36C', limeDeep:'#7CC23A', amber:'#F2B355', rose:'#F2768A', blue:'#7AB8FF',
    diff1:'#86E1A6', diff2:'#F2D266', diff3:'#F29C7A',
  },
  light: {
    bg:'#F7F8FA', surface:'#FFFFFF', surface2:'#F0F2F5', surface3:'#E5E8ED',
    border:'rgba(20,25,35,0.08)', borderHi:'rgba(20,25,35,0.16)',
    text:'#101521', textDim:'#5C6677', textMute:'#9098A6',
    lime:'#5DA02A', limeDeep:'#3F7818', amber:'#C77A1B', rose:'#D4475F', blue:'#2D7CD6',
    diff1:'#3F9466', diff2:'#B89615', diff3:'#C46A3F',
  },
};

const T = {
  ...THEMES.dark,
  font: '"Pretendard","Pretendard Variable",-apple-system,BlinkMacSystemFont,system-ui,"Apple SD Gothic Neo","Noto Sans KR",sans-serif',
  mono: '"JetBrains Mono","SF Mono",ui-monospace,monospace',
};

function applyTheme(mode) {
  const sys = window.matchMedia && window.matchMedia('(prefers-color-scheme: light)').matches ? 'light' : 'dark';
  const m = mode === 'auto' ? sys : mode;
  Object.assign(T, THEMES[m] || THEMES.dark);
  T._mode = m;
}

// 23 cert categories (4 super-groups)
const CERTS = [
  // 건설기계
  { id:'forklift',     name:'지게차운전기능사',   group:'건설기계', items:365, progress:0.42, streak:5, code:'FLT' },
  { id:'excavator',    name:'굴착기운전기능사',   group:'건설기계', items:412, progress:0.18, streak:0, code:'EXC' },
  { id:'crane',        name:'기중기운전기능사',   group:'건설기계', items:298, progress:0.0,  streak:0, code:'CRN' },
  { id:'roller',       name:'로더운전기능사',     group:'건설기계', items:301, progress:0.05, streak:0, code:'LDR' },
  // 전기·전자
  { id:'electric',     name:'전기기능사',         group:'전기·전자', items:520, progress:0.62, streak:12, code:'ELC' },
  { id:'electronics',  name:'전자기기기능사',     group:'전기·전자', items:478, progress:0.0,  streak:0, code:'ETN' },
  { id:'comm',         name:'정보통신기능사',     group:'전기·전자', items:445, progress:0.10, streak:0, code:'COM' },
  // 정보·IT
  { id:'info_proc',    name:'정보처리기능사',     group:'정보·IT',   items:512, progress:0.34, streak:3, code:'IFP' },
  { id:'web_design',   name:'웹디자인기능사',     group:'정보·IT',   items:280, progress:0.0,  streak:0, code:'WEB' },
  { id:'comp_graphic', name:'컴퓨터그래픽스운용', group:'정보·IT',   items:330, progress:0.0,  streak:0, code:'CG' },
  { id:'gis',          name:'전산응용건축제도',   group:'정보·IT',   items:268, progress:0.0,  streak:0, code:'CAD' },
  // 산업·안전
  { id:'industrial',   name:'산업안전기사',       group:'산업·안전', items:680, progress:0.78, streak:21, code:'SAF' },
  { id:'fire',         name:'소방설비기사',       group:'산업·안전', items:540, progress:0.0,  streak:0, code:'FRE' },
  { id:'gas',          name:'가스기능사',         group:'산업·안전', items:392, progress:0.0,  streak:0, code:'GAS' },
  { id:'water',        name:'위험물기능사',       group:'산업·안전', items:421, progress:0.22, streak:0, code:'HZD' },
  { id:'env',          name:'환경기능사',         group:'산업·안전', items:356, progress:0.0,  streak:0, code:'ENV' },
  // 조리·서비스
  { id:'cook_kr',      name:'한식조리기능사',     group:'조리·서비스', items:240, progress:0.0,  streak:0, code:'KOR' },
  { id:'cook_jp',      name:'일식조리기능사',     group:'조리·서비스', items:218, progress:0.0,  streak:0, code:'JPN' },
  { id:'cook_cn',      name:'중식조리기능사',     group:'조리·서비스', items:222, progress:0.0,  streak:0, code:'CHN' },
  { id:'baker',        name:'제과제빵기능사',     group:'조리·서비스', items:310, progress:0.0,  streak:0, code:'BKR' },
  { id:'barber',       name:'이용사',             group:'조리·서비스', items:198, progress:0.0,  streak:0, code:'BRB' },
  { id:'beauty',       name:'미용사(일반)',       group:'조리·서비스', items:284, progress:0.0,  streak:0, code:'BTY' },
  { id:'florist',      name:'화훼장식기능사',     group:'조리·서비스', items:176, progress:0.0,  streak:0, code:'FLR' },
];

// Sample question pulled from user's data — used in 풀이 screen
const SAMPLE_Q = {
  id: 2,
  question: "지게차의 화물 운반 방법으로 가장 적절한 것은?",
  answer: "운반 중 마스트를 뒤로 4도 가량 경사시킨다. 경사지 화물 운반 시 내리막은 후진, 오르막은 전진으로 운행한다. 운전 중 포크는 지면에서 20~30cm 정도 유지한다.",
  ai_explanation: {
    background: "지게차의 안전한 화물 운반은 낙하 사고 예방과 장비의 안정성 확보를 위해 실무와 시험 모두에서 가장 기본이 되는 핵심 지식입니다.",
    concept: "운행 시 화물이 쏟아지지 않게 마스트를 4도 정도 뒤로 기울이고, 포크 높이는 지면에서 20~30cm를 유지하며, 경사지에서는 화물이 항상 높은 곳을 향하도록 주행해야 합니다.",
    exam_tip: "경사지 주행 방향(오르막 전진, 내리막 후진)과 주행 시 포크의 지상고 수치(20~30cm)는 매 시험마다 출제되는 빈출 포인트입니다.",
    memory_tip: "'오전내후(오르막 전진, 내리막 후진)'와 '이삼(20-30)센티'만 기억하면 주행 문제는 다 맞힐 수 있습니다."
  },
  tags: ['주행', '안전', '빈출'],
  difficulty: 1,
  num: 2,
  total: 365,
};

Object.assign(window, { T, THEMES, CERTS, SAMPLE_Q, applyTheme });
