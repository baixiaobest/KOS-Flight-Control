// This class is a singleton,
// use the command 'run once scheduler.',
// then use 'Scheduler()' to get singleton object.
@lazyglobal off.

local function SchdulerContainer {
	parameter param_module.
	parameter param_interval.

	local last_updated_time is 0.
	local module is param_module.
	local interval is param_interval.
	local initialized is false.

	// Run the function if time interval is reached.
	function update {
		if not initialized { 
			set initialized to true.
			if module:haskey("init") {
				module:init().
			}
		}

		local current is time:seconds.
		if current - last_updated_time > interval {
			set last_updated_time to current.
			module:run().
		}
	}

	return lexicon("update", update@).
}

local function create_scheduler {
	local modules is lexicon().

	// Add a module to scheduler.
	// module: An object that contains run() function.
	// rate: Running rate in hz.
	function add_module {
		parameter module_name.
		parameter module.
		parameter rate.

		local interval is 1.0 / rate.
		local container is SchdulerContainer(module, interval).

		modules:add(module_name, container).
	}

	// Run all modules at the defined rate.
	function run {
		for module_name in modules:keys() {
			modules[module_name]:update().
		}
	}

	return lexicon(
		"add_module", add_module@,
		"run", run@
		).
}

local scheduler_obj is create_scheduler().

function Scheduler {
	return scheduler_obj.
}