
### Citation:
Hatheway, W., Snoun, H., ur Rehman, H. et al. WRF-MOSIT: a modular and cross-platform tool for configuring and installing the WRF model. Earth Sci Inform (2023). https://doi.org/10.1007/s12145-023-01136-y

---
### WRF Multi Operational System Install Toolkit
This is a BASH script that provides options to install the following Weather Research & Forecasting Model (WRF) packages in 64-bit systems:

- Weather Research & Forecasting Model (WRF-ARW)
- Weather Research & Forecasting Model Chemistry (WRF-CHEM)
- Weather Research & Forecasting Model Hydro Standalone (WRF-Hydro)
- Weather Research & Forecasting Model Hydro Coupled w/ WRF (WRF-Hydro Coupled)
- Weather Research & Forecasting Model CMAQ (WRF-CMAQ)
- Weather Research & Forecasting Model Wildland Fire (WRF-SFIRE)
- A Coupled-Ocean-Atmosphere-Wave-Sediment Transport Modeling System (COAWST)

- Basic Nesting is set up
---
### System Requirements
- 64-bit system
    - Darwin (MacOS)
    - Linux Debian Distro (Ubuntu, Mint, etc)
    - Windows Subsystem for Linux (Debian Distro, Ubuntu, Mint, etc)
    - Linux Fedora Distro (Centos, Rocky Linux, RHL, etc)
- 350 Gigabyte (GB) of free storage space
---
### Minimum Reccomended System Configuration
- 16GB or more RAM
- 8 or more CPU cores

---
### WRF Folder Structure
The default WRF folder is located at:

```
/home/<username>/<WRF software name>
```

Where:
- `<username>` is your Linux/MacOS system username.
- `<WRF software name>` can be one of:
    - `WRF`
    - `WRF_CHEM`
    - `WRFHYDRO`
    - `WRF_COUPLED`
    - `WRF_SFIRE`
    - `WRF_CMAQ`
    - `COAWST`

Example:

```
/home/johndoe/WRF_CHEM/
/home/johndoe/WRFHYDRO_Coupled_Intel/
```

Update this path accordingly when configuring your environment variables or running tools.

---
### Installed Version Information

```bash
export METPLUS_Version=6.2.0
export met_Version_number=12.2.0
export met_VERSION_number=12.2
export METPLUS_DATA=6.2
export WRF_VERSION=4.7.1
export WPS_VERSION=4.6.0
export CMAQ_VERSION=5.5
```

---
| OS / Model                     |      WRF-ARW |     WRF-CHEM | Hydro Standalone | Hydro Coupled |          **CMAQ** |    **SFIRE** |        **COAWST** |
| ------------------------------ | -----------: | -----------: | ---------------: | ------------: | ----------------: | -----------: | ----------------: |
| **Ubuntu/Debian (x86_64)**     |  GNU / Intel |  GNU / Intel |      GNU / Intel |   GNU / Intel |      **GNU only** | **GNU only** |       GNU / Intel |
| **RHEL/Rocky/CentOS (x86_64)** |  GNU / Intel |  GNU / Intel |      GNU / Intel |   GNU / Intel |      **GNU only** | **GNU only** |       GNU / Intel |
| **macOS (Intel/ARM)**          | **GNU only** | **GNU only** |     **GNU only** |  **GNU only** | **Not available** | **GNU only** | **Not available** |


---
### Libraries Installed (Latest libraries as of 11/01/2025)
- Libraries are manually installed in sub-folders utilizing either Intel or GNU Compilers.
    - Libraries installed with GNU compilers
        - zlib (1.3.1)
        - MPICH (4.3.2)
        - libpng (1.6.39)
        - JasPer (1.900.1)
        - HDF5 (1.14.6)
        - PHDF5 (1.14.6)
        - Parallel-NetCDF (1.14.1)
        - NetCDF-C (4.9.3)
        - NetCDF-Fortran (4.6.2)
        - NetCDF-CXX (4.3.1)
        - Miniconda
    - Libraries installed with Intel compilers
        - zlib (1.3.1)
        - libpng (1.6.39)
        - JasPer (1.900.1)
        - HDF5 (1.14.6)
        - PHDF5 (1.14.6)
        - Parallel-NetCDF (1.14.1)
        - NetCDF-C (4.9.3)
        - NetCDF-Fortran (4.6.2)
        - Miniconda
        - Intel-Basekit
        - Intel-HPCKIT
        - Intel-Oneapi-Python

---
### Software Packages
- WRF
    - WRF v4.7.1
    - WPS v4.6.0
    - WRF PLUS v4.7.1
    - WRFDA 4DVAR v4.7.1
    - OBSGRID (Conda Installed - NCAR Command Language)    
- WRF-CHEM
    - WRF Chem w/KPP v4.7.1
    - WPS v4.6.0
    - WRFDA Chem 3DVAR
    - OBSGRID (Conda Installed - NCAR Command Language) 
- WRF-Hydro Standalone
    - WRF-Hydro v5.4
- WRF-Hydro Coupled
    - WRF-Hydro v5.4
    - WRF v4.7.1
    - WPS v4.6.0
    - OBSGRID (Conda Installed - NCAR Command Language) 
- WRF-CMAQ
    - WRF v4.5.0
    - CMAQ v5.5
    - WPS v4.6.0
- WRF-SFIRE
    - WRF-SFIRE v2
    - WPS v4.2

---
### Pre/Post Processing Packages Installed
- WRF
    - Development Testbed Center (DTC) Model Evaluation Tools (MET) v12.1.1
    - Development Testbed Center (DTC) Enhanced Model Evaluation Tools (METplus) v6.1.0
    - WRF-Python (Conda installed)
    - OpenGrADS 
    - GrADS 
    - NCAR Command Langauge (Conda installed)
    - Climate Data Operators (Conda installed)
      
- WRF-CHEM
    - Development Testbed Center (DTC) Model Evaluation Tools (MET) v12.1.1
    - Development Testbed Center (DTC) Enhanced Model Evaluation Tools (METplus) v6.1.0
    - WRF-Python (Conda installed)
    - OpenGrADS
    - GrADS
    - NCAR Command Langauge (Conda installed)
    - Climate Data Operators (Conda installed)
    - Prep-Chem-SRC v1.5 (GNU only)
    - WRF CHEM Tools
        - Mozbc
        - Megan Bio Emiss
        - Megan Bio Data
        - Wes Coldens
        - ANTHRO EMIS
        - EDGAR HTAP
        - EPA ANTHO EMIS
        - UBC
        - Aircraft
        - FINN

- WRF-Hydro Standalone
    - Development Testbed Center (DTC) Model Evaluation Tools (MET) v12.1.1
    - Development Testbed Center (DTC) Enhanced Model Evaluation Tools (METplus) v6.1.0
    - WRF-GIS-Preprocessor (Conda installed)
      
- WRF-Hydo Coupled
    - Development Testbed Center (DTC) Model Evaluation Tools (MET) v12.1.1
    - Development Testbed Center (DTC) Enhanced Model Evaluation Tools (METplus) v6.1.0
    - WRF-Python (Conda installed)
    - OpenGrADS
    - GrADS
    - NCAR Command Langauge (Conda installed)
    - Climate Data Operators (Conda installed)
    - WRF-GIS-Preprocessor (Conda installed)
      
 - WRF-SFIRE
    - Development Testbed Center (DTC) Model Evaluation Tools (MET) v12.1.1
    - Development Testbed Center (DTC) Enhanced Model Evaluation Tools (METplus) v6.1.0
    - WRF-Python (Conda installed)
    - OpenGrADS
    - GrADS
    - NCAR Command Langauge (Conda installed)
    - Climate Data Operators (Conda installed)
  
- WRF-CMAQ
    - Development Testbed Center (DTC) Model Evaluation Tools (MET) v12.1.1
    - Development Testbed Center (DTC) Enhanced Model Evaluation Tools (METplus) v6.1.0
    - WRF-Python (Conda installed)
    - OpenGrADS
    - GrADS
    - NCAR Command Langauge (Conda installed)
    - Climate Data Operators (Conda installed)

- COAWST
    - Development Testbed Center (DTC) Model Evaluation Tools (MET) v12.1.1
    - Development Testbed Center (DTC) Enhanced Model Evaluation Tools (METplus) v6.1.0
    - WRF-Python (Conda installed)
    - OpenGrADS
    - GrADS
    - NCAR Command Langauge (Conda installed)
    - Climate Data Operators (Conda installed)

---
### MacOS Installation
- Make sure to download and Homebrew before moving to installation.
> cd $HOME

> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

> brew install git

> git clone https://github.com/HathewayWill/WRF-MOSIT.git

> cd $HOME/WRF-MOSIT

> chmod 775 *.sh

> ./WRF-MOSIT.sh 2>&1 | tee WRF_MOSIT.log

### APT Installation
- (Make sure to download folder into your Home Directory):
> cd $HOME

> sudo apt install git -y

> git clone https://github.com/HathewayWill/WRF-MOSIT.git

> cd $HOME/WRF-MOSIT

> chmod 775 *.sh

> ./WRF-MOSIT.sh 2>&1 | tee WRF_MOSIT.log


### YUM/DNF Installation
- (Make sure to download folder into your Home Directory):
> cd $HOME

> sudo (yum or dnf) install git -y

> git clone https://github.com/HathewayWill/WRF-MOSIT.git

> cd $HOME/WRF-MOSIT

> chmod 775 *.sh

> ./WRF-MOSIT.sh 2>&1 | tee WRF_MOSIT.log


---
### Script Behavior and Installation Options

Once the script is launched, it will perform the following checks and guide the user through a step-by-step installation process:

#### Automatic Checks
- Detects **system architecture type** (e.g., Intel, AMD).
- Verifies **available storage space** meets minimum requirements.

#### Interactive Installation Options

Users will be prompted to configure the following options:

1. **Compiler Selection**  
   Choose which compiler to use:
   - `Intel` – Offers improved performance on Intel CPUs. On non-Intel CPUs, performance gains are minimal or negligible.
   - `GNU` – Broad compatibility and stability across most architectures.

2. **Graphics Display Package**  
   Select your preferred visualization software:
   - `GrADS`
   - `OpenGrADS`

3. **Auto Configuration**  
   Enable one-click install using default/recommended settings.
   **Recommended:** `Yes`

4. **Secondary WPS Geography Files**  
   Download additional WPS geography datasets.  
   **Recommended:** `Yes` (especially for full functionality)

5. **Optional WPS Geography Files**  
   Download optional datasets to enhance spatial resolution support.  
   **Recommended:** `Yes`

6. **WRF Software Selection**  
   Choose which WRF-based model you want to install:
   - `WRF`
   - `WRF-CHEM`
   - `WRF-Hydro`
   - `WRF-Hydro Coupled`
   - `WRF-CMAQ`
   - `WRF-SFIRE`
   - `COAWST`

---

---

### Conda Environments and Tools

The WRF-MOSIT installation includes several pre-configured **Conda environments** to support post-processing, visualization, and scripting tools commonly used with WRF output. These are automatically installed during setup:

| Environment Name | Path | Purpose |
|------------------|------|---------|
| `cdo_stable`     | `$HOME/<WRF software name>/miniconda3/envs/cdo_stable` | Environment for **Climate Data Operators (CDO)** – a collection of command-line tools for manipulating and analyzing climate and forecast model data. |
| `ncl_stable`     | `$HOME/<WRF software name>/miniconda3/envs/ncl_stable` | Environment for **NCAR Command Language (NCL)** – used for advanced scientific visualization and analysis of atmospheric data. |
| `wrf-python`     | `$HOME/<WRF software name>/miniconda3/envs/wrf-python` | Environment for **WRF-Python** – a Python package for post-processing WRF model output using NumPy and Matplotlib-compatible interfaces. |
| `wrfh_gis_env`     | `$HOME/<WRF software name>/miniconda3/envs/wrfh_gis_env` | Environment for **WRF-GIS-Preprocessor** – The WRF-Hydro GIS Pre-processor provides various scripts and tools for building the geospatial input files for running a WRF-Hydro simulation. |

> These environments ensure tool stability and avoid dependency conflicts by isolating the tools in their own environments. You can activate them using:

conda activate *environment_name*


---

### Exports to run WRF and WPS programs
- GNU Compilers

    > export LD_LIBRARY_PATH=$HOME/WRF/Libs/NETCDF/lib:$LD_LIBRARY_PATH

    > export LD_LIBRARY_PATH=$HOME/WRF/Libs/grib2/lib:$LD_LIBRARY_PATH

    > export PATH=$HOME/WRF/Libs/MPICH/bin:$PATH

    > export PATH=$HOME/WRF/Libs/grib2/lib:$PATH
    
    > export PATH=$HOME/WRF/GrADS/Contents:$PATH




- Intel Compilers

    > source /opt/intel/oneapi/setvars.sh

    > export LD_LIBRARY_PATH=$HOME/WRF_Intel/Libs/NETCDF/lib:$LD_LIBRARY_PATH

    > export LD_LIBRARY_PATH=$HOME/WRF_Intel/Libs/grib2/lib:$LD_LIBRARY_PATH

    > export PATH=$HOME/WRF_Intel/Libs/grib2/lib:$PATH
       
    > export PATH=$HOME/WRF_Intel/GrADS/Contents:$PATH


- Make sure to change the name of the WRF Folder to whichever version you are using, WRF_CHEM, WRFHYDRO, etc.



---

  ##### *** Tested on Ubuntu 22.04.4 LTS, Ubuntu 24.04.3 LTS, MacOS Ventura, MacOS Sonoma, Centos8, Rocky Linux 9, Windows Sub-Linux Ubuntu***
- Built 64-bit system.
- Tested with current available libraries on 11/01/2025, exceptions have been noted in the script documentation.
---

#### Estimated Run Time ~ 60 to 120 Minutes @ 10mbps download speed.
- Intel compilers take slightly more time to install packages.
---
### Special thanks to:
- University of Zadar's Ivan T. - Youtube's meteoadriatic
- GitHub user jamal919
- University of Manchester's  Doug L
- University of Tunis El Manar's Hosni S.
- GSL's Jordan S.
- NCAR's Mary B., Christine W., Soren R., & Carl D.
- DTC's Tara J.,Julie P., George M., & John H.
- UCAR's Katelyn F., Jim B., Jordan P., Kevin M.,
---
#### Citation:
#### Hatheway, W., Snoun, H., ur Rehman, H. et al. WRF-MOSIT: a modular and cross-platform tool for configuring and installing the WRF model. Earth Sci Inform (2023). https://doi.org/10.1007/s12145-023-01136-y
---
#### References:
Appel KW, Gilliam RC, Davis N, Zubrow A, Howard SC (2011) Overview of the atmospheric model evaluation tool (AMET) v1.1 for evaluating meteorological and air quality models. Environ Model Softw 26:434–443. https://doi.org/10.1016/J.ENVSOFT.2010.09.007
Article Google Scholar 

Brousse O, Martilli A, Foley M, Mills G, Bechtel B (2016) WUDAPT, an efficient land use producing data tool for mesoscale models? Integration of urban LCZ in WRF over Madrid. Urban Clim 17:116–134. https://doi.org/10.1016/J.UCLIM.2016.04.001
Article Google Scholar 

Brown B, Jensen T, Gotway JH, Bullock R, Gilleland E, Fowler T, Newman K, Adriaansen D, Blank L, Burek T, Harrold M, Hertneky T, Kalb C, Kucera P, Nance L, Opatz J, Vigh J, Wolff J (2021) The model evaluation tools (MET): more than a decade of community-supported forecast verification. Bull Am Meteorol Soc 102:E782–E807. https://doi.org/10.1175/BAMS-D-19-0093.1
Article Google Scholar 

Carslaw DC, Ropkins K (2012) Openair — an R package for air quality data analysis. Environ Model Softw 27–28. https://doi.org/10.1016/J.ENVSOFT.2011.09.008
Chang V (2017) Towards data analysis for weather cloud computing. Knowl-Based Syst 127:29–45. https://doi.org/10.1016/J.KNOSYS.2017.03.003
Article Google Scholar 

Coen JL, Cameron M, Michalakes J, Patton EG, Riggan PJ, Yedinak KM (2013) WRF-Fire: coupled Weather–Wildland Fire modeling with the weather research and forecasting model. J Appl Meteorol Climatol 52:16–38. https://doi.org/10.1175/JAMC-D-12-023.1
Article Google Scholar 

Fast JD, Gustafson WI, Easter RC, Zaveri RA, Barnard JC, Chapman EG, Grell GA, Peckham SE (2006) Evolution of ozone, particulates, and aerosol direct radiative forcing in the vicinity of Houston using a fully coupled meteorology-chemistry-aerosol model. J Geophys Res Atmos 111. https://doi.org/10.1029/2005JD006721
Grell GA, Peckham SE, Schmitz R, McKeen SA, Frost G, Skamarock WC, Eder B (2005) Fully coupled online chemistry within the WRF model. Atmos Environ 39:6957–6975. https://doi.org/10.1016/J.ATMOSENV.2005.04.027
Article Google Scholar 

Hluchy L (2016) Software support for the execution of WRF (Weather Research and Forecasting) simulations on HPC infrastructures. https://doi.org/10.1109/eScience.2016.7870932
Hoste K, Timmerman J, Georges A, Weirdt S, D (2012) Easybuild: building software with ease. Proc – 2012 SC Companion High Perform. Comput Netw Storage Anal SCC 2012:572–582. https://doi.org/10.1109/SC.COMPANION.2012.81
Maharjan A, Shakya A (2022) Enhancement of WRF Model using CUDA. Interdiscip J Innov Nepal Acad 1:16–22. https://doi.org/10.3126/IDJINA.V1I1.51963
Article Google Scholar 

McCaslin et al (2004) 14.4 A Graphical User Interface to Prepare the Standard Initialization for WRF (2004–84Annual_20waf16nw) [WWW Document]. https://ams.confex.com/ams/84Annual/techprogram/paper_69852.htm. Accessed 3.7.23
Meyer D, Riechert M (2019) Open source QGIS toolkit for the advanced research WRF modeling system. Environ Model Softw 112:166–178. https://doi.org/10.1016/J.ENVSOFT.2018.10.018
Article Google Scholar 

Muñoz-Esparza D, Kosović B, Jiménez PA, Coen JL (2018) An accurate fire-spread algorithm in the weather research and forecasting model using the level-set method. J Adv Model Earth Syst 10:908–926. https://doi.org/10.1002/2017MS001108
Article Google Scholar 

National Oceanic and Atmospheric Administration (NOAA) (2021) WRF User’s Guide. Retrieved from https://www2.mmm.ucar.edu/wrf/users/docs/user_guide_V4/user_guide_V4.3.pdf. Accessed 2021
Nikfal A (2023) PostWRF: interactive tools for the visualization of the WRF and ERA5 model outputs. Environ Model Softw 160:105591. https://doi.org/10.1016/J.ENVSOFT.2022.105591
Article Google Scholar 

Sanyal J, Zhang S, Dyer J, Mercer A, Amburn P, Moorhead R (2010) Noodles: a tool for visualization of numerical weather model ensemble uncertainty. IEEE Trans Vis Comput Graph 16:1421–1430. https://doi.org/10.1109/TVCG.2010.181
Article Google Scholar 

Shi J, Wu Z, Lu G, Li Y (2013) Design and application of WRF computing platform based on B/S structure. Proc – 2013 Int Conf Mechatron Sci Electr Eng Comput MEC 2013:1804–1807. https://doi.org/10.1109/MEC.2013.6885345
Skamarock WC, Klemp JB, Dudhia J, Gill DO, Barker DM, Wang W, Powers JG (2008) A description of the advanced research WRF version 3. NCAR/TN. https://doi.org/10.5065/D68S4MVH
Skamarock C, Klemp B, Dudhia J, Gill O, Liu Z, Berner J, Wang W, Powers G, Duda G, Barker D, Huang X (2021) A Description of the Advanced Research WRF Model Version 4.3. https://doi.org/10.5065/1DFH-6P97
Wang YQ (2014) MeteoInfo: GIS software for meteorological data visualization and analysis. Meteorol Appl 21:360–368. https://doi.org/10.1002/MET.1345


<a href="https://mapmyvisitors.com/web/1c29b"  title="Visit tracker"><img src="https://mapmyvisitors.com/map.png?d=34dQOkewlyAWNcxAuQtrFtyl-qdhYx9qooqNuu3P0Ro&cl=ffffff" /></a>
---
