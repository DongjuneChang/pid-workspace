#!/bin/bash

cd build && rm -Rf * && cd ..
cd binaries && rm -Rf * && cd ..

if [-d "./public" ]; then
	rm -Rf public
fi
