extends CharacterBody2D


const SPEED = 75.0
enum Dir{UP,DOWN}
var Dirs={
	Dir.UP:-1,
	Dir.DOWN:1
}

var body

@export var dir:Dir
@export var blocks:=3

func _ready() -> void:
	for i in blocks:
		var spr=Sprite2D.new()
		spr.texture=load("res://files/images/platform.png")
		if blocks%2==0:
			spr.offset.x=8
			spr.position.x=(i-blocks/2.0)*16
		else:
			spr.position.x=(i-(blocks-1.0)/2)*16
		self.add_child(spr)
		$CollisionShape2D.shape.size=Vector2(blocks*16,16)

func _physics_process(_delta: float) -> void:
	move_and_slide()
	for i in get_slide_collision_count():
		if body==null:
			body=get_slide_collision(i).get_collider()
	velocity.y=Dirs[dir]*SPEED
	if global_position.y>500:
		set_collision_layer_value(1,false)
		await get_tree().create_timer(0.5).timeout
		global_position.y=-20
		set_collision_layer_value(1,true)
	if global_position.y<-30:
		set_collision_layer_value(1,false)
		await get_tree().create_timer(0.5).timeout
		set_collision_layer_value(1,true)
		global_position.y=490
