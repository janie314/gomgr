.PHONY: fmt compile

fmt:
	uv run black .

compile:
	cat compiled_script_template | awk '/^ZZZ/ { system("cat gomgr.py"); } !/^ZZZ/ { print $0; }' >compiled_script
