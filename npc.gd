@tool
extends StaticBody2D

@export var npc_name: String
@export var npc_speaktext: PackedStringArray
@export var npc_color: Color = Color("415e9b"):
	set(value):
		npc_color = value
		_update_shader()

@onready var e = $e
@onready var sprite = $Sprite2D
@onready var dialouge = $"../CanvasLayer/DialogBox"
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")


func _update_shader():
	if $Sprite2D.material and $Sprite2D.material is ShaderMaterial:
		$Sprite2D.material.set_shader_parameter("replacement_color", npc_color)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if $Sprite2D.material:
		$Sprite2D.material = $Sprite2D.material.duplicate()

	if Engine.is_editor_hint():
		return

	if not npc_name or not sprite or not npc_speaktext or not dialouge or not player:
		queue_free()


func _process(_delta: float) -> void:
	if not player:
		return
	var player_pos = player.global_position
	var distance = global_position.distance_to(player_pos)
	if distance < 35:
		e.visible = true
		var ed = Input.is_action_just_pressed("interact")
		if ed:
			dialouge.display_text(npc_speaktext, npc_name, sprite.texture, npc_color)
	else:
		e.visible = false
