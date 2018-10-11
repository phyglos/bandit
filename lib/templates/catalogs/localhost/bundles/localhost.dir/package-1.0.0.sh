#!/bin/bash

build_compile()
{
    ./configure --prefix=/usr

    make
}

build_test_level=4
build_test()
{
    make test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

