# AudioManager.gd
#
# Singleton for all game audio. Handles background music and sound effects.
#
# SETUP:
#   1. Save this file anywhere in your project, e.g. res://AudioManager.gd
#   2. Open Project Settings -> Autoload
#   3. Click "Add Class Singleton"
#      - Name:    AudioManager
#      - Path:    res://AudioManager.gd
#   4. Click "Save"
#
# USAGE (from any scene/script):
#   # Music (replaces previous music):
#   AudioManager.play_music("res://Audio/Music/Menu.ogg")
#   AudioManager.play_music("res://Audio/Music/credits.ogg", volume=0.8)
#   AudioManager.stop_music()
#
#   # Sound effects (one-shot):
#   AudioManager.play_sfx("res://Audio/soundeffects/Place.wav")
#   AudioManager.play_sfx("res://Audio/soundeffects/Miss.wav", volume=0.6)

extends Node

## Must match the bus names in Audio/default_bus_layout.tres
const MUSIC_BUS := "Music"
const SFX_BUS := "Sounds"

## Default volumes (linear 0.0–1.0)
@export var music_volume := 1.0
@export var sfx_volume := 1.0

## Internal
var _music_player: AudioStreamPlayer = null

## --- Music API ---

## Play background music. Stops any currently playing music.
## path:    res:// path to an audio file
## volume:  0.0–1.0 (default: music_volume)
## pitch_scale: 0.5–2.0 (default: 1.0)
func play_music(path: String, volume: float = -1, pitch_scale: float = -1) -> void:
	if _music_player == null:
		create_music_player()
	
	# Skip if the same song is already playing
	if _music_player.stream != null and _music_player.stream.resource_path == path and _music_player.is_playing():
		return
	
	_music_player.stop()
	_music_player.stream = load(path)
	_music_player.bus = MUSIC_BUS
	_music_player.volume_db = linear_to_db(volume if volume >= 0 else music_volume)
	_music_player.pitch_scale = pitch_scale if pitch_scale > 0 else 1.0
	_music_player.play()

## Stop background music.
func stop_music() -> void:
	if _music_player != null and _music_player.is_playing():
		_music_player.stop()

## Create the music player node (added to the autoload root).
func create_music_player() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.name = "MusicPlayer"
	_music_player.bus = MUSIC_BUS
	add_child(_music_player)

## --- Sound effects API ---

## Play a one-shot sound effect.
## path:    res:// path to an audio file
## volume:  0.0–1.0 (default: sfx_volume)
## pitch_scale: 0.5–2.0 (default: 1.0)
## Returns the player node so you can stop/control it if needed.
func play_sfx(path: String, volume: float = -1, pitch_scale: float = -1) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.stream = load(path)
	player.bus = SFX_BUS
	player.volume_db = linear_to_db(volume if volume >= 0 else sfx_volume)
	player.pitch_scale = pitch_scale if pitch_scale > 0 else 1.0
	add_child(player)
	player.play()
	# Auto-free when the sound finishes (prevents accumulation)
	player.finished.connect(player.queue_free)
	return player
