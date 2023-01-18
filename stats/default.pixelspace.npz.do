#!/usr/bin/env python

import sys
from pathlib import Path

import numpy as np
import openTSNE
import torch
from cnexp import redo
from sklearn.decomposition import PCA
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


def do_pca(data, seed, n_components=2, **kwargs):
    pca = PCA(random_state=seed, n_components=n_components, **kwargs)
    return pca.fit_transform(data)


def do_tsne(data, seed, n_jobs=-1, **kwargs):
    tsne = openTSNE.TSNE(n_jobs=n_jobs, random_state=seed, **kwargs)
    return tsne.fit(data)


def main():
    root = Path("../experiments")
    prefix = root / sys.argv[2]

    rng = np.random.default_rng(342561)

    redo.redo_ifchange(prefix / "dataset.pt")
    data_sd = torch.load(prefix / "dataset.pt")
    dataset = data_sd["full_plain"].dataset

    pixels = np.array([np.array(im) for im, lbl in dataset])
    pixels = pixels.reshape(pixels.shape[0], -1)
    labels = np.array([lbl for im, lbl in dataset], dtype="uint8")

    knn = KNeighborsClassifier(15)
    X_train, X_test, y_train, y_test = train_test_split(
        pixels, labels, test_size=10_000, random_state=11
    )
    knn.fit(X_train, y_train)
    acc = knn.score(X_test, y_test)
    print(f"knn pixel {acc = :%}", file=sys.stderr)
    Y_tsne = do_tsne(pixels, rng.integers(2**31))
    X_train, X_test, y_train, y_test = train_test_split(
        Y_tsne, labels, test_size=10_000, random_state=11
    )
    knn.fit(X_train, y_train)
    acc = knn.score(X_test, y_test)
    print(f"knn tsne {acc = :%}", file=sys.stderr)
    Y_pca = do_pca(pixels, rng.integers(2**31))

    with open(sys.argv[3], "wb") as f:
        np.savez(
            f,
            tsne=Y_tsne.astype("float16"),
            pca=Y_pca.astype("float16"),
            labels=labels,
        )


if __name__ == "__main__":
    main()
