import argparse
import numpy as np
import ast


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('input_file', type=str, nargs=1, help='Input filename.')
    parser.add_argument('output_file', type=str, nargs=1, help='Output filename.')
    parser.add_argument('in_size', type=str, nargs=1, help='Size of the input data in string format like \"1, 2, 3, 4\".')
    parser.add_argument('-p', '--pad', type=str, default=None, help="Padding size in a format like \"left, right, top, bottom, ....\"")
    parser.add_argument('-P', '--pad-value', type=str, default=None, help="Padding value")
    args = parser.parse_args()

    # load input data
    in_data = None
    with open(args.input_file[0], "r") as f:
        in_data = np.fromfile(f, np.int8)

    # parse config
    in_sizes = np.array(ast.literal_eval("(" + args.in_size[0] + ")"))
    if args.pad is not None:
        pads = np.array(ast.literal_eval("(" + args.pad + ")"))
    else:
        pads = np.array([0] * len(in_sizes) * 2)

    # print(f'pads: {pads}')
    # print(f'in_sizes: {in_sizes}')

    assert len(pads) <= 8, "error: pads size"
    assert len(in_sizes) <= 4, "error: in_sizes size"
    assert len(in_sizes)*2 == len(pads), "error: size mismatch between pads and in_sizes"

    out_sizes = np.ones((4), np.int32)
    for i, e in enumerate(in_sizes):
        out_sizes[i] = e + pads[i*2] + pads[i*2+1]

    # resize pads
    pads.resize(8)

    # resize input size
    in_sizes_old = np.array(in_sizes)
    in_sizes = np.ones(4, np.int32)
    in_sizes[:len(in_sizes_old)] = in_sizes_old

    print(f'out_sizes: {out_sizes}')

    # reverse order
    in_sizes = in_sizes[::-1]
    out_sizes = out_sizes[::-1]

    # print(f'rev: pads: {pads}')
    # print(f'rev: in_sizes: {in_sizes}')
    # print(f'rev: out_sizes: {out_sizes}')

    in_data = in_data.reshape(in_sizes)
    if args.pad_value is None:
        out_data = np.zeros(out_sizes, np.int8)
    else:
        
        out_data = np.full(out_sizes, ast.literal_eval(args.pad_value) & 0xff, np.int8)

    out_data[pads[2*3]:pads[2*3]+in_sizes[0], pads[2*2]:pads[2*2]+in_sizes[1],
             pads[2*1]:pads[2*1]+in_sizes[2], pads[2*0]:pads[2*0]+in_sizes[3]] = in_data

    print(f'{out_data}')
    out_data.tofile(args.output_file[0])

if __name__ == "__main__":
    main()
