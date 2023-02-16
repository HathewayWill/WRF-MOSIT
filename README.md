<a href="https://info.flagcounter.com/D269"><img src="https://s01.flagcounter.com/count/D269/bg_FFFFFF/txt_000000/border_CCCCCC/columns_8/maxflags_250/viewers_0/labels_0/pageviews_1/flags_0/percent_0/" alt="Flag Counter" border="0"></a>

### WRF Multi Operational System Install Toolkit
This is a BASH script that provides options to install the following Weather Research & Forecasting Model (WRF) packages in 64-bit systems:

- Weather Research & Forecasting Model (WRF)
- Weather Research & Forecasting Model Chemistry (WRF-CHEM)
- Weather Research & Forecasting Model Hydro Standalone (WRF-Hydro)
- Weather Research & Forecasting Model Hydro Coupled w/ WRF (WRF-Hydro Coupled)
- Hurricane Weather Research & Forecasting Model (HWRF)
---
### System Requirements
- 64-bit system
    - Darwin (MacOS)
    - Linux Debian Distro (Ubuntu, Mint, etc)
    - Windows Subsystem for Linux (Debian Distro, Ubuntu, Mint, etc)
    - CentOS based systems not supported
- 350 Gigabyte (GB) of storage space

---
### Libraries Installed (Latest libraries as of 01/01/2023)
- Libraries are manually installed in sub-folders utilizing either Intel or GNU Compilers.
    - Libraries installed with GNU compilers
        - zlib (1.2.13)
        - MPICH (4.0.3)
        - libpng (1.6.39)
        - JasPer (1.900.1)
        - HDF5 (1.13.2)
        - PHDF5 (1.13.2)
        - Parallel-NetCDF (1.12.3)
        - NetCDF-C (4.9.0)
        - NetCDF-Fortran (4.6.0)
        - Miniconda
    - Libraries installed with Intel compilers
        - zlib (1.2.13)
        - libpng (1.6.39)
        - JasPer (1.900.1)
        - HDF5 (1.13.2)
        - PHDF5 (1.13.2)
        - Parallel-NetCDF (1.12.3)
        - NetCDF-C (4.9.0)
        - NetCDF-Fortran (4.6.0)
        - Miniconda
        - Intel-Basekit
        - Intel-HPCKIT
        - Intel-AIKIT

---
### Software Packages
- WRF
    - WRF v4.4.2
    - WPS v4.4
    - WRF PLUS v4.4.2
    - WRFDA 4DVAR v4.4.2    
- WRF-CHEM
    - WRF Chem w/KPP 4.4.2
    - WPS 4.4
    - WRFDA Chem 3DVAR
- WRF-Hydro Standalone
    - WRF-Hydro v5.2
- WRF-Hydro Coupled
    - WRF-Hydro v5.2
    - WRF v4.4.2
    - WPS v4.4
- Hurricane WRF (HWRF)
    - HWRF Utilities v4.0a
    - POMTC v4.0a
    - NCEP Coupler v4.0a
    - GFDL Vortex Tracker v4.0a
    - GSI v4.0a
    - UPP v4.0a
    - WRF v4.3.3
    - WPS 4.3.1
---
### Pre/Post Processing Packages Installed
- WRF
    - Development Testbed Center (DTC) Model Evaluation Tools (MET) v11.0.0
    - Development Testbed Center (DTC) Enhanced Model Evaluation Tools (METplus) v5.0.0
    - Development Testbed Center (DTC) Unified Post Processor (UPP) v4.1
    - ARWPost v3
    - WRF-Python (Conda installed)
    - OpenGrADS
    - GrADS
    - NCAR Command Langauge (Conda installed)
- WRF-CHEM
    - Development Testbed Center (DTC) Model Evaluation Tools (MET) v11.0.0
    - Development Testbed Center (DTC) Enhanced Model Evaluation Tools (METplus) v5.0.0
    - Development Testbed Center (DTC) Unified Post Processor (UPP) v4.1
    - ARWPost v3
    - WRF-Python (Conda installed)
    - OpenGrADS
    - GrADS
    - NCAR Command Langauge (Conda installed)
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
    - Development Testbed Center (DTC) Model Evaluation Tools (MET) v11.0.0
    - Development Testbed Center (DTC) Enhanced Model Evaluation Tools (METplus) v5.0.0
- WRF-Hydo Coupled
    - Development Testbed Center (DTC) Model Evaluation Tools (MET) v11.0.0
    - Development Testbed Center (DTC) Enhanced Model Evaluation Tools (METplus) v5.0.0
    - Development Testbed Center (DTC) Unified Post Processor (UPP) v4.1
    - ARWPost v3
    - WRF-Python (Conda installed)
    - OpenGrADS
    - GrADS
    - NCAR Command Langauge (Conda installed)
    - WRF-GIS-Preprocessor (Conda installed)
- HWRF
    - Development Testbed Center (DTC) Model Evaluation Tools (MET) v11.0.0
    - Development Testbed Center (DTC) Enhanced Model Evaluation Tools (METplus) v5.0.0
    - Development Testbed Center (DTC) Unified Post Processor (UPP) v4.1
---
### Installation
- (Make sure to download folder into your Home Directory): $HOME


> git clone https://github.com/HathewayWill/WRF-MOSIT.git

> cd $HOME/WRF-MOSIT

> chmod 775 *.sh
>
> ./WRF-MOSIT.sh | tee WRF.MASTER.log

- Script will check for System Architecture Type and Storage Space requirements.

- Once running the script users will be provided with options to select how the WRF_Master_Script will compile and install the various packages.
    - First option, Which compiler users want to use Intel or GNU compilers.
         - Please note that Hurricane WRF (HWRF) can only use Intel Compilers
    - Second option, Which graphic display package should be installed.  GrADS or OpenGrADS
    - Third option, Auto Configuration.  This allows users to have a one-click install
    - Fourth option, Secondary WPS geography file download choice.
      - Author of script reccomends selecting "YES" if user is unsure.
    - Fifth option, Optional WPS geography file download cohice.
      - Author of script reccomends selecting "YES" if user is unsure.
    - Last option, Pick which WRF software user wants to install


---

  ##### *** Tested on Ubuntu 20.04.5 LTS,  Ubuntu 22.04.1 LTS, MacOS Ventura, Windows Sub-Linux Ubuntu***
- Built 64-bit system.
- Tested with current available libraries on 01/01/2023, execptions have been noted in the script documentation.
---

### Sponsorships and donations accepted but not required
Click here!
[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/HathewayWill)

- Sponsorships help the author push updates to the end user faster, maintain and update code, develop new code, provide end user support, and end user consulting.
---
#### Estimated Run Time ~ 60 to 120 Minutes @ 10mbps download speed.
- Intel compilers take slightly more time to install packages.
---
### Special thanks to:
- Youtube's meteoadriatic
- GitHub user jamal919
- University of Manchester's  Doug L
- University of Tunis El Manar's Hosni S.
- GSL's Jordan S.
- NCAR's Mary B., Christine W., & Carl D.
- DTC's Julie P., Tara J., George M., & John H.
- UCAR's Katelyn F., Jim B., Jordan P., Kevin M.,
---
#### Citation:
#### Hatheway, W. (2023). Weather Research & Forecasting Self Install Script (Version 1.0.3) [Computer software]
---
#### References:
- Skamarock, W. C., J. B. Klemp, J. Dudhia, D. O. Gill, Z. Liu, J. Berner, W. Wang, J. G. Powers, M. G. Duda, D. M. Barker, and X.-Y. Huang, 2019: A Description of the Advanced Research WRF Version 4. NCAR Tech. Note NCAR/TN-556+STR, 145 pp. doi:10.5065/1dfh-6p97
- Biswas, M. K., Bernardet, L., Abarca, S., Ginis, I., Grell, E., Kalina, E., … Zhang, Z. (2018). Hurricane Weather Research and Forecasting (HWRF) Model: 2017 Scientific Documentation (No. NCAR/TN-544+STR). doi:10.5065/D6MK6BPR
- Peckham, S., G. A. Grell, S. A. McKeen, M. Barth, G. Pfister, C. Wiedinmyer, J. D. Fast, W. I. Gustafson, R. Zaveri, R. C. Easter, J. Barnard, E. Chapman, M. Hewson, R. Schmitz, M. Salzmann, S. Freitas, 2011: WRF-Chem Version 3.3 User's Guide. NOAA Technical Memo., 98 pp.

- "We acknowledge use of the WRF-Chem preprocessor tool {name of tool} provided by the Atmospheric Chemistry Observations and Modeling Lab (ACOM) of NCAR."

- Gochis, D.J., M. Barlage, R. Cabell, M. Casali, A. Dugger, K. FitzGerald,
M. McAllister, J. McCreight, A. RafieeiNasab, L. Read, K. Sampson, D.
Yates, Y. Zhang (2020).  The WRF-Hydro® modeling system technical
description, (Version 5.2.0).  NCAR Technical Note. 108 pages. Available
online at:
https://ral.ucar.edu/sites/default/files/public/projects/wrf-hydro/technical-description-user-guide/wrf-hydrov5.2technicaldescription.pdf
- Freitas, S. R. ; Longo, K. M. ; Alonso, M. F. ; Pirre, M. ; Marecal, V. ; Grell, G. ; Stockler,
R. ; Mello, R. F. ; Sánchez Gácita, M. . PREP-CHEM-SRC 1.0: a preprocessor of trace
gas and aerosol emission fields for regional and global atmospheric chemistry
models. Geoscientific Model Development, v. 4, p. 419-433, 2011
- Shamsaei, K., Juliano, T., Igrashkina, N., Ebrahimian, H., Kosovic, B., Taciroglu, E. (2022) WRF-Fire Wikipage. doi: 10.5281/zenodo.6667633 [access date]
 

---




