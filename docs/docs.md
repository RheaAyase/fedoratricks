# Fedoratricks Command Reference

`fedoratricks` is a modular helper utility for Fedora Linux designed to streamline common configuration tasks. This document lists all available command modules, their help documentation, options, and usage examples.

---

## Global Syntax & Usage

```bash
fedoratricks <command> <action> [options] [targets...]
```

* Append `-h` or `--help` to any command to view its specific options (e.g., `fedoratricks multimedia --help`).
* Commands that modify system configurations, packages, or repositories generally require root (`sudo`) privileges.
* OSTree-based systems (e.g., Silverblue, Kinoite) are not supported by the modifying commands and will be blocked automatically.

---

## Available Modules

### 1. `rpmfusion`
Manages the installation and status of the community-driven RPM Fusion repositories (Free and Non-Free).

#### Help Text
```text
Command Usage: fedoratricks rpmfusion [action]

Note: This command requires root privileges.

Actions:
  install        Install RPM Fusion repositories.
  remove         Remove RPM Fusion repositories.

Options:
  -h|--help      Print the help text and exit.

Examples:
  fedoratricks rpmfusion install
  fedoratricks rpmfusion remove
```

#### Examples
* **Install and enable both Free and Non-Free repositories:**
  ```bash
  sudo fedoratricks rpmfusion install
  ```
* **Remove RPM Fusion repositories from the system:**
  ```bash
  sudo fedoratricks rpmfusion remove
  ```

---

### 2. `multimedia`
Installs base multimedia codecs and configures hardware acceleration drivers. It requires RPM Fusion to be enabled.

#### Help Text
```text
Command Usage: fedoratricks multimedia [action] [options]

Note: This command modifies system packages and requires root privileges.
OSTree-based systems (Silverblue/Kinoite) are not supported.

Actions:
  install          Install multimedia codecs and apply configurations.
  remove           Remove installed multimedia codecs and revert configurations.

Options:
  -h, --help       Print the help text and exit.
  --config         (Intel only) Configure hardware acceleration modules (GuC/HuC).
  --with-optional  Install optional/extra multimedia packages based on hardware.

Examples:
  fedoratricks multimedia install
  fedoratricks multimedia remove
```

#### Examples
* **Install base codecs (`ffmpeg` and the `@multimedia` group):**
  ```bash
  sudo fedoratricks multimedia install
  ```
* **Install base codecs along with optional hardware-specific packages (e.g., AV1/VP9 codecs, GStreamer extra plugins):**
  ```bash
  sudo fedoratricks multimedia install --with-optional
  ```
* **Enable Intel GPU hardware acceleration configurations (GuC/HuC firmware loading & FBC):**
  ```bash
  sudo fedoratricks multimedia install --config
  ```
* **Remove installed codecs and revert configurations:**
  ```bash
  sudo fedoratricks multimedia remove
  ```

---

### 3. `secureboot`
Generates and stages a custom Machine Owner Key (MOK) using `akmods` and `mokutil`. This is required to load third-party/out-of-tree kernel modules (like NVIDIA drivers) if Secure Boot is active.

#### Help Text
```text
Command Usage: fedoratricks secureboot [action]

Note: This command configures Machine Owner Keys (MOK) for Secure Boot.
It requires root privileges. OSTree-based systems are currently not supported.

Actions:
  enable         Generate and import a custom MOK for third-party drivers.
  disable        Revoke the custom MOK from the system.

Options:
  -h|--help      Print the help text and exit.

Examples:
  fedoratricks secureboot enable
  fedoratricks secureboot disable
```

#### Examples
* **Generate and stage the MOK key for next reboot:**
  ```bash
  sudo fedoratricks secureboot enable
  ```
  *(You will be prompted to create a temporary password to confirm the key enrollment on the blue MOK screen when you reboot.)*
* **Stage the custom MOK for removal from the UEFI signature database:**
  ```bash
  sudo fedoratricks secureboot disable
  ```

---

### 4. `nvidia`
Installs proprietary NVIDIA drivers from the RPM Fusion Non-Free repository and configures kernel module parameters (like early KMS, power management/sleep support, and Resizable BAR).

#### Help Text
```text
Command Usage: fedoratricks nvidia [action] [options]

Note: This command installs proprietary NVIDIA drivers and configures kernel parameters.
It requires root privileges. OSTree-based systems (Silverblue/Kinoite) are not supported.

Actions:
  install          Install NVIDIA drivers and enable persistenced service.
  remove           Remove NVIDIA drivers and fall back to Nouveau.

Options:
  -h|--help        Print the help text and exit.
  --config         Configure driver parameters (sleep, rebar, and earlykms).

Examples:
  fedoratricks nvidia install
  fedoratricks nvidia remove
```

#### Examples
* **Install recommended NVIDIA drivers automatically:**
  ```bash
  sudo fedoratricks nvidia install
  ```
* **Install NVIDIA drivers and apply power saving/early KMS configurations:**
  ```bash
  sudo fedoratricks nvidia install --config
  ```
* **Completely uninstall NVIDIA drivers and restore open-source Nouveau drivers:**
  ```bash
  sudo fedoratricks nvidia remove
  ```

---

### 5. `logs`
Gathers and saves system diagnostic logs. By default, logs print directly to the terminal so they can be piped/grepped. If `-f` is specified, logs are saved to files in the target directory.

#### Help Text
```text
Command Usage: fedoratricks logs [options]

Options:
  -h|--help          Print the help text and exit.
  -a|--all           Save dmesg as well as journal current and last boot.
  -0|--current       Save the current boot logs (default).
  -1|--lastboot      Save the previous boot logs.
  -d|--dmesg         Save the dmesg output.
  -f|--file <path>   File path where to save the logs. If not specified, logs print to terminal.

Inxi System Info Options:
  -i|--inxi          Gather system configuration via inxi.
  --basic|--system   Show basic system info (default for inxi).
  --drivers          Show graphics, audio, and network drivers.
  --kernel-modules   Show system kernel and kernel module details.
  --network          Show network device and interface info.
  --usb              Show USB device info.
  --pcie             Show PCI/PCIe slot info.

Examples:
  fedoratricks logs --all
  fedoratricks logs --inxi --drivers
  fedoratricks logs -f ~/Logs/ --inxi --basic --usb
```

#### Examples
* **Print graphics, audio, and network driver details to the console:**
  ```bash
  fedoratricks logs --drivers
  ```
* **Print USB and PCIe information, filtering with grep:**
  ```bash
  fedoratricks logs --usb --pcie | grep -i controller
  ```
* **Save the current boot journal and the kernel `dmesg` logs to files under `~/SystemLogs`:**
  ```bash
  fedoratricks logs --current --dmesg -f ~/SystemLogs
  ```

---

### 6. `template`
A boilerplate/template command used as a skeleton for building new modules.

#### Help Text
```text
Command Usage: fedoratricks template [options]

Options:
  -h|--help    Print the help text and exit.
  -b|--boolean Toggle a flag.
  -v|--value   Set a custom value.
```

#### Examples
* **Test the template module flags:**
  ```bash
  fedoratricks template --boolean --value "Custom Value"
  ```
