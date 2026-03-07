import { Crown, Diamond, Gem, Star, Sparkles } from 'lucide-react';

interface Artifact {
  id: number;
  name: string;
  rarity: 'rare' | 'epic' | 'legendary';
  icon: React.ElementType;
  effect: string;
}

export function ArtifactsView() {
  const artifacts: Artifact[] = [
    { id: 1, name: '시간의 모래시계', rarity: 'legendary', icon: Crown, effect: '쿨다운 -25%' },
    { id: 2, name: '마나의 결정', rarity: 'epic', icon: Diamond, effect: '최대 마나 +50' },
    { id: 3, name: '불사조 깃털', rarity: 'rare', icon: Sparkles, effect: '부활 1회' },
    { id: 4, name: '고대의 유물', rarity: 'epic', icon: Gem, effect: '피해 +30%' },
    { id: 5, name: '수호자 징표', rarity: 'rare', icon: Star, effect: '방어력 +20' },
  ];

  const rarityColors = {
    rare: 'from-blue-600 to-blue-700',
    epic: 'from-purple-600 to-purple-700',
    legendary: 'from-yellow-600 to-orange-600',
  };

  return (
    <div className="p-3 h-full flex flex-col">
      <div className="text-slate-300 text-sm mb-2 flex items-center justify-between">
        <span>보유 아티팩트</span>
        <span className="text-yellow-400">{artifacts.length}/5</span>
      </div>

      <div className="grid grid-cols-3 gap-2">
        {artifacts.map((artifact) => (
          <div key={artifact.id} className="group relative">
            <div className={`w-full aspect-square bg-gradient-to-br ${rarityColors[artifact.rarity]} rounded-lg flex items-center justify-center border-2 border-slate-700 hover:border-yellow-500 transition-colors cursor-pointer`}>
              <artifact.icon className="w-8 h-8 text-white" />
            </div>

            {/* Hover tooltip */}
            <div className="absolute left-full ml-2 top-0 bg-slate-900 border border-slate-700 rounded-lg p-2 opacity-0 group-hover:opacity-100 pointer-events-none transition-opacity z-10 whitespace-nowrap">
              <div className="text-slate-200 text-sm mb-1">{artifact.name}</div>
              <div className="text-slate-400 text-xs mb-1">{artifact.effect}</div>
              <div className={`text-xs ${
                artifact.rarity === 'legendary' ? 'text-yellow-400' :
                artifact.rarity === 'epic' ? 'text-purple-400' : 'text-blue-400'
              }`}>
                {artifact.rarity === 'legendary' ? '전설' : artifact.rarity === 'epic' ? '영웅' : '희귀'}
              </div>
            </div>
          </div>
        ))}
        {Array.from({ length: 5 - artifacts.length }).map((_, i) => (
          <div key={`empty-${i}`} className="w-full aspect-square bg-slate-900/50 rounded-lg border border-slate-700 border-dashed" />
        ))}
      </div>

      <div className="mt-auto pt-3 text-xs text-slate-500 bg-slate-900/50 p-2 rounded">
        아티팩트는 영구적인 효과를 제공합니다
      </div>
    </div>
  );
}
