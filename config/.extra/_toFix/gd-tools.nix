{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    # Header-only subprocess library
    cpp-subprocess = pkgs.stdenv.mkDerivation {
      pname = "cpp-subprocess";
      version = "2024.01.25";
      src = pkgs.fetchFromGitHub {
        owner = "arun11299";
        repo = "cpp-subprocess";
        rev = "cfad1d02dfbe03a985b38059c16ea58c80df4bb0";
        hash = "sha256-zCQ59Lfk3rCuAXtrwYeF/fthTKbj5IrOY3/RrotpJ4w=";
      };
      installPhase = ''
        mkdir -p $out/include
        cp cpp-subprocess/subprocess.hpp $out/include/
      '';
    };

    # Rikaitan deinflector reference implementation
    rdricpp = pkgs.stdenv.mkDerivation {
      pname = "rdricpp";
      version = "0.3";
      src = pkgs.fetchFromGitHub {
        owner = "Ajatt-Tools";
        repo = "rdricpp";
        rev = "e27700c520988e85b1452a808e7902640e69f251";
        hash = "sha256-2egobwMU7dPsld8oZZyUWZyx2sSjyWUEP2m/XMZAKps=";
      };
      buildPhase = ''
        g++ -std=c++23 -O2 -c src/rdricpp.cpp -o rdricpp.o -I src
        ar rcs librdricpp.a rdricpp.o
      '';
      installPhase = ''
        mkdir -p $out/include/rdricpp $out/lib
        cp src/*.h $out/include/rdricpp/
        cp librdricpp.a $out/lib/
      '';
    };

    gd-tools = pkgs.stdenv.mkDerivation rec {
      pname = "gd-tools";
      version = "unstable-2024";
      src = pkgs.fetchFromGitHub {
        owner = "Ajatt-Tools";
        repo = "gd-tools";
        rev = "c8792ee57c9b41654c0ea09f666f8eb5b757ccc1";
        hash = "sha256-n6SRV1erSm/fzP7YQG9XESBAAFNA7SPFVfuQ7pTRRWI=";
      };
      nativeBuildInputs = with pkgs; [
        pkg-config
      ];
      buildInputs = with pkgs; [
        libcpr
        curl
        openssl
        nlohmann_json
        marisa
        mecab
      ];
      postPatch = ''
        substituteInPlace src/marisa_split.cpp \
        --replace '/usr/share/gd-tools' "${placeholder "out"}/share/gd-tools"
      '';
      buildPhase = ''
        runHook preBuild
        g++ -std=c++23 -O2 \
          -I${cpp-subprocess}/include \
          -I${rdricpp}/include \
          -I${pkgs.nlohmann_json}/include \
          -I${pkgs.marisa}/include \
          -I${pkgs.mecab}/include \
          -I${pkgs.libcpr}/include \
          -D_GLIBCXX_ASSERTIONS \
          -o gd-tools \
          src/main.cpp \
          src/anki_search.cpp \
          src/echo.cpp \
          src/images.cpp \
          src/kana_conv.cpp \
          src/marisa_split.cpp \
          src/massif.cpp \
          src/mecab_split.cpp \
          src/translate.cpp \
          src/util.cpp \
          -L${rdricpp}/lib -lrdricpp \
          -L${pkgs.marisa}/lib -lmarisa \
          -L${pkgs.mecab}/lib -lmecab \
          -L${pkgs.libcpr}/lib -lcpr \
          -L${pkgs.curl}/lib -lcurl \
          -pthread
        runHook postBuild
      '';
      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin $out/share/gd-tools $out/share/fonts/gd-tools
        install -Dm755 gd-tools $out/bin/gd-tools
        for variant in gd-ankisearch gd-echo gd-massif gd-images gd-marisa gd-mecab gd-translate; do
          ln -s $out/bin/gd-tools $out/bin/$variant
        done
        for script in src/*.sh; do
          install -Dm755 "$script" "$out/bin/$(basename $script)"
        done
        cp res/*.dic $out/share/gd-tools/ 2>/dev/null || true
        cp res/*.ttf $out/share/fonts/gd-tools/ 2>/dev/null || true
        runHook postInstall
      '';
      meta = with lib; {
        description = "A set of tools to enhance GoldenDict for immersion learning";
        homepage = "https://github.com/Ajatt-Tools/gd-tools";
        license = licenses.gpl3;
        platforms = platforms.linux;
      };
    };
  in {
    packages.gd-tools = gd-tools;
  };
}

