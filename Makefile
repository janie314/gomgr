.PHONY: fmt compile

fmt:
	uv run ruff format
	uv run ruff check --fix --unsafe-fixes

compile:
	cat compiled_script_template | awk '/^ZZZ/ { system("cat gomgr.py"); } !/^ZZZ/ { print $0; }' >compiled_script
