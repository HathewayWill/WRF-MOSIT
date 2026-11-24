# WRF-MOSIT v2.0.0

**WRF Multi Operational System Install Toolkit**

WRF-MOSIT is a guided Bash installer for the Weather Research and Forecasting (WRF) model and selected related modeling systems. It prepares compiler environments, builds scientific libraries, downloads model source code and optional datasets, compiles model components, and performs installation checks. The toolkit is intended for atmospheric science researchers, educators, and students who want a reproducible starting point for numerical modeling.

**Version 2.0.0 introduces reusable scientific-library profiles, independent model installations, model-specific dependency isolation, geographical-data reuse, and a reorganized six-stage installation interface.** It retains the original model-specific installation procedures rather than replacing them with a new build system.

Repository: https://github.com/HathewayWill/WRF-MOSIT  
Publication: https://doi.org/10.1007/s12145-023-01136-y  
License: [GNU General Public License v3](LICENSE)

## Contents

- [What's new in v2.0.0](#whats-new-in-v200)
- [Modeling systems](#modeling-systems)
- [Compiler and platform compatibility](#compiler-and-platform-compatibility)
- [Requirements](#requirements)
- [Installation](#installation)
- [Guided installer workflow](#guided-installer-workflow)
- [Reusing scientific libraries with YAML](#reusing-scientific-libraries-with-yaml)
- [Reusing WPS geographical data](#reusing-wps-geographical-data)
- [Model versions and scientific dependencies](#model-versions-and-scientific-dependencies)
- [Installation directories](#installation-directories)
- [Running WRF and WPS after installation](#running-wrf-and-wps-after-installation)
- [Optional tools and post-processing](#optional-tools-and-post-processing)
- [Validation and known limitations](#validation-and-known-limitations)
- [Troubleshooting](#troubleshooting)
- [Citation, license, and acknowledgments](#citation-license-and-acknowledgments)
- [Selected references](#selected-references)

## What's new in v2.0.0

| Feature | Description |
| --- | --- |
| Reusable scientific libraries | Save the locations of installed scientific libraries in `Libs/wrf-libraries.yaml`. |
| Compatible model reuse | Build WRF-ARW, WRF-Chem, or WRF-Hydro against a compatible, existing library stack. |
| Compiler isolation | Reject reuse when the YAML compiler family differs from the selected GNU or Intel oneAPI build. |
| Architecture checks | Reject a reusable profile whose CPU architecture differs from the current machine. |
| Specialized dependency isolation | WRF-CMAQ, WRF-SFIRE, and COAWST always receive fresh, model-specific scientific-library builds. |
| Independent model trees | A reused library stack is linked into a separate model installation directory without overwriting the original installation. |
| WPS_GEOG reuse | Link an existing geographical-data directory instead of downloading it again. |
| ARW nesting selection | Choose basic nesting, preset moves, or a vortex-following nest for WRF-ARW. |
| Guided startup | Six ordered selection stages, a configuration summary, and numeric `1) Install / 2) Cancel` confirmation. |
| Architecture-aware visualization | Select OpenGrADS only when an appropriate bundled binary is available; ARM64 users are directed to GrADS. |
| Installation documentation | Expanded inline Bash comments explaining compiler setup, dependency order, installation stages, and verification. |

The installer remains an all-in-one Bash script. It uses the existing upstream source archives and model-specific build commands, along with optional external tools downloaded during installation.

## Modeling systems

The guided model-selection menu provides:

| Menu | Modeling system | Main purpose | Library policy |
| --- | --- | --- | --- |
| 1 | WRF-ARW | Atmospheric prediction with basic, preset-moving, or vortex-following nesting | Fresh or compatible YAML reuse |
| 2 | WRF-Chem | Online atmospheric chemistry, including KPP build support | Fresh or compatible YAML reuse |
| 3 | WRF-Hydro Coupled | Hydrology integrated with atmospheric WRF | Fresh or compatible YAML reuse |
| 4 | WRF-Hydro Standalone | Hydrological model without a coupled WRF integration | Fresh or compatible YAML reuse |
| 5 | WRF-SFIRE | Coupled atmosphere and wildland-fire modeling | **Fresh libraries required** |
| 6 | WRF-CMAQ | WRF and Community Multiscale Air Quality integration | **Fresh libraries required** |
| 7 | COAWST | Coupled ocean, atmosphere, wave, and sediment modeling | **Fresh libraries required** |

WRFDA, WRFPLUS, OBSGRID, WPS, and supporting utilities are handled in their applicable installation branches. WRF-Chem also offers an optional, separate WRF-Chem Tools installation.

**WRF-ARW nesting:** The three nesting selections are separate configurations, and only the WRF-ARW menu offers preset-moving and vortex-following choices. A successful basic-nesting build does not establish successful compilation of the other two modes.

## Compiler and platform compatibility

WRF-MOSIT v2.0.0 supports **GNU** and **Intel oneAPI** compiler families. AMD AOCC is not included in v2.0.0.

The matrix below describes the implemented installer paths and menu constraints, **not a claim that every combination has been independently regression-tested**.

| Modeling system | Ubuntu/Debian x86_64 | RHEL-family x86_64 | macOS Intel or Apple Silicon |
| --- | --- | --- | --- |
| WRF-ARW | GNU, Intel oneAPI | GNU, Intel oneAPI | GNU |
| WRF-Chem | GNU, Intel oneAPI | GNU, Intel oneAPI | GNU |
| WRF-Hydro Coupled | GNU, Intel oneAPI | GNU, Intel oneAPI | GNU |
| WRF-Hydro Standalone | GNU, Intel oneAPI | GNU, Intel oneAPI | GNU |
| WRF-SFIRE | GNU | GNU | GNU |
| WRF-CMAQ | GNU | GNU | Not offered |
| COAWST | GNU | GNU | Not offered |

Linux ARM64 and legacy GCC branches are present for selected models. Their availability and the availability of third-party binaries are architecture dependent. Linux distributions and macOS releases differ in compilers, packages, and upstream source compatibility.

**Compiler-family rule:** Never load a GNU YAML profile for an Intel oneAPI model, or an Intel profile for a GNU model. Even a compiler-matched profile must come from a compatible installation and architecture.

## Requirements

- A 64-bit Linux or macOS system with network access for source downloads. Ubuntu/Debian-based Linux, RHEL-family Linux, and macOS have installation paths in the script. A compatible Linux distribution under Windows Subsystem for Linux may use its Linux installation path, but is not separately guaranteed.
- Bash, Git, a system package manager, and permission to install system dependencies. The script requests elevated privileges during installation.
- **Recommended:** at least 16 GiB RAM and 8 CPU cores. Larger configurations are useful for parallel source compilation.
- **Storage preflight:** the script requires **300 GiB free** for a normal installation. It reduces this check to **50 GiB** only when *both* scientific libraries and WPS geography are reused. More disk space may be needed depending on optional datasets and model sources; approximately 350 GiB or more is prudent for a fresh installation.
- Python 3 is used to create and read the scientific-library YAML profile. Miniconda and optional Python environments are installed in applicable model branches.

A long installation is normal. Build time varies with selected model, compiler, CPU count, network throughput, and optional geographical datasets. Do not interpret the elapsed time of a single installation as a performance benchmark.

## Installation

The installer assumes a repository directory named **`WRF-MOSIT`** beneath your home directory. Keep that directory name unless you also update the corresponding paths in the installer. In particular, several branches refer to:

```text
$HOME/WRF-MOSIT/wrf-python-stable.yml
```

### Ubuntu and Debian-based Linux

```bash
cd "$HOME"
sudo apt update
sudo apt install -y git
git clone https://github.com/HathewayWill/WRF-MOSIT.git
cd "$HOME/WRF-MOSIT"
chmod +x WRF-MOSIT.sh
bash ./WRF-MOSIT.sh 2>&1 | tee WRF_MOSIT.log
```

### RHEL, Rocky Linux, Fedora, and related systems

```bash
cd "$HOME"
sudo dnf install -y git
git clone https://github.com/HathewayWill/WRF-MOSIT.git
cd "$HOME/WRF-MOSIT"
chmod +x WRF-MOSIT.sh
bash ./WRF-MOSIT.sh 2>&1 | tee WRF_MOSIT.log
```

For distributions using `yum` instead of `dnf`, use the available package manager to install Git.

### macOS

Install Xcode Command Line Tools and Homebrew, if needed, then:

```bash
cd "$HOME"
brew install git
git clone https://github.com/HathewayWill/WRF-MOSIT.git
cd "$HOME/WRF-MOSIT"
chmod +x WRF-MOSIT.sh
bash ./WRF-MOSIT.sh 2>&1 | tee WRF_MOSIT.log
```

The installer contains additional macOS prerequisite checks. GNU is the selectable compiler family for macOS branches; do not choose an Intel oneAPI Linux configuration on macOS.

### If installing from a downloaded release archive

Extract the release so that the directory structure is `$HOME/WRF-MOSIT/`, including `WRF-MOSIT.sh` and `wrf-python-stable.yml`. Then run the same `chmod` and `./WRF-MOSIT.sh` commands above. Do not rename the YAML environment file.

**Log files:** The `tee` command displays installer output and saves it in `WRF_MOSIT.log`. For build failures, retain the relevant `configure.log`, `compile.log`, `make.log`, or model-specific logs in addition to the main installer log.

## Guided installer workflow

At startup, select either `1) New model installation`, `2) Register already-installed scientific libraries (create YAML)`, or `0) Exit without changes`.

For a new model installation, the menu presents six stages in this order:

1. **System and compiler:** detect the operating system and CPU architecture, then choose GNU or Intel oneAPI where supported.
2. **Model and nesting:** select the modeling system, and, for WRF-ARW, choose basic nesting, preset moves, or vortex following.
3. **Scientific libraries:** build a fresh stack or load a compatible YAML profile for ARW, Chem, or Hydro. Specialized models use fresh builds automatically.
4. **WPS geographical data:** download mandatory datasets or select a reusable `WPS_GEOG` directory. Optional geographic datasets are offered only for new downloads and when applicable.
5. **Configuration and optional tools:** select GrADS or OpenGrADS, automatic or manual WRF/WPS configuration, optional WRF-Chem preprocessing tools, and, where offered, DTC MET/METplus.
6. **Preflight and review:** verify available disk space, review the selected configuration, and choose **`1) Install`** or **`2) Cancel`** before authentication and build commands.

Automatic configuration supplies predefined configure selections. Manual configuration leaves the relevant upstream configuration choices to the user. Selecting an option does not guarantee that every upstream physics, chemistry, or nesting configuration is valid; consult the model's own documentation.

## Reusing scientific libraries with YAML

### What is saved

A successful eligible fresh installation can create:

```text
<installation-root>/Libs/wrf-libraries.yaml
```

The profile records the compiler family, a shared-library group identifier, operating system/architecture metadata, source installation location, NetCDF and HDF5 prefixes, and additional registered paths such as MPI and PnetCDF when present. It also records selected `PATH` and `LD_LIBRARY_PATH` entries. It does **not** contain compiled model executables, WRF namelists, or the complete source/build environment.

The current profile schema uses `schema_version: 1`, and eligible profiles carry `library_group: "wrf_shared"`. The installer reads a restricted profile format instead of executing raw YAML contents as shell commands.

### Allowed and disallowed reuse

| Existing library source | Build WRF-ARW | Build WRF-Chem | Build WRF-Hydro | Build CMAQ / SFIRE / COAWST |
| --- | :---: | :---: | :---: | :---: |
| WRF-ARW shared profile | Yes | Yes | Yes | **No** |
| WRF-Chem shared profile | Yes | Yes | Yes | **No** |
| WRF-Hydro shared profile | Yes | Yes | Yes | **No** |
| WRF-CMAQ / WRF-SFIRE / COAWST libraries | **No** | **No** | **No** | **No, always fresh** |

**Additional conditions:** The compiler family and CPU architecture must match, the required libraries and compiler wrappers must exist, and the source installation must be compatible. WRF-SFIRE, WRF-CMAQ, and COAWST have model-specific dependency stacks and never publish reusable shared profiles.

### Build another model from an existing YAML

For example, after building Intel oneAPI WRF-ARW, choose WRF-Chem or WRF-Hydro, select **reuse existing compatible libraries**, and provide the ARW profile:

```text
$HOME/WRF_Intel/Libs/wrf-libraries.yaml
```

The installer validates compatibility and creates a separate destination such as:

```text
$HOME/WRF_Intel_WRFCHEM_4.8.1/
```

Library-directory aliases point to the already installed scientific libraries. WRF model sources and executables are compiled into the new model directory. **Keep the original library source installed.** Removing or relocating it can break installations linked to that stack.

### Register an already-installed stack

Choose **`2) Register already-installed scientific libraries (create YAML)`** at the main menu, provide the installation directory, and select the compiler family. This mode checks library file locations and creates a registry entry; **it does not recompile the libraries or rerun the original build compatibility tests**. Use it only when you know the source installation is sound. Model-specific CMAQ, SFIRE, and COAWST stacks are ineligible.

A YAML registry is a path/compatibility record, not a portable copy of the libraries. It cannot be moved between unrelated computers or compilers and expected to work.

## Reusing WPS geographical data

WPS static geographic datasets may be large. The installation menu supports either downloading a new `WPS_GEOG` directory or linking an existing one. Geography reuse is independent of scientific-library reuse.

For a typical existing installation, enter a directory such as:

```text
$HOME/WRF_Intel/GEOG/WPS_GEOG
```

The installer checks that the directory exists and is nonempty, and creates a link in the new installation when supported. It does not copy the source dataset. Optional and application-specific geography downloads are not offered when reuse is selected. An existing GEOG directory must contain the datasets required by the domains and physics settings you intend to use.

WPS geographical input data and the scientific-library YAML are different resources. Do not point the YAML path at `WPS_GEOG`, or the GEOG selection at `wrf-libraries.yaml`.

## Model versions and scientific dependencies

The default version variables in the uploaded v2.0.0 installer are:

| Component | Default in script |
| --- | --- |
| WRF | `4.8.1` |
| WPS | `4.7.0` |
| CMAQ | `6.0` |
| WRF-Hydro Croton test case | `5.4.0` |
| MET | `12.2.1` |
| METplus | `6.2.1` |
| zlib | `1.3.2` |
| MPICH | `5.0.1` |
| libpng | `1.6.58` |
| JasPer | `1.900.1` |
| HDF5 | `1.14.6` |
| Parallel-NetCDF | `1.14.1` |
| NetCDF-C | `4.10.0` |
| NetCDF-Fortran | `4.6.2` |
| NetCDF-CXX | `4.3.1` |

These are installer defaults, not claims that they are the latest upstream releases. Some model branches intentionally use different source versions or cloned upstream repositories. **In particular, the WRF-SFIRE WPS sections use WPS 4.2, even though the general WPS default is 4.7.0.** WRFDA 3DVAR and 4DVAR compilation paths use the model-specific source trees shown in the installer.

The scientific-library build sequence is designed around dependencies such as MPI, zlib, libpng/JasPer, HDF5, PnetCDF, and NetCDF. Specialized integrations may add NetCDF-CXX, MCT, I/O API, or other model-specific libraries. Do not substitute an ARW shared-library profile for a specialized stack.

## Installation directories

The exact root depends on the model, compiler, and whether libraries are being reused. Typical fresh-build defaults on Linux include:

```text
$HOME/WRF/                   # GNU WRF-ARW
$HOME/WRF_Intel/             # Intel oneAPI WRF-ARW
$HOME/WRFCHEM/               # GNU WRF-Chem
$HOME/WRFCHEM_Intel/         # Intel oneAPI WRF-Chem
$HOME/WRFHYDRO_COUPLED/      # GNU WRF-Hydro Coupled
$HOME/WRFHYDRO_STANDALONE/   # GNU WRF-Hydro Standalone
$HOME/WRF_SFIRE/             # GNU WRF-SFIRE
$HOME/WRF_CMAQ/              # GNU WRF-CMAQ
$HOME/COAWST/                # GNU COAWST
```

For shared-library reuse, the installer suggests a separate model/version-specific destination and prompts you before creating it. Never use the same installation root for two different nesting or model builds. The initial source installation and any linked scientific libraries must remain in place.

A typical installation contains some of these locations, depending on the selected model:

```text
<installation-root>/
├── Downloads/              # Downloaded source archives and temporary files
├── Libs/                   # Scientific libraries or links to shared libraries
│   └── wrf-libraries.yaml  # Eligible fresh ARW/Chem/Hydro builds only
├── GEOG/
│   └── WPS_GEOG/           # New geographical data or link to an existing set
├── WRF-4.8.1/              # WRF source tree when applicable
├── WPS-4.7.0/              # WPS source tree when applicable
├── WRFDA/                  # Data assimilation when applicable
└── OBSGRID/                # Objective analysis preprocessing when applicable
```

Source-folder names and optional components vary across model branches. Source archive cleanup removes downloaded archives from the active installation, not installed model trees or a separately reused geographical dataset.

## Running WRF and WPS after installation

WRF-MOSIT installs software; it does not automatically configure or execute a scientific simulation. Once the relevant executables exist, users must prepare geographical files, forcing data, namelists, and model-specific inputs.

For a typical Intel oneAPI WRF-ARW installation, start a new shell with the compiler environment and scientific libraries available:

```bash
source /opt/intel/oneapi/setvars.sh --force
export NETCDF="$HOME/WRF_Intel/Libs/NETCDF"
export HDF5="$HOME/WRF_Intel/Libs/grib2"
export PATH="$NETCDF/bin:$PATH"
export LD_LIBRARY_PATH="$NETCDF/lib:$HDF5/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
```

For GNU, the corresponding scientific-library paths are typically beneath `$HOME/WRF/Libs`, with MPI wrappers beneath `$HOME/WRF/Libs/MPICH/bin`. **Adjust these exports for your actual installation root, compiler family, and compiler/MPI settings.** Installing a model using shared-library reuse means its `Libs/` entries can be symbolic links.

Inspect the generated WRF and WPS trees for the expected executable files, consult the [WRF User's Guide](https://www2.mmm.ucar.edu/wrf/users/wrf_users_guide/build/html/index.html), and configure `namelist.wps` and `namelist.input` for the chosen domain and physics. A successful compilation does not prove that a model configuration or scientific simulation is correct.

## Optional tools and post-processing

The script contains optional workflows for:

- **WRFDA and WRFPLUS:** Data assimilation components, including 3DVAR for applicable WRF-Chem branches and 4DVAR for WRF-ARW branches.
- **OBSGRID:** Objective analysis preprocessing. The primary installation check is `obsgrid.exe`; optional plotting executables may require additional GNU Fortran linker configuration.
- **WRF-Chem Tools:** Separate tools for chemical emissions and chemical boundary/initial conditions. This option invokes an external installer and may compile its own scientific libraries.
- **GrADS and OpenGrADS:** Visualization options selected according to supported platform/architecture; ARM64 users should use GrADS.
- **Conda environments:** Some branches install environments such as `wrf-python`, `ncl_stable`, `cdo_stable`, and WRF-Hydro GIS tools.
- **DTC MET/METplus:** An optional installation path included in the script. Its compatibility and dependencies require independent verification; skipping it is recommended if the current external installation issues affect your platform.

### WRF-Python environment

The repository includes `wrf-python-stable.yml`. Some installer branches call it directly from `$HOME/WRF-MOSIT/wrf-python-stable.yml`. To create or inspect it independently:

```bash
conda env create -f "$HOME/WRF-MOSIT/wrf-python-stable.yml"
conda activate wrf-python
```

The environment file deliberately pins versions. These are the project's specified versions rather than automatically updated packages. The scientific Python environment is not a replacement for the compiled NetCDF/MPI libraries used by WRF.

### WRF-Hydro surface-runoff example

`SurfaceRunoff.py` is a standalone example that reads `UGDRNOFF` from a WRF-Hydro `LDASOUT` NetCDF file and produces a runoff figure. It is **not** a core WRF-MOSIT installation dependency.

```bash
python SurfaceRunoff.py /path/to/201108290000.LDASOUT_DOMAIN1 \
  --output SurfaceRunoff.pdf
```

The script accepts `--time-index`, `--vmin`, `--vmax`, and `--no-flip-y`. It requires NumPy, Matplotlib, and netCDF4. The color bar uses the variable's `units` attribute when available. The default orientation and color limits reproduce the original plotting example.

## Validation and known limitations

**Validated original baseline:** WRF-MOSIT v1.5.0 and its earlier working model installation paths served as the functional starting point for v2.0.0. Do not interpret v2.0.0 refactoring as evidence that the original installer had not been tested.

**Evidence from the v2.0.0 development logs:**

- Fresh GNU and Intel oneAPI WRF-ARW builds and WPS compilation completed in the reported tests.
- Intel oneAPI scientific-library profiles were reused to compile WRF-Hydro Coupled and WRF-Chem.
- Compiler-family mismatch tests correctly rejected incompatible GNU/Intel YAML reuse.
- Existing WPS geographical data were successfully reused, and WPS directory-handling corrections were exercised during installations.
- Intel WRFDA/WRFPLUS 4DVAR and GNU ARW WRFDA/WRFPLUS paths were exercised in the reported tests.

**Scope limitations:** These tests do not establish that every operating-system/compiler/model/nesting combination is validated. Specifically, Linux ARM64, all macOS branches, WRF-CMAQ, COAWST, every WRF-SFIRE path, moving/vortex-following nesting, and optional DTC MET may require additional regression testing and environment-specific adjustments.

**WRF-Chem KPP:** A mechanism-specific CBM4 diagnostic was observed during WRF-Chem 4.8.1 KPP processing. The overall WRF-Chem executable build completed in that run, but the CBM4 mechanism should not be treated as validated on that basis. Development discussion: https://forum.mmm.ucar.edu/threads/wrf-4-8-0-wrf-chem-kpp-build-order-failures-and-cbm4-missing-m-diagnostic.29361/

**Third-party sources:** WRF-MOSIT downloads and compiles upstream software, which can change independently of this repository. Package availability, download URLs, toolchain incompatibilities, and external scientific software errors may affect installation. Preserve logs when reporting issues.

## Troubleshooting

**Installation stops at compiler-family validation.** Select a YAML profile built with the same compiler family. GNU-built libraries and Intel-built libraries are not interchangeable.

**A YAML profile is rejected for CMAQ, SFIRE, or COAWST.** This is intentional. These models require model-specific fresh libraries, and their library stacks are not reusable for ARW, Chem, or Hydro.

**A profile cannot locate NetCDF, HDF5, or MPI wrappers.** Ensure its source installation still exists and its library paths are valid. Reusing YAML does not copy the libraries or reconstruct missing compiler tools.

**WPS_GEOG is unavailable.** Select a valid, nonempty existing directory or choose to download new datasets. Link reuse does not install datasets missing from your current geographical-data collection.

**Conda reports an environment conflict.** Check platform, solver output, and the version pins in `wrf-python-stable.yml`. The file records specific package versions and is not guaranteed to resolve on every current operating system.

**A build prints warnings but produces executables.** Verify the actual required executables and relevant build logs. Some optional utilities may fail to link while the principal model build succeeds. Do not treat every warning as a successful or failed installation without checking the associated target.

**Where to ask for assistance.** Open a GitHub issue at https://github.com/HathewayWill/WRF-MOSIT/issues. Include the operating system, architecture, model, compiler, fresh/YAML setting, WRF/WPS versions, and the relevant build log excerpts. Avoid posting passwords, tokens, private keys, or unrelated personal information.

## Citation, license, and acknowledgments

If WRF-MOSIT supports published research, **please cite the peer-reviewed paper**:

> Hatheway, W., Snoun, H., ur Rehman, H., et al. (2023). WRF-MOSIT: a modular and cross-platform tool for configuring and installing the WRF model. *Earth Science Informatics*. https://doi.org/10.1007/s12145-023-01136-y

Machine-readable citation metadata is provided in [`CITATION.cff`](CITATION.cff), with the journal article as the preferred citation. Credit the underlying WRF and third-party model developers as appropriate for the components used in the research.

The WRF-MOSIT code is distributed under the **GNU General Public License, version 3**. The complete, unmodified license text is in [`LICENSE`](LICENSE). Third-party dependencies and data obtained by the installer retain their own licenses and use conditions.

**Acknowledgments:** Thanks to the researchers, developers, and community contributors acknowledged by the original WRF-MOSIT project, including Ivan T. (University of Zadar / meteoadriatic), GitHub contributor jamal919, Doug L. (University of Manchester), Yeamin R. and Saiful Islam F. (Institute of Water & Flood Management, BUET), Hosni S. (University of Tunis El Manar), Jordan S. (GSL), Mary B., Christine W., Soren R., and Carl D. (NCAR), Tara J., Julie P., George M., and John H. (DTC), and Katelyn F., Jim B., Jordan P., and Kevin M. (UCAR).

WRF-MOSIT is an independent community installation toolkit. References to upstream model software do not imply official institutional endorsement of this installer.

## Selected references

The references below retain the scientific context documented in the previous WRF-MOSIT README. Consult the individual publications for details and proper citation in model-specific research.

- Appel, K. W., Gilliam, R. C., Davis, N., Zubrow, A., & Howard, S. C. (2011). Overview of the atmospheric model evaluation tool (AMET) v1.1 for evaluating meteorological and air quality models. *Environmental Modelling & Software*, 26, 434–443. https://doi.org/10.1016/j.envsoft.2010.09.007
- Brousse, O., Martilli, A., Foley, M., Mills, G., & Bechtel, B. (2016). WUDAPT, an efficient land-use producing data tool for mesoscale models? Integration of urban LCZ in WRF over Madrid. *Urban Climate*, 17, 116–134. https://doi.org/10.1016/j.uclim.2016.04.001
- Brown, B., et al. (2021). The Model Evaluation Tools (MET): More than a decade of community-supported forecast verification. *Bulletin of the American Meteorological Society*, 102, E782–E807. https://doi.org/10.1175/BAMS-D-19-0093.1
- Carslaw, D. C., & Ropkins, K. (2012). Openair: An R package for air quality data analysis. *Environmental Modelling & Software*, 27–28. https://doi.org/10.1016/j.envsoft.2011.09.008
- Chang, V. (2017). Towards data analysis for weather cloud computing. *Knowledge-Based Systems*, 127, 29–45. https://doi.org/10.1016/j.knosys.2017.03.003
- Coen, J. L., et al. (2013). WRF-Fire: Coupled weather–wildland fire modeling with the Weather Research and Forecasting model. *Journal of Applied Meteorology and Climatology*, 52, 16–38. https://doi.org/10.1175/JAMC-D-12-023.1
- Fast, J. D., et al. (2006). Evolution of ozone, particulates, and aerosol direct radiative forcing in the vicinity of Houston using a fully coupled meteorology-chemistry-aerosol model. *Journal of Geophysical Research: Atmospheres*, 111. https://doi.org/10.1029/2005JD006721
- Grell, G. A., et al. (2005). Fully coupled online chemistry within the WRF model. *Atmospheric Environment*, 39, 6957–6975. https://doi.org/10.1016/j.atmosenv.2005.04.027
- Hluchy, L. (2016). Software support for the execution of WRF simulations on HPC infrastructures. https://doi.org/10.1109/eScience.2016.7870932
- Hoste, K., et al. (2012). EasyBuild: Building software with ease. *SC Companion*, 572–582. https://doi.org/10.1109/SC.COMPANION.2012.81
- Maharjan, A., & Shakya, A. (2022). Enhancement of WRF Model using CUDA. *Interdisciplinary Journal of Innovation in Nepal Academia*, 1, 16–22. https://doi.org/10.3126/IDJINA.V1I1.51963
- McCaslin, P., et al. (2004). A graphical user interface to prepare the standard initialization for WRF. https://ams.confex.com/ams/84Annual/techprogram/paper_69852.htm
- Meyer, D., & Riechert, M. (2019). Open-source QGIS toolkit for the Advanced Research WRF modeling system. *Environmental Modelling & Software*, 112, 166–178. https://doi.org/10.1016/j.envsoft.2018.10.018
- Muñoz-Esparza, D., et al. (2018). An accurate fire-spread algorithm in the Weather Research and Forecasting model using the level-set method. *Journal of Advances in Modeling Earth Systems*, 10, 908–926. https://doi.org/10.1002/2017MS001108
- Nikfal, A. (2023). PostWRF: Interactive tools for visualization of WRF and ERA5 model outputs. *Environmental Modelling & Software*, 160, 105591. https://doi.org/10.1016/j.envsoft.2022.105591
- Sanyal, J., et al. (2010). Noodles: A tool for visualization of numerical weather model ensemble uncertainty. *IEEE Transactions on Visualization and Computer Graphics*, 16, 1421–1430. https://doi.org/10.1109/TVCG.2010.181
- Shi, J., et al. (2013). Design and application of WRF computing platform based on B/S structure. *MEC*, 1804–1807. https://doi.org/10.1109/MEC.2013.6885345
- Skamarock, W. C., et al. (2008). A description of the Advanced Research WRF version 3. *NCAR Technical Note*. https://doi.org/10.5065/D68S4MVH
- Skamarock, W. C., et al. (2021). A description of the Advanced Research WRF model version 4.3. https://doi.org/10.5065/1DFH-6P97
- Wang, Y. Q. (2014). MeteoInfo: GIS software for meteorological data visualization and analysis. *Meteorological Applications*, 21, 360–368. https://doi.org/10.1002/met.1345


