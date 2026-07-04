# Fedoratricks Developer Guide

This document is for developers who want to understand the inner workings of the `fedoratricks` core execution framework.

## Table of Contents
* [Architecture Overview](#architecture-overview)
* [Privilege Escalation (`run_cmd`, `run_cmd_eval`)](#privilege-escalation-run_cmd-run_cmd_eval)
* [The Task & Transaction System](#the-task--transaction-system)
* [Command & Task Summary Tracking](#command--task-summary-tracking)
* [How Automated Rollbacks Work](#how-automated-rollbacks-work)
* [Creating New Modules](#creating-new-modules)

---

## Architecture Overview

`fedoratricks` is a modular Bash utility. Core utilities are housed in `commands/utils_core` and sourced automatically by `fedoratricks.sh`. 

> [!NOTE]
> When writing a new module, use `commands/template` as your base reference (which served as the blueprint Rhea used for developing all other modules).

---

## Privilege Escalation (`run_cmd`, `run_cmd_eval`)

To avoid running the entire application as root, the framework uses targeted escalation helpers:

* **`run_cmd <command> [args...]`**: Evaluates arguments as a command. If the command belongs to a list of root-requiring utilities (like `dnf`, `systemctl`, `sed`, `touch`, `rm`, `mkdir`, `dracut`, `kmodgenca`, `mokutil`, `journalctl`), it prepends `sudo` automatically for non-root users.
* **`run_cmd_eval "<command_string>"`**: Runs eval on a command string (essential for commands using redirections or pipes, like `dmesg -H &> file.log`). It automatically prepends `sudo` to the start of the string if executed by a non-root user.

Both utilities format the commands for the user-facing log output (replaces `pkexec` with `sudo` and wraps redirects with `sudo sh -c`).

---

## The Task & Transaction System

Tasks that modify the system are registered and executed inside a structured transaction:

1. **`init_tasks <count>`**: Configures the total number of expected steps.
2. **`register_task "Task Display Name" "install_cmd" "rollback_cmd" "ostree_behavior"`**:
   * `"Task Display Name"`: String shown in progress messages.
   * `"install_cmd"`: The function or command string to execute for the task.
   * `"rollback_cmd"`: The counterpart function or command to execute in case of a rollback.
   * `"ostree_behavior"`: Set to `"skip"` to skip execution on OSTree-based systems (e.g. Silverblue), or `"allow"` to run it regardless.
3. **`run_transaction "${action}"`**: Executes all registered tasks sequentially.

---

## Command & Task Summary Tracking

The framework tracks the outcomes of both high-level tasks and individual commands executed within them:

* **Task Results**: High-level task execution status is registered in `TASK_RESULTS` as `PASSED`, `FAILED`, or `SKIPPED`.
* **Command History (`track_command_execution`)**: Every command run through `run_cmd` or `run_cmd_eval` records its start time, execution mode, command string, and final exit status.
* **Execution Summary**: Upon completion (or failure), `print_task_summary` is called. It prints a detailed execution scorecard, highlighting which tasks succeeded, failed, or were skipped.

---

## How Automated Rollbacks Work

If any registered task fails, the framework immediately halts execution and calls `trigger_transaction_rollback`:

1. It iterates **backwards** through the transaction stack, identifying all successfully executed tasks up to the point of failure.
2. For each successful task, it executes its associated `rollback_cmd`.
3. **Smart DNF Rollbacks (`resolve_rollback_dnf_cmd`)**: The framework automatically monitors DNF commands. Before executing a DNF command, it checks the latest DNF history transaction ID. If the transaction finishes and produces a new ID, it registers the ID in `CMD_TRACK_DNF_ID`. During a rollback, it automatically runs `dnf history undo -y <transaction_id>` to cleanly revert package installations.

---

## Creating New Modules & First Task Example

To create a new module, implement the arguments parser and execution function in your script, register your tasks using `register_task`, and call `run_transaction`. 

Refer to [commands/template](file:///var/home/imshubhamsocial/Downloads/Web/fedoratricks/commands/template) for the complete boilerplate structure.

### Quick Start: Writing Your First Task

Here is a basic example of writing and registering a task to configure a custom system settings file.

#### 1. Define the Step Helper
Create the helper function that handles both the installation/enable action and the removal/disable action:

```bash
setupCustomBanner() {
    local action="$1"
    local target_file="/etc/issue"

    if [[ ${action} == "install" ]]; then
        # Check if already configured
        if grep -q "Fedoratricks Custom Banner" "${target_file}" 2>/dev/null; then
            track_noop "Configure custom issue banner" "SUCCESS (Already configured)"
            return 0
        fi

        # Modify the system file (run_cmd_eval handles sudo escalation)
        run_cmd_eval "printf 'Fedoratricks Custom Banner\n' > '${target_file}'"
    else
        # Revert changes by clearing out the custom line
        run_cmd sed -i '/Fedoratricks Custom Banner/d' "${target_file}"
    fi
}
```

#### 2. Register & Execute the Task
Inside your module's Execute function, register this task and trigger the transaction:

```bash
myconfigExecute() {
    local action="$1"

    # Validate that we are on Fedora, not on OSTree, etc.
    validate_environment "myconfig" "myconfig ${action}"

    # Initialize the transaction (1 task)
    init_tasks 1

    # Register the task: Name, Install command, Rollback command, OSTree behavior
    register_task "Configure custom issue banner" \
                  "setupCustomBanner install" \
                  "setupCustomBanner remove" \
                  "skip"

    # Run the transaction!
    run_transaction "${action}"
}
```

#### 3. Sample Execution Output

When a user runs `fedoratricks myconfig install`, the console output will look like this:

```text
  Managing custom configurations...

  [1/1] RUNNING: Configure custom issue banner
        sudo sh -c "printf 'Fedoratricks Custom Banner\n' > '/etc/issue'"

  Execution Summary:
    [1/1] PASSED: Configure custom issue banner

  Complete!
```

If the task fails midway or if a user runs `fedoratricks myconfig remove`, the framework cleanly executes the rollback/disable command to undo the changes.
