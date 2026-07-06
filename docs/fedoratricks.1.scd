fedoratricks(1) "0.2" "Fedoratricks Manual"

# NAME

fedoratricks - helper utility for common Fedora Linux configuration tasks

# SYNOPSIS

*fedoratricks* _command_ _action_ [_options_] [_targets_...]

# DESCRIPTION

*fedoratricks* is a modular collection of scripts designed to make common
post-install configuration tasks easier for Fedora Linux users. It aims to
not only perform the task, but to explain what is happening under the hood.

Commands that modify system packages, repositories, or kernel configuration
generally require root privileges (use *sudo*). OSTree-based systems
(Silverblue, Kinoite) are not supported by modifying commands and will be
blocked automatically.

# GLOBAL OPTIONS

*-h*, *--help*
	Print help text and exit. Can also be appended to any subcommand to show
	that command's specific options.

# COMMANDS

## rpmfusion

Manages the installation and status of the community-driven RPM Fusion
repositories (Free and Non-Free).

*Usage:* fedoratricks rpmfusion _action_

*Actions:*

	*install*
		Install RPM Fusion Free and Non-Free repositories.

	*remove*
		Remove RPM Fusion repositories from the system.

*Examples:*

```
sudo fedoratricks rpmfusion install
sudo fedoratricks rpmfusion remove
```

## multimedia

Installs base multimedia codecs and configures hardware acceleration drivers.
Requires RPM Fusion to be enabled first.

*Usage:* fedoratricks multimedia _action_ [_options_]

*Actions:*

	*install*
		Install multimedia codecs and apply configurations.

	*remove*
		Remove installed multimedia codecs and revert configurations.

*Options:*

	*--config*
		(Intel only) Configure hardware acceleration modules (GuC/HuC firmware
		loading and Frame Buffer Compression).

	*--with-optional*
		Install optional/extra multimedia packages based on detected hardware
		(e.g., AV1/VP9 codecs, GStreamer extra plugins).

*Examples:*

```
sudo fedoratricks multimedia install
sudo fedoratricks multimedia install --with-optional
sudo fedoratricks multimedia install --config
sudo fedoratricks multimedia remove
```

## nvidia

Installs proprietary NVIDIA drivers from the RPM Fusion Non-Free repository
and configures kernel module parameters, including early KMS, power
management/sleep support, and Resizable BAR.

*Usage:* fedoratricks nvidia _action_ [_options_]

*Actions:*

	*install*
		Install NVIDIA drivers and enable the persistenced service.

	*remove*
		Remove NVIDIA drivers and fall back to the open-source Nouveau driver.

*Options:*

	*--config*
		Configure driver parameters: sleep support, Resizable BAR, and early KMS.

*Examples:*

```
sudo fedoratricks nvidia install
sudo fedoratricks nvidia install --config
sudo fedoratricks nvidia remove
```

## secureboot

Generates and stages a custom Machine Owner Key (MOK) using *akmods*(8) and
*mokutil*(1). Required to load third-party/out-of-tree kernel modules (such as
NVIDIA drivers) when Secure Boot is active.

*Usage:* fedoratricks secureboot _action_

*Actions:*

	*enable*
		Generate and import a custom MOK for third-party drivers. You will be
		prompted to create a temporary password to confirm key enrollment on the
		MOK Manager screen at next reboot.

	*disable*
		Revoke the custom MOK from the UEFI signature database.

*Examples:*

```
sudo fedoratricks secureboot enable
sudo fedoratricks secureboot disable
```

## logs

Gathers and saves system diagnostic logs. By default (no flags), saves all
logs to a timestamped directory at _~/logs-<timestamp>_. Without *-f*, output
is printed to stdout and can be piped or grepped.

*Usage:* fedoratricks logs [_options_]

*Options:*

	*-a*, *--all*
		Collect dmesg plus current and previous boot journal logs.

	*-0*, *--current*
		Collect the current boot journal logs.

	*-1*, *--lastboot*
		Collect the previous boot journal logs.

	*-d*, *--dmesg*
		Collect the kernel ring buffer output (dmesg).

	*-f* _path_, *--file* _path_
		Save logs to files under _path_. Without this option logs are printed
		to stdout.

*Inxi System Info Options:*

	*-i*, *--inxi*
		Gather system configuration information via *inxi*(1).

	*--basic*, *--system*
		Show basic system info (default when *--inxi* is specified).

	*--drivers*
		Show graphics, audio, and network driver details.

	*--kernel-modules*
		Show kernel version and loaded kernel module details.

	*--network*
		Show network device and interface information.

	*--usb*
		Show USB device information.

	*--pcie*
		Show PCI/PCIe slot information.

*Examples:*

```
fedoratricks logs --all
fedoratricks logs --inxi --drivers
fedoratricks logs --usb --pcie | grep -i controller
fedoratricks logs --current --dmesg -f ~/SystemLogs
```

# EXIT STATUS

*0*
	Success.

*1*
	An error occurred or an unknown command was specified.

# SEE ALSO

*dnf*(8), *inxi*(1), *mokutil*(1), *journalctl*(1), *dmesg*(1)

# AUTHORS

Rhea Gustavsson <contact@rhea.dev>

Source code and issue tracker: https://github.com/RheaAyase/fedoratricks

