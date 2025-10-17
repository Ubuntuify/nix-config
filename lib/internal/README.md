### Internal functions

An internal function is a function that does not require to be tapped into by any
configuration, such as a nix-darwin, NixOS, or home-manager configuration. It is
simply used internally to create features of this specific flake, and has no place
being called anywhere else.

For example, the `mkHomeModules` function is only used to support the usage of
`system-helpers.nix` modules, and how it interacts. Something that won't be used
directly in a configuration (even if it could).

It can change internally how it works as long as the other functions that rely on
it change with it, as the other functions

It's therefore supposed to be relied upon as little as possible, to prevent major
breakages in the nix configuration, and usage of it directly is highly frowned upon.

It is similar in that regard to internal Windows syscalls, or the Linux ABI (which is
practically not existent).

#### Some functions here seem similar to non-internal functions

That's correct, but those functions rely on these internal functions, they are somewhat
the helpers to the helpers.

For example, internally, there's a way to get common modules of a certain directory,
directly (you have to specify the path of the directory which you want to get the modules
from). The outer/top-level function doesn't need you to specify which directory as it's
already specified to how the flake is structured.

If you want some more fine-grained control on how the flake works, you use internal
functions, but otherwise, the top-level functions should be good enough.
