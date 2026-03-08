extends Marker2D
# scripts/tower.gd (타워에 붙어있는 스크립트)

# 장착된 스킬들과 각각의 쿨타임을 관리할 가방(배열)
var active_skills: Array[Dictionary] = []
var base_damage: float = DataManager.player_stats["base_damage"]

func _ready() -> void:
	# 🌟 [추가] UI에서 스킬을 선택했다는 신호를 귀 기울여 듣습니다.
	GlobalSignalBus.skill_equipped.connect(_on_skill_equipped)

# 신호를 받으면 실행되는 함수
func _on_skill_equipped(new_skill: SkillData) -> void:
	print("🏰 타워가 스킬을 획득했습니다!: ", new_skill.name_kr)
	
	# 스킬 데이터와 타이머를 묶어서 내 가방(배열)에 쏙 넣습니다.
	active_skills.append({
		"skill": new_skill,
		"timer": new_skill.cooldown # 장착하자마자 바로 한 발 쏘도록 타이머를 꽉 채워둡니다!
	})

func _process(delta: float) -> void:
	# 🌟 [추가] 매 프레임마다 내 가방 속 스킬들의 쿨타임을 돌립니다.
	for i in range(active_skills.size()):
		var skill_info: Dictionary = active_skills[i]
		skill_info["timer"] += delta # delta(시간)를 더해서 타이머를 굴림
		
		var skill_data: SkillData = skill_info["skill"]
		
		# 타이머가 스킬의 요구 쿨타임(cooldown)을 꽉 채웠다면?
		if skill_info["timer"] >= skill_data.cooldown:
			skill_info["timer"] = 0.0 # 쏜 다음엔 다시 0초로 초기화!
			_fire_skill(skill_data)   # 스킬 발사!

# 빵야! 스킬을 쏘는 함수 (수정됨)
func _fire_skill(skill: SkillData) -> void:
	var target = _get_closest_target()
	if target == null: return 
	
	# 1. 단일 타격 (기존에 만든 레이저 공격)
	if skill.target_type == "HITSCAN":
		var final_damage: float = base_damage * skill.damage
		if target.has_method("take_damage"):
			target.take_damage(final_damage)
		_show_laser_effect(target.global_position)
		
	# 2. 광역 타격 (독구름, 폭발 등)
	elif skill.target_type == "SUMMON":
		_spawn_summon_area(skill, target.global_position)
	
# 🌟 [이펙트 2 본체] 타워에서 적까지 레이저 선을 그렸다가 지우는 함수
func _show_laser_effect(target_pos: Vector2) -> void:
	var line = Line2D.new()
	line.add_point(global_position) # 시작점: 내(타워) 위치
	line.add_point(target_pos)      # 끝점: 적 위치
	line.width = 4.0                # 레이저 굵기
	line.default_color = Color.ORANGE # 레이저 색상 (오렌지색)
	
	# 화면(현재 씬)에 레이저 선을 추가합니다.
	get_tree().current_scene.add_child(line)
	
	# Tween을 생성해서 0.1초만에 레이저를 투명하게(modulate:a) 만들고 삭제합니다.
	var tween = create_tween()
	tween.tween_property(line, "modulate:a", 0.0, 0.1) # a는 알파(투명도)값
	tween.tween_callback(line.queue_free) # 투명해지면 화면에서 삭제!

func _spawn_summon_area(skill: SkillData, target_pos: Vector2) -> void:
	var summon_node = SummonedArea.new()
	
	# 장판에 필요한 데이터를 넘겨줍니다.
	summon_node.global_position = target_pos
	summon_node.damage = base_damage * skill.damage
	summon_node.element = skill.element
	
	# [참고] 만약 CSV에 duration(유지시간) 데이터가 없다면 임의로 5초 유지 / 1초 틱으로 설정합니다.
	summon_node.duration = 5.0 
	summon_node.tick_interval = 1.0 
	
	
	# 화면 최상단(current_scene)에 장판을 깝니다!
	get_tree().current_scene.add_child(summon_node)
		
# 📡 [신규 추가] 레이더: 가장 가까운 크립을 찾는 함수
func _get_closest_target() -> Node2D:
	var creeps = get_tree().get_nodes_in_group("creeps")
	if creeps.is_empty():
		return null
		
	var closest_creep: Node2D = null
	var shortest_distance: float = INF # 거리를 비교하기 위해 일단 무한대(INF)로 설정
	
	for creep in creeps:
		# 타워의 위치(global_position)와 크립의 위치 사이의 거리를 계산합니다.
		var distance: float = global_position.distance_to(creep.global_position)
		
		# 지금까지 찾은 가장 짧은 거리보다 이 크립이 더 가깝다면? 갱신!
		if distance < shortest_distance:
			shortest_distance = distance
			closest_creep = creep
			
	return closest_creep # 가장 가까운 놈을 반환!
