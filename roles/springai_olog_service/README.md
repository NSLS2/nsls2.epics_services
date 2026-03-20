springai_olog_service
=====================

Install the SpringAI Olog semantic search and LLM analysis service.

This service provides semantic search over Phoebus Olog log entries using
Ollama for embeddings and LLM inference, backed by Elasticsearch for
vector storage.


**Installation location:**
`/opt/epics-tools/services/springai_olog/` (configurable via `springai_olog_install_dir`)

**Startup scripts:**
`systemctl start springai_olog`


Dependencies
------------
OpenJDK 21
role: jdk_dependency

Ollama
role: ollama_dependency

Elasticsearch (provided by the co-deployed Phoebus Olog stack)

procServ
role: procserv_dependency


Role Variables
--------------

| Variable | Type | Description |
| --- | --- | --- |
| `springai_olog_install_dir` | string | Installation directory (default: `/opt/epics-tools/services/springai_olog`). |
| `springai_olog_repo` | string | Git repository URL (default: `https://github.com/alexariv/SpringAI.git`). |
| `springai_olog_version` | string | Git ref to checkout (default: `ologUI`). |
| `springai_olog_jar` | string | JAR filename (default: `semantic-0.0.1-SNAPSHOT.jar`). |
| `springai_olog_port` | int | HTTP port for the SpringAI REST API (default: `8090`). |
| `springai_olog_procServ_port` | int | procServ port (default: `60052`). |
| `springai_ollama_model` | string | Ollama model for chat and embeddings (default: `qwen3:8b`). |
| `springai_vector_index` | string | Elasticsearch index for vectors (default: `olog_vectors`). |
