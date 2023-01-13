#!/bin/bash

start=`date`
START=$(date +"%s")


############################### System Architecture Type #################
# 32 or 64 bit
##########################################################################


export SYS_ARCH=$(uname -m)

if [ "$SYS_ARCH" = "x86_64" ]; then
  export SYSTEMBIT="64"
else
  export SYSTEMBIT="32"
fi

############################# System OS Version #############################
# Macos or linux
# Make note that this script only works for Debian Linux kernals
#############################################################################
export SYS_OS=$(uname -s)

if [ "$SYS_OS" = "Darwin" ]; then
  export SYSTEMOS="MacOS"
elif [ "$SYS_OS" = "Linux" ]; then
  export SYSTEMOS="Linux"
fi

########## Centos Test #############
if [ "$SYSTEMOS" = "Linux" ]; then
   export YUM=$(command -v yum)
    if [ "$YUM" != "" ]; then
   echo " yum found"
   read -r -p "Your system is a CentOS based system which is not compatible with this script"
   exit ;
    fi

fi

############################### Intel or GNU Compiler Option #############


if [ "$SYSTEMBIT" = "32" ] && [ "$SYSTEMOS" = "Darwin" ]; then
  echo "Your system is not compatibile with this script."
  exit ;
fi

if [ "$SYSTEMBIT" = "64" ] && [ "$SYSTEMOS" = "Darwin" ]; then
  echo "Your system is a 64bit version of MacOS"
  echo " "
  echo "Intel compilers are not compatibile with this script"
  echo " "
  echo "Setting compiler to GNU"
  export macos_64bit_GNU=1
  echo " "
  echo "Xcode Command Line Tools & Homebrew are required for this script."
  echo " "
  echo "Installing Homebrew and Xcode Command Line Tools now"
  echo " "
  echo "Please enter password when prompted"
  chsh -s /bin/bash
  bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if [ "$SYSTEMBIT" = "64" ] && [ "$SYSTEMOS" = "Linux" ];
  then
    echo "Your system is 64bit version of Debian Linux Kernal"
    echo " "
  while read -r -p "Which compiler do you want to use?
  - Intel
  - GNU

  Please answer Intel or GNU (case sensative).
  " yn; do

    case $yn in
    Intel)
      echo "-------------------------------------------------- "
      echo " "
      echo "Intel is selected for installation"
      export Ubuntu_64bit_Intel=1
      break
      ;;
    GNU)
      echo "-------------------------------------------------- "
      echo " "
      echo "GNU is selected for installation"
      export Ubuntu_64bit_GNU=1
      break
      ;;
      * )
     echo " "
     echo "Please answer Intel or GNU (case sensative).";;

  esac
  done
fi

if [ "$SYSTEMBIT" = "32" ] && [ "$SYSTEMOS" = "Linux" ]; then
  echo "Your system is not compatibile with this script."
  exit ;
fi




##################################### WRFCHEM Tools ###############################################
# This script will install the WRFCHEM pre-processor tools.
# Information on these tools can be found here:
# https://www2.acom.ucar.edu/wrf-chem/wrf-chem-tools-community#download
#
# Addtional information on WRFCHEM can be found here:
# https://ruc.noaa.gov/wrf/wrf-chem/
#
# We ask users of the WRF-Chem preprocessor tools to include in any publications the following acknowledgement:
# "We acknowledge use of the WRF-Chem preprocessor tool {mozbc, fire_emiss, etc.} provided by the Atmospheric Chemistry Observations and Modeling Lab (ACOM) of NCAR."
#
#
# This script installs the WRFCHEM Tools with gnu or intel compilers.
####################################################################################################



if [ "$Ubuntu_64bit_GNU" = "1" ]; then


  # Basic Package Management for WRF-CHEM Tools and Processors

  sudo apt-get -y update
  sudo apt-get -y upgrade
  sudo apt -y install python3 python3-dev emacs flex bison libpixman-1-dev libjpeg-dev pkg-config libpng-dev unzip python2 python2-dev python3-pip pipenv gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git libncurses5 libncurses6 mlocate pkg-config build-essential curl libcurl4-openssl-dev byacc flex

  #Directory Listings
  export HOME=`cd;pwd`
  mkdir $HOME/WRFCHEM
  export WRFCHEM_FOLDER=$HOME/WRFCHEM
  cd $HOME/WRFCHEM
  mkdir Downloads
  mkdir Libs
  mkdir Libs/grib2
  mkdir Libs/NETCDF
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs/grib2
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs/NETCDF
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/mozbc
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_emiss
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_data
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/wes_coldens
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/ANTHRO_EMIS
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/EDGAR_HTAP
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/EPA_ANTHRO_EMIS
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/UBC
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Aircraft
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN



  ##############################Downloading Libraries############################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads

  wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz
  wget -c -4 https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_2.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz
  wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.39.tar.gz
  wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
  wget -c -4 https://github.com/pmodels/mpich/releases/download/v4.0.3/mpich-4.0.3.tar.gz

  #############################Core Management####################################
  export CPU_CORE=$(nproc)                                             # number of available thread -rs on system
  export CPU_6CORE="6"
  export CPU_HALF=$(($CPU_CORE / 2))                                   #half of availble cores on system
  export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))              #Forces CPU cores to even number to avoid partial core export. ie 7 cores would be 3.5 cores.

  if [ $CPU_CORE -le $CPU_6CORE ]                                  #If statement for low core systems.  Forces computers to only use 1 core if there are 4 cores or less on the system.
  then
    export CPU_HALF_EVEN="2"
  else
    export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))
  fi


  echo "##########################################"
  echo "Number of thread -rs being used $CPU_HALF_EVEN"
  echo "##########################################"
  echo " "

  #############################Compilers############################
  export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
  export CC=gcc
  export CXX=g++
  export FC=gfortran
  export F77=gfortran
  export CFLAGS="-fPIC -fPIE -O3"

  #IF statement for GNU compiler issue
  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
  then
    export fallow_argument=-fallow-argument-mismatch
    export boz_argument=-fallow-invalid-boz
  else
    export fallow_argument=
    export boz_argument=
  fi


  export FFLAGS="$fallow_argument -m64"
  export FCFLAGS="$fallow_argument -m64"


  echo "##########################################"
  echo "FFLAGS = $FFLAGS"
  echo "FCFLAGS = $FCFLAGS"
  echo "##########################################"


  #############################zlib############################
  #Uncalling compilers due to comfigure issue with zlib1.2.13
  #With CC & CXX definied ./configure uses different compiler Flags

  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/
  ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  ##############################MPICH############################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  tar -xvzf mpich-4.0.3.tar.gz
  cd mpich-4.0.3/
  F90= ./configure --prefix=$DIR/MPICH --with-device=ch3 FFLAGS="$fallow_argument -m64" FCFLAGS="$fallow_argument -m64"

  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install |& tee make.install.log
  #make check


  export PATH=$DIR/MPICH/bin:$PATH

  export MPIFC=$DIR/MPICH/bin/mpifort
  export MPIF77=$DIR/MPICH/bin/mpifort
  export MPIF90=$DIR/MPICH/bin/mpifort
  export MPICC=$DIR/MPICH/bin/mpicc
  export MPICXX=$DIR/MPICH/bin/mpicxx


  echo " "

  #############################libpng############################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  export LDFLAGS=-L$DIR/grib2/lib
  export CPPFLAGS=-I$DIR/grib2/include
  tar -xvzf libpng-1.6.39.tar.gz
  cd libpng-1.6.39/
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check


  #############################JasPer############################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  unzip jasper-1.900.1.zip
  cd jasper-1.900.1/
  autoreconf -i
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install

  export JASPERLIB=$DIR/grib2/lib
  export JASPERINC=$DIR/grib2/include


  #############################hdf5 library for netcdf4 functionality############################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  tar -xvzf hdf5-1_13_2.tar.gz
  cd hdf5-hdf5-1_13_2
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2  --enable-hl --enable-fortran --enable-parallel
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  export HDF5=$DIR/grib2
  export PHDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH

  echo " "



  #############################Install Parallel-netCDF##############################
  #Make file created with half of available cpu cores
  #Hard path for MPI added
  ##################################################################################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  wget -c -4  https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz
  tar -xvzf pnetcdf-1.12.3.tar.gz
  cd pnetcdf-1.12.3
  ./configure --prefix=$DIR/grib2  --enable-shared --enable-static

  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  export PNETCDF=$DIR/grib2



  ##############################Install NETCDF C Library############################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  tar -xzvf v4.9.0.tar.gz
  cd netcdf-c-4.9.0/
  export CPPFLAGS=-I$DIR/grib2/include
  export LDFLAGS=-L$DIR/grib2/lib
  export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lgfortran -lgcc -lm -ldl"
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/NETCDF --with-zlib=$DIR/grib2 --disable-dap --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-pnetcdf --enable-cdf5 --enable-parallel-tests
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  export PATH=$DIR/NETCDF/bin:$PATH
  export NETCDF=$DIR/NETCDF


  ##############################NetCDF fortran library############################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  tar -xvzf v4.6.0.tar.gz
  cd netcdf-fortran-4.6.0/
  export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
  export CPPFLAGS="-I$DIR/NETCDF/include -I$DIR/grib2/include"
  export LDFLAGS="-L$DIR/NETCDF/lib -L$DIR/grib2/lib"
  export LIBS="-lnetcdf -lpnetcdf -lcurl -lhdf5_hl -lhdf5 -lz -ldl -lgcc -lgfortran"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-parallel-tests --enable-hdf5
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install |& tee make.install.log
  #make check


  echo " "


  # Downloading WRF-CHEM Tools and untarring files
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads


  wget -c -4  https://www.acom.ucar.edu/wrf-chem/mozbc.tar
  wget -c -4  https://www.acom.ucar.edu/wrf-chem/UBC_inputs.tar
  wget -c -4  https://www.acom.ucar.edu//wrf-chem/megan_bio_emiss.tar
  wget -c -4  https://www.acom.ucar.edu/wrf-chem/megan.data.tar.gz
  wget -c -4  https://www.acom.ucar.edu/wrf-chem/wes-coldens.tar
  wget -c -4  https://www.acom.ucar.edu/wrf-chem/ANTHRO.tar
  wget -c -4  https://www.acom.ucar.edu/webt/wrf-chem/processors/EDGAR-HTAP.tgz
  wget -c -4  https://www.acom.ucar.edu/wrf-chem/EPA_ANTHRO_EMIS.tgz
  wget -c -4  https://www2.acom.ucar.edu/sites/default/files/documents/aircraft_preprocessor_files.tar
  # Downloading FINN
  wget -c -4  https://www.acom.ucar.edu/Data/fire/data/finn2/FINNv2.4_MOD_MOZART_2020_c20210617.txt.gz
  wget -c -4  https://www.acom.ucar.edu/Data/fire/data/finn2/FINNv2.4_MOD_MOZART_2013_c20210617.txt.gz
  wget -c -4  https://www.acom.ucar.edu/Data/fire/data/finn2/FINNv2.4_MODVRS_MOZART_2019_c20210615.txt.gz
  wget -c -4   https://www.acom.ucar.edu/Data/fire/data/fire_emis.tgz
  wget -c -4   https://www.acom.ucar.edu/Data/fire/data/fire_emis_input.tar
  wget -c -4  https://www.acom.ucar.edu/Data/fire/data/TrashEmis.zip



  echo ""
  echo "Unpacking Mozbc."
  tar -xvf mozbc.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/mozbc
  echo ""
  echo "Unpacking MEGAN Bio Emission."
  tar -xvf megan_bio_emiss.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_emiss
  echo ""
  echo "Unpacking MEGAN Bio Emission Data."
  tar -xzvf megan.data.tar.gz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_data
  echo ""
  echo "Unpacking Wes Coldens"
  tar -xvf wes-coldens.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/wes_coldens
  echo ""
  echo "Unpacking Unpacking ANTHRO Emission."
  tar -xvf ANTHRO.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/ANTHRO_EMIS
  echo ""
  echo "Unpacking EDGAR-HTAP."
  tar -xzvf EDGAR-HTAP.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/EDGAR_HTAP
  echo ""
  echo "Unpacking EPA ANTHRO Emission."
  tar -xzvf EPA_ANTHRO_EMIS.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/EPA_ANTHRO_EMIS
  echo ""
  echo "Unpacking Upper Boundary Conditions."
  tar -xvf UBC_inputs.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/UBC
  echo ""
  echo "Unpacking Aircraft Preprocessor Files."
  echo ""
  tar -xvf aircraft_preprocessor_files.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/Aircraft
  echo ""
  echo "Unpacking Fire INventory from NCAR (FINN)"
  tar -xzvf fire_emis.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN
  tar -xvf fire_emis_input.tar
  tar -zxvf grass_from_img.nc.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src
  tar -zxvf tempfor_from_img.nc.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src
  tar -zxvf shrub_from_img.nc.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src
  tar -zxvf tropfor_from_img.nc.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src

  mv $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads/FINNv2.4_MOD_MOZART_2020_c20210617.txt.gz $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN
  mv $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads/FINNv2.4_MOD_MOZART_2013_c20210617.txt.gz  $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN
  mv $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads/FINNv2.4_MODVRS_MOZART_2019_c20210615.txt.gz $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN

  unzip TrashEmis.zip
  mv $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads/ALL_Emiss_04282014.nc $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src

  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN

  gunzip  FINNv2.4_MOD_MOZART_2020_c20210617.txt.gz
  gunzip  FINNv2.4_MOD_MOZART_2013_c20210617.txt.gz
  gunzip  FINNv2.4_MODVRS_MOZART_2019_c20210615.txt.gz
  ############################Installation of Mozbc #############################
  # Recalling variables from install script to make sure the path is right

  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/mozbc
  chmod +x make_mozbc
  export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
  export FC=gfortran
  export NETCDF_DIR=$DIR/NETCDF
  sed -i 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_mozbc
  sed -i '8s/FFLAGS = --g/FFLAGS = --g ${fallow_argument}/' Makefile
  sed -i '10s/FFLAGS = -g/FFLAGS = -g ${fallow_argument}/' Makefile
  ./make_mozbc


  ################## Information on Upper Boundary Conditions ###################

  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/UBC/
  wget -c -4  https://www2.acom.ucar.edu/sites/default/files/documents/8A_2_Barth_WRFWorkshop_11.pdf


  ########################## MEGAN Bio Emission #################################
  # Data for MEGAN Bio Emission located in
  # $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_data

  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_emiss
  chmod +x make_util
  export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
  export FC=gfortran
  export NETCDF_DIR=$DIR/NETCDF
  sed -i 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_util
  sed -i '8s/FFLAGS = --g/FFLAGS = --g ${fallow_argument}/' Makefile
  sed -i '10s/FFLAGS = -g/FFLAGS = -g ${fallow_argument}/' Makefile
  ./make_util megan_bio_emiss
  ./make_util megan_xform
  ./make_util surfdata_xform


  ############################# Anthroprogenic Emissions #########################

  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/ANTHRO_EMIS/ANTHRO/src
  chmod +x make_anthro
  export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
  export FC=gfortran
  export NETCDF_DIR=$DIR/NETCDF
  sed -i 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_anthro
  sed -i '8s/FFLAGS = --g/FFLAGS = --g ${fallow_argument}/' Makefile
  sed -i '10s/FFLAGS = -g/FFLAGS = -g ${fallow_argument}/' Makefile
  ./make_anthro

  ############################# EDGAR HTAP ######################################
  #  This directory contains EDGAR-HTAP anthropogenic emission files for the
  #  year 2010.  The files are in the MOZCART and MOZART-MOSAIC sub-directories.
  #  The MOZCART files are intended to be used for the WRF MOZCART_KPP chemical
  #  option.  The MOZART-MOSAIC files are intended to be used with the following
  #  WRF chemical options (See read -rme in Folder

  ######################### EPA Anthroprogenic Emissions ########################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/EPA_ANTHRO_EMIS/src
  chmod +x make_anthro
  export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
  export FC=gfortran
  export NETCDF_DIR=$DIR/NETCDF
  sed -i 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_anthro
  sed -i '8s/FFLAGS = --g/FFLAGS = --g ${fallow_argument}/' Makefile
  sed -i '10s/FFLAGS = -g/FFLAGS = -g ${fallow_argument}/' Makefile
  ./make_anthro

  ######################### Weseley EXO Coldens ##################################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/wes_coldens
  chmod +x make_util
  export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
  export FC=gfortran
  export NETCDF_DIR=$DIR/NETCDF
  sed -i 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_util
  sed -i '8s/FFLAGS = --g/FFLAGS = --g ${fallow_argument}/' Makefile
  sed -i '10s/FFLAGS = -g/FFLAGS = -g ${fallow_argument}/' Makefile
  ./make_util wesely
  ./make_util exo_coldens


  ########################## Aircraft Emissions Preprocessor #####################
  # This is an IDL based preprocessor to create WRF-Chem read -ry aircraft emissions files
  # (wrfchemaircraft_) from a global inventory in netcdf format. Please consult the read -rME file
  # for how to use the preprocessor. The emissions inventory is not included, so the user must
  # provide their own.
  echo " "
  echo "######################################################################"
  echo " Please see script for details about Aircraft Emissions Preprocessor"
  echo "######################################################################"
  echo " "

  ######################## Fire INventory from NCAR (FINN) ###########################
  # Fire INventory from NCAR (FINN): A daily fire emissions product for atmospheric chemistry models
  # https://www2.acom.ucar.edu/modeling/finn-fire-inventory-ncar
  echo " "
  echo "###########################################"
  echo " Please see folder for details about FINN."
  echo "###########################################"
  echo " "



    ######################################### PREP-CHEM-SRC ##############################################
    # PREP-CHEM-SRC is a pollutant emissions numerical too developed at CPTEC/INPE
    # whose function is to create data of atmospheric pollutant emissions from biomass burning,
    # photosynthesis or other forest transformation processes, combustion of oil-based products
    # by vehicles or industry, charcoal production, and many other processes.
    # The system is maintained and developed at CPTEC/INPE by the GMAI group, which not
    # only updates versions of data such as EDGAR, RETRO, MEGAN, etc., but also
    # implements new functionalities such as volcanic emissions which is present now in this
    # version.
    # The purpose of this guide is to present how to install, compile and run the pre-processor.
    # Finally, the steps for utilizing the emissions data in the CCATT-BRAMS, WRF-Chem and
    # FIM-Chem models are presented.
    # We recommend that you read -r the article “PREP-CHEM-SRC – 1.0: a preprocessor of
    # trace gas and aerosol emission fields for regional and global atmospheric chemistry
    # models” (Freitas et al., 2010 - http://www.geosci-model-dev.net/4/419/2011/gmd-4-419-
    # 2011.pdf).
    # Email: mailto:atende.cptec@inpe.br
    # WEB: http://brams.cptec.inpe.br
    # http:// meioambiente.cptec.inpe.br
    # Prep-Chem-Src v1.5.0 (note v1.8.3 is in Beta still)
    #########################################################################################################



    # Downloading PREP-CHEM-SRC-1.5 and untarring files
      mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/PREP-CHEM-SRC-1.5

      cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads

      wget -4 -c http://ftp.cptec.inpe.br/pesquisa/bramsrd/BRAMS_5.4/PREP-CHEM/PREP-CHEM-SRC-1.5.tar.gz

      tar -xzvf PREP-CHEM-SRC-1.5.tar.gz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/PREP-CHEM-SRC-1.5

      cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/PREP-CHEM-SRC-1.5


    # Installation of PREP-CHEM-SRC-1.5

      cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/PREP-CHEM-SRC-1.5/bin/build

      sed -i '47s|/scratchin/grupos/catt-brams/shared/libs/gfortran/netcdf-4.1.3|${DIR}/NETCDF|' include.mk.gfortran.wrf  #Changing NETDCF Location
      sed -i '53s|/scratchin/grupos/catt-brams/shared/libs/gfortran/hdf5-1.8.13-serial|${DIR}/grib2|' include.mk.gfortran.wrf #Changing HDF5 Location
      sed -i '55s|-L/scratchin/grupos/catt-brams/shared/libs/gfortran/zlib-1.2.8/lib|-L${DIR}/grib2/lib|' include.mk.gfortran.wrf #Changing zlib Location
      sed -i '69s|-frecord-marker=4|-frecord-marker=4 ${fallow_argument}|' include.mk.gfortran.wrf #Changing adding fallow argument mismatch to fix dummy error

      make OPT=gfortran.wrf CHEM=RADM_WRF_FIM AER=SIMPLE  # Compiling and making of PRE-CHEM-SRC-1.5


    # IF statement to check that all files were created.
      cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/PREP-CHEM-SRC-1.5/bin
      n=$(ls ./*.exe | wc -l)
      if (($n >= 2))
        then
          echo "All expected files created."
          read -r -t 5 -p "Finished installing WRF-CHEM-PREP. I am going to wait for 5 seconds only ..."
        else
          echo "Missing one or more expected files. Exiting the script."
          read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
          exit
      fi
      echo " "




  #####################################BASH Script Finished##############################
  echo " "
  echo "WRF CHEM Tools & PREP_CHEM_SRC compiled with latest version of NETCDF files available on 01/01/2023"
  echo "If error occurs using WRFCHEM tools please update your NETCDF libraries or reconfigure with older libraries"
  echo "This is a WRC Chem Community tool made by a private user and is not supported by UCAR/NCAR"
  read -r -t 5 -p "BASH Script Finished"

fi

if [ "$Ubuntu_64bit_Intel" = "1" ]; then



  sudo apt -y update
  sudo apt -y upgrade

  # download the key to system keyring; this and the following echo command are
  # needed in order to install the Intel compilers
  wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
  | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null


  # add signed entry to apt sources and configure the APT client to use Intel repository:
  echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list

  # this update should get the Intel package info from the Intel repository
  sudo apt -y update


  # Basic Package Management for WRF-CHEM Tools and Processors

  sudo apt-get -y update
  sudo apt-get -y upgrade
  sudo apt -y install gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git build-essential unzip mlocate byacc flex git python3 python3-dev python2 python2-dev curl cmake libcurl4-openssl-dev pkg-config build-essential


  # install the Intel compilers
  sudo apt -y install intel-basekit intel-hpckit intel-aikit
  sudo apt -y update
  sudo apt -y upgrade

  # make sure some critical packages have been installed
  which cmake pkg-config make gcc g++

  # add the Intel compiler file paths to various environment variables
  source /opt/intel/oneapi/setvars.sh

  # some of the libraries we install below need one or more of these variables
  export CC=icc
  export CXX=icpc
  export FC=ifort
  export F77=ifort
  export F90=ifort
  export MPIFC=mpiifort
  export MPIF77=mpiifort
  export MPIF90=mpiifort
  export MPICC=mpiicc
  export MPICXX=mpiicpc
  export CFLAGS="-fPIC -fPIE -O3 -diag-disable=10441"



  #Directory Listings
  export HOME=`cd;pwd`
  mkdir $HOME/WRFCHEM_Intel
  export WRFCHEM_FOLDER=$HOME/WRFCHEM_Intel
  cd $HOME/WRFCHEM_Intel
  mkdir Downloads
  mkdir Libs
  mkdir Libs/grib2
  mkdir Libs/NETCDF
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs/grib2
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs/NETCDF
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/mozbc
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_emiss
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_data
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/wes_coldens
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/ANTHRO_EMIS
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/EDGAR_HTAP
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/EPA_ANTHRO_EMIS
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/UBC
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Aircraft
  mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN

  export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs


  ##############################Downloading Libraries############################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads

  wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz
  wget -c -4 https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_2.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz
  wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.39.tar.gz
  wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip

  #############################Core Management####################################
  export CPU_CORE=$(nproc)                                             #number of available thread -rs on system
  export CPU_6CORE="6"
  export CPU_HALF=$(($CPU_CORE / 2))                                   #half of availble cores on system
  export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))              #Forces CPU cores to even number to avoid partial core export. ie 7 cores would be 3.5 cores.

  if [ $CPU_CORE -le $CPU_6CORE ]                                  #If statement for low core systems.  Forces computers to only use 1 core if there are 4 cores or less on the system.
  then
    export CPU_HALF_EVEN="2"
  else
    export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))
  fi


  echo "##########################################"
  echo "Number of thread -rs being used $CPU_HALF_EVEN"
  echo "##########################################"
  echo " "

  #############################Compilers############################


  #############################zlib############################
  #Uncalling compilers due to comfigure issue with zlib1.2.13
  #With CC & CXX definied ./configure uses different compiler Flags

  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/
  ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  #############################libpng############################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  export LDFLAGS=-L$DIR/grib2/lib
  export CPPFLAGS=-I$DIR/grib2/include
  tar -xvzf libpng-1.6.39.tar.gz
  cd libpng-1.6.39/
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check


  #############################JasPer############################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  unzip jasper-1.900.1.zip
  cd jasper-1.900.1/
  autoreconf -i
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install

  export JASPERLIB=$DIR/grib2/lib
  export JASPERINC=$DIR/grib2/include


  #############################hdf5 library for netcdf4 functionality############################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  tar -xvzf hdf5-1_13_2.tar.gz
  cd hdf5-hdf5-1_13_2
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2  --enable-hl --enable-fortran --enable-parallel
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  export HDF5=$DIR/grib2
  export PHDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH

  echo " "



  #############################Install Parallel-netCDF##############################
  #Make file created with half of available cpu cores
  #Hard path for MPI added
  ##################################################################################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  wget -c -4  https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz
  tar -xvzf pnetcdf-1.12.3.tar.gz
  cd pnetcdf-1.12.3
  ./configure --prefix=$DIR/grib2  --enable-shared --enable-static

  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  export PNETCDF=$DIR/grib2



  ##############################Install NETCDF C Library############################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  tar -xzvf v4.9.0.tar.gz
  cd netcdf-c-4.9.0/
  export CPPFLAGS=-I$DIR/grib2/include
  export LDFLAGS=-L$DIR/grib2/lib
  export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lgfortran -lgcc -lm -ldl"
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/NETCDF --with-zlib=$DIR/grib2 --disable-dap --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-pnetcdf --enable-cdf5 --enable-parallel-tests
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  export PATH=$DIR/NETCDF/bin:$PATH
  export NETCDF=$DIR/NETCDF


  ##############################NetCDF fortran library############################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
  tar -xvzf v4.6.0.tar.gz
  cd netcdf-fortran-4.6.0/
  export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
  export CPPFLAGS="-I$DIR/NETCDF/include -I$DIR/grib2/include"
  export LDFLAGS="-L$DIR/NETCDF/lib -L$DIR/grib2/lib"
  export LIBS="-lnetcdf -lpnetcdf -lcurl -lhdf5_hl -lhdf5 -lz -ldl -lgcc -lgfortran"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-parallel-tests --enable-hdf5
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install |& tee make.install.log
  #make check


  echo " "





  # Downloading WRF-CHEM Tools and untarring files
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads


  wget -c -4 https://www.acom.ucar.edu/wrf-chem/mozbc.tar
  wget -c -4 https://www.acom.ucar.edu/wrf-chem/UBC_inputs.tar
  wget -c -4 https://www.acom.ucar.edu//wrf-chem/megan_bio_emiss.tar
  wget -c -4 https://www.acom.ucar.edu/wrf-chem/megan.data.tar.gz
  wget -c -4 https://www.acom.ucar.edu/wrf-chem/wes-coldens.tar
  wget -c -4 https://www.acom.ucar.edu/wrf-chem/ANTHRO.tar
  wget -c -4 https://www.acom.ucar.edu/webt/wrf-chem/processors/EDGAR-HTAP.tgz
  wget -c -4 https://www.acom.ucar.edu/wrf-chem/EPA_ANTHRO_EMIS.tgz
  wget -c -4 https://www2.acom.ucar.edu/sites/default/files/documents/aircraft_preprocessor_files.tar
  # Downloading FINN
  wget -c -4 https://www.acom.ucar.edu/Data/fire/data/finn2/FINNv2.4_MOD_MOZART_2020_c20210617.txt.gz
  wget -c -4 https://www.acom.ucar.edu/Data/fire/data/finn2/FINNv2.4_MOD_MOZART_2013_c20210617.txt.gz
  wget -c -4 https://www.acom.ucar.edu/Data/fire/data/finn2/FINNv2.4_MODVRS_MOZART_2019_c20210615.txt.gz
  wget -c -4 https://www.acom.ucar.edu/Data/fire/data/fire_emis.tgz
  wget -c -4 https://www.acom.ucar.edu/Data/fire/data/fire_emis_input.tar
  wget -c -4 https://www.acom.ucar.edu/Data/fire/data/TrashEmis.zip



  echo ""
  echo "Unpacking Mozbc."
  tar -xvf mozbc.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/mozbc
  echo ""
  echo "Unpacking MEGAN Bio Emission."
  tar -xvf megan_bio_emiss.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_emiss
  echo ""
  echo "Unpacking MEGAN Bio Emission Data."
  tar -xzvf megan.data.tar.gz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_data
  echo ""
  echo "Unpacking Wes Coldens"
  tar -xvf wes-coldens.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/wes_coldens
  echo ""
  echo "Unpacking Unpacking ANTHRO Emission."
  tar -xvf ANTHRO.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/ANTHRO_EMIS
  echo ""
  echo "Unpacking EDGAR-HTAP."
  tar -xzvf EDGAR-HTAP.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/EDGAR_HTAP
  echo ""
  echo "Unpacking EPA ANTHRO Emission."
  tar -xzvf EPA_ANTHRO_EMIS.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/EPA_ANTHRO_EMIS
  echo ""
  echo "Unpacking Upper Boundary Conditions."
  tar -xvf UBC_inputs.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/UBC
  echo ""
  echo "Unpacking Aircraft Preprocessor Files."
  echo ""
  tar -xvf aircraft_preprocessor_files.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/Aircraft
  echo ""
  echo "Unpacking Fire INventory from NCAR (FINN)"
  tar -xzvf fire_emis.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN
  tar -xvf fire_emis_input.tar
  tar -zxvf grass_from_img.nc.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src
  tar -zxvf tempfor_from_img.nc.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src
  tar -zxvf shrub_from_img.nc.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src
  tar -zxvf tropfor_from_img.nc.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src

  mv $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads/FINNv2.4_MOD_MOZART_2020_c20210617.txt.gz $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN
  mv $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads/FINNv2.4_MOD_MOZART_2013_c20210617.txt.gz  $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN
  mv $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads/FINNv2.4_MODVRS_MOZART_2019_c20210615.txt.gz $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN

  unzip TrashEmis.zip
  mv $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads/ALL_Emiss_04282014.nc $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src

  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN

  gunzip  FINNv2.4_MOD_MOZART_2020_c20210617.txt.gz
  gunzip  FINNv2.4_MOD_MOZART_2013_c20210617.txt.gz
  gunzip  FINNv2.4_MODVRS_MOZART_2019_c20210615.txt.gz
  ############################Installation of Mozbc #############################
  # Recalling variables from install script to make sure the path is right

  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/mozbc
  chmod +x make_mozbc
  export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
  export NETCDF_DIR=$DIR/NETCDF
  sed -i 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_mozbc

  ./make_mozbc


  ################## Information on Upper Boundary Conditions ###################

  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/UBC/
  wget -c -4 https://www2.acom.ucar.edu/sites/default/files/documents/8A_2_Barth_WRFWorkshop_11.pdf


  ########################## MEGAN Bio Emission #################################
  # Data for MEGAN Bio Emission located in
  # $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_data

  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_emiss
  chmod +x make_util
  export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs

  export NETCDF_DIR=$DIR/NETCDF
  sed -i 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_util

  ./make_util megan_bio_emiss
  ./make_util megan_xform
  ./make_util surfdata_xform


  ############################# Anthroprogenic Emissions #########################

  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/ANTHRO_EMIS/ANTHRO/src
  chmod +x make_anthro
  export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs

  export NETCDF_DIR=$DIR/NETCDF
  sed -i 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_anthro

  ./make_anthro

  ############################# EDGAR HTAP ######################################
  #  This directory contains EDGAR-HTAP anthropogenic emission files for the
  #  year 2010.  The files are in the MOZCART and MOZART-MOSAIC sub-directories.
  #  The MOZCART files are intended to be used for the WRF MOZCART_KPP chemical
  #  option.  The MOZART-MOSAIC files are intended to be used with the following
  #  WRF chemical options (See read -rme in Folder

  ######################### EPA Anthroprogenic Emissions ########################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/EPA_ANTHRO_EMIS/src
  chmod +x make_anthro
  export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs

  export NETCDF_DIR=$DIR/NETCDF
  sed -i 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_anthro

  ./make_anthro

  ######################### Weseley EXO Coldens ##################################
  cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/wes_coldens
  chmod +x make_util
  export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs

  export NETCDF_DIR=$DIR/NETCDF
  sed -i 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_util

  ./make_util wesely
  ./make_util exo_coldens


  ########################## Aircraft Emissions Preprocessor #####################
  # This is an IDL based preprocessor to create WRF-Chem read -ry aircraft emissions files
  # (wrfchemaircraft_) from a global inventory in netcdf format. Please consult the read -rME file
  # for how to use the preprocessor. The emissions inventory is not included, so the user must
  # provide their own.
  echo " "
  echo "######################################################################"
  echo " Please see script for details about Aircraft Emissions Preprocessor"
  echo "######################################################################"
  echo " "

  ######################## Fire INventory from NCAR (FINN) ###########################
  # Fire INventory from NCAR (FINN): A daily fire emissions product for atmospheric chemistry models
  # https://www2.acom.ucar.edu/modeling/finn-fire-inventory-ncar
  echo " "
  echo "###########################################"
  echo " Please see folder for details about FINN."
  echo "###########################################"
  echo " "

  ######################################### PREP-CHEM-SRC ##############################################
  # PREP-CHEM-SRC is a pollutant emissions numerical too developed at CPTEC/INPE
  # whose function is to create data of atmospheric pollutant emissions from biomass burning,
  # photosynthesis or other forest transformation processes, combustion of oil-based products
  # by vehicles or industry, charcoal production, and many other processes.
  # The system is maintained and developed at CPTEC/INPE by the GMAI group, which not
  # only updates versions of data such as EDGAR, RETRO, MEGAN, etc., but also
  # implements new functionalities such as volcanic emissions which is present now in this
  # version.
  # The purpose of this guide is to present how to install, compile and run the pre-processor.
  # Finally, the steps for utilizing the emissions data in the CCATT-BRAMS, WRF-Chem and
  # FIM-Chem models are presented.
  # We recommend that you read -r the article “PREP-CHEM-SRC – 1.0: a preprocessor of
  # trace gas and aerosol emission fields for regional and global atmospheric chemistry
  # models” (Freitas et al., 2010 - http://www.geosci-model-dev.net/4/419/2011/gmd-4-419-
  # 2011.pdf).
  # Email: mailto:atende.cptec@inpe.br
  # WEB: http://brams.cptec.inpe.br
  # http:// meioambiente.cptec.inpe.br
  # Prep-Chem-Src v1.5.0 (note v1.8.3 is in Beta still)
  #########################################################################################################



    # Downloading PREP-CHEM-SRC-1.5 and untarring files
    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/PREP-CHEM-SRC-1.5
    wget -4 -c http://ftp.cptec.inpe.br/pesquisa/bramsrd/BRAMS_5.4/PREP-CHEM/PREP-CHEM-SRC-1.5.tar.gz

    tar -xzvf PREP-CHEM-SRC-1.5.tar.gz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/PREP-CHEM-SRC-1.5

    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/PREP-CHEM-SRC-1.5


    # Installation of PREP-CHEM-SRC-1.5

    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/PREP-CHEM-SRC-1.5/bin/build

    sed -i '48s|/scratchin/grupos/catt-brams/shared/libs/intel/netcdf-4.1.3|${DIR}/NETCDF|' include.mk.intel.wrf  #Changing NETDCF Location
    sed -i '56s|/scratchin/grupos/catt-brams/shared/libs/intel/hdf5-1.8.13-serial|${DIR}/grib2|' include.mk.intel.wrf #Changing HDF5 Location
    sed -i '58s|-L/scratchin/grupos/catt-brams/shared/libs/zlib-1.2.8/lib|-L${DIR}/grib2/lib|' include.mk.intel.wrf #Changing zlib Location
    sed -i '71s|-convert big_endian|-convert big_endian -diag-disable 6405  |' include.mk.intel.wrf

    make OPT=intel.wrf CHEM=RADM_WRF_FIM AER=SIMPLE |& tee make.log  # Compiling and making of PRE-CHEM-SRC-1.5


    # IF statement to check that all files were created.
    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/PREP-CHEM-SRC-1.5/bin
    n=$(ls ./*.exe | wc -l)
    if (($n >= 2))
     then
     echo "All expected files created."
     read -r -t 5 -p "Finished installing WRF-CHEM-PREP. I am going to wait for 5 seconds only ..."
    else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
    fi
    echo " "




  #####################################BASH Script Finished##############################
  echo " "
  echo "WRF CHEM Tools & PREP-CHEM-SRC compiled with latest version of NETCDF files available on 01/01/2023"
  echo "If error occurs using WRFCHEM tools please update your NETCDF libraries or reconfigure with older libraries"
  echo "This is a WRC Chem Community tool made by a private user and is not supported by UCAR/NCAR"
  read -r -t 5 -p "BASH Script Finished"



fi

if [ "$macos_64bit_GNU" = "1" ]; then




    #############################basic package managment############################
    brew install wget git
    brew install gcc libtool automake autoconf make m4 java ksh  mpich grads ksh tcsh
    brew install snap
    brew install python@3.9
    brew install gcc libtool automake autoconf make m4 java ksh git wget mpich grads ksh tcsh python@3.9 cmake xorgproto xorgrgb xauth curl flex byacc bison gnu-sed


    ##############################Directory Listing############################

    export HOME=`cd;pwd`
    mkdir $HOME/WRFCHEM
    export WRFCHEM_FOLDER=$HOME/WRFCHEM
    cd $WRFCHEM_FOLDER/
    mkdir Downloads
    mkdir WRFPLUS
    mkdir WRFDA
    mkdir Libs
    mkdir -p Libs/grib2
    mkdir -p Libs/NETCDF
    mkdir -p Tests/Environment
    mkdir -p Tests/Compatibility
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs/grib2
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs/NETCDF
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/mozbc
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_emiss
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_data
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/wes_coldens
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/ANTHRO_EMIS
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/EDGAR_HTAP
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/EPA_ANTHRO_EMIS
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/UBC
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/Aircraft
    mkdir $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN

    export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs

    ##############################Downloading Libraries############################

    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
    wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz
    wget -c -4 https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_2.tar.gz
    wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz
    wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz
    wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.39.tar.gz
    wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip



    echo " "

    #############################Compilers############################


    #Symlink to avoid clang conflicts with compilers
    #default gcc path /usr/bin/gcc
    #default homebrew path /usr/local/bin

    sudo ln -sf /usr/local/bin/gcc-1* /usr/local/bin/gcc
    sudo ln -sf /usr/local/bin/g++-1* /usr/local/bin/g++
    sudo ln -sf /usr/local/bin/gfortran-1* /usr/local/bin/gfortran

    export CC=gcc
    export CXX=g++
    export FC=gfortran
    export F77=gfortran
    export CFLAGS="-fPIC -fPIE -O3 -Wno-implicit-function-declaration -Wall"

    echo " "

    #############################zlib############################
    #Uncalling compilers due to comfigure issue with zlib1.2.12
    #With CC & CXX definied ./configure uses different compiler Flags

    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
    tar -xvzf v1.2.13.tar.gz
    cd zlib-1.2.13/
    ./configure --prefix=$DIR/grib2
    make
    make install
    #make check

    echo " "
    #############################libpng############################
    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
    export LDFLAGS=-L$DIR/grib2/lib
    export CPPFLAGS=-I$DIR/grib2/include
    tar -xvzf libpng-1.6.39.tar.gz
    cd libpng-1.6.39/
    ./configure --prefix=$DIR/grib2
    make
    make install
    #make check

    echo " "
    #############################JasPer############################

    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
    unzip jasper-1.900.1.zip
    cd jasper-1.900.1/
    autoreconf -i
    ./configure --prefix=$DIR/grib2
    make
    make install
    export JASPERLIB=$DIR/grib2/lib
    export JASPERINC=$DIR/grib2/include

    echo " "
    #############################hdf5 library for netcdf4 functionality############################

    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
    tar -xvzf hdf5-1_13_2.tar.gz
    cd hdf5-hdf5-1_13_2
    ./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran
    make
    make install
    #make check

    export HDF5=$DIR/grib2
    export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH

    echo " "
    ##############################Install NETCDF C Library############################
    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
    tar -xzvf v4.9.0.tar.gz
    cd netcdf-c-4.9.0/
    export CPPFLAGS=-I$DIR/grib2/include
    export LDFLAGS=-L$DIR/grib2/lib
    export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lgfortran -lgcc -lm -ldl"
    ./configure --prefix=$DIR/NETCDF --with-zlib=$DIR/grib2 --disable-dap --enable-netcdf-4 --enable-netcdf4 --enable-shared
    make
    make install
    #make check

    export PATH=$DIR/NETCDF/bin:$PATH
    export NETCDF=$DIR/NETCDF

    echo " "
    ##############################NetCDF fortran library############################

    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads
    tar -xvzf v4.6.0.tar.gz
    cd netcdf-fortran-4.6.0/
    export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
    export CPPFLAGS="-I$DIR/NETCDF/include -I$DIR/grib2/include"
    export LDFLAGS="-L$DIR/NETCDF/lib -L$DIR/grib2/lib"
    export LIBS="-lnetcdf -lm -lcurl -lhdf5_hl -lhdf5 -lz -ldl -lgcc -lgfortran -lm"
    ./configure --prefix=$DIR/NETCDF --disable-shared
    make
    make install
    #make check


    #################################### System Environment Tests ##############
    mkdir -p $WRFCHEM_FOLDER/Tests/Environment
    mkdir -p $WRFCHEM_FOLDER/Tests/Compatibility


    cd $WRFCHEM_FOLDER/Downloads
    wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
    wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar


    tar -xvf Fortran_C_tests.tar -C $WRFCHEM_FOLDER/Tests/Environment
    tar -xvf Fortran_C_NETCDF_MPI_tests.tar -C $WRFCHEM_FOLDER/Tests/Compatibility
    export one="1"
    echo " "
    ############## Testing Environment #####

    cd $WRFCHEM_FOLDER/Tests/Environment

    echo " "
    echo " "
    echo "Environment Testing "
    echo "Test 1"
    gfortran TEST_1_fortran_only_fixed.f
    ./a.out | tee env_test1.txt
    export TEST_PASS=$(grep -w -o -c "SUCCESS" env_test1.txt | awk  '{print$1}')
    if [ $TEST_PASS -ge 1 ]
      then
        echo "Enviroment Test 1 Passed"
      else
        echo "Environment Compiler Test 1 Failed"
        exit
    fi
    read -r -t 3 -p "I am going to wait for 3 seconds only ..."

    echo " "
    echo "Test 2"
    gfortran TEST_2_fortran_only_free.f90
    ./a.out | tee env_test2.txt
    export TEST_PASS=$(grep -w -o -c "SUCCESS" env_test2.txt | awk  '{print$1}')
    if [ $TEST_PASS -ge 1 ]
      then
        echo "Enviroment Test 2 Passed"
      else
        echo "Environment Compiler Test 2 Failed"
        exit
    fi
    echo " "
    read -r -t 3 -p "I am going to wait for 3 seconds only ..."

    echo " "
    echo "Test 3"
    gcc TEST_3_c_only.c
    ./a.out | tee env_test3.txt
    export TEST_PASS=$(grep -w -o -c "SUCCESS" env_test3.txt | awk  '{print$1}')
    if [ $TEST_PASS -ge 1 ]
      then
        echo "Enviroment Test 3 Passed"
      else
        echo "Environment Compiler Test 3 Failed"
        exit
    fi
    echo " "
    read -r -t 3 -p "I am going to wait for 3 seconds only ..."

    echo " "
    echo "Test 4"
    gcc -c -m64 TEST_4_fortran+c_c.c
    gfortran -c -m64 TEST_4_fortran+c_f.f90
    gfortran -m64 TEST_4_fortran+c_f.o TEST_4_fortran+c_c.o
    ./a.out | tee env_test4.txt
    export TEST_PASS=$(grep -w -o -c "SUCCESS" env_test4.txt | awk  '{print$1}')
    if [ $TEST_PASS -ge 1 ]
      then
        echo "Enviroment Test 4 Passed"
      else
        echo "Environment Compiler Test 4 Failed"
        exit
    fi
    echo " "
    read -r -t 3 -p "I am going to wait for 3 seconds only ..."

    echo " "
    ############## Testing Environment #####

    cd $WRFCHEM_FOLDER/Tests/Compatibility

    cp ${NETCDF}/include/netcdf.inc .

    echo " "
    echo " "
    echo "Library Compatibility Tests "
    echo "Test 1"
    gfortran -c 01_fortran+c+netcdf_f.f
    gcc -c 01_fortran+c+netcdf_c.c
    gfortran 01_fortran+c+netcdf_f.o 01_fortran+c+netcdf_c.o \
       -L${NETCDF}/lib -lnetcdff -lnetcdf

       ./a.out | tee comp_test1.txt
       export TEST_PASS=$(grep -w -o -c "SUCCESS" comp_test1.txt | awk  '{print$1}')
        if [ $TEST_PASS -ge 1 ]
           then
             echo "Compatibility Test 1 Passed"
           else
             echo "Compatibility Compiler Test 1 Failed"
             exit
         fi
       echo " "
       read -r -t 3 -p "I am going to wait for 3 seconds only ..."

    echo " "

    echo "Test 2"
    mpifort -c 02_fortran+c+netcdf+mpi_f.f
    mpicc -c 02_fortran+c+netcdf+mpi_c.c
    mpifort 02_fortran+c+netcdf+mpi_f.o \
    02_fortran+c+netcdf+mpi_c.o \
       -L${NETCDF}/lib -lnetcdff -lnetcdf

    mpirun ./a.out | tee comp_test2.txt
    export TEST_PASS=$(grep -w -o -c "SUCCESS" comp_test2.txt | awk  '{print$1}')
    if [ $TEST_PASS -ge 1 ]
      then
        echo "Compatibility Test 2 Passed"
      else
        echo "Compatibility Compiler Test 2 Failed"
        exit
    fi
    echo " "
    read -r -t 3 -p "I am going to wait for 3 seconds only ..."
    echo " "

    echo " All tests completed and passed"
    echo " "



      # Downloading WRF-CHEM Tools and untarring files
    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads


    wget -c -4 https://www.acom.ucar.edu/wrf-chem/mozbc.tar
    wget -c -4 https://www.acom.ucar.edu/wrf-chem/UBC_inputs.tar
    wget -c -4 https://www.acom.ucar.edu//wrf-chem/megan_bio_emiss.tar
    wget -c -4 https://www.acom.ucar.edu/wrf-chem/megan.data.tar.gz
    wget -c -4 https://www.acom.ucar.edu/wrf-chem/wes-coldens.tar
    wget -c -4 https://www.acom.ucar.edu/wrf-chem/ANTHRO.tar
    wget -c -4 https://www.acom.ucar.edu/webt/wrf-chem/processors/EDGAR-HTAP.tgz
    wget -c -4 https://www.acom.ucar.edu/wrf-chem/EPA_ANTHRO_EMIS.tgz
    wget -c -4 https://www2.acom.ucar.edu/sites/default/files/documents/aircraft_preprocessor_files.tar
    # Downloading FINN
    wget -c -4 https://www.acom.ucar.edu/Data/fire/data/finn2/FINNv2.4_MOD_MOZART_2020_c20210617.txt.gz
    wget -c -4 https://www.acom.ucar.edu/Data/fire/data/finn2/FINNv2.4_MOD_MOZART_2013_c20210617.txt.gz
    wget -c -4 https://www.acom.ucar.edu/Data/fire/data/finn2/FINNv2.4_MODVRS_MOZART_2019_c20210615.txt.gz
    wget -c -4 https://www.acom.ucar.edu/Data/fire/data/fire_emis.tgz
    wget -c -4 https://www.acom.ucar.edu/Data/fire/data/fire_emis_input.tar
    wget -c -4 https://www.acom.ucar.edu/Data/fire/data/TrashEmis.zip



    echo ""
    echo "Unpacking Mozbc."
    tar -xvf mozbc.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/mozbc
    echo ""
    echo "Unpacking MEGAN Bio Emission."
    tar -xvf megan_bio_emiss.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_emiss
    echo ""
    echo "Unpacking MEGAN Bio Emission Data."
    tar -xzvf megan.data.tar.gz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_data
    echo ""
    echo "Unpacking Wes Coldens"
    tar -xvf wes-coldens.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/wes_coldens
    echo ""
    echo "Unpacking Unpacking ANTHRO Emission."
    tar -xvf ANTHRO.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/ANTHRO_EMIS
    echo ""
    echo "Unpacking EDGAR-HTAP."
    tar -xzvf EDGAR-HTAP.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/EDGAR_HTAP
    echo ""
    echo "Unpacking EPA ANTHRO Emission."
    tar -xzvf EPA_ANTHRO_EMIS.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/EPA_ANTHRO_EMIS
    echo ""
    echo "Unpacking Upper Boundary Conditions."
    tar -xvf UBC_inputs.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/UBC
    echo ""
    echo "Unpacking Aircraft Preprocessor Files."
    echo ""
    tar -xvf aircraft_preprocessor_files.tar -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/Aircraft
    echo ""
    echo "Unpacking Fire INventory from NCAR (FINN)"
    tar -xzvf fire_emis.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN
    tar -xvf fire_emis_input.tar
    tar -zxvf grass_from_img.nc.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src
    tar -zxvf tempfor_from_img.nc.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src
    tar -zxvf shrub_from_img.nc.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src
    tar -zxvf tropfor_from_img.nc.tgz -C $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src

    mv $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads/FINNv2.4_MOD_MOZART_2020_c20210617.txt.gz $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN
    mv $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads/FINNv2.4_MOD_MOZART_2013_c20210617.txt.gz  $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN
    mv $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads/FINNv2.4_MODVRS_MOZART_2019_c20210615.txt.gz $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN

    unzip TrashEmis.zip
    mv $WRFCHEM_FOLDER/WRF_CHEM_Tools/Downloads/ALL_Emiss_04282014.nc $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN/grid_finn_fire_emis_v2020/src

    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/FINN

    gunzip  FINNv2.4_MOD_MOZART_2020_c20210617.txt.gz
    gunzip  FINNv2.4_MOD_MOZART_2013_c20210617.txt.gz
    gunzip  FINNv2.4_MODVRS_MOZART_2019_c20210615.txt.gz
    ############################Installation of Mozbc #############################
    export fallow_argument=-fallow-argument-mismatch
    export boz_argument=-fallow-invalid-boz


    # Recalling variables from install script to make sure the path is right

    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/mozbc
    chmod +x make_mozbc
    export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
    export FC=gfortran
    export NETCDF_DIR=$DIR/NETCDF
    sed -i'' -e 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_mozbc
    sed -i'' -e '8s/FFLAGS = --g/FFLAGS = --g ${fallow_argument}/' Makefile
    sed -i'' -e '10s/FFLAGS = -g/FFLAGS = -g ${fallow_argument}/' Makefile
    ./make_mozbc


    ################## Information on Upper Boundary Conditions ###################

    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/UBC/
    wget -c -4  https://www2.acom.ucar.edu/sites/default/files/documents/8A_2_Barth_WRFWorkshop_11.pdf


    ########################## MEGAN Bio Emission #################################
    # Data for MEGAN Bio Emission located in
    # $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_data

    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/megan_bio_emiss
    chmod +x make_util
    export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
    export FC=gfortran
    export NETCDF_DIR=$DIR/NETCDF
    sed -i'' -e 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_util
    sed -i'' -e '8s/FFLAGS = --g/FFLAGS = --g ${fallow_argument}/' Makefile
    sed -i'' -e '10s/FFLAGS = -g/FFLAGS = -g ${fallow_argument}/' Makefile
    ./make_util megan_bio_emiss
    ./make_util megan_xform
    ./make_util surfdata_xform


    ############################# Anthroprogenic Emissions #########################

    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/ANTHRO_EMIS/ANTHRO/src
    chmod +x make_anthro
    export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
    export FC=gfortran
    export NETCDF_DIR=$DIR/NETCDF
    sed -i'' -e 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_anthro
    sed -i'' -e '8s/FFLAGS = --g/FFLAGS = --g ${fallow_argument}/' Makefile
    sed -i'' -e '10s/FFLAGS = -g/FFLAGS = -g ${fallow_argument}/' Makefile
    ./make_anthro

    ############################# EDGAR HTAP ######################################
    #  This directory contains EDGAR-HTAP anthropogenic emission files for the
    #  year 2010.  The files are in the MOZCART and MOZART-MOSAIC sub-directories.
    #  The MOZCART files are intended to be used for the WRF MOZCART_KPP chemical
    #  option.  The MOZART-MOSAIC files are intended to be used with the following
    #  WRF chemical options (See read -rme in Folder

    ######################### EPA Anthroprogenic Emissions ########################
    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/EPA_ANTHRO_EMIS/src
    chmod +x make_anthro
    export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
    export FC=gfortran
    export NETCDF_DIR=$DIR/NETCDF
    sed -i'' -e 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_anthro
    sed -i'' -e '8s/FFLAGS = --g/FFLAGS = --g ${fallow_argument}/' Makefile
    sed -i'' -e '10s/FFLAGS = -g/FFLAGS = -g ${fallow_argument}/' Makefile
    ./make_anthro

    ######################### Weseley EXO Coldens ##################################
    cd $WRFCHEM_FOLDER/WRF_CHEM_Tools/wes_coldens
    chmod +x make_util
    export DIR=$WRFCHEM_FOLDER/WRF_CHEM_Tools/Libs
    export FC=gfortran
    export NETCDF_DIR=$DIR/NETCDF
    sed -i'' -e 's/"${ar_libs} -lnetcdff"/"-lnetcdff ${ar_libs}"/' make_util
    sed -i'' -e '8s/FFLAGS = --g/FFLAGS = --g ${fallow_argument}/' Makefile
    sed -i'' -e '10s/FFLAGS = -g/FFLAGS = -g ${fallow_argument}/' Makefile
    ./make_util wesely
    ./make_util exo_coldens


    ########################## Aircraft Emissions Preprocessor #####################
    # This is an IDL based preprocessor to create WRF-Chem read -ry aircraft emissions files
    # (wrfchemaircraft_) from a global inventory in netcdf format. Please consult the read -rME file
    # for how to use the preprocessor. The emissions inventory is not included, so the user must
    # provide their own.
    echo " "
    echo "######################################################################"
    echo " Please see script for details about Aircraft Emissions Preprocessor"
    echo "######################################################################"
    echo " "

    ######################## Fire INventory from NCAR (FINN) ###########################
    # Fire INventory from NCAR (FINN): A daily fire emissions product for atmospheric chemistry models
    # https://www2.acom.ucar.edu/modeling/finn-fire-inventory-ncar
    echo " "
    echo "###########################################"
    echo " Please see folder for details about FINN."
    echo "###########################################"
    echo " "
    #####################################BASH Script Finished##############################
    echo " "
    echo "WRF CHEM Tools compiled with latest version of NETCDF files available on 01/01/2023"
    echo "If error occurs using WRFCHEM tools please update your NETCDF libraries or reconfigure with older libraries"
    echo "This is a WRC Chem Community tool made by a private user and is not supported by UCAR/NCAR"
    echo "BASH Script Finished"



fi

#####################################BASH Script Finished##############################



end=`date`
END=$(date +"%s")
DIFF=$(($END-$START))
echo "Install Start Time: ${start}"
echo "Install End Time: ${end}"
echo "Install Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
