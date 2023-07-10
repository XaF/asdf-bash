<div align="center">

# asdf-bash [![Build](https://github.com/XaF/asdf-bash/actions/workflows/build.yml/badge.svg)](https://github.com/XaF/asdf-bash/actions/workflows/build.yml) [![Lint](https://github.com/XaF/asdf-bash/actions/workflows/lint.yml/badge.svg)](https://github.com/XaF/asdf-bash/actions/workflows/lint.yml)

[bash](https://www.gnu.org/software/bash/manual/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `ASDF_CONCURRENCY`: if you want to define the compilation concurrency when `make` is called to build a bash version

# Install

Plugin:

```shell
asdf plugin add bash
# or
asdf plugin add bash https://github.com/XaF/asdf-bash.git
```

bash:

```shell
# Show all installable versions
asdf list-all bash

# Install specific version
asdf install bash latest

# Set a version globally (on your ~/.tool-versions file)
asdf global bash latest

# Now bash commands are available
bash --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/XaF/asdf-bash/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Raphaël Beamonte](https://github.com/XaF/)
