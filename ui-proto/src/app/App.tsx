import { useState } from 'react';
import { BattleArea } from './components/BattleArea';
import { RightPanel } from './components/RightPanel';
import { BottomBar } from './components/BottomBar';

export default function App() {
  const [wave, setWave] = useState(1);
  const [gold, setGold] = useState(1000);

  return (
    <div className="size-full flex flex-col bg-slate-900 overflow-hidden">
      {/* Main content area - takes remaining space after bottom bar */}
      <div className="flex-1 flex overflow-hidden">
        {/* Battle Area - left 2/3 of the screen */}
        <div className="flex-[2] relative">
          <BattleArea />
        </div>

        {/* Right Panel - right 1/3 of the screen */}
        <div className="flex-[1] border-l border-slate-700">
          <RightPanel wave={wave} gold={gold} />
        </div>
      </div>

      {/* Bottom Bar - fixed height, 1/5 of screen */}
      <div className="h-[20vh] border-t border-slate-700">
        <BottomBar />
      </div>
    </div>
  );
}