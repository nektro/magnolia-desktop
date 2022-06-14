#!/usr/bin/env bash

set -e

time zig build --prominent-compile-errors -Dall -Drelease-safe

./zig-out/bin/magnolia-triangle
./zig-out/bin/magnolia-demo-centersquare
./zig-out/bin/magnolia-demo-focusblur
./zig-out/bin/magnolia-demo-layout
./zig-out/bin/magnolia-demo-layout2
./zig-out/bin/magnolia-demo-margin
./zig-out/bin/magnolia-demo-text
./zig-out/bin/magnolia-demo-centersquare2
./zig-out/bin/magnolia-demo-text2
