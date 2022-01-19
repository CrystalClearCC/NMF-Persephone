/obj/item/integrated_circuit/logic
	name = "logic gate"
	desc = "This tiny chip will decide for you!"
	extended_desc = "Logic circuits will treat a null, 0, and a \"\" string value as FALSE and anything else as TRUE. If inputs are of mismatching type, expect undocumented behaviour."
	complexity = 3
	outputs = list("result" = IC_PINTYPE_BOOLEAN)
	activators = list("compare" = IC_PINTYPE_PULSE_IN)
	category_text = "Logic"
	power_draw_per_use = 1

/obj/item/integrated_circuit/logic/binary
	inputs = list(
		"A" = IC_PINTYPE_ANY,
		"B" = IC_PINTYPE_ANY
	)
	activators = list(
		"compare" = IC_PINTYPE_PULSE_IN,
		"on true result" = IC_PINTYPE_PULSE_OUT,
		"on false result" = IC_PINTYPE_PULSE_OUT
	)

/obj/item/integrated_circuit/logic/binary/do_work()
	var/data1 = get_pin_data(IC_INPUT, 1)
	var/data2 = get_pin_data(IC_INPUT, 2)

	var/result = FALSE
	if (comparable(data1, data2))
		result = !!do_compare(data1, data2)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()

	if (result)
		activate_pin(2)
	else
		activate_pin(3)

/obj/item/integrated_circuit/logic/binary/proc/do_compare(A, B)
	return FALSE

/obj/item/integrated_circuit/logic/binary/proc/comparable(A, B)
	if (isnum(A) && isnum(B))
		. = TRUE
	else if (istext(A) && istext(B))
		. = TRUE
	else if (islist(A) && islist(B))
		. = TRUE
	else if (isdatum(A) && isdatum(B))
		. = TRUE
	else
		. = FALSE

/obj/item/integrated_circuit/logic/unary
	inputs = list(
		"A" = IC_PINTYPE_ANY
	)
	activators = list(
		"compare" = IC_PINTYPE_PULSE_IN,
		"on compare" = IC_PINTYPE_PULSE_OUT
	)

/obj/item/integrated_circuit/logic/unary/do_work()
	var/mydata = get_pin_data(IC_INPUT, 1)
	set_pin_data(IC_OUTPUT, 1, !!do_check(mydata))
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/logic/unary/proc/do_check(A)
	return FALSE

/obj/item/integrated_circuit/logic/binary/equals
	name = "equal gate"
	desc = "This gate compares two values, and outputs the number one if both are the same."
	icon_state = "equal"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/equals/do_compare(A, B)
	return A == B

/obj/item/integrated_circuit/logic/binary/jklatch
	name = "JK latch"
	desc = "This gate is a synchronized JK latch."
	icon_state = "jklatch"
	inputs = list("J" = IC_PINTYPE_ANY,"K" = IC_PINTYPE_ANY)
	outputs = list("Q" = IC_PINTYPE_BOOLEAN,"!Q" = IC_PINTYPE_BOOLEAN)
	activators = list("pulse in C" = IC_PINTYPE_PULSE_IN, "pulse out Q" = IC_PINTYPE_PULSE_OUT, "pulse out !Q" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/lstate=FALSE

/obj/item/integrated_circuit/logic/binary/jklatch/do_work()
	if(get_pin_data(IC_INPUT, 1))
		if(get_pin_data(IC_INPUT, 2))
			lstate=!lstate
		else
			lstate = TRUE
	else
		if(get_pin_data(IC_INPUT, 2))
			lstate=FALSE
	set_pin_data(IC_OUTPUT, 1, lstate ? TRUE : FALSE)
	set_pin_data(IC_OUTPUT, 2, !lstate ? TRUE : FALSE)
	if(get_pin_data(IC_OUTPUT, 1))
		activate_pin(2)
	else
		activate_pin(3)
	push_data()

/obj/item/integrated_circuit/logic/binary/rslatch
	name = "RS latch"
	desc = "This gate is a synchronized RS latch. If both R and S are true, its state will not change."
	icon_state = "sr_nor"
	inputs = list("S" = IC_PINTYPE_ANY,"R" = IC_PINTYPE_ANY)
	outputs = list("Q" = IC_PINTYPE_BOOLEAN,"!Q" = IC_PINTYPE_BOOLEAN)
	activators = list("pulse in C" = IC_PINTYPE_PULSE_IN, "pulse out Q" = IC_PINTYPE_PULSE_OUT, "pulse out !Q" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/lstate=FALSE

/obj/item/integrated_circuit/logic/binary/rslatch/do_work()
	if(get_pin_data(IC_INPUT, 1))
		if(!get_pin_data(IC_INPUT, 2))
			lstate=TRUE
	else
		if(get_pin_data(IC_INPUT, 2))
			lstate=FALSE
	set_pin_data(IC_OUTPUT, 1, lstate ? TRUE : FALSE)
	set_pin_data(IC_OUTPUT, 2, !lstate ? TRUE : FALSE)
	if(get_pin_data(IC_OUTPUT, 1))
		activate_pin(2)
	else
		activate_pin(3)
	push_data()

/obj/item/integrated_circuit/logic/binary/gdlatch
	name = "gated D latch"
	desc = "This gate is a synchronized gated D latch."
	icon_state = "gated_d"
	inputs = list("D" = IC_PINTYPE_ANY,"E" = IC_PINTYPE_ANY)
	outputs = list("Q" = IC_PINTYPE_BOOLEAN,"!Q" = IC_PINTYPE_BOOLEAN)
	activators = list("pulse in C" = IC_PINTYPE_PULSE_IN, "pulse out Q" = IC_PINTYPE_PULSE_OUT, "pulse out !Q" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/lstate=FALSE

/obj/item/integrated_circuit/logic/binary/gdlatch/do_work()
	if(get_pin_data(IC_INPUT, 2))
		if(get_pin_data(IC_INPUT, 1))
			lstate=TRUE
		else
			lstate=FALSE


	set_pin_data(IC_OUTPUT, 1, lstate ? TRUE : FALSE)
	set_pin_data(IC_OUTPUT, 2, !lstate ? TRUE : FALSE)
	if(get_pin_data(IC_OUTPUT, 1))
		activate_pin(2)
	else
		activate_pin(3)
	push_data()

/obj/item/integrated_circuit/logic/binary/not_equals
	name = "not equal gate"
	desc = "This gate compares two values, and outputs the number one if both are different."
	icon_state = "not_equal"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/not_equals/do_compare(A, B)
	return A != B

/obj/item/integrated_circuit/logic/binary/and
	name = "and gate"
	desc = "This gate will output 'one' if both inputs evaluate to true."
	icon_state = "and"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/and/do_compare(A, B)
	return A && B

/obj/item/integrated_circuit/logic/binary/or
	name = "or gate"
	desc = "This gate will output 'one' if one of the inputs evaluate to true."
	icon_state = "or"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/or/do_compare(A, B)
	return A || B

/obj/item/integrated_circuit/logic/binary/less_than
	name = "less than gate"
	desc = "This will output 'one' if the first input is less than the second input."
	icon_state = "less_than"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/less_than/do_compare(A, B)
	return A < B

/obj/item/integrated_circuit/logic/binary/less_than_or_equal
	name = "less than or equal gate"
	desc = "This will output 'one' if the first input is less than, or equal to the second input."
	icon_state = "less_than_or_equal"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/less_than_or_equal/do_compare(A, B)
	return A <= B

/obj/item/integrated_circuit/logic/binary/greater_than
	name = "greater than gate"
	desc = "This will output 'one' if the first input is greater than the second input."
	icon_state = "greater_than"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/greater_than/do_compare(A, B)
	return A > B

/obj/item/integrated_circuit/logic/binary/greater_than_or_equal
	name = "greater_than or equal gate"
	desc = "This will output 'one' if the first input is greater than, or equal to the second input."
	icon_state = "greater_than_or_equal"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/greater_than_or_equal/do_compare(A, B)
	return A >= B

/obj/item/integrated_circuit/logic/unary/not
	name = "not gate"
	desc = "This gate inverts what's fed into it."
	icon_state = "not"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	activators = list("invert" = IC_PINTYPE_PULSE_IN, "on inverted" = IC_PINTYPE_PULSE_OUT)

/obj/item/integrated_circuit/logic/unary/not/do_check(A)
	return !A
