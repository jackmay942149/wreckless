package core

import "base:runtime"
import "core:log"
import "core:os"

Logger_User :: enum {
	All,
	Jack,
}

Logger_Topic :: enum {
	All,
	Temp,
	Core,
}

@(private = "file")
Logger_Context :: struct {
	user:  Logger_User,
	topic: Logger_Topic,
}

@(private = "file")
logger_ctx: Logger_Context

init_logger :: proc(
	user := Logger_User.All,
	topic := Logger_Topic.All,
	file: string = "",
	allocator := context.allocator,
) -> log.Logger {
	context.allocator = allocator
	logger_ctx = {user, topic}

	// Create terminal logger
	info_opt := log.Options{.Level}
	info_log := log.create_console_logger(.Info, info_opt, "", context.allocator)
	context.logger = info_log

	// Return early if no file logger
	if file == "" {
		logger := info_log
		return logger
	}

	// Create file logger
	os.remove(file)
	handle, err := os.open(file, os.O_CREATE | os.O_WRONLY)
	if err != nil {
		log.fatal("Failed to open file logger")
	}
	debug_log := log.create_file_logger(
		handle,
		.Debug,
		log.Default_File_Logger_Opts,
		"",
		context.allocator,
	)

	logger := log.create_multi_logger(debug_log, info_log, allocator = context.allocator)
	log.info("Created logger")
	return logger
}

@(disabled = RELEASE)
user_debug :: proc(user: Logger_User, args: ..any, location := #caller_location) {
	if logger_ctx.user != .All && user != logger_ctx.user && user != .All {
		return
	}
	for a in args {
		log.debug(user, location, "-", a)
	}
}

@(disabled = RELEASE)
user_info :: proc(user: Logger_User, args: ..any, location := #caller_location) {
	if logger_ctx.user != .All && user != logger_ctx.user && user != .All {
		return
	}
	for a in args {
		log.info(user, location, "-", a)
	}
}

@(disabled = RELEASE)
user_warn :: proc(user: Logger_User, args: ..any, location := #caller_location) {
	if logger_ctx.user != .All && user != logger_ctx.user && user != .All {
		return
	}
	for a in args {
		log.warn(user, location, "-", a)
	}
}

@(disabled = RELEASE)
user_error :: proc(user: Logger_User, args: ..any, location := #caller_location) {
	if logger_ctx.user != .All && user != logger_ctx.user && user != .All {
		return
	}
	for a in args {
		log.error(user, location, "-", a)
	}
}

@(disabled = RELEASE)
user_fatal :: proc(user: Logger_User, args: ..any, location := #caller_location) {
	if logger_ctx.user != .All && user != logger_ctx.user && user != .All {
		return
	}
	for a in args {
		log.fatal(user, location, "-", a)
	}
}

@(disabled = RELEASE)
topic_debug :: proc(topic: Logger_Topic, args: ..any, location := #caller_location) {
	if logger_ctx.topic != .All && topic != logger_ctx.topic && topic != .All {
		return
	}
	for a in args {
		log.debug(topic, location, "-", a)
	}
}

@(disabled = RELEASE)
topic_info :: proc(topic: Logger_Topic, args: ..any, location := #caller_location) {
	if logger_ctx.topic != .All && topic != logger_ctx.topic && topic != .All {
		return
	}
	for a in args {
		log.info(topic, location, "-", a)
	}
}

@(disabled = RELEASE)
topic_warn :: proc(topic: Logger_Topic, args: ..any, location := #caller_location) {
	if logger_ctx.topic != .All && topic != logger_ctx.topic && topic != .All {
		return
	}
	for a in args {
		log.warn(topic, location, "-", a)
	}
}

@(disabled = RELEASE)
topic_error :: proc(topic: Logger_Topic, args: ..any, location := #caller_location) {
	if logger_ctx.topic != .All && topic != logger_ctx.topic && topic != .All {
		return
	}
	for a in args {
		log.error(topic, location, "-", a)
	}
}

@(disabled = RELEASE)
topic_fatal :: proc(topic: Logger_Topic, args: ..any, location := #caller_location) {
	if logger_ctx.topic != .All && topic != logger_ctx.topic && topic != .All {
		return
	}
	for a in args {
		log.fatal(topic, location, "-", a)
	}
	assert(false)
}

