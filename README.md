# fedoratricks

`fedoratricks` is a collection of scripts to make the life of a beginner Fedora Linux user a little bit easier. We aspire to not spoon-feed the solution, but to also teach what these tools do for you under the hood.

## Table of Contents
* [Install](#install)
* [Usage Overview](#usage-overview)
* [Available Commands](#available-commands)
  * [1. rpmfusion](#1-rpmfusion)
  * [2. codecs](#2-codecs)
  * [3. secureboot](#3-secureboot)
  * [4. nvidiadrivers](#4-nvidiadrivers)
  * [5. Developer & Utility Commands](#5-developer--utility-commands)
* [Contact](#contact)

---

### Install

Install from our [copr repository](https://copr.fedorainfracloud.org/coprs/rhea/fedoratricks/):

```bash
sudo dnf copr enable rhea/fedoratricks
sudo dnf install fedoratricks
```

---

### Usage Overview

The tool is structured around specific system components. The general syntax is:

```bash
fedoratricks <command> [options] [targets...]
```

You can append `-h` or `--help` to any command to see its specific manual (e.g., `fedoratricks codecs -h`).

*Note: Commands modifying kernel modules or repositories generally require root (`sudo`) privileges. OSTree-based systems (Silverblue/Kinoite) currently have limited support and are explicitly blocked on certain commands to prevent system breakage.*

---

### Available Commands

#### 1. `rpmfusion`
Manages the community-driven RPM Fusion Free and Non-Free repositories, which provide software that the Fedora Project cannot ship due to licensing restrictions.

**Options:**
* `-i`, `--install` : Install the repositories to your system.
* `-r`, `--remove`  : Uninstall the repositories entirely.
* `-e`, `--enable`  : Re-enable the repositories if they were disabled.
* `-d`, `--disable` : Disable the repositories without uninstalling them.

**Examples:**
```bash
sudo fedoratricks rpmfusion -i
sudo fedoratricks rpmfusion -d
```

#### 2. `codecs`
Installs essential multimedia codecs (like SVT-AV1, GStreamer plugins, and HEIF support) and configures hardware acceleration for your specific GPU.
*(Requires RPM Fusion to be enabled).*

**Options:**
* `-i`, `--install` : Install codecs and apply hardware modprobe configurations.
* `-r`, `--remove`  : Remove codecs and revert configurations.
* `--pre-skylake`   : (Intel only) Override auto-detection for CPUs older than 6th Gen.
* `--skylake`       : (Intel only) Override auto-detection for 6th–10th Gen CPUs.
* `--tigerlake`     : (Intel only) Override auto-detection for 11th Gen+ CPUs.

**Targets:**
Specify one or more GPU vendors: `intel`, `amd`, `nvidia`.

**Examples:**
```bash
sudo fedoratricks codecs -i amd
sudo fedoratricks codecs -i intel amd --tigerlake
sudo fedoratricks codecs -r nvidia
```

#### 3. `secureboot`
Generates and stages a Machine Owner Key (MOK) using `akmods` and `mokutil`. This is required if you have Secure Boot enabled and want to load third-party kernel modules (like proprietary NVIDIA drivers).

**Options:**
* `-e`, `--enable`  : Generate a key and stage it for import on the next reboot.
* `-d`, `--disable` : Stage the key for revocation on the next reboot.

**Examples:**
```bash
sudo fedoratricks secureboot -e
sudo fedoratricks secureboot -d
```

#### 4. `nvidiadrivers`
Installs proprietary NVIDIA drivers from RPM Fusion and safely configures kernel parameters for modern features like Sleep (S0ix), Resizable BAR, and Early KMS. 
*(Requires RPM Fusion Non-Free to be enabled).*

**Options:**
* `-i`, `--install`   : Install the driver, persistenced service, and compile the akmod.
* `-r`, `--remove`    : Remove the proprietary driver and fall back to open-source Nouveau.
* `--sleep <arg>`     : Configure S0ix and video memory preservation (`enable` | `disable`).
* `--rebar <arg>`     : Configure Resizable BAR (`enable` | `disable`).
* `--earlykms <arg>`  : Configure Early KMS / MUX loading via dracut (`enable` | `disable`).

**Overrides (If auto-detection fails):**
* `--current`         : Use current branch (Turing/RTX 20-series and newer).
* `--legacy-580xx`    : Use 580xx branch (Maxwell/Pascal / GTX 800-10-series).
* `--legacy-470xx`    : Use 470xx branch (Kepler / GTX 600-700-series).

**Examples:**
```bash
# Install driver and enable modern system optimizations
sudo fedoratricks nvidiadrivers -i --sleep enable --earlykms enable

# Toggle a specific feature without reinstalling the driver
sudo fedoratricks nvidiadrivers --rebar enable

# Remove the proprietary drivers
sudo fedoratricks nvidiadrivers -r
```

#### 5. Developer & Utility Commands
* `logs`: Utility module for diagnosing system issues (refer to `--help` for specific flags).
* `template`: A boilerplate testing module used for developing new `fedoratricks` commands.

---

### Contact
>>>>>>> a10f0d8 (feat: implement robust module architecture and auto-testing suite)

Find us on the [Fedora Discord](https://discord.gg/fedora)
