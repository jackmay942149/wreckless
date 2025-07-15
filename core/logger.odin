package core

import "base:runtime"
import "core:log"
import "core:os"
import "core:fmt"

Logger_User :: enum {
	All,
	Jack,
}

Logger_Topic :: enum {
	All,
	Temp,
	Core,
	Graphics,
}

@(private = "file")
Logger_Context :: struct {
	user:         Logger_User,
	topic:        Logger_Topic,
	log: ^log.Logger,
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
	logger_ctx = {user, topic, nil}

	// Create terminal logger
	info_opt := log.Options{.Level, .Terminal_Color}
	info_log := log.create_console_logger(.Info, info_opt, "", context.allocator)
	context.logger = info_log
	logger_ctx.log = &info_log

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
	logger_ctx.log = &logger
	topic_info(.Core, "Created logger")
	return logger
}

// TODO: Destroy logger

@(disabled = RELEASE)
user_debug :: proc(user: Logger_User, args: ..any, location := #caller_location) {
	if logger_ctx.user != .All && user != logger_ctx.user && user != .All {
		return
	}
	log.debug(user, location)
	log.debug(..args)
	fmt.println("")
	
}

@(disabled = RELEASE)
user_info :: proc(user: Logger_User, args: ..any, location := #caller_location) {
	if logger_ctx.user != .All && user != logger_ctx.user && user != .All {
		return
	}
	log.info(user, location)
	log.info(..args)
	fmt.println("")
	
}

@(disabled = RELEASE)
user_warn :: proc(user: Logger_User, args: ..any, location := #caller_location) {
	if logger_ctx.user != .All && user != logger_ctx.user && user != .All {
		return
	}
	log.warn(user, location)
	log.warn(..args)
	fmt.println("")
	
}

@(disabled = RELEASE)
user_error :: proc(user: Logger_User, args: ..any, location := #caller_location) {
	if logger_ctx.user != .All && user != logger_ctx.user && user != .All {
		return
	}
	log.error(user, location)
	log.error(..args)
	fmt.println("")
	
}

@(disabled = RELEASE)
user_fatal :: proc(user: Logger_User, args: ..any, location := #caller_location) {
	if logger_ctx.user != .All && user != logger_ctx.user && user != .All {
		return
	}
	log.fatal(user, location)
	log.fatal(..args)
	fmt.println("")
	
}

@(disabled = RELEASE)
topic_debug :: proc(topic: Logger_Topic, args: ..any, location := #caller_location) {
	if logger_ctx.topic != .All && topic != logger_ctx.topic && topic != .All {
		return
	}
	log.debug(topic, location)
	log.debug(..args)
	fmt.println("")
	
}

@(disabled = RELEASE)
topic_info :: proc(topic: Logger_Topic, args: ..any, location := #caller_location) {
	if logger_ctx.topic != .All && topic != logger_ctx.topic && topic != .All {
		return
	}
	log.info(topic, location)
	log.info(..args)
	fmt.println("")
	
}

@(disabled = RELEASE)
topic_warn :: proc(topic: Logger_Topic, args: ..any, location := #caller_location) {
	if logger_ctx.topic != .All && topic != logger_ctx.topic && topic != .All {
		return
	}
	log.warn(topic, location)
	log.warn(..args)
	fmt.println("")
	
}

@(disabled = RELEASE)
topic_error :: proc(topic: Logger_Topic, args: ..any, location := #caller_location) {
	if logger_ctx.topic != .All && topic != logger_ctx.topic && topic != .All {
		return
	}
	log.error(topic, location)
	log.error( ..args)
	fmt.println("")
}

@(disabled = RELEASE)
topic_fatal :: proc(topic: Logger_Topic, args: ..any, location := #caller_location) {
	if logger_ctx.topic != .All && topic != logger_ctx.topic && topic != .All {
		return
	}
	log.fatal(topic, location)
	log.fatal(..args)
	fmt.println("")
	
	assert(false)
}

