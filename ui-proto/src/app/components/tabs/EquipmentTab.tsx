import { Sword, Shield, Gem } from 'lucide-react';

interface Equipment {
  id: number;
  name: string;
  type: 'weapon' | 'armor' | 'accessory';
  rarity: 'common' | 'rare' | 'epic' | 'legendary';
  stats: string[];
  equipped: boolean;
}

export function EquipmentTab() {
  const equipment: Equipment[] = [
    {
      id: 1,
      name: '불멸의 검',
      type: 'weapon',
      rarity: 'legendary',
      stats: ['공격력 +45', '치명타 +20%', '화염 피해 +30'],
      equipped: true
    },
    {
      id: 2,
      name: '강철 검',
      type: 'weapon',
      rarity: 'rare',
      stats: ['공격력 +25', '공격속도 +10%'],
      equipped: false
    },
    {
      id: 3,
      name: '드래곤 플레이트',
      type: 'armor',
      rarity: 'epic',
      stats: ['방어력 +50', '체력 +100', '화염 저항 +25%'],
      equipped: true
    },
    {
      id: 4,
      name: '가죽 갑옷',
      type: 'armor',
      rarity: 'common',
      stats: ['방어력 +15', '회피 +5%'],
      equipped: false
    },
    {
      id: 5,
      name: '마나 반지',
      type: 'accessory',
      rarity: 'epic',
      stats: ['최대 마나 +50', '마나 회복 +10/초'],
      equipped: true
    },
    {
      id: 6,
      name: '신속의 부적',
      type: 'accessory',
      rarity: 'rare',
      stats: ['이동속도 +15%', '쿨다운 -10%'],
      equipped: false
    },
  ];

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

  const groupedEquipment = {
    weapon: equipment.filter(e => e.type === 'weapon'),
    armor: equipment.filter(e => e.type === 'armor'),
    accessory: equipment.filter(e => e.type === 'accessory'),
  };

  return (
    <div className="p-4 space-y-4">
      {/* Equipment Slots Overview */}
      <div className="bg-slate-900/80 p-4 rounded-lg grid grid-cols-3 gap-3">
        {(['weapon', 'armor', 'accessory'] as const).map((type) => {
          const Icon = typeIcons[type];
          const equipped = equipment.find(e => e.type === type && e.equipped);
          return (
            <div key={type} className="text-center">
              <div className={`w-14 h-14 mx-auto mb-2 bg-gradient-to-br ${equipped ? rarityColors[equipped.rarity] : 'from-slate-700 to-slate-800'} rounded-lg flex items-center justify-center border-2 ${equipped ? 'border-opacity-70' : 'border-slate-600'}`}>
                <Icon className="w-7 h-7 text-white" />
              </div>
              <div className="text-xs text-slate-400">{typeNames[type]}</div>
              {equipped && (
                <div className={`text-xs ${rarityTextColors[equipped.rarity]} mt-1 truncate`}>
                  {equipped.name}
                </div>
              )}
            </div>
          );
        })}
      </div>

      {/* Equipment Lists by Type */}
      {(['weapon', 'armor', 'accessory'] as const).map((type) => (
        <div key={type}>
          <h3 className="text-slate-300 mb-2 flex items-center gap-2">
            {React.createElement(typeIcons[type], { className: 'w-4 h-4' })}
            {typeNames[type]}
          </h3>
          <div className="space-y-2">
            {groupedEquipment[type].map((item) => (
              <div
                key={item.id}
                className={`bg-slate-900/80 rounded-lg p-3 border transition-all ${
                  item.equipped
                    ? 'border-cyan-500/50 bg-slate-800/80'
                    : 'border-slate-700 hover:border-slate-600'
                }`}
              >
                <div className="flex items-start gap-3">
                  <div className={`w-12 h-12 bg-gradient-to-br ${rarityColors[item.rarity]} rounded-lg flex items-center justify-center border-2 ${item.equipped ? 'ring-2 ring-cyan-500/50' : ''}`}>
                    {React.createElement(typeIcons[item.type], { className: 'w-6 h-6 text-white' })}
                  </div>

                  <div className="flex-1">
                    <div className="flex items-center justify-between mb-1">
                      <h4 className="text-slate-200">{item.name}</h4>
                      {item.equipped && (
                        <span className="text-xs bg-cyan-500/20 text-cyan-400 px-2 py-0.5 rounded">
                          장착됨
                        </span>
                      )}
                    </div>
                    <span className={`text-xs ${rarityTextColors[item.rarity]} uppercase tracking-wider`}>
                      {item.rarity === 'legendary' && '전설'}
                      {item.rarity === 'epic' && '영웅'}
                      {item.rarity === 'rare' && '희귀'}
                      {item.rarity === 'common' && '일반'}
                    </span>
                    <div className="mt-2 space-y-1">
                      {item.stats.map((stat, i) => (
                        <div key={i} className="text-xs text-green-400">
                          + {stat}
                        </div>
                      ))}
                    </div>
                  </div>

                  <button
                    className={`px-3 py-1 rounded-md text-sm transition-colors ${
                      item.equipped
                        ? 'bg-red-900/50 text-red-300 hover:bg-red-900/70'
                        : 'bg-cyan-900/50 text-cyan-300 hover:bg-cyan-900/70'
                    }`}
                  >
                    {item.equipped ? '해제' : '장착'}
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      ))}
    </div>
  );
}
