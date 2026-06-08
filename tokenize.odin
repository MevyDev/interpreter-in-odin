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
	if tokenizer.idx >= len(tokenizer.source) {
		return 0
	}
	return tokenizer.source[tokenizer.idx]
}

advance :: proc(tokenizer: ^Tokenizer) {
	assert(tokenizer.idx < len(tokenizer.source))
	switch tokenizer.source[tokenizer.idx] {
	case '\n':
		tokenizer.idx += 1
		tokenizer.line += 1
		tokenizer.col = 0
	case:
		tokenizer.idx += 1
	}
}

eof_token :: proc(tokenizer: ^Tokenizer) -> Token {
	return Token{kind = .EOF, pos = tokenizer.pos, literal = ""}
}

scan_comment :: proc(tokenizer: ^Tokenizer) -> Token {
	// it's on the same line, we can just deadvance this way
	tokenizer.idx -= 1
	tokenizer.col -= 1
	pos := tokenizer.pos
	loop: for true {
		switch peek(tokenizer) {
		case 0, '\n', '\r':
			break loop
		}
		advance(tokenizer)
	}
	kind: TokenKind = .Comment
	assert(tokenizer.idx < len(tokenizer.source))
	lit: string = tokenizer.source[pos.idx:tokenizer.idx]
	return Token{kind = kind, literal = lit, pos = pos}
}

scan :: proc(tokenizer: ^Tokenizer) -> Token {
	if tokenizer.idx >= len(tokenizer.source) {
		return eof_token(tokenizer)
	}

	skip_whitespace(tokenizer)

	start_pos := tokenizer.pos
	kind: TokenKind
	lit: string

	switch ch := peek(tokenizer); ch {
	case 0:
		return eof_token(tokenizer)
	case '0' ..= '9':
	// return scan_num(tokenizer)
	case 'a' ..= 'z', 'A' ..= 'Z', '_':
	// return scan_iden(tokenizer)
	case:
		advance(tokenizer)
		switch ch {
		case ';':
			kind = .Semicolon
		case '*':
			kind = .Mul
		case '/':
			kind = .Div
			if peek(tokenizer) == '/' {
				// the position is deadvanced inside the scan_comment proc
				return scan_comment(tokenizer)
			}
		case '+':
			kind = .Add
		case '-':
			kind = .Sub
		case '=':
			kind = .Assign
			if peek(tokenizer) == '=' {
				advance(tokenizer)
				kind = .Eql
			}
		case '%':
			kind = .Mod
		case '!':
			kind = .Not
			if peek(tokenizer) == '!' {
				advance(tokenizer)
				kind = .NotEql
			}
		}
	}

	if lit == "" {
		lit = tokenizer.source[start_pos.idx:tokenizer.idx]
	}

	return Token{kind = kind, literal = lit, pos = tokenizer.pos}
}
