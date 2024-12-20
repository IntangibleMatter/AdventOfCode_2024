#!/usr/bin/env -S godot --headless -s
extends SceneTree

var towels: PackedStringArray
var indent := 0


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	towels = f.get_line().split(", ", false)
	var re := RegEx.create_from_string(generate_regex_string(towels))

	var possible: Array[String] = []
	while not f.eof_reached():
		var line := f.get_line()
		prints("testing", line)
		if re.search(line) != null:
			prints("Match!")
			possible.append(line)
		print()
	print(possible)

	var sum := 0
	for p in possible:
		sum += get_towel_permutations(p)
		print(sum)
		print()
	prints("total:")
	print(sum)

	quit()


func get_towel_permutations(of: String) -> int:
	var possible_towels: Array[String] = []
	for t in towels:
		if t in of:
			possible_towels.append(t)
	prints("testing", of, possible_towels)

	var out := recurse_next_segment(of, possible_towels)
	prints("Possible", out)
	return out


func recurse_next_segment(text: String, ptowels: Array[String]) -> int:
	indent += 1
	print_tabs()
	prints("\tstring:", text)
	var part_options: Array[String]
	for t in ptowels:
		#if t == text:
		#	print_tabs()
		#	prints("full match", text, t)
		#	indent -= 1
		#	return 1
		if text.begins_with(t):
			part_options.append(t)

	if part_options.is_empty():
		print_tabs()
		prints("No match")
		indent -= 1
		return 0

	print_tabs()
	print("part options", part_options)

	var count := 0
	for t in part_options:
		print_tabs()
		prints("\t", t)
		if t.length() == text.length():
			count += 1 if t == text else 0
		else:
			count += recurse_next_segment(text.substr(t.length()), ptowels)
	print_tabs()
	print("\t\t<------")
	indent -= 1
	return count


func print_tabs() -> void:
	for i in indent:
		printraw("    ")


func generate_regex_string(options: PackedStringArray) -> String:
	var re_string := "^("
	for opt in options.size():
		re_string += options[opt]
		if opt < options.size() - 1:
			re_string += "|"
	re_string += ")+$"
	return re_string
