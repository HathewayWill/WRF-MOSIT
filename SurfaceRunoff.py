#!/usr/bin/env python3
"""Plot surface runoff from a WRF-Hydro LDASOUT NetCDF file.

WRF-MOSIT v2.0.0 example post-processing utility. The default input file,
plot limits, and output name reproduce the original SurfaceRunoff.py example.

Usage:
    python SurfaceRunoff.py
    python SurfaceRunoff.py /path/to/LDASOUT_DOMAIN1 -o runoff.pdf
    python SurfaceRunoff.py /path/to/LDASOUT_DOMAIN1 --time-index 1

Requires: netCDF4, NumPy, and Matplotlib.
"""

import argparse
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
from netCDF4 import Dataset


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "input",
        nargs="?",
        type=Path,
        default=Path("201108290000.LDASOUT_DOMAIN1"),
        help="WRF-Hydro LDASOUT NetCDF file (default: original example file)",
    )
    parser.add_argument(
        "-o", "--output", type=Path, default=Path("SurfaceRunoff.pdf"),
        help="Output figure (default: SurfaceRunoff.pdf)",
    )
    parser.add_argument(
        "--time-index", type=int, default=0,
        help="Zero-based time index for a 3D runoff variable (default: 0)",
    )
    parser.add_argument("--vmin", type=float, default=0.0, help="Color scale minimum")
    parser.add_argument("--vmax", type=float, default=300.0, help="Color scale maximum")
    parser.add_argument(
        "--no-flip-y", action="store_true",
        help="Use the native row orientation instead of flipping the first axis",
    )
    args = parser.parse_args()

    if args.time_index < 0:
        parser.error("--time-index must be zero or greater")
    if args.vmin >= args.vmax:
        parser.error("--vmin must be less than --vmax")

    with Dataset(args.input, "r") as ds:
        if "UGDRNOFF" not in ds.variables:
            parser.error("input file does not contain the UGDRNOFF runoff variable")
        runoff_var = ds.variables["UGDRNOFF"]
        if runoff_var.ndim == 3:
            if args.time_index >= runoff_var.shape[0]:
                parser.error(f"--time-index must be below {runoff_var.shape[0]}")
            runoff = runoff_var[args.time_index, :, :]
        elif runoff_var.ndim == 2:
            if args.time_index != 0:
                parser.error("--time-index must be 0 for a 2D runoff variable")
            runoff = runoff_var[:, :]
        else:
            parser.error("UGDRNOFF must have two spatial dimensions, with optional time")
        units = getattr(runoff_var, "units", "mm")

    # Preserve the original example's north/south row reversal by default.
    if not args.no_flip_y:
        runoff = np.flip(runoff, axis=0)

    fig, ax = plt.subplots(figsize=(6, 6), dpi=200)
    image = ax.imshow(runoff, vmin=args.vmin, vmax=args.vmax)
    colorbar = fig.colorbar(image, ax=ax, orientation="horizontal")
    colorbar.set_label(f"Surface runoff ({units})")
    ax.set_title("WRF-Hydro surface runoff (UGDRNOFF)")
    fig.tight_layout()
    fig.savefig(args.output)
    plt.close(fig)
    print(f"Saved runoff plot: {args.output}")


if __name__ == "__main__":
    main()
