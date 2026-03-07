import { Crown, Diamond, Gem, Star, Sparkles } from 'lucide-react';

interface Artifact {
  id: number;
  name: string;
  rarity: 'common' | 'rare' | 'epic' | 'legendary';
  icon: React.ElementType;
  effect: string;
  equipped: boolean;
}

export function ArtifactsTab() {
  const artifacts: Artifact[] = [
    { id: 1, name: '시간의 모래시계', rarity: 'legendary', icon: Crown, effect: '모든 쿨다운 -25%', equipped: true },
    { id: 2, name: '마나의 결정', rarity: 'epic', icon: Diamond, effect: '최대 마나 +50', equipped: true },
    { id: 3, name: '불사조의 깃털', rarity: 'rare', icon: Sparkles, effect: '사망 시 1회 부활', equipped: true },
    { id: 4, name: '고대의 유물', rarity: 'epic', icon: Gem, effect: '모든 피해 +30%', equipped: false },
    { id: 5, name: '수호자의 징표', rarity: 'rare', icon: Star, effect: '방어력 +20', equipped: false },
  ];

  const maxSlots = 5;
  const equippedCount = artifacts.filter(a => a.equipped).length;

  const rarityColors = {
    common: 'from-slate-600 to-slate-700 border-slate-500',
    rare: 'from-blue-600 to-blue-700 border-blue-500',
    epic: 'from-purple-600 to-purple-700 border-purple-500',
    legendary: 'from-yellow-600 to-orange-600 border-yellow-500',
  };

  const rarityTextColors = {
    common: 'text-slate-400',
    rare: 'text-blue-400',
    epic: 'text-purple-400',
    legendary: 'text-yellow-400',
  };

  return (
    <div className="p-4 space-y-4">
      {/* Slot Counter */}
      <div className="bg-slate-900/80 p-3 rounded-lg">
        <div className="flex justify-between items-center mb-2">
          <span className="text-slate-300">아티팩트 슬롯</span>
          <span className={`${equippedCount >= maxSlots ? 'text-red-400' : 'text-yellow-400'}`}>
            {equippedCount} / {maxSlots}
          </span>
        </div>
        <div className="flex gap-1">
          {Array.from({ length: maxSlots }).map((_, i) => (
            <div
              key={i}
              className={`flex-1 h-2 rounded-full ${
                i < equippedCount ? 'bg-yellow-500' : 'bg-slate-700'
              }`}
            />
          ))}
        </div>
      </div>

      {/* Artifacts Grid */}
      <div className="grid grid-cols-1 gap-3">
        {artifacts.map((artifact) => (
          <div
            key={artifact.id}
            className={`bg-slate-900/80 rounded-lg p-4 border transition-all ${
              artifact.equipped
                ? 'border-yellow-500/50 bg-slate-800/80'
                : 'border-slate-700 hover:border-slate-600'
            }`}
          >
            <div className="flex items-center gap-3 mb-3">
              <div className={`w-16 h-16 bg-gradient-to-br ${rarityColors[artifact.rarity]} rounded-lg flex items-center justify-center border-2 ${artifact.equipped ? 'ring-2 ring-yellow-500/50' : ''}`}>
                <artifact.icon className="w-8 h-8 text-white" />
              </div>
              <div className="flex-1">
                <h4 className="text-slate-200 mb-1">{artifact.name}</h4>
                <span className={`text-xs ${rarityTextColors[artifact.rarity]} uppercase tracking-wider`}>
                  {artifact.rarity === 'legendary' && '전설'}
                  {artifact.rarity === 'epic' && '영웅'}
                  {artifact.rarity === 'rare' && '희귀'}
                  {artifact.rarity === 'common' && '일반'}
                </span>
              </div>
              {artifact.equipped && (
                <span className="text-xs bg-yellow-500/20 text-yellow-400 px-2 py-1 rounded">
                  장착됨
                </span>
              )}
            </div>

            <p className="text-slate-300 text-sm mb-3 bg-slate-800/50 p-2 rounded">
              {artifact.effect}
            </p>

            <button
              className={`w-full py-2 rounded-md text-sm transition-colors ${
                artifact.equipped
                  ? 'bg-red-900/50 text-red-300 hover:bg-red-900/70'
                  : 'bg-yellow-900/50 text-yellow-300 hover:bg-yellow-900/70'
              }`}
            >
              {artifact.equipped ? '해제' : '장착'}
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
