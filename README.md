Description
===========

Binwalk is a fast, easy to use tool for analyzing, reverse engineering, and extracting firmware images.

Installation
============

Binwalk follows the standard Unix configure/make installation procedure:

```bash
$ autoreconf
$ ./configure
$ make
$ sudo make install
```

For convenience, optional dependencies for automatic extraction and graphical visualizations can be installed by running the included `deps.sh` script:

```bash
$ ./deps.sh
```

If your system is not supported by `deps.sh`, or if you wish to manually install dependencies, see `INSTALL.md`.

For advanced installation options, see `INSTALL.md`.

Usage
=====

Basic usage is simple:

```bash
$ binwalk firmware.bin
```

For additional examples and descriptions of advanced options, see the [wiki](https://github.com/devttys0/binwalk/wiki).
