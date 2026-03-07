import { Heart, Sparkles, Shield, Zap } from 'lucide-react';

interface Consumable {
  id: number;
  name: string;
  icon: React.ElementType;
  effect: string;
  quantity: number;
  color: string;
  key: string;
}

export function ConsumablesView() {
  const consumables: Consumable[] = [
    { id: 1, name: '체력 물약', icon: Heart, effect: '체력 50% 회복', quantity: 3, color: 'bg-red-600', key: '1' },
    { id: 2, name: '마나 물약', icon: Sparkles, effect: '마나 50% 회복', quantity: 5, color: 'bg-cyan-600', key: '2' },
    { id: 3, name: '방어 물약', icon: Shield, effect: '30초간 피해 -50%', quantity: 2, color: 'bg-blue-600', key: '' },
    { id: 4, name: '힘의 물약', icon: Zap, effect: '30초간 공격력 +50%', quantity: 2, color: 'bg-yellow-600', key: '' },
  ];

  const quickSlots = consumables.filter(c => c.key);

  return (
    <div className="p-3 h-full flex flex-col gap-4">
      {/* Quick Slots */}
      <div>
        <div className="text-slate-300 text-sm mb-2">퀵슬롯 (단축키 사용)</div>
        <div className="grid grid-cols-2 gap-2">
          {quickSlots.map((item) => (
            <button
              key={item.id}
              className="bg-slate-900/80 rounded-lg p-2 border border-cyan-500/50 hover:bg-slate-800 transition-colors relative"
            >
              <div className="absolute top-1 left-1 bg-slate-700 rounded px-1.5 py-0.5 text-xs text-slate-300">
                {item.key}
              </div>
              <div className="absolute top-1 right-1 bg-slate-900 rounded-full px-1.5 py-0.5 text-xs text-slate-300">
                {item.quantity}
              </div>
              <div className="flex flex-col items-center gap-1 pt-4">
                <div className={`w-12 h-12 ${item.color} rounded-lg flex items-center justify-center`}>
                  <item.icon className="w-7 h-7 text-white" />
                </div>
                <div className="text-slate-300 text-xs">{item.name}</div>
                <div className="text-slate-500 text-xs text-center">{item.effect}</div>
              </div>
            </button>
          ))}
        </div>
      </div>

      {/* All Consumables */}
      <div className="flex-1">
        <div className="text-slate-300 text-sm mb-2">전체 소모품</div>
        <div className="space-y-2">
          {consumables.map((item) => (
            <div
              key={item.id}
              className={`bg-slate-900/80 rounded-lg p-2 border transition-colors flex items-center gap-3 ${
                item.key ? 'border-cyan-500/30' : 'border-slate-700 hover:border-slate-600'
              }`}
            >
              <div className={`w-10 h-10 ${item.color} rounded-lg flex items-center justify-center relative flex-shrink-0`}>
                <item.icon className="w-6 h-6 text-white" />
                <div className="absolute -top-1 -right-1 bg-slate-900 rounded-full w-5 h-5 flex items-center justify-center border border-slate-700">
                  <span className="text-xs text-slate-300">{item.quantity}</span>
                </div>
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2">
                  <span className="text-slate-200 text-sm">{item.name}</span>
                  {item.key && (
                    <span className="text-xs bg-cyan-500/20 text-cyan-400 px-1.5 py-0.5 rounded">
                      {item.key}
                    </span>
                  )}
                </div>
                <div className="text-slate-400 text-xs">{item.effect}</div>
              </div>
              <button className="px-3 py-1 rounded text-xs bg-cyan-900/50 text-cyan-300 hover:bg-cyan-900/70 transition-colors flex-shrink-0">
                {item.key ? '해제' : '등록'}
              </button>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
