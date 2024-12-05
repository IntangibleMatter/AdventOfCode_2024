#!/usr/bin/env -S godot --headless -s
extends SceneTree


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	var re := RegEx.create_from_string("mul\\(\\d+,\\d+\\)")
	var subbed := RegEx.create_from_string("don't\\(\\).*?do\\(\\)").sub(
		f.get_as_text().replace("\n", ""), "", true
	)
	print(subbed)
	var matches := re.search_all(subbed)

	var sum: int = 0

	for match in matches:
		var stri := match.strings[0]
		stri.replace("mul(", "")
		stri.replace(")", "")
		var nums: Array = Array(stri.split(",")).map(func(i) -> int: return int(i))
		sum += nums[0] * nums[1]
		prints("sum", sum, "\tDidmult:", match.strings[0], stri, nums)

	print(sum)
	quit()
