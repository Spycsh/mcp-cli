```bash
docker build --build-arg https_proxy=$https_proxy --build-arg http_proxy=$http_proxy -t opea/mcp-sqlite:latest -f Dockerfile .

systemctl stop ollama.service # docker will start ollama instead
ollama run qwen2.5-coder

export OLLAMA_ENDPOINT=http://${host_ip}:11434
export no_proxy=${host_ip},localhost,127.0.0.1
git clone https://github.com/Spycsh/mcp-cli.git
docker compose up -d

docker exec -it mcp-sqlite bash
uvx mcp-server-sqlite --db-path employees.db > /var/log/mcp-server.log 2>&1 &
uv run mcp-cli --server sqlite --provider ollama --model qwen2.5-coder
```