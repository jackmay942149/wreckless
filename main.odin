package main

import "./core"

main :: proc() {
	context.logger = core.init_logger(.Jack, .All)
	core.user_info(.Jack, "Hello", "Hello")
}

