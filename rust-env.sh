#!/usr/bin/env bash

# Rust environment setup

# Install Rust
curl https://sh.rustup.rs -sSf | sh

# Tools
rustup component add rustfmt
rustup toolchain add nightly
cargo +nightly install racer
