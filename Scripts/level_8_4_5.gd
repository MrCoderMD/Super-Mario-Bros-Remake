extends Level

@onready var mario=$Mario

const QUESTION_BLOCK_ID=0
const BRICK_BLOCK_ID=0
const USED_BLOCK_ID=0
const INVISIBLE_BLOCK_ID=0
const COIN_BRICK_ID=0
const invisible_blocks=[]
const powerupcoords=[]
const lifeupcoords=[]
const coinbrickcoords=[]
const starcoords=[]
const palette:="underwater"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mario.global_position=self.to_global($ForegroundTile.map_to_local(Global.spawn[Global.currentlevel]))+Vector2(-16,mario.collision.shape.extents.y-16)
	await mario.slide_up()
	mario.is_underwater=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
	if mario:
		if mario.global_position.x<1877.5:
			if $CameraFollower.position.x<=$Mario.global_position.x:
				$CameraFollower.position.x=$Mario.global_position.x

func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_level_timer_timeout() -> void:
	Global.check_time() # Replace with function body.


func _on_transition_body_entered(body: Node2D) -> void:
	if body==mario:
		await mario.slide_right()
		Global.can_transition=false # Replace with function body.
		Global.spawn["8-4"]=Vector2i(4,11)
		get_tree().change_scene_to_file("res://Scenes/level_8_4_4.tscn")
