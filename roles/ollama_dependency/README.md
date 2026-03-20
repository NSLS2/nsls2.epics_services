ollama_dependency
=================

Install Ollama (local LLM server) as a shared dependency.


**Binary location:** `/usr/local/bin/ollama` (installed via official script)

**Startup:** `systemctl start ollama`


Behavior
--------
- Run-once guard (`_ollama_dependency_done`) prevents redundant execution
- Installs Ollama via the official install script (idempotent via `creates:`)
- Templates a systemd override to set `OLLAMA_HOST`
- Starts/enables the `ollama` systemd service
- Waits for the API to be ready (`/api/tags` endpoint)
- Pulls models from `ollama_models` list, skipping already-present models
- Exports `ollama_base_url` fact for downstream roles


Role Variables
--------------

| Variable | Type | Description |
| --- | --- | --- |
| `ollama_host` | string | Bind address for Ollama (default: `127.0.0.1`). |
| `ollama_port` | int | Ollama API port (default: `11434`). |
| `ollama_models` | list | Models to pull after install (default: `[qwen3:8b]`). |
| `ollama_model_pull_timeout` | int | Timeout in seconds for model pull (default: `1800`). |
