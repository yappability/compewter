{ lib, stdenvNoCC, fetchurl, autoPatchelfHook, unzip, installShellFiles, openssl
, writeShellScript, curl, jq, common-updater-scripts }:

# unforunately, the maintainer of the original bun package in nixpkgs, didnt put the baseline executable for bun, and since my computer is pretty old, I need to baseline executable to use bun.
stdenvNoCC.mkDerivation rec {
  version = "1.0.30";
  pname = "bun";

  src = passthru.sources.${stdenvNoCC.hostPlatform.system} or (throw
    "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  strictDeps = true;
  nativeBuildInputs = [ unzip installShellFiles ]
    ++ lib.optionals stdenvNoCC.isLinux [ autoPatchelfHook ];
  buildInputs = [ openssl ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm 755 ./bun $out/bin/bun
    ln -s $out/bin/bun $out/bin/bunx

    runHook postInstall
  '';

  postPhases = [ "postPatchelf" ];
  postPatchelf = lib.optionalString
    (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
      completions_dir=$(mktemp -d)

      SHELL="bash" $out/bin/bun completions $completions_dir
      SHELL="zsh" $out/bin/bun completions $completions_dir
      SHELL="fish" $out/bin/bun completions $completions_dir

      installShellCompletion --name bun \
        --bash $completions_dir/bun.completion.bash \
        --zsh $completions_dir/_bun \
        --fish $completions_dir/bun.fish
    '';

  passthru = {
    sources = {
      "aarch64-darwin" = fetchurl {
        url =
          "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
        hash = "sha256-Upgh45aYCNmW1we/+2VsNbJl718HKQNFoAg0zDmHSwA=";
      };
      "aarch64-linux" = fetchurl {
        url =
          "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-aarch64.zip";
        hash = "sha256-RhHJ3H6tA8te1sk0eMEb5jBHFoAvfBTUWQo6O3ycMCs=";
      };
      "x86_64-darwin" = fetchurl {
        url =
          "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64.zip";
        hash = "sha256-TSnZ727ERoglVxJQ/Ve+YkZNezYD1YxwJRw2sC1F0ro=";
      };
      "x86_64-linux" = fetchurl {
        url =
          "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
        hash =
          "sha256-k9q2idr4zMg+gWanJMlSsz2QcQFAhw3tSs2zBf6496E="; # get the new hash by changing version, building, and replace this hash with the hash the one that was specified in the error
      };
    };
    updateScript = writeShellScript "update-bun" ''
      set -o errexit
      export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
      NEW_VERSION=$(curl --silent https://api.github.com/repos/oven-sh/bun/releases/latest | jq '.tag_name | ltrimstr("bun-v")' --raw-output)
      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs meta.platforms}; do
        update-source-version "bun" "0" "${lib.fakeHash}" --source-key="sources.$platform"
        update-source-version "bun" "$NEW_VERSION" --source-key="sources.$platform"
      done
    '';
  };
  meta = with lib; {
    homepage = "https://bun.sh";
    changelog = "https://bun.sh/blog/bun-v${version}";
    description =
      "Incredibly fast JavaScript runtime, bundler, transpiler and package manager – all in one";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    longDescription = ''
      All in one fast & easy-to-use tool. Instead of 1,000 node_modules for development, you only need bun.
    '';
    license = with licenses; [
      mit # bun core
      lgpl21Only # javascriptcore and webkit
    ];
    platforms = builtins.attrNames passthru.sources;
    # Broken for Musl at 2024-01-13, tracking issue:
    # https://github.com/NixOS/nixpkgs/issues/280716
    broken = stdenvNoCC.hostPlatform.isMusl;
  };
}
