# fedoratricks

`fedoratricks` is a collection of scripts to make the life of a beginner Fedora Linux user a little bit easier. We aspire to not spoon-feed the solution, but to also teach what these tools do for you under the hood.

## Table of Contents
* [Install](#install)
* [Documentation](#documentation)
* [Developer Guide](#developer-guide)
* [Contact](#contact)

---

### Install

Install from our [copr repository](https://copr.fedorainfracloud.org/coprs/rhea/fedoratricks/):

```bash
sudo dnf copr enable rhea/fedoratricks
sudo dnf install fedoratricks
```

---

### Documentation

Complete usage documentation, options, help guides, and command examples are available in the [Fedoratricks Command Reference](docs/docs.md).

For quick reference, the general command syntax is:
```bash
fedoratricks <command> <action> [options] [targets...]
```

After installing, you can also read the documentation directly in your terminal:
```bash
man fedoratricks
```

The man page source is written in [scdoc](https://git.sr.ht/~sircmpwn/scdoc) format and lives at `docs/fedoratricks.1.scd`. To build it locally:

```bash
# Fedora
sudo dnf install scdoc

# macOS
brew install scdoc

# Build
scdoc < docs/fedoratricks.1.scd > docs/fedoratricks.1
man ./docs/fedoratricks.1
```

---

### Developer Guide

If you are a developer looking to contribute, understand the transaction/rollback system, or write new command modules, check out the [Fedoratricks Developer Guide](docs/developer.md).

---

### Contact

Find us on the [Fedora Discord](https://discord.gg/fedora)
