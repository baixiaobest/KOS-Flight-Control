// This class is a singleton, to use this class,
// use "run once publish_subscribe." command,
// then call PublishSubscribe() to get the singleton object.

@lazyglobal off.

local function create {
  // Member variables.
  local pub_sub_data is lexicon().

  // Member functions.

  // Subscribe to a topic, and when the
  // topic is updated, the callback function is called.
  function subscribe {
    parameter topic.
    parameter callback.

    if pub_sub_data:haskey(topic) {
      pub_sub_data[topic]:add(callback).
    }
    else {
      pub_sub_data:add(topic, list(callback)).
    }
  }

  // Publish to a topic with any value.
  function publish {
    parameter topic.
    parameter value.

    if not pub_sub_data:haskey(topic) {
      return.
    }
    for callback in pub_sub_data[topic] {
      callback(value).
    }
  }

  return lexicon(
    "subscribe", subscribe@,
    "publish", publish@
    ).
}

local publish_subscribe_obj is create().

function PublishSubscribe {
  return publish_subscribe_obj.
}