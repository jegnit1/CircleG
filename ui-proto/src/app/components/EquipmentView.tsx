import { Sword, Shield, Gem } from 'lucide-react';

interface Equipment {
  id: number;
  name: string;
  type: 'weapon' | 'armor' | 'accessory';
  rarity: 'rare' | 'epic' | 'legendary';
  stats: string[];
}

export function EquipmentView() {
  const equipment = {
    weapon: { id: 1, name: '불멸의 검', rarity: 'legendary' as const, stats: ['공격력 +45', '치명타 +20%'] },
    armor: { id: 2, name: '드래곤 플레이트', rarity: 'epic' as const, stats: ['방어력 +50', '체력 +100'] },
    accessory: { id: 3, name: '마나 반지', rarity: 'epic' as const, stats: ['마나 +50', '마나 회복 +10/초'] },
  };

  const rarityColors = {
    rare: 'from-blue-600 to-blue-700 border-blue-500',
    epic: 'from-purple-600 to-purple-700 border-purple-500',
    legendary: 'from-yellow-600 to-orange-600 border-yellow-500',
  };

  const rarityTextColors = {
    rare: 'text-blue-400',
    epic: 'text-purple-400',
    legendary: 'text-yellow-400',
  };

  const typeIcons = {
    weapon: Sword,
    armor: Shield,
    accessory: Gem,
  };

  const typeNames = {
    weapon: '무기',
    armor: '방어구',
    accessory: '장신구',
  };

  return (
    <div className="p-3 h-full flex flex-col gap-3">
      {(['weapon', 'armor', 'accessory'] as const).map((type) => {
        const item = equipment[type];
        const Icon = typeIcons[type];

        return (
          <div key={type} className="bg-slate-900/80 rounded-lg p-3 border border-slate-700">
            <div className="text-slate-400 text-xs mb-2">{typeNames[type]}</div>
            <div className="flex items-start gap-3">
              <div className={`w-14 h-14 bg-gradient-to-br ${rarityColors[item.rarity]} rounded-lg flex items-center justify-center border-2 flex-shrink-0`}>
                <Icon className="w-7 h-7 text-white" />
              </div>
              <div className="flex-1 min-w-0">
                <div className="text-slate-200 text-sm mb-0.5">{item.name}</div>
                <div className={`text-xs ${rarityTextColors[item.rarity]} mb-1`}>
                  {item.rarity === 'legendary' ? '전설' : item.rarity === 'epic' ? '영웅' : '희귀'}
                </div>
                <div className="space-y-0.5">
                  {item.stats.map((stat, i) => (
                    <div key={i} className="text-xs text-green-400">+ {stat}</div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
}
