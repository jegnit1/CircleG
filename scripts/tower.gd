extends Marker2D
# scripts/tower.gd (타워에 붙어있는 스크립트)

# 장착된 스킬들과 각각의 쿨타임을 관리할 가방(배열)
var active_skills: Array[Dictionary] = []

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
	for i in range(active_skills.size()):
		var skill_info: Dictionary = active_skills[i]
		
		# 🌟 [스탯 2 적용] 쿨타임 가속! (1.2면 시간이 1.2배 빠르게 흐름)
		var cd_speed = DataManager.player_stats["cooldown_speed"]
		skill_info["timer"] += (delta * cd_speed) 
		
		var skill_data: SkillData = skill_info["skill"]
		
		if skill_info["timer"] >= skill_data.cooldown:
			skill_info["timer"] = 0.0 
			_fire_skill(skill_data)

# 빵야! 스킬을 쏘는 함수 (수정됨)
func _fire_skill(skill: SkillData) -> void:
	var target = _get_closest_target()
	if target == null: return 
	
	# 🌟 [스탯 3 적용] DataManager의 기본 공격력을 가져와서 계산!
	var current_base_damage = DataManager.player_stats["base_damage"]
	var final_damage: float = current_base_damage * skill.damage
	
	if skill.target_type == "HITSCAN":
		if target.has_method("take_damage"):
			target.take_damage(final_damage)
		_show_laser_effect(target.global_position)
		
	elif skill.target_type == "SUMMON":
		# 데미지 계산이 끝난 값을 장판한테도 넘겨줍니다.
		_spawn_summon_area(skill, target.global_position, final_damage)
	
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

# 🌟 이 함수 전체를 덮어씌워 주세요!
func _spawn_summon_area(skill: SkillData, target_pos: Vector2, final_damage: float) -> void:
	# 🔧 [수정 1] SummonArea -> SummonedArea 로 오타 수정!
	var summon_node = SummonedArea.new() 
	
	summon_node.global_position = target_pos
	
	# 🔧 [수정 2] 삭제된 base_damage 대신, 위에서 계산해서 넘겨준 final_damage를 넣습니다!
	summon_node.damage = final_damage 
	summon_node.element = skill.element
	
	var base_radius: float = 120.0
	summon_node.radius = base_radius * DataManager.player_stats["effect_range"]
	
	summon_node.duration = 5.0 
	summon_node.tick_interval = 1.0 
	
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
