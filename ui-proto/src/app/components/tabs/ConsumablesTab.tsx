import { FlaskConical, Heart, Sparkles, Shield, Zap } from 'lucide-react';

interface Consumable {
  id: number;
  name: string;
  icon: React.ElementType;
  effect: string;
  quantity: number;
  color: string;
  equipped: boolean;
}

export function ConsumablesTab() {
  const consumables: Consumable[] = [
    { id: 1, name: '체력 물약', icon: Heart, effect: '체력 50% 즉시 회복', quantity: 3, color: 'text-red-400', equipped: true },
    { id: 2, name: '마나 물약', icon: Sparkles, effect: '마나 50% 즉시 회복', quantity: 5, color: 'text-cyan-400', equipped: true },
    { id: 3, name: '방어 물약', icon: Shield, effect: '30초간 받는 피해 50% 감소', quantity: 2, color: 'text-blue-400', equipped: false },
    { id: 4, name: '힘의 물약', icon: Zap, effect: '30초간 공격력 50% 증가', quantity: 2, color: 'text-yellow-400', equipped: false },
  ];

  const maxSlots = 2;
  const equippedCount = consumables.filter(c => c.equipped).length;

  return (
    <div className="p-4 space-y-4">
      {/* Slot Counter */}
      <div className="bg-slate-900/80 p-3 rounded-lg">
        <div className="flex justify-between items-center mb-2">
          <span className="text-slate-300">퀵슬롯</span>
          <span className={`${equippedCount >= maxSlots ? 'text-red-400' : 'text-green-400'}`}>
            {equippedCount} / {maxSlots}
          </span>
        </div>
        <div className="flex gap-1">
          {Array.from({ length: maxSlots }).map((_, i) => (
            <div
              key={i}
              className={`flex-1 h-2 rounded-full ${
                i < equippedCount ? 'bg-green-500' : 'bg-slate-700'
              }`}
            />
          ))}
        </div>
        <p className="text-slate-500 text-xs mt-2">
          퀵슬롯에 등록된 소모품은 전투 중 빠르게 사용할 수 있습니다
        </p>
      </div>

      {/* Consumables List */}
      <div className="space-y-2">
        {consumables.map((consumable) => (
          <div
            key={consumable.id}
            className={`bg-slate-900/80 rounded-lg p-3 border transition-all ${
              consumable.equipped
                ? 'border-green-500/50 bg-slate-800/80'
                : 'border-slate-700 hover:border-slate-600'
            }`}
          >
            <div className="flex items-center gap-3">
              <div className={`relative w-14 h-14 bg-slate-800 rounded-lg flex items-center justify-center border border-slate-700 ${consumable.equipped ? 'ring-2 ring-green-500/50' : ''}`}>
                <consumable.icon className={`w-7 h-7 ${consumable.color}`} />
                <div className="absolute -top-1 -right-1 bg-slate-900 border border-slate-700 rounded-full w-6 h-6 flex items-center justify-center">
                  <span className="text-xs text-slate-300">{consumable.quantity}</span>
                </div>
              </div>

              <div className="flex-1">
                <div className="flex items-center gap-2 mb-1">
                  <h4 className="text-slate-200">{consumable.name}</h4>
                  {consumable.equipped && (
                    <span className="text-xs bg-green-500/20 text-green-400 px-2 py-0.5 rounded">
                      등록됨
                    </span>
                  )}
                </div>
                <p className="text-slate-400 text-sm">{consumable.effect}</p>
              </div>

              <div className="flex flex-col gap-1">
                <button
                  className={`px-3 py-1 rounded-md text-sm transition-colors ${
                    consumable.equipped
                      ? 'bg-red-900/50 text-red-300 hover:bg-red-900/70'
                      : 'bg-green-900/50 text-green-300 hover:bg-green-900/70'
                  }`}
                >
                  {consumable.equipped ? '해제' : '등록'}
                </button>
                <button className="px-3 py-1 rounded-md text-sm bg-slate-700/50 text-slate-300 hover:bg-slate-700/70 transition-colors">
                  사용
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Info Box */}
      <div className="bg-slate-900/80 p-3 rounded-lg border border-slate-700">
        <div className="flex items-start gap-2">
          <FlaskConical className="w-4 h-4 text-slate-400 mt-0.5" />
          <div className="text-slate-400 text-xs">
            <p>소모품은 전투 중 언제든지 사용할 수 있습니다.</p>
            <p className="mt-1">퀵슬롯에 등록하면 단축키로 빠르게 사용 가능합니다.</p>
          </div>
        </div>
      </div>
    </div>
  );
}
