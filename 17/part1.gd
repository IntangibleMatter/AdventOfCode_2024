#!/usr/bin/env -S godot --headless -s
extends SceneTree

var opcodes: Dictionary = {
	0: op_adv,
	1: op_bxl,
	2: op_bst,
	3: op_jnz,
	4: op_bxc,
	5: op_out,
	6: op_bdv,
	7: op_cdv,
}

var registers: Array = [0, 0, 0]
var pointer: int = 0
enum REG { A, B, C }
var instructions: Array[int]

# flags
var jumped: bool = false

var output: Array


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	registers[0] = f.get_line().to_int()
	registers[1] = f.get_line().to_int()
	registers[2] = f.get_line().to_int()
	f.get_line()
	instructions.assign(
		Array(f.get_line().replace("Program: ", "").split(",", false)).map(
			func(i) -> int: return i.to_int()
		)
	)

	while pointer < instructions.size():
		print()
		print_state()
		var opcode := instructions[pointer]
		opcodes[opcode].call()
		if jumped:
			jumped = false
		else:
			pointer += 2

	var fout := str(output).replace("[", "").replace("]", "").replace(" ", "")
	prints(fout)
	prints(fout.replace(",", ""))

	quit()


func print_state() -> void:
	prints("Pointer:", pointer)
	prints("registers:", registers)
	if pointer < instructions.size():
		prints("opcode:", instructions[pointer], "\toperand:", instructions[pointer + 1])
	else:
		print("POINTER OUT OF BOUNDS")


func get_op_value(literal: bool = false) -> int:
	if pointer + 1 > instructions.size():
		prints("FUCK FUCK")
		prints("FUCK FUCK")
		return -1
	if literal:
		return instructions[pointer + 1]
	match instructions[pointer + 1]:
		0, 1, 2, 3:
			return instructions[pointer + 1]
		4:
			return registers[REG.A]
		5:
			return registers[REG.B]
		6:
			return registers[REG.C]
	prints("ERRR, invalid combo operand:", instructions[pointer + 1])
	return -1


# opcode 0 (division)
func op_adv() -> void:
	print_rich("[color=blue]op_adv[/color]")
	var numer: int = registers[REG.A]
	var denom := get_op_value(false)
	if denom < 0:
		return
	denom = 2 ** denom
	registers[REG.A] = int(numer / denom)


# opcode 1 (bitwise xor)
func op_bxl() -> void:
	print_rich("[color=blue]op_bxl[/color]")
	var a: int = registers[REG.B]
	var b := get_op_value(true)
	if b < 0:
		return
	registers[REG.B] = a ^ b


# opcode 2 (mod 8)
func op_bst() -> void:
	print_rich("[color=blue]op_bst[/color]")
	var op := get_op_value(false)
	if op < 0:
		return
	registers[REG.B] = op % 8


# opcode 3 (jump)
func op_jnz() -> void:
	if registers[REG.A] == 0:
		print_rich("[color=blue]no jump[/color]")
		return
	else:
		print_rich("[color=blue]jump[/color]")
		var npointer := get_op_value(true)
		if npointer < 0:
			return
		pointer = npointer
		jumped = true


# opcode 4 (bitwise xor B/C)
func op_bxc() -> void:
	print_rich("[color=blue]op_bxc[/color]")
	var operand := get_op_value(false)
	if operand < 0:
		return
	registers[REG.B] = registers[REG.B] ^ registers[REG.C]


# opcode 5 (output)
func op_out() -> void:
	print_rich("[color=blue]op_out[/color]")
	var operand := get_op_value(false)
	if operand < 0:
		return
	output.append(operand % 8)
	print_rich("\t[color=green]%d[/color]" % (operand % 8))


# opcode 6 (division w/ B)
func op_bdv() -> void:
	print_rich("[color=blue]op_bdv[/color]")
	var numer: int = registers[REG.A]
	var denom := get_op_value(false)
	if denom < 0:
		return
	denom = 2 ** denom
	registers[REG.B] = int(numer / denom)


# opcode 7 (division w/ C)
func op_cdv() -> void:
	print_rich("[color=blue]op_cdv[/color]")
	var numer: int = registers[REG.A]
	var denom := get_op_value(false)
	if denom < 0:
		return
	denom = 2 ** denom
	registers[REG.C] = int(numer / denom)
