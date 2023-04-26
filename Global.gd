extends Node2D

var red_packs = 0
var green_packs = 0

func calculate_score(red, green):
	if red + green > red_packs + green_packs:
		red_packs = red
		green_packs = green

func total():
	return red_packs + green_packs
