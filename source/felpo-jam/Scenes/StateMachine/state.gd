extends Node
class_name State

var player : Player
var state_machine : StateMachine

func enter() -> void:
	pass

func exit() -> void:
	pass

func handle_input(_event : InputEvent) -> State:
	return null

func update(_delta : float) -> State:
	return null

func physics_update(_delta : float) -> State:
	return null
