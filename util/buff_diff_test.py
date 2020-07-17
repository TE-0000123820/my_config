#!/usr/bin/env python3

import numpy as np
import buff_diff

def make_array(extents, val=None):
    array_len = 1
    for i in extents:
        array_len *= i
    if val is None:
        array = np.random.rand(array_len)*0xff
    else:
        array = np.array([val]*array_len)*0xff
    array = array.astype(np.uint8).reshape(*extents)
    return array

def test_0():
    extents0 = np.array((5, 6, 7, 8))
    array0 = make_array(extents0)

    extents1 = np.array((6, 8, 10, 12))
    array1 = make_array(extents1, 1)
    array1[1:, 2:, 3:, 4:] = array0

    array0.tofile("data0.bin")
    array1.tofile("data1.bin")

    extents_diff = extents1 - extents0

    assert 0 == buff_diff.diff("data0.bin data1.bin 8 7 6 5 --stride1 {} {} {} --skip-byte1 {} {} {} {} -v"
            .format(extents1[3], extents1[2:4].prod(), extents1[1:4].prod(), *reversed(extents_diff)).split(" "))
    assert 0 == buff_diff.diff("data1.bin data0.bin 8 7 6 5 --stride0 {} {} {} --skip-byte0 {} {} {} {} -v"
            .format(extents1[3], extents1[2:4].prod(), extents1[1:4].prod(), *reversed(extents_diff)).split(" "))

def test_1():
    extents0 = np.array((5, 6, 7, 8))
    array0 = make_array(extents0)

    extents1 = np.array((7, 9, 11, 13))
    array1 = make_array(extents1, 1)
    array1[1:-1, 2:-1, 3:-1, 4:-1] = array0

    array0.tofile("data0.bin")
    array1.tofile("data1.bin")

    skips = (4, 3, 2, 1)

    assert 0 == buff_diff.diff("data0.bin data1.bin 8 7 6 5 --stride1 {} {} {} --skip-byte1 {} {} {} {} -v"
            .format(extents1[3], extents1[2:4].prod(), extents1[1:4].prod(), *skips).split(" "))
    assert 0 == buff_diff.diff("data1.bin data0.bin 8 7 6 5 --stride0 {} {} {} --skip-byte0 {} {} {} {} -v"
            .format(extents1[3], extents1[2:4].prod(), extents1[1:4].prod(), *skips).split(" "))

def test_2():
    extents0 = np.array((5, 6, 7, 8))
    array0 = make_array(extents0)

    extents1 = np.array((7, 9, 11, 13))
    array1 = make_array(extents1, 1)
    array1[0:-2, 0:-3, 0:-4, 0:-5] = array0

    array0.tofile("data0.bin")
    array1.tofile("data1.bin")

    skips = (0, 0, 0, 0)

    assert 0 == buff_diff.diff("data0.bin data1.bin 8 7 6 5 --stride1 {} {} {} --skip-byte1 {} {} {} {} -v"
            .format(extents1[3], extents1[2:4].prod(), extents1[1:4].prod(), *skips).split(" "))
    assert 0 == buff_diff.diff("data1.bin data0.bin 8 7 6 5 --stride0 {} {} {} --skip-byte0 {} {} {} {} -v"
            .format(extents1[3], extents1[2:4].prod(), extents1[1:4].prod(), *skips).split(" "))
    assert 0 == buff_diff.diff("data0.bin data1.bin 8 7 6 5 --stride1 {} {} {} -v"
            .format(extents1[3], extents1[2:4].prod(), extents1[1:4].prod()).split(" "))
    assert 0 == buff_diff.diff("data1.bin data0.bin 8 7 6 5 --stride0 {} {} {} -v"
            .format(extents1[3], extents1[2:4].prod(), extents1[1:4].prod()).split(" "))

def test_3():
    extents0 = np.array((6, 7, 8, 9))
    extents1 = extents0
    array0 = make_array(extents0)
    array1 = array0

    array0.tofile("data0.bin")
    array1.tofile("data1.bin")

    skips = (0, 0, 0, 0)

    assert 0 == buff_diff.diff("data0.bin data1.bin {} {} {} {} --stride0 {} {} {} --skip-byte1 {} {} {} {} -v"
            .format(*reversed(extents0), extents1[3], extents1[2:4].prod(), extents1[1:4].prod(), *skips).split(" "))
    assert 0 == buff_diff.diff("data1.bin data0.bin {} {} {} {} --stride1 {} {} {} --skip-byte0 {} {} {} {} -v"
            .format(*reversed(extents0), extents1[3], extents1[2:4].prod(), extents1[1:4].prod(), *skips).split(" "))
    assert 0 == buff_diff.diff("data0.bin data1.bin {} {} {} {} --stride0 {} {} {} -v"
            .format(*reversed(extents0), extents1[3], extents1[2:4].prod(), extents1[1:4].prod()).split(" "))
    assert 0 == buff_diff.diff("data1.bin data0.bin {} {} {} {} --stride1 {} {} {} -v"
            .format(*reversed(extents0), extents1[3], extents1[2:4].prod(), extents1[1:4].prod()).split(" "))
    assert 0 == buff_diff.diff("data0.bin data1.bin {} {} {} {} -v"
            .format(*reversed(extents0)).split(" "))
    assert 0 == buff_diff.diff("data1.bin data0.bin {} {} {} {} -v"
            .format(*reversed(extents0)).split(" "))

if __name__ == "__main__":
    #test_0()
    #test_1()
    #test_2()
    test_3()
