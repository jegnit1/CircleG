extends Node

# 재화 및 상태 갱신 신호
signal gold_updated(current_gold: int)
signal creep_count_updated(current_count: int, max_count: int)
signal round_updated(current_round: int)

# 팝업 및 UI 조작 신호
signal draw_popup_requested(draw_type: String)
