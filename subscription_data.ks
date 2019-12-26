// Data that stores subscribed data. 
@lazyglobal off.

run once publish_subscribe.

function SubscriptionData {
	parameter topic.
	parameter default_value is 0.

	local data is default_value.
	local data_updated is false.
	local ever_published is false.

	function callback {
		parameter new_data.

		set data to new_data.
		set data_updated to true.
		set ever_published to true.
	}

	local subscriber is PublishSubscribe().
	subscriber:subscribe(topic, callback@).

	function get {
		set data_updated to false.
		return data.
	}

	function is_updated {
		return data_updated.
	}

	function is_ever_published {
		return ever_published.
	}

	return lexicon(
		"get", get@,
		"is_updated", is_updated@,
		"is_ever_published", is_ever_published@
		).
}