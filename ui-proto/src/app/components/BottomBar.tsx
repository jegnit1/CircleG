import { Sparkles, Sword, Shield, Gem as Ring, FlaskConical, Skull, ShoppingBag } from 'lucide-react';

export function BottomBar() {
  // Mock equipment data
  const equipment = {
    weapon: { name: '화염의 검', icon: Sword, color: 'text-red-400', level: 5 },
    armor: { name: '강철 갑옷', icon: Shield, color: 'text-blue-400', level: 3 },
    accessory: { name: '마법 반지', icon: Ring, color: 'text-purple-400', level: 4 },
  };

  const consumables = [
    { id: 1, name: '피해 증가 물약', icon: FlaskConical, color: 'text-red-400', quantity: 3 },
    { id: 2, name: '속도 증가 물약', icon: FlaskConical, color: 'text-cyan-400', quantity: 5 },
  ];

  return (
    <div className="size-full bg-slate-900/90 backdrop-blur-sm flex items-center px-6 gap-6">
      {/* Action Buttons Section */}
      <div className="flex gap-2">
        <button className="px-4 py-3 bg-purple-900/50 hover:bg-purple-900/70 text-purple-300 rounded-lg border border-purple-700 transition-colors flex items-center gap-2">
          <Sparkles className="w-4 h-4" />
          <span>스킬 뽑기</span>
        </button>
        <button className="px-4 py-3 bg-blue-900/50 hover:bg-blue-900/70 text-blue-300 rounded-lg border border-blue-700 transition-colors flex items-center gap-2">
          <ShoppingBag className="w-4 h-4" />
          <span>장비 뽑기</span>
        </button>
        <button className="px-4 py-3 bg-red-900/50 hover:bg-red-900/70 text-red-300 rounded-lg border border-red-700 transition-colors flex items-center gap-2">
          <Skull className="w-4 h-4" />
          <span>보스 소환</span>
        </button>
      </div>

      {/* Divider */}
      <div className="w-px h-16 bg-slate-700"></div>

      {/* Equipment Status Section */}
      <div className="flex-1 flex items-center gap-3">
        <div className="text-slate-400 mr-2 min-w-fit">장비 현황</div>
        
        {/* Weapon */}
        <div className="flex-1 bg-slate-800 rounded-lg p-2 border border-slate-700 relative group cursor-pointer hover:bg-slate-700/50 transition-colors">
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 bg-slate-900 rounded-lg flex items-center justify-center">
              <equipment.weapon.icon className={`w-5 h-5 ${equipment.weapon.color}`} />
            </div>
            <div className="flex-1">
              <div className="text-slate-300 text-sm">{equipment.weapon.name}</div>
              <div className="text-xs text-slate-500">Lv. {equipment.weapon.level}</div>
            </div>
          </div>
        </div>

        {/* Armor */}
        <div className="flex-1 bg-slate-800 rounded-lg p-2 border border-slate-700 relative group cursor-pointer hover:bg-slate-700/50 transition-colors">
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 bg-slate-900 rounded-lg flex items-center justify-center">
              <equipment.armor.icon className={`w-5 h-5 ${equipment.armor.color}`} />
            </div>
            <div className="flex-1">
              <div className="text-slate-300 text-sm">{equipment.armor.name}</div>
              <div className="text-xs text-slate-500">Lv. {equipment.armor.level}</div>
            </div>
          </div>
        </div>

        {/* Accessory */}
        <div className="flex-1 bg-slate-800 rounded-lg p-2 border border-slate-700 relative group cursor-pointer hover:bg-slate-700/50 transition-colors">
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 bg-slate-900 rounded-lg flex items-center justify-center">
              <equipment.accessory.icon className={`w-5 h-5 ${equipment.accessory.color}`} />
            </div>
            <div className="flex-1">
              <div className="text-slate-300 text-sm">{equipment.accessory.name}</div>
              <div className="text-xs text-slate-500">Lv. {equipment.accessory.level}</div>
            </div>
          </div>
        </div>
      </div>

      {/* Divider */}
      <div className="w-px h-16 bg-slate-700"></div>

      {/* Consumables Section */}
      <div className="flex items-center gap-2">
        <div className="text-slate-400 mr-2 min-w-fit">소모품</div>
        {consumables.map((consumable) => (
          <button
            key={consumable.id}
            className="w-20 bg-slate-800 hover:bg-slate-700 rounded-lg p-2 border border-slate-700 transition-colors relative"
          >
            {/* Quantity indicator */}
            <div className="absolute -top-2 -right-2 w-6 h-6 bg-slate-900 rounded-full border border-slate-700 flex items-center justify-center text-xs text-slate-300">
              {consumable.quantity}
            </div>

            <div className="flex flex-col items-center gap-1">
              <div className="w-10 h-10 bg-slate-900 rounded-lg flex items-center justify-center">
                <consumable.icon className={`w-6 h-6 ${consumable.color}`} />
              </div>
              <div className="text-slate-300 text-xs truncate w-full text-center">{consumable.name}</div>
            </div>
          </button>
        ))}
      </div>
    </div>
  );
}