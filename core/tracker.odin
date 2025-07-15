package core

import "base:runtime"
import "core:log"
import "core:mem"

init_tracker :: proc() -> (^mem.Tracking_Allocator, mem.Allocator) {
	tracker := new(mem.Tracking_Allocator)
	mem.tracking_allocator_init(tracker, context.allocator)
	topic_info(.Core, "Created tracking allocator")
	return tracker, mem.tracking_allocator(tracker)
}

@(disabled = RELEASE)
check_tracker :: proc(tracker: ^mem.Tracking_Allocator) {
	topic_info(.Core, "Checking tracker allocator")
	for _, elem in tracker.allocation_map {
		topic_warn(.Core, "Allocation not freed:", elem.size, "bytes @", elem.location)
	}
	for elem in tracker.bad_free_array {
		topic_warn(.Core, "Incorrect frees:", elem.memory, "@", elem.location)
	}
}

@(disabled = RELEASE)
assert_tracker_empty :: proc(tracker: ^mem.Tracking_Allocator) {
	check_tracker(tracker)
	assert(len(tracker.allocation_map) == 0)
	assert(len(tracker.bad_free_array) == 0)
}

destroy_tracker :: proc(tracker: ^mem.Tracking_Allocator) {
	mem.tracking_allocator_destroy(tracker)
}

