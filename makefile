#
# makefile
# ignacio, 2016-05-25 17:30
#

clean: clean-so
	find pianito -name "*.c" -delete

clean-so:
	find pianito -name "*.so" -delete

clean-html:
	find pianito -name "*.html" -delete

build_ext:
	python setup.py build_ext --inplace

run: build_ext
	python -c 'from pianito.main import main; main()'

html:
	find pianito -name "*.pyx" -exec python scripts/make_html.py {} +
	find pianito -name "*.html" | python scripts/make_html_tree.py > tree.html

# vim:ft=make
#
