extends Node2D

var FirstPivotSprite={
	"overworld":load("res://files/images/seesaw_0.png"),
	"castle":load("res://files/images/seesaw1_0.png")
}
var SecondPivotSprite={
	"overworld":load("res://files/images/seesaw_1.png"),
	"castle":load("res://files/images/seesaw1_1.png")
}
var VerRope={
	"overworld":load("res://files/images/seesaw_3.png"),
	"castle":load("res://files/images/seesaw1_3.png")
}
var HorizRope={
	"overworld":load("res://files/images/seesaw_2.png"),
	"castle":load("res://files/images/seesaw1_2.png")
}

var left_platform_speed=0
var right_platform_speed=0
var is_broken:=false
var palette:String
@export var blocks:int
@export var length:int
@export var left_length:int
@export var right_length:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	palette=get_tree().current_scene.palette
	await get_tree().process_frame
	for i in blocks:
		var sprleft=Sprite2D.new()
		sprleft.texture=load("res://files/images/platform.png")
		var sprright=Sprite2D.new()
		sprright.texture=load("res://files/images/platform.png")
		if blocks%2==0:
			sprleft.offset.x=8
			sprleft.position.x=$Left.position.x+(i-blocks/2.0)*16
			sprright.offset.x=8
			sprright.position.x=$Left.position.x+(i-blocks/2.0)*16
		else:
			sprleft.position.x=$Left.position.x+(i-(blocks-1)/2.0)*16
			sprright.position.x=$Left.position.x+(i-(blocks-1)/2.0)*16
		$Left/Sprites.add_child(sprleft)
		$Right/Sprites.add_child(sprright)
	$Left/CollisionShape2D.shape.size=Vector2(blocks*16,16)
	$Right/CollisionShape2D.shape.size=Vector2(blocks*16,16)
	$FirstPivot/Sprite2D.texture=FirstPivotSprite[palette]
	$SecondPivot/Sprite2D2.texture=SecondPivotSprite[palette]
	$LeftVerRope.texture=VerRope[palette]
	$RightVerRope.texture=VerRope[palette]
	$HorizRope.texture=HorizRope[palette]
	$SecondPivot.global_position.x=$FirstPivot.global_position.x+(length-1)*32
	$HorizRope.global_position.x=($FirstPivot.global_position.x+$SecondPivot.global_position.x)/2
	$HorizRope.scale.x=($SecondPivot.global_position.x-$FirstPivot.global_position.x-32)/32.0 # Replace with function body.
	$RightVerRope.global_position.x=$SecondPivot.global_position.x
	$Right.global_position.x=$SecondPivot.global_position.x
	$Left.global_position.y=$FirstPivot.global_position.y+left_length*32+24
	$Right.global_position.y=$SecondPivot.global_position.y+right_length*32+24
	$Left/LeftDetector/CollisionShape2D.shape.size.x=blocks*16
	$Right/RightDetector/CollisionShape2D.shape.size.x=blocks*16
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$Left.move_and_slide()
	$Right.move_and_slide()
	$Left.velocity.y+=left_platform_speed*delta
	$Left.velocity.y=clamp($Left.velocity.y,-300,300)
	$Right.velocity.y+=right_platform_speed*delta
	$Right.velocity.y=clamp($Right.velocity.y,-300,300)
	if !is_broken:
		$LeftVerRope.global_position.y=($FirstPivot.global_position.y+$Left.global_position.y+8)/2
		$LeftVerRope.scale.y=($FirstPivot.global_position.y-$Left.global_position.y+8)/16.0
		$RightVerRope.global_position.y=($SecondPivot.global_position.y+$Right.global_position.y)/2
		$RightVerRope.scale.y=($SecondPivot.global_position.y-$Right.global_position.y+8)/16.0


func _on_first_pivot_body_entered(body) -> void:
	if body==$Left:
		break_seesaw()

func _on_second_pivot_body_entered(body) -> void:
	if body==$Right:
		break_seesaw()


func _on_left_detector_body_entered(body) -> void:
	if body.name=="Mario":
		if !is_broken:
			left_platform_speed=300
			right_platform_speed=-300 # Replace with function body.


func _on_left_detector_body_exited(body) -> void:
	if body.name=="Mario":
		if body.velocity.y<0 or body.velocity.x!=0:
			$Left.velocity.y=0
			$Right.velocity.y=0
			left_platform_speed=0
			right_platform_speed=0# Replace with function body.

func _on_right_detector_body_entered(body) -> void:
	if body.name=="Mario":
		if !is_broken:
			left_platform_speed=-300
			right_platform_speed=300 # Replace with function body.

func _on_right_detector_body_exited(body) -> void:
	if body.name=="Mario":
		if body.velocity.y<0 or body.velocity.x!=0:
			$Left.velocity.y=0
			$Right.velocity.y=0
			left_platform_speed=0
			right_platform_speed=0# Replace with function body.

func break_seesaw():
		$Left.set_collision_mask_value(2,false)
		$Left.set_collision_layer_value(2,false)
		$Right.set_collision_mask_value(2,false)
		$Right.set_collision_layer_value(2,false)
		$Left/LeftDetector.set_collision_mask_value(2,false)
		$Right/RightDetector.set_collision_mask_value(2,false)
		$Right.velocity.y=0
		$Left.velocity.y=0
		left_platform_speed=Global.GRAVITY # Replace with function body.
		right_platform_speed=Global.GRAVITY
		is_broken=true
		Global.score+=1000
		get_tree().current_scene.get_node("Mario").pop_up_score(1000,self.global_position)
