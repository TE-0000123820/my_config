#!/usr/bin/env python

import argparse
import sys
import numpy as np

def make_stride_list(stride, extent):
    cur_stride = 1
    cur_stride_str = ""
    stride_str = []
    for i in range(4):
        if len(stride) > i:
            s = stride[i]
        else:
            s = extent[i]
        cur_stride *= s
        if i == 0:
            cur_stride_str = str(s)
        else:
            cur_stride_str += "*"+str(s)
        if len(stride) <= i:
            stride.append(cur_stride)
            stride_str.append(cur_stride_str)
        else:
            stride_str.append(str(stride[i]))
    return (stride_str, stride)

def diff(argv):

    parser = argparse.ArgumentParser(description="diff binary files")
    parser.add_argument(
        "input0",
        type=str,
        help="input file0.",
    )
    parser.add_argument(
        "input1",
        type=str,
        help="input file1.",
    )
    parser.add_argument(
        "extent",
        type=int,
        nargs="+",
        help="extent: i j k l",
    )
    parser.add_argument(
        "--stride0",
        nargs="+",
        type=int,
        help="stride0",
    )
    parser.add_argument(
        "--stride1",
        nargs="+",
        type=int,
        help="stride1",
    )
    parser.add_argument(
        "--skip0",
        type=int,
        nargs="+",
        help="skip0",
    )
    parser.add_argument(
        "--skip1",
        type=int,
        nargs="+",
        help="skip1",
    )
    parser.add_argument('-v', '--verbose', required=False, action='store_true', help='Run in verbose mode.')
    parser.add_argument('-q', '--quiet', required=False, action='store_true', help='Run in quiet mode.')

    args = parser.parse_args(argv)
    extent = list(args.extent)

    data0 = np.fromfile(args.input0, np.uint8)
    data1 = np.fromfile(args.input1, np.uint8)

    if args.stride0 is None:
        stride0 = []
    else:
        stride0 = args.stride0
    if args.stride1 is None:
        stride1 = []
    else:
        stride1 = args.stride1
    if args.skip0 is None:
        skip0 = [0, 0, 0, 0]
    else:
        skip0 = list(args.skip0)
    if args.skip1 is None:
        skip1 = [0, 0, 0, 0]
    else:
        skip1 = list(args.skip1)

    assert(len(extent) <= 4)

    err = 0

    extent += [1]*(4-len(extent))
    skip0 += [0]*(4-len(skip0))
    skip1 += [0]*(4-len(skip1))

    (stride_str0, stride0) = make_stride_list(stride0, extent)
    (stride_str1, stride1) = make_stride_list(stride1, extent)

    if args.quiet == False:
        print("extent: {}".format(extent))
        print("stride0: {}".format(stride0))
        print("stride0: {}".format(stride_str0))
        print("stride1: {}".format(stride1))
        print("stride1: {}".format(stride_str1))
        print("skip0: {}".format(skip0))
        print("skip1: {}".format(skip1))

    orig_dims = len(args.extent)

    for l in range(extent[3]):
        l_act0 = skip0[3] + l
        l_act1 = skip1[3] + l
        for k in range(extent[2]):
            k_act0 = skip0[2] + k
            k_act1 = skip1[2] + k
            for j in range(extent[1]):
                j_act0 = skip0[1] + j
                j_act1 = skip1[1] + j
                base0 = skip0[0] + j_act0 * stride0[0] + k_act0 * stride0[1] + (l_act0)*stride0[2]
                base1 = skip1[0] + j_act1 * stride1[0] + k_act1 * stride1[1] + (l_act1)*stride1[2]
                data0_tmp = data0[base0:base0+extent[0]]
                data1_tmp = data1[base1:base1+extent[0]]
                assert(len(data0_tmp) == extent[0])
                for i in range(extent[0]):
                    i_act0 = skip0[0] + i
                    i_act1 = skip1[0] + i
                    if args.verbose:
                        print("{},{}: {},{}: 0x{:02x},0x{:02x}".format(base0+i_act0, base1+i_act1,
                            (i_act0, j_act0, k_act0, l_act0)[0:orig_dims],
                            (i_act1, j_act1, k_act1, l_act1)[0:orig_dims],
                            data0_tmp[i], data1_tmp[i]))
                    if int(data0_tmp[i]) - int(data1_tmp[i]) != 0:
                        print("DIFFER: {},{}: {},{}: 0x{:02x},0x{:02x}".format(base0+i_act0, base1+i_act1,
                            (i_act0, j_act0, k_act0, l_act0)[0:orig_dims],
                            (i_act1, j_act1, k_act1, l_act1)[0:orig_dims],
                            data0_tmp[i], data1_tmp[i]))

    if err == 0 and args.quiet == False:
        print("Indentical: {}, {}".format(args.input0, args.input1))

    return err

if __name__ == "__main__":
    sys.exit(diff(sys.argv[1:]))
