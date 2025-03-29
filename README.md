# LiteFlow

## Overview

This project is a prototype for a simple, Python-based workflow management system inspired by [Nextflow](https://www.nextflow.io/). It aims to provide a more "Pythonic" way to define and execute computational pipelines for fun.

The core idea is to define pipeline tasks using Python functions and decorators, automatically handle dependencies based on function inputs/outputs, manage parallel execution, and configure runs via a structured JSON file.

Co-author: Google AI Studio, Gemini 2.5 Pro Experimental 3-25

**Status:** Early Prototype

## Motivation

Nextflow is an incredibly powerful and widely adopted workflow system, especially in bioinformatics. While tools like Snakemake offer a Python-based alternative, this project explores a different approach focusing on:

1.  **Simplicity:** Aiming for a lower learning curve compared to the full feature set and DSL of Nextflow or Snakemake.
2.  **Pythonic Interface:** Leveraging Python decorators (`@task`) and standard Python functions for defining workflows, making it feel natural for Python developers.
3.  **Core Workflow Needs:** Focusing initially on essential features like dependency management, parallelism, structured configuration, shell command execution, and basic containerization.

This prototype serves as a proof-of-concept for such a system.

## Key Features (Current Prototype)

*   **Pythonic Task Definition:** Define pipeline steps as standard Python functions using the `@workflow.task` decorator (applied within the main pipeline script).
*   **Automatic Dependency Management:** The workflow engine automatically determines the execution order based on how the output of one task (`TaskOutput` object) is used as input to another.
*   **File-Based Data Flow:** Primarily designed for tasks that consume and produce files. Tasks generally return absolute paths to their outputs, which are passed to downstream tasks. Lists of paths or basic Python objects can also be passed.
*   **Parallel Execution:** Utilizes Python's `concurrent.futures.ProcessPoolExecutor` to run independent tasks (tasks whose dependencies are met) concurrently, leveraging multiple CPU cores.
*   **Structured JSON Configuration:** Load workflow parameters from a structured JSON file (`--config config.json`), including `global_params` (like `work_dir`, `output_dir`) and task-specific sections with parameters (`tasks.<task_name>.params`). Tasks access the relevant parts of this configuration.
*   **Shell Command Integration:** Provides a `run_shell` helper function within `pyflow_core.py` to easily execute external command-line tools within tasks, handling errors.
*   **Informative Task Workspaces:** Each task execution runs in a unique working directory (`<work_dir>/<task_name>/<task_hash>/`). This directory contains symlinks to input files (`input_*`), a script logging the exact command executed (`.command.sh`), and any intermediate files generated by the task. Tasks handling multiple inputs (via internal loops) may create further subdirectories (e.g., based on input hash).
*   **Docker Execution (Optional):** Tasks can be configured (via the JSON config file's `docker` section within a task) to run inside a specified Docker container. Includes basic support for volume mounting and user mapping. Execution defaults to the host if not enabled in config.
*   **Basic Error Handling:**
    *   Detects exceptions raised within tasks.
    *   Reports errors clearly, including tracebacks from the execution process.
    *   Automatically cancels downstream tasks that depend on a failed task.
    *   Propagates failure to the main workflow run.

## Installation

Currently, this is a prototype consisting of Python script files and potentially helper scripts.

1.  **Clone/Download:** Get the files: `pyflow_core.py`, `tasks.py`, `pipeline.py`, `config.json` (and example scripts like `word_counter.sh` if provided).
    ```bash
    git clone <repository_url> # Or download ZIP
    cd <repository_directory>
    ```
2.  **Python Version:** Requires Python 3.7+ (due to `concurrent.futures`, f-strings, etc.).
3.  **Dependencies:** No external Python libraries are required beyond the standard library.
4.  **Docker (Optional):** A working Docker installation is required if using the Docker execution feature for any tasks.

## Usage

1.  **Define Task Logic:** Implement the core logic of your pipeline steps as plain Python functions in `tasks.py`. These functions can accept parameters, a `config` dictionary slice, and a `task_work_dir`. They should typically return the absolute path(s) to output files or other serializable results.
2.  **Configure:** Create a structured `config.json` file defining `global_params` (like `work_dir`, `output_dir`) and a `tasks` section. Each task within the `tasks` section can have `description`, `params`, and an optional `docker` configuration (`image`, `enabled`).
3.  **Define Workflow:**
    *   In `pipeline.py`, import the task functions from `tasks.py`.
    *   Load the configuration file.
    *   Create a `Workflow` instance from `pyflow_core`, potentially passing the `work_dir` from the config.
    *   Apply the `@workflow.task` decorator to the imported task functions.
    *   Define the pipeline structure by calling the decorated functions, passing parameters from the config and outputs of upstream tasks as inputs to downstream tasks. This builds the dependency graph.
4.  **Helper Scripts:** Ensure any external scripts called by tasks (like `word_counter.sh`) are present and executable.
5.  **Run:** Execute the main pipeline script from your terminal, providing the configuration file path.


**Example Commands:**

```bash
# Run using configuration from config.json
# (Docker usage is controlled internally based on the config file)
python pipeline.py --config config.json

# Clean up the intermediate work directory before running
python pipeline.py --config config.json --cleanup
```

## Current Limitations
* No Caching: Tasks are re-executed every time the workflow runs, even if inputs haven't changed. There is no persistent caching between runs.
* Limited Container Support: Basic Docker integration via config toggle. No support for Singularity, complex orchestration (like Kubernetes), or specifying resource limits within containers.
* Basic Input/Output Handling: Primarily focused on passing file paths (as strings) and basic Python objects (lists, numbers). No explicit system for handling directories robustly or guaranteeing serialization of complex custom objects between processes.
* Basic Scheduling: Dependency-driven execution only. No support for task retries, time limits, conditional execution based on output content, etc.
* No Task Mapping/Scattering: Tasks processing list inputs (like the word count example) loop internally; the engine doesn't automatically parallelize across list items by invoking multiple task instances.
* Local Execution Only: Designed to run on a single machine using multiple processes (potentially within Docker containers). No support for submitting jobs to HPC schedulers (SLURM, SGE, LSF, etc.) or cloud batch systems.
* Rudimentary DAG: The dependency graph is built implicitly and used for execution, but there's no upfront DAG analysis, cycle detection, or visualization capability.
* Basic Error Propagation: Basic cancellation of downstream tasks on failure. More sophisticated strategies (e.g., ignore failures, collect outputs anyway) are not implemented.

## Next Steps / Roadmap
* Robust Caching: Implement persistent caching based on hashing inputs (arguments, config, input file content/timestamps) and checking output existence/integrity.
* Enhanced Container Integration: Add support for Singularity, allow specifying container resources (CPUs, memory), improve volume handling and path mapping robustness.
* Task Mapping/Scattering: Implement engine support to automatically parallelize a task across elements of an input list/channel (like Nextflow processes or Snakemake's expand).
* Input/Output Type System: Introduce explicit types (e.g., File, Directory, Str, Int) for task inputs/outputs to enable better validation, handling, and potentially more robust serialization.
* Enhanced Error Handling: Implement task retry mechanisms (e.g., configured per task).
* Explicit DAG Management: Build the Directed Acyclic Graph explicitly before execution, allowing for cycle detection and potentially visualization (e.g., using Graphviz).
* (Ambitious) Basic Executor Plugins: Develop support for different execution environments, starting potentially with a simple SLURM backend.
