extends Node


signal die
signal speed_booster
signal stop_shrinking
signal greater_jump
signal bridge_ability
signal extra_life
signal reverse_shrink
signal menu_close
var total_jump := 0
var total_cloud_potions := 0
var total_stop_shrink_potions := 0
var total_reverse_shrink_potions := 0
var total_coins := 0
var total_keys_collected:= 0
var total_wolf_slain := 0
var total_times_telported := 0

var coins := 0:
	set(value):
		coins = value
		var hud: Control = get_tree().get_first_node_in_group("players").find_children("HUD")[0]
		hud.set_coins(value)
