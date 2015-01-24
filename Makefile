TESTS = $(shell find ./test/* -name 'test.*.coffee')

test:
	@echo 'Seq-ei Testing...'
	./node_modules/mocha/bin/mocha --compilers coffee:coffee-script/register $(TESTS)
	make clean

clean:
	rm -fr ./test/models

.PHONY: test clean
