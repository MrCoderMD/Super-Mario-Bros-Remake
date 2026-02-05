extends Level

@onready var mario=$Mario

const QUESTION_BLOCK_ID=1
const BRICK_BLOCK_ID=0
const USED_BLOCK_ID=4
const INVISIBLE_BLOCK_ID=5
const powerupcoords=[Vector2i(59,10)]
const invisible_blocks=[]
const lifeupcoords=[]
const coinbrickcoords=[]
const starcoords=[]
const palette="overworld"
const castle_x:=5104
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	Global.time=399
	await get_tree().process_frame
	var fly_koopa=[Vector2i(74,4),Vector2i(114,5)]
	var red_koopa_x=[30,74,110,117,133]
	for enemy in $Enemies.get_children():
		var cell_pos=$Enemies.local_to_map($Enemies.to_local(enemy.global_position))
		if int((enemy.global_position.x-16)/32) in red_koopa_x:
			enemy.palette="red"
		if cell_pos in fly_koopa:
			enemy.state=enemy.States.FLY
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
		#$CameraFollower/Controls.process_mode=Node.PROCESS_MODE_ALWAYS
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x


func _on_level_timer_timeout() -> void:
	Global.check_time("5-4") # Replace with function body.


func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_bullet_timer_timeout() -> void:
	var bullet=load("res://Scenes/bullet_bill.tscn").instantiate() # Replace with function body.
	var view=get_viewport().get_visible_rect().size
	bullet.global_position=Vector2($CameraFollower.global_position.x+view.x/2,randi_range(0,view.y))
	self.add_child(bullet)
	bullet.velocity.x=-bullet.SPEED
