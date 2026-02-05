extends StaticBody2D

var mario
@onready var markers=[$Marker2D,$Marker2D2]

var can_shoot:=true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mario=get_tree().current_scene.get_node("Mario") # Replace with function body.

func _on_shoot_timer_timeout() -> void:
	if can_shoot:
		var bullet=load("res://Scenes/bullet_bill.tscn").instantiate() # Replace with function body.
		var pos=int(mario.global_position.x-self.global_position.x>0)
		var dir=sign(mario.global_position.x-self.global_position.x)
		bullet.global_position=markers[pos].global_position
		get_tree().current_scene.add_child(bullet)
		bullet.velocity.x=dir*bullet.SPEED


func _on_idle_area_body_entered(body) -> void:
	if body==mario:
		can_shoot=false


func _on_idle_area_body_exited(body) -> void:
	if body==mario:
		can_shoot=true # Replace with function body.


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	can_shoot=true # Replace with function body.


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	can_shoot=false # Replace with function body.
