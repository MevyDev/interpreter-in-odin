package main

import "core:fmt"
import "core:os"

main :: proc() {
	if len(os.args) != 2 {
		fmt.eprintln("expecting one source code file")
		return
	}
}
