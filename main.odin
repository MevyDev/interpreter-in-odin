package main

import "core:fmt"
import "core:os"
import "core:path/filepath"

main :: proc() {
	if len(os.args) != 2 {
		fmt.eprintln("Error: expecting one source code file")
		return
	}

	raw_path := os.args[1]

	abs_source_path, abs_err := filepath.abs(raw_path)
	if abs_err != nil {
		fmt.eprintfln("Error: path %s could not be converted to an absolute path", raw_path)
		return
	}

	source_path, clean_err := filepath.clean(abs_source_path)
	if clean_err != nil {
		fmt.eprintfln("Error: path %s could not be cleaned up", abs_source_path)
		return
	}

	if !os.is_file(source_path) {
		fmt.eprintfln("Error: file %s doesn't exist", raw_path)
		return
	}

	source_content_bytes, read_err := os.read_entire_file(source_path, context.allocator)
	if read_err != nil {
		fmt.eprintln("Error: file %s could not be read", raw_path)
	}
	source_content := string(source_content_bytes)

	tokenizer := Tokenizer {
		source      = source_content,
		source_path = source_path,
	}

	for true {
		tok := scan(&tokenizer)
		fmt.println(tok)
		if tok.kind == .EOF {
			break
		}
	}
}
