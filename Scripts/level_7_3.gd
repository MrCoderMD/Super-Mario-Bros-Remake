extends Level

@onready var mario=$Mario

const powerupcoords=[Vector2i(102,5)]
const lifeupcoords=[]
const coinbrickcoords=[]
const starcoords=[]
const invisible_blocks=[]
const QUESTION_BLOCK_ID=1
const BRICK_BLOCK_ID=0
const USED_BLOCK_ID=4
const INVISIBLE_BLOCK_ID:=0
var is_pipe_entered:=false
var transition_coordx=0
var castle_x:=230*32
var palette:="overworld"

func _ready() -> void:
	super()
	if Global.checkpoint:
		mario.global_position=Vector2(3648,400)
	Global.time=399
	await get_tree().process_frame
	var hop_koopax=[52,140,156]
	var red_koopax=[95,119]
	for enemy in $Enemies.get_children():
		var cell_pos=$Enemies.local_to_map($Enemies.to_local(enemy.global_position)).x
		if cell_pos in hop_koopax:
			enemy.state=enemy.States.HOP
		if cell_pos in red_koopax:
			enemy.palette="red"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
		#$CameraFollower/Controls.process_mode=Node.PROCESS_MODE_ALWAYS
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x

func _on_level_timer_timeout() -> void:
	Global.check_time("7-4") # Replace with function body.


func _on_cheep_timer_timeout() -> void:
	var cheep=load("res://Scenes/cheep.tscn").instantiate()
	cheep.palette="red" # Replace with function body.
	cheep.state=cheep.States.FLY
	cheep.dir=[1,-1][randi_range(0,1)]
	cheep.velocity.x=cheep.dir*randi_range(1,3)*100
	cheep.global_position=Vector2(randi_range(mario.global_position.x-get_viewport().get_visible_rect().size.x/2,mario.global_position.x+get_viewport().get_visible_rect().size.x/2),get_viewport().get_visible_rect().size.y)
	self.add_child(cheep)
	$CheepTimer.start(randf_range(0.5,1.5)) # Replace with function body.


func _on_cheep_spawner_body_entered(body) -> void:
	if body==mario:
		$CheepTimer.start(randf_range(0.5,1.5)) # Replace with function body.


func _on_cheep_stopper_body_entered(body: Node2D) -> void:
	if body==mario:
		$CheepTimer.stop() # Replace with function body.


func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.checkpoint=true # Replace with function body.
