import { useState } from 'react';
import { Sparkles, Gem, Zap, Coins } from 'lucide-react';
import { SkillsView } from './SkillsView';
import { ArtifactsView } from './ArtifactsView';

interface RightPanelProps {
  wave: number;
  gold: number;
}

type TabType = 'skills' | 'artifacts';

export function RightPanel({ wave, gold }: RightPanelProps) {
  const [activeTab, setActiveTab] = useState<TabType>('skills');

  const tabs = [
    { id: 'skills' as const, name: '스킬', icon: Sparkles },
    { id: 'artifacts' as const, name: '아티팩트', icon: Gem },
  ];

  return (
    <div className="size-full bg-slate-800/50 backdrop-blur-sm flex flex-col">
      {/* Stats Section */}
      <div className="bg-slate-900/80 p-3 border-b border-slate-700">
        <div className="space-y-2">
          <div className="flex items-center justify-between text-slate-300">
            <div className="flex items-center gap-2">
              <Zap className="w-4 h-4 text-blue-400" />
              <span className="text-sm">웨이브</span>
            </div>
            <span className="text-blue-400">{wave}</span>
          </div>

          <div className="flex items-center justify-between text-slate-300">
            <div className="flex items-center gap-2">
              <Coins className="w-4 h-4 text-yellow-400" />
              <span className="text-sm">보유 골드</span>
            </div>
            <span className="text-yellow-400">{gold.toLocaleString()}</span>
          </div>
        </div>
      </div>

      {/* Tab Navigation */}
      <div className="flex bg-slate-900/80 border-b border-slate-700">
        {tabs.map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`flex-1 py-2 px-1 flex flex-col items-center gap-0.5 transition-colors border-b-2 ${
              activeTab === tab.id
                ? 'border-cyan-500 bg-slate-800/50 text-cyan-400'
                : 'border-transparent text-slate-400 hover:text-slate-300 hover:bg-slate-800/30'
            }`}
          >
            <tab.icon className="w-4 h-4" />
            <span className="text-xs">{tab.name}</span>
          </button>
        ))}
      </div>

      {/* Tab Content */}
      <div className="flex-1 overflow-hidden">
        {activeTab === 'skills' && <SkillsView />}
        {activeTab === 'artifacts' && <ArtifactsView />}
      </div>
    </div>
  );
}