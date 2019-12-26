run once subscription_data.
run once publish_subscribe.

local function create {
	local pub_sub is PublishSubscribe().
	local vector_debug_name_value_map is lexicon().

	function vector_debug_callback {
		parameter debug_msg.

		local name is debug_msg:name.
		local start is debug_msg:start.
		local vec is debug_msg:vec.
		local color is debug_msg:color.

		if vector_debug_name_value_map:haskey(name) {
			set vector_debug_name_value_map[name] to lexicon(
				"start", start, "vec", vec).
		}
		else {
			if color = 0 {
				set color to rgb(random(), random(), random()).
			}

			vector_debug_name_value_map:add(
				name, 
				lexicon("start", start, "vec", vec)).
			
			vecdraw(
				{return vector_debug_name_value_map[name]:start.},
				{return vector_debug_name_value_map[name]:vec.},
				color,
				name,
				1.0,
				true).
		}
	}

	function init {
		pub_sub:subscribe("/debug/vector", vector_debug_callback@).
	}

	function run {

	}

	return lexicon(
		"run", run@,
		"init", init@).
}

local draw_debug_obj is create().

function DrawDebug {
	return draw_debug_obj.
}

function draw_debug_vector {
	parameter name.
	parameter start.
	parameter vec.
	parameter color is 0.

	PublishSubscribe():publish(
		"/debug/vector", 
		lexicon("name", name,
				"start", start,
				"vec", vec,
				"color", color)).
}