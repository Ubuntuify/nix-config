#!/usr/bin/env bash

BUILD_ATTR="github:Ubuntuify/nix-config#nixosConfigurations.Andromeda-WSL.config.system.build.tarballBuilder"

if command -v fakeroot >/dev/null 2>@1; then
  echo "Using fakeroot environment to create tarball.."
  exec fakeroot -u /tmp/build-wsl-tarball -- nix run $BUILD_ATTR
fi

if command -v doas >/dev/null 2>@1; then
  echo "Using doas for elevation to create tarball.."
  exec doas nix run $BUILD_ATTR
fi

if command -v sudo >/dev/null 2>@1; then
  echo "Using sudo for elevation to create tarball.."
  exec sudo nix run $BUILD_ATTR
fi

if command -v run0 >/dev/null 2>@1; then
  echo "Using run0 (systemd) for elevation to create tarball.."
  exec run0 nix run $BUILD_ATTR
fi

echo "Could not find an elevation program to use.. (Is PATH set correctly?)"
exit 255
