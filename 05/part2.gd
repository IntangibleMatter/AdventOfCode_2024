#!/usr/bin/env -S godot --headless -s
extends SceneTree

var ordering_rules: Dictionary = {}
var ordered: Array[int]


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	var split := f.get_as_text().split("\n")
	var rules_arr: Array[String]
	rules_arr.assign(Array(split.slice(0, split.find(""))))
	var pages_arr: Array[String]
	pages_arr.assign(Array(split.slice(split.find("") + 1)))
	pages_arr.pop_back()
	#print(rules_arr)
	#print(pages_arr)

	for rule in rules_arr:
		print(rule)
		var s: Array = Array(rule.split("|")).map(func(i): return int(i))
		var r0: Dictionary = ordering_rules.get(s[0], {"before": [], "after": []})
		var r1: Dictionary = ordering_rules.get(s[1], {"before": [], "after": []})
		r0.after.append(s[1])
		r1.before.append(s[0])
		ordering_rules[s[0]] = r0
		ordering_rules[s[1]] = r1
	print("ASLKD")
	for ord in ordering_rules:
		prints(ord, ordering_rules[ord])

	ordered.assign(ordering_rules.keys())

	ordered.sort_custom(sort_rules)
	print(ordered)

	var sum: int = 0
	for page in pages_arr:
		var pagenums: Array[int]
		pagenums.assign(Array(page.split(",")).map(func(i): return int(i)))
		var valid := true
		for i in pagenums.size():
			var cnum: Dictionary = ordering_rules[pagenums[i]]
			for j in pagenums.slice(0, i):
				if j in cnum.after:
					valid = false
			for j in pagenums.slice(i + 1):
				if j in cnum.before:
					valid = false
		if valid:
			pass
			#sum += pagenums[pagenums.size() / 2]
		else:
			prints("unsorted", pagenums)
			pagenums.sort_custom(sort_rules)
			prints("sorted  ", pagenums)
			sum += pagenums[pagenums.size() / 2]

		#prints("checking page", pagenums)
		#if pagenums == filter_ordered(pagenums):
		#@warning_ignore("NARROWING_CONVERSION")
		#sum += pagenums[pagenums.size() / 2]
		#prints("PAGE ORDER", pagenums, "IS CORRECT")
		#prints("len", pagenums.size(), pagenums.size() / 2)
		#prints("\t\tsum is now", sum)

	print(sum)

	quit()


"""
func filter_ordered(arr: Array[int]) -> Array[int]:
	var outarr: Array[int] = ordered.duplicate()
	outarr = outarr.filter(
		func(i: int):
			#prints("checking", i, i in arr)
			return i in arr
	)
	#prints("filtered:", arr, outarr)
	return outarr
"""


func sort_rules(a: int, b: int):
	if b in ordering_rules[a].before:
		return false
	elif b in ordering_rules[a].after:
		return true
	elif a in ordering_rules[b].before:
		return true
	elif a in ordering_rules[b].after:
		return false
	else:
		return ordered.find(a) < ordered.find(b)
