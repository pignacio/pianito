#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import absolute_import, division

import os
import sys


def main():
    for fname in sys.argv[1:]:
        make_html(fname)


def make_html(fname):
    if not os.path.isfile(fname):
        print "Not a file: '{}'".format(fname)
        return

    basename = os.path.basename(fname).rsplit(".", 1)[0]
    dest = fname.rsplit(".", 1)[0]  + ".html"

    if os.path.isfile(dest) and os.path.getmtime(fname) < os.path.getmtime(dest):
        print "{}: html is up to date".format(fname)
        return

    output = os.path.join("/tmp", basename + ".c")
    html_output = os.path.join("/tmp", basename + ".html")

    print "{}: Cythonizing".format(fname)
    command = "cython -a --fast-fail -o {} {}".format(output, fname)
    code = os.system(command)
    if code == 0:
        os.system("cp {} {}".format(html_output, dest))
    else:
        print "{}: Cythonization failed!!!".format(fname)


if __name__ == "__main__":
    main()
