extends CharacterBody2D

@export var blocks:int
const SPEED = Global.GRAVITY

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

func _physics_process(_delta: float) -> void:
	move_and_slide()
