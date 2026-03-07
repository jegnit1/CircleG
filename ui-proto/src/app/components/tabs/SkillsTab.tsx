import { useState } from 'react';
import { Flame, Snowflake, Zap, Wind, Shield, Swords, Target, Wand2 } from 'lucide-react';

type SkillType = 'active' | 'passive';

interface Skill {
  id: number;
  name: string;
  type: SkillType;
  icon: React.ElementType;
  manaCost?: number;
  cooldown?: number;
  description: string;
  color: string;
  equipped: boolean;
}

export function SkillsTab() {
  const [skillType, setSkillType] = useState<SkillType>('active');

  const activeSkills: Skill[] = [
    { id: 1, name: '화염구', type: 'active', icon: Flame, manaCost: 20, cooldown: 5, description: '강력한 화염구를 발사', color: 'text-orange-400', equipped: true },
    { id: 2, name: '얼음 폭풍', type: 'active', icon: Snowflake, manaCost: 35, cooldown: 10, description: '적을 느리게 하고 피해', color: 'text-cyan-400', equipped: true },
    { id: 3, name: '번개', type: 'active', icon: Zap, manaCost: 25, cooldown: 7, description: '순간 강타', color: 'text-yellow-400', equipped: true },
    { id: 4, name: '회오리', type: 'active', icon: Wind, manaCost: 30, cooldown: 8, description: '범위 공격', color: 'text-green-400', equipped: false },
    { id: 5, name: '성스러운 빛', type: 'active', icon: Wand2, manaCost: 40, cooldown: 12, description: '광역 피해와 치유', color: 'text-purple-400', equipped: false },
  ];

  const passiveSkills: Skill[] = [
    { id: 11, name: '마나 회복', type: 'passive', icon: Shield, description: '마나 자동 회복 +5/초', color: 'text-blue-400', equipped: true },
    { id: 12, name: '강화 방어', type: 'passive', icon: Shield, description: '받는 피해 -10%', color: 'text-slate-400', equipped: true },
    { id: 13, name: '공격력 증가', type: 'passive', icon: Swords, description: '모든 스킬 피해 +15%', color: 'text-red-400', equipped: true },
    { id: 14, name: '집중', type: 'passive', icon: Target, description: '치명타 확률 +20%', color: 'text-yellow-400', equipped: false },
    { id: 15, name: '신속', type: 'passive', icon: Wind, description: '쿨다운 -10%', color: 'text-green-400', equipped: false },
  ];

  const skills = skillType === 'active' ? activeSkills : passiveSkills;
  const maxSlots = 7;
  const equippedCount = skills.filter(s => s.equipped).length;

  return (
    <div className="p-4 space-y-4">
      {/* Skill Type Toggle */}
      <div className="flex gap-2 bg-slate-900/80 p-1 rounded-lg">
        <button
          onClick={() => setSkillType('active')}
          className={`flex-1 py-2 rounded-md transition-colors ${
            skillType === 'active'
              ? 'bg-cyan-600 text-white'
              : 'text-slate-400 hover:text-slate-300'
          }`}
        >
          액티브 스킬
        </button>
        <button
          onClick={() => setSkillType('passive')}
          className={`flex-1 py-2 rounded-md transition-colors ${
            skillType === 'passive'
              ? 'bg-purple-600 text-white'
              : 'text-slate-400 hover:text-slate-300'
          }`}
        >
          패시브 스킬
        </button>
      </div>

      {/* Slot Counter */}
      <div className="bg-slate-900/80 p-3 rounded-lg">
        <div className="flex justify-between items-center mb-2">
          <span className="text-slate-300">장착 슬롯</span>
          <span className={`${equippedCount >= maxSlots ? 'text-red-400' : 'text-cyan-400'}`}>
            {equippedCount} / {maxSlots}
          </span>
        </div>
        <div className="flex gap-1">
          {Array.from({ length: maxSlots }).map((_, i) => (
            <div
              key={i}
              className={`flex-1 h-2 rounded-full ${
                i < equippedCount ? 'bg-cyan-500' : 'bg-slate-700'
              }`}
            />
          ))}
        </div>
      </div>

      {/* Skills List */}
      <div className="space-y-2">
        {skills.map((skill) => (
          <div
            key={skill.id}
            className={`bg-slate-900/80 rounded-lg p-3 border transition-all ${
              skill.equipped
                ? 'border-cyan-500/50 bg-slate-800/80'
                : 'border-slate-700 hover:border-slate-600'
            }`}
          >
            <div className="flex items-start gap-3">
              <div className={`w-12 h-12 bg-slate-800 rounded-lg flex items-center justify-center border border-slate-700 ${skill.equipped ? 'ring-2 ring-cyan-500/50' : ''}`}>
                <skill.icon className={`w-6 h-6 ${skill.color}`} />
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center justify-between mb-1">
                  <h4 className="text-slate-200">{skill.name}</h4>
                  {skill.equipped && (
                    <span className="text-xs bg-cyan-500/20 text-cyan-400 px-2 py-0.5 rounded">
                      장착됨
                    </span>
                  )}
                </div>
                <p className="text-slate-400 text-sm mb-2">{skill.description}</p>
                {skill.type === 'active' && (
                  <div className="flex gap-3 text-xs text-slate-500">
                    <span>마나: {skill.manaCost}</span>
                    <span>쿨다운: {skill.cooldown}초</span>
                  </div>
                )}
              </div>
              <button
                className={`px-3 py-1 rounded-md text-sm transition-colors ${
                  skill.equipped
                    ? 'bg-red-900/50 text-red-300 hover:bg-red-900/70'
                    : 'bg-cyan-900/50 text-cyan-300 hover:bg-cyan-900/70'
                }`}
              >
                {skill.equipped ? '해제' : '장착'}
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
