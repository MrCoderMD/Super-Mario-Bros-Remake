extends Node2D

@onready var mario=get_tree().current_scene.get_node("Mario")

func _ready() -> void:
	self.get_parent().final=self

func _on_ending_body_entered(body: Node2D) -> void:
	if body==mario:
		mario.is_auto_walking=false
		await get_tree().create_timer(0.5).timeout
		mario.set_physics_process(false)
		$Label.visible=true
		await get_tree().create_timer(1).timeout
		$Label2.visible=true # Replace with function body.
