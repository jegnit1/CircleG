extends Node

# 데이터 보관용 딕셔너리
var artifacts_data: Dictionary = {}

# 노드 초기화 및 리소스 자동 로드
func _ready() -> void:
	_load_resources_from_dir("res://data/artifacts/", artifacts_data)
	print("로드된 아티팩트 개수: ", artifacts_data.size())

# 디렉토리 순회 및 커스텀 리소스 동적 로드
func _load_resources_from_dir(path: String, target_dict: Dictionary) -> void:
	var dir: DirAccess = DirAccess.open(path)
	if dir == null:
		push_error("디렉토리 접근 실패: " + path)
		return
		
	for file_name in dir.get_files():
		# 빌드 시 .tres 파일이 .remap으로 래핑되는 현상 대응
		var clean_name: String = file_name.replace(".remap", "")
		
		if clean_name.ends_with(".tres") or clean_name.ends_with(".res"):
			var resource_path: String = path + "/" + clean_name
			var resource: Resource = load(resource_path)
			
			# 고유 ID를 키값으로 딕셔너리에 적재
			if resource and "id" in resource and resource.id != "":
				target_dict[resource.id] = resource

# 아티팩트 데이터 반환 인터페이스
func get_artifact(id: String) -> ArtifactData:
	return artifacts_data.get(id, null)
