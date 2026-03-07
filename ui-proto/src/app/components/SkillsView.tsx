import {
  Flame,
  Snowflake,
  Zap,
  Wind,
  Shield,
  Swords,
  Target,
  Wand2,
} from "lucide-react";

interface Skill {
  id: number;
  name: string;
  type: "active" | "passive";
  icon: React.ElementType;
  description: string;
  color: string;
  level: number;
}

export function SkillsView() {
  const activeSkills: Skill[] = [
    {
      id: 1,
      name: "화염구",
      type: "active",
      icon: Flame,
      description: "화염 피해",
      color: "bg-orange-500",
      level: 3,
    },
    {
      id: 2,
      name: "얼음 폭풍",
      type: "active",
      icon: Snowflake,
      description: "광역 둔화",
      color: "bg-cyan-500",
      level: 2,
    },
    {
      id: 3,
      name: "번개",
      type: "active",
      icon: Zap,
      description: "순간 강타",
      color: "bg-yellow-500",
      level: 4,
    },
    {
      id: 4,
      name: "회오리",
      type: "active",
      icon: Wind,
      description: "범위 공격",
      color: "bg-green-500",
      level: 1,
    },
    {
      id: 5,
      name: "성스러운 빛",
      type: "active",
      icon: Wand2,
      description: "광역 피해",
      color: "bg-purple-500",
      level: 2,
    },
    {
      id: 6,
      name: "암흑 화살",
      type: "active",
      icon: Target,
      description: "관통 피해",
      color: "bg-gray-600",
      level: 1,
    },
    {
      id: 7,
      name: "폭발",
      type: "active",
      icon: Flame,
      description: "대폭발",
      color: "bg-red-600",
      level: 3,
    },
  ];

  const passiveSkills: Skill[] = [
    {
      id: 11,
      name: "마나 회복",
      type: "passive",
      icon: Shield,
      description: "+5 마나/초",
      color: "bg-blue-500",
      level: 3,
    },
    {
      id: 12,
      name: "강화 방어",
      type: "passive",
      icon: Shield,
      description: "-10% 피해",
      color: "bg-slate-500",
      level: 2,
    },
    {
      id: 13,
      name: "공격력",
      type: "passive",
      icon: Swords,
      description: "+15% 피해",
      color: "bg-red-500",
      level: 4,
    },
    {
      id: 14,
      name: "치명타",
      type: "passive",
      icon: Target,
      description: "+20% 확률",
      color: "bg-yellow-500",
      level: 1,
    },
    {
      id: 15,
      name: "신속",
      type: "passive",
      icon: Wind,
      description: "-10% 쿨다운",
      color: "bg-green-500",
      level: 2,
    },
  ];

  const SkillIcon = ({ skill }: { skill: Skill }) => (
    <div className="group relative">
      <div
        className={`w-full aspect-square ${skill.color} rounded-lg flex flex-col items-center justify-center border border-slate-700 hover:border-cyan-500 transition-colors cursor-pointer`}
      >
        <skill.icon className="w-6 h-6 text-white mb-1" />
        <div className="absolute bottom-0.5 right-0.5 bg-slate-900 rounded px-1 text-xs text-white">
          {skill.level}
        </div>
      </div>

      {/* Hover tooltip */}
      <div className="absolute left-full ml-2 top-0 bg-slate-900 border border-slate-700 rounded-lg p-2 opacity-0 group-hover:opacity-100 pointer-events-none transition-opacity z-10 whitespace-nowrap">
        <div className="text-slate-200 text-sm mb-1">
          {skill.name}
        </div>
        <div className="text-slate-400 text-xs">
          {skill.description}
        </div>
        <div className="text-cyan-400 text-xs mt-1">
          레벨 {skill.level}
        </div>
      </div>
    </div>
  );

  return (
    <div className="p-3 space-y-3 h-full flex flex-col">
      {/* Active Skills */}
      <div className="flex-1">
        <div className="text-slate-300 text-sm mb-2 flex items-center justify-between">
          <span>액티브 스킬 (자동 시전)</span>
          <span className="text-cyan-400">
            {activeSkills.length}/7
          </span>
        </div>
        <div className="grid grid-cols-4 gap-2">
          {activeSkills.map((skill) => (
            <SkillIcon key={skill.id} skill={skill} />
          ))}
          {Array.from({ length: 7 - activeSkills.length }).map(
            (_, i) => (
              <div
                key={`empty-${i}`}
                className="w-full aspect-square bg-slate-900/50 rounded-lg border border-slate-700 border-dashed"
              />
            ),
          )}
        </div>
      </div>

      {/* Passive Skills */}
      <div className="flex-1">
        <div className="text-slate-300 text-sm mb-2 flex items-center justify-between">
          <span>패시브 스킬</span>
          <span className="text-purple-400">
            {passiveSkills.length}/7
          </span>
        </div>
        <div className="grid grid-cols-4 gap-2">
          {passiveSkills.map((skill) => (
            <SkillIcon key={skill.id} skill={skill} />
          ))}
          {Array.from({ length: 7 - passiveSkills.length }).map(
            (_, i) => (
              <div
                key={`empty-${i}`}
                className="w-full aspect-square bg-slate-900/50 rounded-lg border border-slate-700 border-dashed"
              />
            ),
          )}
        </div>
      </div>
    </div>
  );
}