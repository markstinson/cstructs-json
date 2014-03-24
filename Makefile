# temp makefile during development

tests = out/cjson_test
testenv = DYLD_INSERT_LIBRARIES=/usr/lib/libgmalloc.dylib MALLOC_LOG_FILE=/dev/null

all: out/test1


test: out/cjson_test
	@echo Running tests:
	@echo -
	@for test in $(tests); do $(testenv) $$test || exit 1; done
	@echo -
	@echo All tests passed!

out/cjson_test: test/cjson_test.c out/CArray.o out/CMap.o out/CList.o out/ctest.o out/cjson.o | out
	clang -o $@ $^ -I.

out/ctest.o: test/ctest.c test/ctest.h
	clang -o $@ -c $<

out/test1: test1.c out/cjson.o out/CArray.o out/CMap.o out/CList.o | out
	clang -o out/test1 $^

out/cjson.o: cjson.c cjson.h | out
	clang -c cjson.c -o out/cjson.o

out/C%.o: cstructs/C%.c cstructs/C%.h | out
	clang -o $@ -c $<

out:
	mkdir out

clean:
	rm -rf out/

.PHONY: test
