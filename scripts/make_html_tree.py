#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import absolute_import, division

import logging
import sys
import os

logger = logging.getLogger(__name__)  # pylint: disable=invalid-name

_FILENAME = "__filename__"


def print_tree(tree):
    print '<ul>'
    for name, subtree in sorted(tree.items()):
        print '<li class="jstree-open">'
        filename = subtree.get(_FILENAME)
        if filename:
            print "<a href='{}'>{}</a>".format(filename, name)
            print filename
        else:
            print name
            print_tree(subtree)
        print "</li>"
    print "</ul>"


def main():
    files = {}
    for line in sys.stdin:
        line = line.strip()
        current = files
        for name in line.split("/"):
            current = current.setdefault(name, {})
        current[_FILENAME] = line
    print '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Cython files</title>
 </head>
 <body>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.0.0-rc1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.1/jstree.min.js"></script>
  <div id="tree">'''
    print_tree(files)
    print '''  </div>
  <script>$("#tree").jstree().bind("select_node.jstree", function (e, data) {
     var href = data.node.a_attr.href;
     document.location.href = href;
});;</script>
 </body>
</html>'''


if __name__ == "__main__":
    main()
