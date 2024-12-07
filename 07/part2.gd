#!/usr/bin/env -S godot --headless -s
extends SceneTree


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	#var f := FileAccess.open("./demoin.txt", FileAccess.READ)
	var lines := f.get_as_text().split("\n")
	lines.remove_at(lines.size() - 1)

	var sum := 0

	for line in lines:
		prints("evaluating", line)
		var nums := Array(line.replace(":", "").split(" "))
		var out := int(nums.pop_front())
		# actually we want them as strings lmao
		# no we don't idiot that was a bad idea
		nums = nums.map(func(i: String) -> int: return int(i))
		var combos := 3 ** (nums.size() - 1)
		prints("testing", combos, "combos")

		for i in combos:
			var n := String.num_int64(i, 3).pad_zeros(nums.size() - 1)
			#var n := i
			#prints("nums", nums)
			var tsum: int = nums[0]
			#prints("testing", n.replace("0", "+").replace("1", "*"))
			for j in nums.size() - 1:
				#if n & 0x01 == 1:
				if n[j] == "0":
					tsum += nums[j + 1]
				elif n[j] == "1":
					tsum *= nums[j + 1]
				else:
					tsum = int(str(tsum) + str(nums[j + 1]))
			"""prints(
				"trying",
				interlace(
					nums, Array(n.replace("0", "+").replace("1", "*").replace("2", "||").split(""))
				)
			)"""

#				n = n >> 1
			if tsum == out:
				sum += tsum
				prints(
					"valid combo found!",
					interlace(
						nums,
						Array(n.replace("0", "+").replace("1", "*").replace("2", "||").split(""))
					)
				)
				break

	#	for i in combos:
	#		var n := i

	print(sum)

	quit()


func interlace(a: Array, b: Array) -> String:
	var nstr := ""
	var na := a.duplicate()
	while not na.is_empty() and not b.is_empty():
		nstr += str(na.pop_front())
		nstr += str(b.pop_front())
	if not na.is_empty():
		for _i in na.size():
			nstr += str(na.pop_front())
	return nstr
