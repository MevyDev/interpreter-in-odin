package main

Tokenizer :: struct {
	source:      string,
	source_path: string,
	using pos:   Pos,
}

skip_whitespace :: proc(tokenizer: ^Tokenizer) {
	assert(tokenizer.idx < len(tokenizer.source))
	for tokenizer.idx < len(tokenizer.source) {
		switch tokenizer.source[tokenizer.idx] {
		case '\n':
			tokenizer.idx += 1
			tokenizer.line += 1
			tokenizer.col = 0
		case ' ', '\r':
			tokenizer.idx += 1
		case:
			return
		}
	}
}

peek :: proc(tokenizer: ^Tokenizer) -> u8 {
	assert(tokenizer.idx < len(tokenizer.source))
	return tokenizer.source[tokenizer.idx]
}
