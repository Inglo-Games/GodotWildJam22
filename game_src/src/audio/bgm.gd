extends Node

onready var audio_player := AudioStreamPlayer.new()
onready var stream := preload("res://assets/sfx/UprisingBegins.ogg")

func _ready():
	stream.loop = true
	audio_player.set_stream(stream)
	audio_player.volume_db = -12.5
	get_tree().get_root().call_deferred("add_child", audio_player)

func play_audio():
	if not audio_player.playing:
		audio_player.play()
