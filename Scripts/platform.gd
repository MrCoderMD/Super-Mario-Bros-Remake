extends CharacterBody2D

enum Movement{HORIZ,VERT}

@export var max_distance:=48
@export var blocks=5
@export var move:=Movement.HORIZ

const SPEED := Vector2(300.0,300.0)
var start_pos:Vector2
var dir:=Vector2(1,1)
var dir_changed:=false

func _ready() -> void:
	for i in blocks:
		var spr=Sprite2D.new()
		spr.texture=load("res://files/images/platform.png")
		if blocks%2==0:
			spr.offset.x=8
			spr.position.x=(i-blocks/2.0)*16
		else:
			spr.position.x=(i-(blocks-1)/2.0)*16
		self.add_child(spr)
		$CollisionShape2D.shape.size=Vector2(blocks*16,16)
	start_pos=global_position

func _physics_process(_delta: float) -> void:
	move_and_slide()
	match move:
		Movement.HORIZ:
			handle_horizontal_movement()
		Movement.VERT:
			handle_vertical_movement()

func handle_horizontal_movement():
	if abs(global_position.x-start_pos.x)>=max_distance:
		if !dir_changed:
			dir_changed=true
			velocity.x=0
			await get_tree().create_timer(2.0).timeout
			dir.x*=-1
			velocity.x=dir.x*SPEED.x
	else:
		velocity.x=dir.x*SPEED.x
		dir_changed=false
		
func handle_vertical_movement():
	if abs(global_position.y-start_pos.y)>=max_distance:
		if !dir_changed:
			dir_changed=true
			velocity.y=0
			await get_tree().create_timer(2.0).timeout
			dir.y*=-1
			velocity.y=dir.y*SPEED.y
	else:
		velocity.y=dir.y*SPEED.y
		dir_changed=false
