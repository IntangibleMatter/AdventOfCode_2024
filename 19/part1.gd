#!/usr/bin/env -S godot --headless -s
extends SceneTree


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	var regex_options: PackedStringArray = f.get_line().split(", ", false)
	var re := RegEx.create_from_string(generate_regex_string(regex_options))

	var count: int = 0
	while not f.eof_reached():
		var line := f.get_line()
		prints("testing", line)
		if re.search(line) != null:
			prints("Match!")
			count += 1
		print()
	prints("count:")
	print(count)

	quit()


func generate_regex_string(options: PackedStringArray) -> String:
	var re_string := "^("
	for opt in options.size():
		re_string += options[opt]
		if opt < options.size() - 1:
			re_string += "|"
	re_string += ")+$"
	return re_string
