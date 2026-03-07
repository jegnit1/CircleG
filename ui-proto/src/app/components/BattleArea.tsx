export function BattleArea() {
  return (
    <div className="size-full bg-gradient-to-br from-slate-800 to-slate-900 relative">
      {/* Grid overlay for placement guidance */}
      <div className="absolute inset-0 opacity-20">
        <svg width="100%" height="100%">
          <defs>
            <pattern id="grid" width="60" height="60" patternUnits="userSpaceOnUse">
              <path d="M 60 0 L 0 0 0 60" fill="none" stroke="cyan" strokeWidth="0.5"/>
            </pattern>
          </defs>
          <rect width="100%" height="100%" fill="url(#grid)" />
        </svg>
      </div>

      {/* Path visualization */}
      <svg className="absolute inset-0 pointer-events-none" width="100%" height="100%">
        <path
          d="M 0 50% Q 30% 20%, 50% 50% T 100% 50%"
          stroke="rgba(147, 197, 253, 0.3)"
          strokeWidth="60"
          fill="none"
          strokeLinecap="round"
        />
      </svg>

      {/* Game info overlay */}
      <div className="absolute top-4 left-4 bg-slate-900/80 backdrop-blur-sm px-4 py-2 rounded-lg border border-slate-700">
        <div className="text-slate-200">전투 영역</div>
      </div>
    </div>
  );
}
