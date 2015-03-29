TESTS = $(shell find ./test/* -name 'test.*.coffee')

test:
	@echo 'Seq-ei Testing...'
	./node_modules/mocha/bin/mocha --compilers coffee:coffee-script/register $(TESTS)
	make clean

test-cov:
	@echo 'Testing and generating coverage report...'
	./node_modules/.bin/ibrik cover ./node_modules/.bin/_mocha --report lcovonly -- -t 10000 $(TESTS);
	make clean

test-watch:
	./node_modules/mocha/bin/mocha -w --compilers coffee:coffee-script/register $(TESTS)

clean:
	rm -fr ./test/models ./models

.PHONY: test clean
