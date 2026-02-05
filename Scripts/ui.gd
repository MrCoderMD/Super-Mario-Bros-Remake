extends CanvasLayer

func _ready() -> void:
	$MarginContainer/HBoxContainer/Label2.text="WORLD\n"+str(Global.currentlevel)

func _process(_delta: float) -> void:
	$MarginContainer/HBoxContainer/Label.text="MARIO\n"+str(Global.score)
	$MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Coins.text="x"+str(Global.coins)
	$MarginContainer/HBoxContainer/Label4.text="TIME\n"+str(Global.time)
