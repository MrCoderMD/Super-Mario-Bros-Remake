extends Level
@onready var mario=$Mario

const QUESTION_BLOCK_ID=19
const BRICK_BLOCK_ID=20
const USED_BLOCK_ID=22
const INVISIBLE_BLOCK_ID=12
const powerupcoords=[]
const lifeupcoords=[]
const coinbrickcoords=[]
const starcoords=[]
const palette="underground"
var invisible_blocks=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void: # Replace with function body.
	super() 
	mario.animation.play(mario.size_prefix[Global.size]+"_jump")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)


func _on_bg_music_finished() -> void:
	$BgMusic.play() # Replace with function body.


func _on_level_timer_timeout() -> void:
	Global.check_time()


func _on_transition_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		await body.slide_right() # Replace with function body.
		get_tree().change_scene_to_file("res://Scenes/level_"+Global.currentlevel+".tscn")
