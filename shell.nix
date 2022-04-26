with import <nixpkgs> {};

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    gcc
    x11
    mesa_glu
  ];

  hardeningDisable = [ "all" ];
}
