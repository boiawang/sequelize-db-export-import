TESTS = $(shell find test/test.*.coffee)

test:
	@echo 'Seq-ei Testing...'
	./node_modules/mocha/bin/mocha --compilers coffee:coffee-script/register $(TESTS)

clean:
	rm -fr ./models

.PHONY: test clean
