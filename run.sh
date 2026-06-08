#!/bin/bash

mkdir -p out
odin build . -out:./out/out -debug

exec ./out/out "$@"
