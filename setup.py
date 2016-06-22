#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import absolute_import, division

import os

from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

CYTHON_EXTENSIONS = (
    Extension('*',
              ["pianito/**/*.pyx"],
              include_dirs=['pianito'],
              libraries=['SDL2', 'SDL2_image', 'SDL2_mixer', 'SDL2_ttf'],
#               define_macros=[('CYTHON_WITHOUT_ASSERTIONS', 1)],
              extra_compile_args=['-Wno-unused-function',
                                  '-Wno-incompatible-pointer-types',
                                 ]), )

setup(ext_modules=cythonize(
                            CYTHON_EXTENSIONS,
                            compiler_directives={'profile': True},
))
