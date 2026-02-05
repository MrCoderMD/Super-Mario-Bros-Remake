extends CharacterBody2D

var dir:int
var nohit=["Mario","PowerUpMushroom","1UpMushroom","Spring","Left","Right"]
var can_blast:=false
@onready var sfx=Configfile.load_music_settings()

func _ready() -> void:
	$AudioStreamPlayer2D.volume_linear=sfx["sfx_volume"]*0.01
	velocity=Vector2(dir*480,0)

func _process(delta: float) -> void:
	move_and_slide()
	
	if !is_on_floor():
		velocity.y+=Global.GRAVITY*delta
	else:
		velocity.y=-128*pow(3,0.5)
	if global_position.y>480:
		self.queue_free()
		
	if velocity.x==0:
		$AnimatedSprite2D.play("blast")
		velocity=Vector2.ZERO
		await $AnimatedSprite2D.animation_finished
		self.queue_free()
		



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free() # Replace with function body.


func _on_area_2d_area_entered(area: Area2D) -> void:
	area.bounceoff(area.global_position)
	$AnimatedSprite2D.play("blast")
	velocity=Vector2.ZERO
	await $AnimatedSprite2D.animation_finished
	self.queue_free()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.name!="FireBall":
		if body.name not in nohit:
			body.bounceoff(body.global_position)
			can_blast=true
	elif body is TileMapLayer:
		if velocity.x==0:
			velocity=Vector2(0,0)
			$AudioStreamPlayer2D.play()
			can_blast=true
	if can_blast:
		$AnimatedSprite2D.play("blast")
		velocity=Vector2.ZERO
		await $AnimatedSprite2D.animation_finished
		self.queue_free()
