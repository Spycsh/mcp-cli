# Use a base image with bash and curl support
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    sqlite3 \
    bash \
    git \
    && apt-get clean

RUN git clone https://github.com/Spycsh/mcp-cli
WORKDIR mcp-cli

# Install uv using the provided script
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Add UV binary to the PATH
ENV PATH="$HOME/.local/bin:$PATH"

# Copy the employee insertion script into the container
RUN echo -e "apple\nbanana\ncherry\ndate\ngrape\nlemon\nmango\norange\npear\nplum" > /usr/share/dict/words
COPY insert_employees.sh /usr/local/bin/insert_employees.sh
RUN chmod +x /usr/local/bin/insert_employees.sh

# Run the employee script to populate the SQLite database
RUN bash /usr/local/bin/insert_employees.sh

ENTRYPOINT ["sleep", "infinity"]

# enter into the container and start a mcp sqlite server based on provided database and
# start a client (check the server_config.json)
# $HOME/.local/bin/uvx mcp-server-sqlite --db-path employees.db > /var/log/mcp-server.log 2>&1 &
# $HOME/.local/bin/uv run mcp-cli --server sqlite --provider ollama --model qwen2.5-coder