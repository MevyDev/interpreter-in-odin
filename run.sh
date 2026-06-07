#!/bin/bash

mkdir -p out
odin build . -out:./out/out

exec ./out/out "$@"
