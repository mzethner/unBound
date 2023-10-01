extends Node2D


onready var ysort = $YSort
onready var tween = $Tween
onready var whiteBox = $CanvasLayer2/ColorRect2
onready var endText = $CanvasLayer2/ColorRect2/Position2D
onready var player = get_tree().get_nodes_in_group("player")
onready var introText = $CanvasLayer2/ColorRect2/Label
onready var theme = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var playerCamera = get_tree().get_nodes_in_group("playerCamera")
	playerCamera[0].limit_top = -3280
	player[0].playerCanMove = false
	introText.text = "I should wake up..."
	tween.interpolate_property(introText, "percent_visible", 0, 1, .8,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,3)
	tween.start()
	yield(get_tree().create_timer(6),"timeout")
	introText.percent_visible = 0
	introText.text = "its time to move on"
	tween.interpolate_property(introText,"percent_visible", 0, 1, .8,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(3),"timeout")
	theme.play()
	tween.interpolate_property(whiteBox,"modulate", Color(1,1,1,1), Color(1,1,1,0), 1)
	tween.interpolate_property(theme, "volume_db", -80, 0, 2.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()
	
	player[0].playerCanMove = true


func _input(_event: InputEvent):
	if Input.is_action_just_pressed("test1"):
		var bot = load("res://assets/bot/bot.tscn")
		var botInstance = bot.instance()
		ysort.add_child(botInstance)
		botInstance.global_position = Vector2(700,-200)
		


func _on_Area2D_body_entered(body: Node) -> void:
	body.playerCanMove = false
	body.visible = false
	introText.visible = false
	tween.interpolate_property(whiteBox, "modulate", Color(1,1,1,0), Color(1,1,1,1), .7,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	yield(tween,"tween_all_completed")
	tween.interpolate_property(endText,"modulate", Color(1,1,1,0), Color(1,1,1,1), .3)
	tween.start()
	
