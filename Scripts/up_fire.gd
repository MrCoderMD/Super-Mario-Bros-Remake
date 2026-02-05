extends Area2D

var velocity=Vector2(0,0)
var init:Vector2
var is_reversed:=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity.y=-844
	init=global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.flip_v=(velocity.y>0)
	if global_position.y>init.y:
		set_process(false)
		await get_tree().create_timer(randi_range(1,2)).timeout
		set_process(true)
		velocity.y=randi_range(-844,-543)
	else:
		velocity.y+=Global.GRAVITY*delta
	global_position.y+=velocity.y*delta


func _on_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		body.shrink_or_die()
