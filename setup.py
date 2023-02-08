#!/usr/bin/env python
from setuptools import setup, find_packages
from os import path
here = path.abspath(path.dirname(__file__))

setup(
    name="cnexp",
    version="0.0.1",
    description="Contrastive experiments",
    author="Niklas Böhm",
    author_email="jan-niklas.boehm@uni-tuebingen.de",
    packages=find_packages(exclude=[]),
    package_dir={"nnvision": "nnvision"},
    install_requires=[
        "torch",
        "torchvision",
        "numpy",
        "pandas",
        "matplotlib",
        "tqdm",
        "python-telegram-bot",
        "ffmpeg-python",
        "scikit-learn",
        "pillow",
        "annoy",
        "scipy",
        "medmnist",
    ],
)
