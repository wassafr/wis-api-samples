#!/usr/bin/env python

from setuptools import setup, find_packages

setup(
    name                = 'wis',
    version             = '1.0',
    description         = 'Wassa Inovation Services python API',
    author              = 'Florent TARALLE',
    author_email        = 'TODO',
    url                 = 'TODO',
    package_dir         = {"": "src"},
    packages            = find_packages(where="src"),
    python_requires     = ">=3.6",
    install_requires    = ['requests', 'environs', 'pytest']
)

