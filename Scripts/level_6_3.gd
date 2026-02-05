extends Level

@onready var mario=$Mario

const powerupcoords=[Vector2i(55,3)]
const lifeupcoords=[]
const coinbrickcoords=[]
const starcoords=[]
const invisible_blocks=[]
const QUESTION_BLOCK_ID:=26
const BRICK_BLOCK_ID:=0
const USED_BLOCK_ID:=0
const INVISIBLE_BLOCK_ID:=0
const palette="castle"
const castle_x:=174*32+16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if Global.checkpoint:
		mario.global_position=Vector2(2912,224)
	Global.time=399
	await get_tree().create_timer(0.5).timeout
	$Platform4.process_mode=Node.PROCESS_MODE_INHERIT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x


func _on_bullet_trigger_body_entered(body: Node2D) -> void:
	if body==mario:
		$BulletTimer.start(2.5)

func _on_level_timer_timeout() -> void:
	Global.check_time("6-4")


func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_bullet_timer_timeout() -> void:
	var bullet=load("res://Scenes/bullet_bill.tscn").instantiate() # Replace with function body.
	var view=get_viewport().get_visible_rect().size
	bullet.global_position=Vector2($CameraFollower.global_position.x+view.x/2,randi_range(0,view.y))
	self.add_child(bullet)
	bullet.velocity.x=-bullet.SPEED
	$BulletTimer.start(2.5)


func _on_bullet_stop_body_entered(body: Node2D) -> void:
	if body==mario:
		$BulletTimer.stop() # Replace with function body.


func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.checkpoint=true # Replace with function body.
