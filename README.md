# Magnolia
![loc](https://sloc.xyz/github/nektro/magnolia-desktop)

**Magnolia** is a new UI toolkit written entirely from scratch in Zig for Linux desktops. It has a focus on ease-of-use, performance, and supporting older devices.

The only runtime system dependencies are X11 and OpenGL.

The only additional build dependencies are [Git](https://git-scm.com/), [Zig](https://ziglang.org/), [Zigmod](https://github.com/nektro/zigmod).

> Note: this project is a WIP and still in a very experimental state. Stay tuned for more updates.

As far as problem space you can consider this project as an alternative to a mix of GTK/KDE/QT and GNOME/Plasma depending on which part of the code you're using.

## License

Source-Available, All rights reserved. (c) 2022 Meghan Denny

[Cozette](https://github.com/slavfox/Cozette) font, MIT. (c) 2020 Slavfox

## Credits
- Zig master
- See [`zig.mod`](./zig.mod) and [`zigmod.lock`](./zigmod.lock)

## Building

Magnolia is built using the Zig build system. To see all available build options run `zig build --help`.

If building on NixOS, there is a `shell.nix` which will enable all the system dependencies needed.

Pull in the Zig dependencies by running `zigmod ci`.

### Options
- `-Dtarget=[string]            The CPU architecture, OS, and ABI to build for`
- `-Dcpu=[string]               Target CPU features to add or subtract`
- `-Drelease-safe=[bool]        Optimizations on and safety on`
- `-Drelease-fast=[bool]        Optimizations on and safety off`
- `-Drelease-small=[bool]       Size optimizations on and safety off`
- `-Dall=[bool]                 Build all apps, default only selected steps`
- `-Drun=[bool]                 Run the app too`
- `-Dstrip=[bool]               Strip debug symbols`

### Available Steps
- `triangle`
- `demo-centersquare`
- `demo-focusblur`
- `demo-layout`
- `demo-layout2`
- `demo-margin`
- `demo-text`
- `demo-centersquare2`
- `demo-text2`
