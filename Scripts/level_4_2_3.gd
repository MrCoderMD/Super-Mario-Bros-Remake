extends Level

@onready var mario=$Mario

const powerupcoords=[]
const lifeupcoords=[]
const coinbrickcoords=[]
const starcoords=[]
const invisible_blocks=[]
const QUESTION_BLOCK_ID:=19
const BRICK_BLOCK_ID:=20
const USED_BLOCK_ID:=22
const INVISIBLE_BLOCK_ID:=19
const palette="overworld"
var transition_coordx=-1
var transition_level
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$CameraFollower/Controls/SelectButton/Label.text="PAUSE"
	mario.set_physics_process(false)
	mario.visible=false
	await create_vine()
	mario.visible=true
	mario.set_physics_process(true)
	mario.global_position=Vector2(135,464)
	mario.animation.position.y+=32
	mario.is_auto_climbing=true
	mario.velocity.y=-50
	mario.state=mario.States.HANG
	mario.animation.play(mario.size_prefix[Global.size]+"_hang")
	await get_tree().create_timer(3.0).timeout
	mario.animation.position.y=0
	mario.velocity=Vector2(200,-200)
	mario.state=mario.States.JUMP
	mario.animation.play(mario.size_prefix[Global.size]+"_jump")
	mario.is_auto_climbing=false
	$StaticBody2D.set_collision_layer_value(4,true)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
		#$CameraFollower/Controls.process_mode=Node.PROCESS_MODE_ALWAYS
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			if mario.global_position.x<2048-get_viewport().get_visible_rect().size.x/2:
				$CameraFollower.position.x=$Mario.global_position.x


func _on_transition_61_body_entered(body: Node2D) -> void:
	if body==mario:
		transition_coordx=1888
		Global.currentlevel="6-1"
		transition_level=load("res://Scenes/stage_transition.tscn") # Replace with function body.


func _on_transition_71_body_entered(body: Node2D) -> void:
	if body==mario:
		transition_coordx=1760
		Global.currentlevel="7-1"
		transition_level=load("res://Scenes/stage_transition.tscn") 


func _on_transition_81_body_entered(body: Node2D) -> void:
	if body==mario:
		transition_coordx=1632
		Global.currentlevel="8-1"
		transition_level=load("res://Scenes/stage_transition.tscn")


func _on_level_timer_timeout() -> void:
	Global.check_time() # Replace with function body.

func create_vine():
	var vine_appear=AudioStreamPlayer2D.new()
	vine_appear.stream=load("res://files/sounds/mushroomappear.wav")
	$CameraFollower.add_child(vine_appear)
	vine_appear.play()
	var vine_count=7
	for i in vine_count:
		var vine=load("res://Scenes/vine.tscn").instantiate()
		if i==0:
			vine.is_top=true
		var initial= self.to_global($ForegroundTile.map_to_local(Vector2i(4,15)))
		vine.global_position=initial
		vine.target_y=initial.y-32*(vine_count-i-1)
		vine.z_index=$ForegroundTile.z_index-1
		self.add_child(vine)
		await get_tree().create_timer(0.533).timeout
