package main

Tokenizer :: struct {
	source:      string,
	source_path: string,
	using pos:   Pos,
}

skip_whitespace :: proc(t: ^Tokenizer) {
	assert(t.idx < len(t.source))
	for t.idx < len(t.source) {
		switch t.source[t.idx] {
		case '\n':
			t.idx += 1
			t.line += 1
			t.col = 0
		case ' ', '\r':
			t.idx += 1
		case:
			return
		}
	}
}

peek :: proc(t: ^Tokenizer) -> u8 {
	if t.idx >= len(t.source) {
		return 0
	}
	return t.source[t.idx]
}

advance :: proc(t: ^Tokenizer) {
	assert(t.idx < len(t.source))
	switch t.source[t.idx] {
	case '\n':
		t.idx += 1
		t.line += 1
		t.col = 0
	case:
		t.idx += 1
	}
}

eof_token :: proc(t: ^Tokenizer) -> Token {
	return Token{kind = .EOF, pos = t.pos, literal = ""}
}

scan_comment :: proc(t: ^Tokenizer) -> Token {
	// it's on the same line, we can just deadvance this way
	t.idx -= 1
	t.col -= 1
	pos := t.pos
	loop: for true {
		switch peek(t) {
		case 0, '\n', '\r':
			break loop
		}
		advance(t)
	}
	kind: TokenKind = .Comment
	assert(t.idx < len(t.source))
	lit: string = t.source[pos.idx:t.idx]
	return Token{kind = kind, literal = lit, pos = pos}
}

digit_value :: proc(char: u8) -> int {
	switch char {
	case '0' ..= '9':
		return int(char - '0')
	case:
		return 255
	}
}
scan :: proc(t: ^Tokenizer) -> Token {
	if t.idx >= len(t.source) {
		return eof_token(t)
	}

	skip_whitespace(t)

	start_pos := t.pos
	kind: TokenKind
	lit: string

	switch ch := peek(t); ch {
	case 0:
		return eof_token(t)
	case '0' ..= '9':
	// return scan_num(t)
	case 'a' ..= 'z', 'A' ..= 'Z', '_':
	// return scan_iden(t)
	case:
		advance(t)
		switch ch {
		case ';':
			kind = .Semicolon
		case '*':
			kind = .Mul
		case '/':
			kind = .Div
			if peek(t) == '/' {
				// the position is deadvanced inside the scan_comment proc
				return scan_comment(t)
			}
		case '+':
			kind = .Add
		case '-':
			kind = .Sub
		case '=':
			kind = .Assign
			if peek(t) == '=' {
				advance(t)
				kind = .Eql
			}
		case '%':
			kind = .Mod
		case '!':
			kind = .Not
			if peek(t) == '=' {
				advance(t)
				kind = .NotEql
			}
		}
	}

	if lit == "" {
		lit = t.source[start_pos.idx:t.idx]
	}

	return Token{kind = kind, literal = lit, pos = t.pos}
}
