import { Sparkles, Shield, Skull, Coins } from 'lucide-react';

export function ShopView() {
  const shopItems = [
    {
      id: 1,
      name: '스킬 뽑기',
      icon: Sparkles,
      description: '랜덤 스킬 획득',
      cost: 100,
      color: 'from-cyan-600 to-blue-600',
      iconColor: 'text-cyan-300',
    },
    {
      id: 2,
      name: '장비 뽑기',
      icon: Shield,
      description: '랜덤 장비 획득',
      cost: 150,
      color: 'from-purple-600 to-pink-600',
      iconColor: 'text-purple-300',
    },
    {
      id: 3,
      name: '보스 소환',
      icon: Skull,
      description: '보스를 즉시 소환하여 추가 보상 획득',
      cost: 200,
      color: 'from-red-600 to-orange-600',
      iconColor: 'text-red-300',
    },
  ];

  return (
    <div className="p-4 h-full flex flex-col">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-slate-200">상점</h3>
        <div className="flex items-center gap-2 bg-slate-900/80 px-3 py-1.5 rounded-lg border border-slate-700">
          <Coins className="w-4 h-4 text-yellow-400" />
          <span className="text-yellow-400">500 골드</span>
        </div>
      </div>

      <div className="space-y-3">
        {shopItems.map((item) => (
          <div
            key={item.id}
            className="bg-slate-900/80 rounded-lg border border-slate-700 hover:border-slate-600 transition-colors overflow-hidden"
          >
            <div className={`h-2 bg-gradient-to-r ${item.color}`} />
            <div className="p-4">
              <div className="flex items-start gap-4">
                <div className={`w-16 h-16 bg-gradient-to-br ${item.color} rounded-lg flex items-center justify-center flex-shrink-0`}>
                  <item.icon className={`w-8 h-8 ${item.iconColor}`} />
                </div>
                <div className="flex-1 min-w-0">
                  <h4 className="text-slate-200 mb-1">{item.name}</h4>
                  <p className="text-slate-400 text-sm mb-3">{item.description}</p>
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <Coins className="w-4 h-4 text-yellow-400" />
                      <span className="text-yellow-400">{item.cost} 골드</span>
                    </div>
                    <button className="px-4 py-2 bg-cyan-600 hover:bg-cyan-700 text-white rounded-lg transition-colors">
                      구매
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="mt-auto pt-4">
        <div className="bg-slate-900/80 border border-slate-700 rounded-lg p-3">
          <div className="text-slate-400 text-xs space-y-1">
            <p>• 스킬과 장비는 뽑기를 통해 획득할 수 있습니다</p>
            <p>• 보스는 강력하지만 처치 시 큰 보상을 제공합니다</p>
            <p>• 골드는 적 처치 시 획득됩니다</p>
          </div>
        </div>
      </div>
    </div>
  );
}
