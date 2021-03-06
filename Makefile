BUILDOUT_BIN ?= $(shell command -v buildout || echo 'bin/buildout')
ROBOT_BROWSER ?= firefox

all: build check

build: $(BUILDOUT_BIN)
	$(BUILDOUT_BIN)

check: test

clean:
	rm -rf .installed bin develop-eggs parts

show: $(BUILDOUT_BIN)
	$(BUILDOUT_BIN) annotate

test: bin/code-analysis bin/pybot
	bin/code-analysis
	bin/pybot -v BROWSER:$(ROBOT_BROWSER) tests

watch: bin/instance
	bin/instance fg

###

.PHONY: all show build docs test check watch clean

bootstrap-buildout.py:
	curl -k -O https://bootstrap.pypa.io/bootstrap-buildout.py

bin/buildout: bootstrap-buildout.py buildout.cfg
	python bootstrap-buildout.py -c buildout.cfg

bin/instance: $(BUILDOUT_BIN) buildout.cfg
	$(BUILDOUT_BIN) $(BUILDOUT_ARGS) install instance plonesite

bin/code-analysis: $(BUILDOUT_BIN) buildout.cfg
	$(BUILDOUT_BIN) $(BUILDOUT_ARGS) install code-analysis

bin/pybot: $(BUILDOUT_BIN) buildout.cfg
	$(BUILDOUT_BIN) $(BUILDOUT_ARGS) install pybot
