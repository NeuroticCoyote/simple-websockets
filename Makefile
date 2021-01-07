.PHONY: clean app shell

clean:
	rm -rf _build
	rm -rf log
	rebar3 clean

app:
	rebar3 compile

shell:
	rebar3 compile
	rebar3 shell
