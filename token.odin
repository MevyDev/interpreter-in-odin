package main

Token :: struct {
	kind:      TokenKind,
	literal:   string,
	using pos: Pos,
}

Pos :: struct {
	idx:  int,
	line: int,
	col:  int,
}

TokenKind :: enum {
	Invalid, // nil
	EOF,
	Comment,
	Semicolon,

	// Literals
	Identifier,
	Integer,

	// Operators
	NotEql, // !=
	Eql, // ==
	Not, // !
	Add, // +
	Sub, // -
	Mul, // *
	Div, // /
	Mod, // %

	// Keywords
	Loop, // loop
	If, // if
	And, // and
	Or, // or
	Assign, // =
}
