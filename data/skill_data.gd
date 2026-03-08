class_name SkillData
extends RefCounted

var id: String
var type: String             # ACTIVE, PASSIVE
var damage: float # 캐릭터 공격력의 배수 (예: 1.0, 0.5)
var cooldown: float          # 쿨타임 (초)
var target_type: String      # HITSCAN, SUMMON 등
var element: String          # FIRE, ICE 등
var name_kr: String
var name_en: String
var logic: String
