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


if [ "$SYSTEMBIT" = "32" ] && [ "$SYSTEMOS" = "MacOS" ]; then
  echo "Your system is not compatibile with this script."
  exit ;
fi

if [ "$SYSTEMBIT" = "64" ] && [ "$SYSTEMOS" = "MacOS" ]; then
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
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if [ "$SYSTEMBIT" = "64" ] && [ "$SYSTEMOS" = "Linux" ];
  then
    echo "Your system is 64bit version of Debian Linux Kernal"
    echo " "
  while read -r -p "Which compiler do you want to use?
  -Intel
   --Please note that Hurricane WRF (HWRF) is on compatibile with Intel Compilers.

  -GNU

  Please answer Intel or GNU and press enter (case sensative).
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

################### System Information Tests ##############################

if [ "$SYSTEMOS" = "Linux" ]; then

  export HOME=`cd;pwd`
  export Storage_Space_Size=$(df -h --output=avail ${HOME} | awk 'NR==2 {print $1}' | tr -cd '[:digit:]')
  export Storage_Space_Units=$(df -h --output=avail ${HOME} | awk 'NR==2 {print $1}' | tr -cd '[:alpha:]')
  export Storage_Space_Required="350"
  echo "-------------------------------------------------- "
  echo " "
  echo " Testing for Storage Space for installation"
  echo " "

  case $Storage_Space_Units in
      [Pp]* )

        echo " "
        echo "Sufficient storage space for installation found"
        echo "-------------------------------------------------- " ;;
      [Tt]* )
        echo " "
        echo "Sufficient storage space for installation found"
        echo "-------------------------------------------------- " ;;
      [Gg]* )
        if [[ ${Storage_Space_Size} -lt ${Storage_Space_Required} ]]; then
          echo " "
          echo "Not enough storage space for installation"
          echo "-------------------------------------------------- "
          exit
        else
          echo " "
          echo "Sufficient storage space for installation found."
          echo "-------------------------------------------------- "
        fi ;;
      [MmKk]* )
        echo " "
        echo "Not enough storage space for installation."
        echo "-------------------------------------------------- "
        exit ;;
      * )
      echo " "
      echo "Not enough storage space for installation."
      echo "-------------------------------------------------- "
      exit ;;
    esac

  echo " "
fi



if [ "$SYSTEMOS" = "MacOS" ]; then
  while true; do
    read -r -p "Do you have minimum of 350GB of FREE storage space available for this instllation (Y/N) " yn
    case $yn in
      [Yy]* )
      echo "-------------------------------------------------- "
      echo " "
      echo "Installation will move forward"
      break
        ;;
      [Nn]* )
      echo " "
      echo "Not enough storage space available. Exiting script."
      break
        ;;
      * ) echo "Please answer yes or no.";;
    esac
  done
fi




############################# Chose GrADS or OpenGrADS #########################
while read -r -p "Which graphic display software should be install?
-OpenGrADS
-GrADS (Not available for MacOS)

Please answer with either OpenGrADS or GrADS and press enter.
    " yn; do

  case $yn in
  OpenGrADS)


    echo " "
    echo "OpenGrADS selected for installation"
    echo "-------------------------------------------------- "
    export GRADS_PICK=1    #variable set for grads or opengrads choice
    break
    ;;
  GrADS)
    echo " "
    echo "GrADS selected for installation"
    echo "-------------------------------------------------- "
    export GRADS_PICK=2   #variable set for grads or opengrads choice
    break
    ;;
   * )
   echo " "
   echo "Please answer OpenGrADS or GrADS (case sensative).";;

esac
done

echo " "

################################# Auto Configuration Test ##################

while true; do
  echo " Auto Configuration Check"
  read -r -p "
  Would you like the script to select all the configure options for you?
  Please note, that you should not have to type anything else in the terminal.

  (Y/N)    " yn
  case $yn in
    [Yy]* )
      export auto_config=1  #variable set for one click config and installation
      break
      ;;
    [Nn]* )
      export auto_config=0  #variable set for manual config and installation
      break
      ;;
    * ) echo "Please answer yes or no.";;
  esac
done



echo " "
################################# GEOG WPS Geographical Input Data Mandatory for Specific Applications ##################

while true; do
  echo "-------------------------------------------------- "
  echo " "
  echo "Would you like to download the WPS Geographical Input Data for Specific Applications? (Optional)"
  echo " "
  echo "Specific Applicaitons files can be viewed here:  "
  echo " "
  printf '\e]8;;https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html\e\\Specific GEOG Applications Website (right click to open link) \e]8;;\e\\\n'
  echo " "
  read -r -p "(Y/N)   " yn
  case $yn in
    [Yy]* )
      export WPS_Specific_Applications=1  #variable set for "YES" for specific application data
      break
      ;;
    [Nn]* )
      export WPS_Specific_Applications=0  #variable set for "NO" for specific application data
      break
      ;;
    * ) echo "Please answer yes or no.";;
  esac
done




echo " "

################################# GEOG Optional WPS Geographical Input Data ##################

while true; do
    echo "-------------------------------------------------- "
    echo " "
    echo "Would you like to download the GEOG Optional WPS Geographical Input Data? (Optional)"
    echo " "
    echo "Optional Geogrpahical files can be viewed here:  "
    echo " "
    printf '\e]8;;https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html\e\\Optional GEOG File Applications Website (right click to open link) \e]8;;\e\\\n'
    echo " "
    read -r -p "(Y/N)    " yn
    echo " "
  case $yn in
    [Yy]* )
      export Optional_GEOG=1  #variable set for "YES" for Optional GEOG Data
      break
      ;;
    [Nn]* )
      export Optional_GEOG=0  #variable set for "NO" for Optional GEOG Data
      break
      ;;
    * ) echo "Please answer yes or no.";;
  esac
done

echo " "



############################## Choice for which version of WRF to Install ############

while read -r -p "Which version of WRF would you like to install?
-WRF
-WRFCHEM
-WRFHYDRO_COUPLED
-WRFHYDRO_STANDALONE
-HURRICANE_WRF
Please enter one of the above options and press enter (Case Sensative):
" yn; do

  case $yn in
  HURRICANE_WRF)
    echo " "
    echo "Hurricane WRF (HWRF) selected for installation"
    echo "HWRF is only compatible with Intel Compilers"
    echo "All geography files are downloaded and must be installed on system."
    export HWRF_PICK=1    #variable set for grads or opengrads choice
    break
      ;;
  WRF)
    echo " "
    echo "WRF selected for installation"
    export WRF_PICK=1    #variable set for grads or opengrads choice
    break
    ;;
  WRFCHEM)
    echo " "
    echo "WRFCHEM selected for installation"
    export WRFCHEM_PICK=1   #variable set for grads or opengrads choice
    break
    ;;
  WRFHYDRO_COUPLED)
    echo " "
    echo "WRFHYDRO_COUPLED selected for installation"
    export WRFHYDRO_COUPLED_PICK=1   #variable set for grads or opengrads choice
    break
    ;;
  WRFHYDRO_STANDALONE)
    echo " "
    echo "WRFHYDRO_STANDALONE selected for installation"
    export WRFHYDRO_STANDALONE_PICK=1   #variable set for grads or opengrads choice
    break
    ;;
   * )
   echo " "
   echo "Please answer WRF, WRFCHEM, WRFHYDRO_COUPLED, WRFHYDRO_STANDALONE (All Upper Case).";;

esac
done


############################# Enter sudo users information #############################
echo "-------------------------------------------------- "
while true; do
  echo " "
  read -r -s -p "
  Password is only save locally and will not be seen when typing.
  Please enter your sudo password:

  " yn
  export PASSWD=$yn
  echo "-------------------------------------------------- "
  break
done

echo " "
echo "Beginning Installation"
echo " "



############################ DTC's MET & METPLUS ##################################################

###################################################################################################



if [ "$Ubuntu_64bit_Intel" = "1" ]; then



  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade

  # download the key to system keyring; this and the following echo command are
  # needed in order to install the Intel compilers
  wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
  | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null


  # add signed entry to apt sources and configure the APT client to use Intel repository:
  echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list

  # this update should get the Intel package info from the Intel repository
  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade
  echo $PASSWD | sudo -S apt -y install python3 python3-dev emacs flex bison libpixman-1-dev libjpeg-dev pkg-config libpng-dev unzip python2 python2-dev python3-pip pipenv gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git libncurses5 libncurses6 mlocate pkg-config build-essential curl libcurl4-openssl-dev

  # install the Intel compilers
  echo $PASSWD | sudo -S apt -y install intel-basekit intel-hpckit intel-aikit
  echo $PASSWD | sudo -S apt -y update


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
  export FFLAGS="-m64"
  export FCFLAGS="-m64"
  #########################

  #Downloading latest dateutil due to python3.8 running old version.
  pip3 install python-dateutil==2.8

  #Directory Listings
  if [ "$WRFCHEM_PICK" = "1" ]; then
    mkdir $HOME/WRFCHEM_Intel
    export WRF_FOLDER=$HOME/WRFCHEM_Intel
  fi

  if [ "$WRFHYDRO_COUPLED_PICK" = "1" ]; then
    mkdir $HOME/WRFHYDRO_COUPLED_Intel
    export WRF_FOLDER=$HOME/WRFHYDRO_COUPLED_Intel
  fi

  if [ "$WRF_PICK" = "1" ]; then
    mkdir $HOME/WRF_Intel
    export WRF_FOLDER=$HOME/WRF_Intel
  fi

  if [ "$HWRF_PICK" = "1" ]; then
    mkdir $HOME/HWRF
    export WRF_FOLDER=$HOME/HWRF
  fi

  mkdir $WRF_FOLDER/MET-11.0.0
  mkdir $WRF_FOLDER/MET-11.0.0/Downloads
  mkdir $WRF_FOLDER/METplus-5.0.0
  mkdir $WRF_FOLDER/METplus-5.0.0/Downloads



  #Downloading MET and untarring files
  #Note weblinks change often update as needed.
  cd $WRF_FOLDER/MET-11.0.0/Downloads
  wget -c -4 https://raw.githubusercontent.com/dtcenter/MET/main_v11.0/internal/scripts/installation/compile_MET_all.sh

  wget -c -4 https://dtcenter.ucar.edu/dfiles/code/METplus/MET/installation/tar_files.tgz

  wget -c -4 https://github.com/dtcenter/MET/archive/refs/tags/v11.0.0.tar.gz


  cp compile_MET_all.sh $WRF_FOLDER/MET-11.0.0
  tar -xvzf tar_files.tgz -C $WRF_FOLDER/MET-11.0.0
  cp v11.0.0.tar.gz $WRF_FOLDER/MET-11.0.0/tar_files
  cd $WRF_FOLDER/MET-11.0.0



  cd $WRF_FOLDER/MET-11.0.0





  export PYTHON_VERSION=$(/opt/intel/oneapi/intelpython/latest/bin/python3 -V 2>&1|awk '{print $2}')
  export PYTHON_VERSION_MAJOR_VERSION=$(echo $PYTHON_VERSION | awk -F. '{print $1}')
  export PYTHON_VERSION_MINOR_VERSION=$(echo $PYTHON_VERSION | awk -F. '{print $2}')
  export PYTHON_VERSION_COMBINED=$PYTHON_VERSION_MAJOR_VERSION.$PYTHON_VERSION_MINOR_VERSION

  export CC=icc
  export CXX=icpc
  export FC=ifort
  export F77=ifort
  export F90=ifort
  export gcc_version=$(icc -dumpversion -diag-disable=10441)
  export TEST_BASE=$WRF_FOLDER/MET-11.0.0
  export COMPILER=intel_$gcc_version
  export MET_SUBDIR=${TEST_BASE}
  export MET_TARBALL=v11.0.0.tar.gz
  export USE_MODULES=FALSE
  export MET_PYTHON=/opt/intel/oneapi/intelpython/python${PYTHON_VERSION_COMBINED}
  export MET_PYTHON_CC=-I${MET_PYTHON}/include/python${PYTHON_VERSION_COMBINED}
  export MET_PYTHON_LD=-L${MET_PYTHON}/lib/python${PYTHON_VERSION_COMBINED}/config-${PYTHON_VERSION_COMBINED}-x86_64-linux-gnu\ -L${MET_PYTHON}/lib\ -lpython${PYTHON_VERSION_COMBINED}\ -lcrypt\ -lpthread\ -ldl\ -lm\ -lm
  export SET_D64BIT=FALSE


  chmod 775 compile_MET_all.sh

  time ./compile_MET_all.sh

  export PATH=$WRF_FOLDER/MET-11.0.0/bin:$PATH            #Add MET executables to path


#Basic Package Management for Model Evaluation Tools (METplus)

  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade



#Directory Listings for Model Evaluation Tools (METplus

  mkdir $WRF_FOLDER/METplus-5.0.0
  mkdir $WRF_FOLDER/METplus-5.0.0/Sample_Data
  mkdir $WRF_FOLDER/METplus-5.0.0/Output
  mkdir $WRF_FOLDER/METplus-5.0.0/Downloads




#Downloading METplus and untarring files

  cd $WRF_FOLDER/METplus-5.0.0/Downloads
  wget -c -4 https://github.com/dtcenter/METplus/archive/refs/tags/v5.0.0.tar.gz
  tar -xvzf v5.0.0.tar.gz -C $WRF_FOLDER



# Insatlllation of Model Evaluation Tools Plus
  cd $WRF_FOLDER/METplus-5.0.0/parm/metplus_config

  sed -i "s|MET_INSTALL_DIR = /path/to|MET_INSTALL_DIR = $WRF_FOLDER/MET-11.0.0|" defaults.conf
  sed -i "s|INPUT_BASE = /path/to|INPUT_BASE = $WRF_FOLDER/METplus-5.0.0/Sample_Data|" defaults.conf
  sed -i "s|OUTPUT_BASE = /path/to|OUTPUT_BASE = $WRF_FOLDER/METplus-5.0.0/Output|" defaults.conf


# Downloading Sample Data

  cd $WRF_FOLDER/METplus-5.0.0/Downloads
  wget -c -4 https://dtcenter.ucar.edu/dfiles/code/METplus/METplus_Data/v5.0/sample_data-met_tool_wrapper-5.0.tgz
  tar -xvzf sample_data-met_tool_wrapper-5.0.tgz -C $WRF_FOLDER/METplus-5.0.0/Sample_Data


# Testing if installation of MET & METPlus was sucessfull
# If you see in terminal "METplus has successfully finished running."
# Then MET & METPLUS is sucessfully installed

  echo 'Testing MET & METPLUS Installation.'
  $WRF_FOLDER/METplus-5.0.0/ush/run_metplus.py -c $WRF_FOLDER/METplus-5.0.0/parm/use_cases/met_tool_wrapper/GridStat/GridStat.conf
  export PATH=$WRF_FOLDER/METplus-5.0.0/ush:$PATH
  echo " "
  read -r -t 5 -p "MET and METPLUS sucessfully installed with intel compilers"

fi



if [ "$Ubuntu_64bit_GNU" = "1" ]; then

  export HOME=`cd;pwd`
  #Basic Package Management for Model Evaluation Tools (MET)


  #############################basic package managment############################
  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade
  echo $PASSWD | sudo -S apt -y install python3 python3-dev emacs flex bison libpixman-1-dev libjpeg-dev pkg-config libpng-dev unzip python2 python2-dev python3-pip pipenv gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git libncurses5 libncurses6 mlocate pkg-config build-essential curl libcurl4-openssl-dev

  #Downloading latest dateutil due to python3.8 running old version.
  pip3 install python-dateutil==2.8



  #Directory Listings
  if [ "$WRFCHEM_PICK" = "1" ]; then
    mkdir $HOME/WRFCHEM
    export WRF_FOLDER=$HOME/WRFCHEM
  fi

  if [ "$WRFHYDRO_COUPLED_PICK" = "1" ]; then
    mkdir $HOME/WRFHYDRO_COUPLED
    export WRF_FOLDER=$HOME/WRFHYDRO_COUPLED
  fi

  if [ "$WRFHYDRO_STANDALONE_PICK" = "1" ]; then
    mkdir $HOME/WRFHYDRO_STANDALONE
    export WRF_FOLDER=$HOME/WRFHYDRO_STANDALONE
  fi


  if [ "$WRF_PICK" = "1" ]; then
    mkdir $HOME/WRF
    export WRF_FOLDER=$HOME/WRF
  fi

  if [ "$HWRF_PICK" = "1" ]; then
    mkdir $HOME/HWRF
    export WRF_FOLDER=$HOME/HWRF
  fi


  mkdir $WRF_FOLDER/MET-11.0.0
  mkdir $WRF_FOLDER/MET-11.0.0/Downloads
  mkdir $WRF_FOLDER/METplus-5.0.0
  mkdir $WRF_FOLDER/METplus-5.0.0/Downloads



  #Downloading MET and untarring files
  #Note weblinks change often update as needed.
  cd $WRF_FOLDER/MET-11.0.0/Downloads

  wget -c -4 https://raw.githubusercontent.com/dtcenter/MET/main_v11.0/internal/scripts/installation/compile_MET_all.sh

  wget -c -4 https://dtcenter.ucar.edu/dfiles/code/METplus/MET/installation/tar_files.tgz

  wget -c -4 https://github.com/dtcenter/MET/archive/refs/tags/v11.0.0.tar.gz



  cp compile_MET_all.sh $WRF_FOLDER/MET-11.0.0
  tar -xvzf tar_files.tgz -C $WRF_FOLDER/MET-11.0.0
  cp v11.0.0.tar.gz $WRF_FOLDER/MET-11.0.0/tar_files
  cd $WRF_FOLDER/MET-11.0.0



  # Installation of Model Evaluation Tools
  export CC=/usr/bin/gcc
  export CXX=/usr/bin/g++
  export FC=/usr/bin/gfortran
  export F77=/usr/bin/gfortran
  export CFLAGS="-fPIC -fPIE -O3"

  cd $WRF_FOLDER/MET-11.0.0
  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  export PYTHON_VERSION=$(/usr/bin/python3 -V 2>&1|awk '{print $2}')
  export PYTHON_VERSION_MAJOR_VERSION=$(echo $PYTHON_VERSION | awk -F. '{print $1}')
  export PYTHON_VERSION_MINOR_VERSION=$(echo $PYTHON_VERSION | awk -F. '{print $2}')
  export PYTHON_VERSION_COMBINED=$PYTHON_VERSION_MAJOR_VERSION.$PYTHON_VERSION_MINOR_VERSION


  export FC=/usr/bin/gfortran
  export F77=/usr/bin/gfortran
  export F90=/usr/bin/gfortran
  export gcc_version=$(gcc -dumpfullversion)
  export TEST_BASE=$WRF_FOLDER/MET-11.0.0
  export COMPILER=gnu_$gcc_version
  export MET_SUBDIR=${TEST_BASE}
  export MET_TARBALL=v11.0.0.tar.gz
  export USE_MODULES=FALSE
  export MET_PYTHON=/usr
  export MET_PYTHON_CC=-I${MET_PYTHON}/include/python${PYTHON_VERSION_COMBINED}
  export MET_PYTHON_LD=-L${MET_PYTHON}/lib/python${PYTHON_VERSION_COMBINED}/config-${PYTHON_VERSION_COMBINED}-x86_64-linux-gnu\ -L${MET_PYTHON}/lib\ -lpython${PYTHON_VERSION_COMBINED}\ -lcrypt\ -lpthread\ -ldl\ -lutil\ -lm
  export SET_D64BIT=FALSE


  chmod 775 compile_MET_all.sh

  time ./compile_MET_all.sh | tee compile_MET_all.log

  export PATH=$WRF_FOLDER/MET-11.0.0/bin:$PATH

  #basic Package Management for Model Evaluation Tools (METplus)

  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade



#Directory Listings for Model Evaluation Tools (METplus

  mkdir $WRF_FOLDER/METplus-5.0.0
  mkdir $WRF_FOLDER/METplus-5.0.0/Sample_Data
  mkdir $WRF_FOLDER/METplus-5.0.0/Output
  mkdir $WRF_FOLDER/METplus-5.0.0/Downloads



#Downloading METplus and untarring files

  cd $WRF_FOLDER/METplus-5.0.0/Downloads
  wget -c -4 https://github.com/dtcenter/METplus/archive/refs/tags/v5.0.0.tar.gz
  tar -xvzf v5.0.0.tar.gz -C $WRF_FOLDER



# Insatlllation of Model Evaluation Tools Plus
  cd $WRF_FOLDER/METplus-5.0.0/parm/metplus_config

  sed -i "s|MET_INSTALL_DIR = /path/to|MET_INSTALL_DIR = $WRF_FOLDER/MET-11.0.0|" defaults.conf
  sed -i "s|INPUT_BASE = /path/to|INPUT_BASE = $WRF_FOLDER/METplus-5.0.0/Sample_Data|" defaults.conf
  sed -i "s|OUTPUT_BASE = /path/to|OUTPUT_BASE = $WRF_FOLDER/METplus-5.0.0/Output|" defaults.conf


# Downloading Sample Data

  cd $WRF_FOLDER/METplus-5.0.0/Downloads
  wget -c -4 https://dtcenter.ucar.edu/dfiles/code/METplus/METplus_Data/v5.0/sample_data-met_tool_wrapper-5.0.tgz
  tar -xvzf sample_data-met_tool_wrapper-5.0.tgz -C $WRF_FOLDER/METplus-5.0.0/Sample_Data


# Testing if installation of MET & METPlus was sucessfull
# If you see in terminal "METplus has successfully finished running."
# Then MET & METPLUS is sucessfully installed

  echo 'Testing MET & METPLUS Installation.'
  $WRF_FOLDER/METplus-5.0.0/ush/run_metplus.py -c $WRF_FOLDER/METplus-5.0.0/parm/use_cases/met_tool_wrapper/GridStat/GridStat.conf

  export PATH=$WRF_FOLDER/METplus-5.0.0/ush:$PATH
   read -r -t 5 -p "MET and METPLUS sucessfully installed with GNU compilers."
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



if [ "$Ubuntu_64bit_GNU" = "1" ] && [ "$WRFCHEM_PICK" = "1" ]; then


  # Basic Package Management for WRF-CHEM Tools and Processors

  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade
  echo $PASSWD | sudo -S apt -y install python3 python3-dev emacs flex bison libpixman-1-dev libjpeg-dev pkg-config libpng-dev unzip python2 python2-dev python3-pip pipenv gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git libncurses5 libncurses6 mlocate pkg-config build-essential curl libcurl4-openssl-dev byacc flex

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
  export CPU_CORE=$(nproc)                                             # number of available threads on system
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
  echo "Number of threads being used $CPU_HALF_EVEN"
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
  make -j $CPU_HALF_EVEN install | tee make.install.log
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
  export LIBS="-lnetcdf -lpnetcdf -lcurl -lhdf5_hl -lhdf5 -lz -lm -ldl -lgcc -lgfortran"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-parallel-tests --enable-hdf5
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
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
  #  WRF chemical options (See Readme in Folder

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
  # This is an IDL based preprocessor to create WRF-Chem ready aircraft emissions files
  # (wrfchemaircraft_) from a global inventory in netcdf format. Please consult the README file
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
    # We recommend that you read the article “PREP-CHEM-SRC – 1.0: a preprocessor of
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


fi

if [ "$Ubuntu_64bit_Intel" = "1" ] && [ "$WRFCHEM_PICK" = "1" ]; then



  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade

  # download the key to system keyring; this and the following echo command are
  # needed in order to install the Intel compilers
  wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
  | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null


  # add signed entry to apt sources and configure the APT client to use Intel repository:
  echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list

  # this update should get the Intel package info from the Intel repository
  echo $PASSWD | sudo -S apt -y update


  # Basic Package Management for WRF-CHEM Tools and Processors

  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade
  echo $PASSWD | sudo -S apt -y install gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git build-essential unzip mlocate byacc flex git python3 python3-dev python2 python2-dev curl cmake libcurl4-openssl-dev pkg-config build-essential


  # install the Intel compilers
  echo $PASSWD | sudo -S apt -y install intel-basekit intel-hpckit intel-aikit
  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade

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
  export CPU_CORE=$(nproc)                                             #number of available threads on system
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
  echo "Number of threads being used $CPU_HALF_EVEN"
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
  export LIBS="-lnetcdf -lpnetcdf -lcurl -lhdf5_hl -lhdf5 -lz -lm -ldl -lgcc -lgfortran"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-parallel-tests --enable-hdf5
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
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
  #  WRF chemical options (See Readme in Folder

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
  # This is an IDL based preprocessor to create WRF-Chem ready aircraft emissions files
  # (wrfchemaircraft_) from a global inventory in netcdf format. Please consult the README file
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
  # We recommend that you read the article “PREP-CHEM-SRC – 1.0: a preprocessor of
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

    make OPT=intel.wrf CHEM=RADM_WRF_FIM AER=SIMPLE | tee make.log  # Compiling and making of PRE-CHEM-SRC-1.5


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




fi

if [ "$macos_64bit_GNU" = "1" ]  && [ "$WRFCHEM_PICK" = "1" ]; then

  cd $HOME
  git clone https://github.com/HathewayWill/WRFCHEM-TOOLS-MASTER.git
  cd WRFCHEM-TOOLS-MASTER
  chmod 775 *.sh
  ./WRFCHEM_TOOLS_Master_Script.sh
  cd $HOME

fi

############################################# WRF Hydro Standalone #################################
## WRFHYDRO Standalone installation with parallel process.
# Download and install required library and data files for WRFHYDRO.
# Tested in Ubuntu 20.04.4 LTS & Ubuntu 22.04 & MacOS Ventura 64bit
# Built in 64-bit system
# Built with Intel or GNU compilers
# Tested with current available libraries on 01/01/2023
# If newer libraries exist edit script paths for changes
#Estimated Run Time ~ 30 - 60 Minutes with 10mb/s downloadspeed.
# Special thanks to:
# Youtube's meteoadriatic, GitHub user jamal919.
# University of Manchester's  Doug L
# University of Tunis El Manar's Hosni
# GSL's Jordan S.
# NCAR's Mary B., Christine W., & Carl D.
# DTC's Julie P., Tara J., George M., & John H.
# UCAR's Katelyn F., Jim B., Jordan P., Kevin M.,
##############################################################



if [ "$Ubuntu_64bit_GNU" = "1" ] && [ "$WRFHYDRO_STANDALONE_PICK" = "1" ]; then

#############################basic package managment############################
  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade
  echo $PASSWD | sudo -S apt -y install gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh tcsh okular cmake time xorg openbox xauth git python3 python3-dev python2 python2-dev cmake mlocate pkg-config

  echo " "
##############################Directory Listing############################
  export HOME=`cd;pwd`

  mkdir $HOME/WRFHYDRO_STANDALONE
  export WRFHYDRO_FOLDER=$HOME/WRFHYDRO_STANDALONE
  cd $WRFHYDRO_FOLDER/
  mkdir Downloads
  mkdir Libs
  export DIR=$WRFHYDRO_FOLDER/Libs
  mkdir Libs/grib2
  mkdir Libs/NETCDF
  mkdir Libs/MPICH
  echo " "
##############################Downloading Libraries############################
  cd Downloads
  wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz
  wget -c -4 https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_2.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz
  wget -c -4 https://github.com/pmodels/mpich/releases/download/v4.0.3/mpich-4.0.3.tar.gz
  wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.39.tar.gz
  wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip



  echo " "
#############################Compilers############################
  export CC=gcc
  export CXX=g++
  export FC=gfortran
  export F77=gfortran
  export CFLAGS="-fPIC -fPIE -O3"

  export gcc_version="$(gcc -dumpversion)"
  export gfortran_version="$(gfortran -dumpversion)"
  export gplusplus_version="$(g++ -dumpversion)"
  export version_10="10"

  if [ $gcc_version -ge $version_10 ] || [ $gfortran_version -ge $version_10 ] || [ $gplusplus_version -ge $version_10 ]
    then
      export fallow_argument=-fallow-argument-mismatch
      export boz_argument=-fallow-invalid-boz
    else
      export fallow_argument=
      export boz_argument=
  fi


  export FFLAGS="$fallow_argument -m64"
  export FCFLAGS="$fallow_argument -m64"

  echo " "
#############################Core Management####################################

  export CPU_CORE=$(nproc)                                             # number of available threads on system
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
  echo "Number of Threads being used $CPU_HALF_EVEN"
  echo "##########################################"

  echo " "

##############################MPICH############################
  cd $WRFHYDRO_FOLDER/Downloads
  tar -xvzf mpich-4.0.3.tar.gz
  cd mpich-4.0.3/
  F90= ./configure --prefix=$DIR/MPICH --with-device=ch3 FFLAGS="$fallow_argument -m64" FCFLAGS="$fallow_argument -m64"
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check


  export PATH=$DIR/MPICH/bin:$PATH


  echo " "

  #############################zlib############################
    #Uncalling compilers due to comfigure issue with zlib1.2.13
    #With CC & CXX definied ./configure uses different compiler Flags

    cd $WRFHYDRO_FOLDER/Downloads
    tar -xvzf v1.2.13.tar.gz
    cd zlib-1.2.13/
    ./configure --prefix=$DIR/grib2
    make -j $CPU_HALF_EVEN
    make -j $CPU_HALF_EVEN install | tee make.install.log
    #make check

    echo " "
    ##############################MPICH############################
    cd $WRFHYDRO_FOLDER/Downloads
    tar -xvzf mpich-4.0.3.tar.gz
    cd mpich-4.0.3/
    F90= ./configure --prefix=$DIR/MPICH --with-device=ch3 FFLAGS="$fallow_argument -m64" FCFLAGS="$fallow_argument -m64"

    make -j $CPU_HALF_EVEN
    make -j $CPU_HALF_EVEN install | tee make.install.log
    #make check


    export PATH=$DIR/MPICH/bin:$PATH

    export MPIFC=$DIR/MPICH/bin/mpifort
    export MPIF77=$DIR/MPICH/bin/mpifort
    export MPIF90=$DIR/MPICH/bin/mpifort
    export MPICC=$DIR/MPICH/bin/mpicc
    export MPICXX=$DIR/MPICH/bin/mpicxx


    echo " "
    #############################libpng############################
    cd $WRFHYDRO_FOLDER/Downloads
    export LDFLAGS=-L$DIR/grib2/lib
    export CPPFLAGS=-I$DIR/grib2/include
    tar -xvzf libpng-1.6.39.tar.gz
    cd libpng-1.6.39/
    CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
    make -j $CPU_HALF_EVEN
    make -j $CPU_HALF_EVEN install | tee make.install.log
    #make check
    echo " "
    #############################JasPer############################
    cd $WRFHYDRO_FOLDER/Downloads
    unzip jasper-1.900.1.zip
    cd jasper-1.900.1/
    autoreconf -i
    CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
    make -j $CPU_HALF_EVEN
    make -j $CPU_HALF_EVEN install | tee make.install.log
    #make check

    export JASPERLIB=$DIR/grib2/lib
    export JASPERINC=$DIR/grib2/include


    echo " "
    #############################hdf5 library for netcdf4 functionality############################
    cd $WRFHYDRO_FOLDER/Downloads
    tar -xvzf hdf5-1_13_2.tar.gz
    cd hdf5-hdf5-1_13_2
    CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran --enable-parallel
    make -j $CPU_HALF_EVEN
    make -j $CPU_HALF_EVEN install | tee make.install.log
    #make check

    export HDF5=$DIR/grib2
    export PHDF5=$DIR/grib2
    export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH


    #############################Install Parallel-netCDF##############################
    #Make file created with half of available cpu cores
    #Hard path for MPI added
    ##################################################################################
    cd $WRFHYDRO_FOLDER/Downloads
    wget -c -4  https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz
    tar -xvzf pnetcdf-1.12.3.tar.gz
    cd pnetcdf-1.12.3
    export MPIFC=$DIR/MPICH/bin/mpifort
    export MPIF77=$DIR/MPICH/bin/mpifort
    export MPIF90=$DIR/MPICH/bin/mpifort
    export MPICC=$DIR/MPICH/bin/mpicc
    export MPICXX=$DIR/MPICH/bin/mpicxx
    ./configure --prefix=$DIR/grib2  --enable-shared --enable-static

    make -j $CPU_HALF_EVEN
    make -j $CPU_HALF_EVEN install
    #make check

    export PNETCDF=$DIR/grib2

    ##############################Install NETCDF C Library############################
    cd $WRFHYDRO_FOLDER/Downloads
    tar -xzvf v4.9.0.tar.gz
    cd netcdf-c-4.9.0/
    export CPPFLAGS=-I$DIR/grib2/include
    export LDFLAGS=-L$DIR/grib2/lib
    export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lgfortran -lgcc -lm -ldl"
    CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --disable-dap --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-pnetcdf --enable-cdf5 --enable-parallel-tests
    make -j $CPU_HALF_EVEN
    make -j $CPU_HALF_EVEN install | tee make.install.log
    #make check

    export PATH=$DIR/NETCDF/bin:$PATH
    export NETCDF=$DIR/NETCDF
    echo " "
    ##############################NetCDF fortran library############################
    cd $WRFHYDRO_FOLDER/Downloads
    tar -xvzf v4.6.0.tar.gz
    cd netcdf-fortran-4.6.0/
    export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
    export CPPFLAGS="-I$DIR/NETCDF/include -I$DIR/grib2/include"
    export LDFLAGS="-L$DIR/NETCDF/lib -L$DIR/grib2/lib"
    export LIBS="-lnetcdf -lpnetcdf -lcurl -lhdf5_hl -lhdf5 -lz -lm -ldl -lgcc -lgfortran"
    CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-parallel-tests --enable-hdf5
    make -j $CPU_HALF_EVEN
    make -j $CPU_HALF_EVEN install | tee make.install.log
    #make check

    echo " "


  #################################### System Environment Tests ##############
  mkdir -p $WRFHYDRO_FOLDER/Tests/Environment
  mkdir -p $WRFHYDRO_FOLDER/Tests/Compatibility


  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar


  tar -xvf Fortran_C_tests.tar -C $WRFHYDRO_FOLDER/Tests/Environment
  tar -xvf Fortran_C_NETCDF_MPI_tests.tar -C $WRFHYDRO_FOLDER/Tests/Compatibility
  export one="1"
  echo " "
  ############## Testing Environment #####

  cd $WRFHYDRO_FOLDER/Tests/Environment

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

  cd $WRFHYDRO_FOLDER/Tests/Compatibility

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




  ############################# WRF HYDRO V5.2.0 #################################
  # Version 5.2.0
  # Standalone mode
  # GNU
  ################################################################################

  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4  https://github.com/NCAR/wrf_hydro_nwm_public/archive/refs/tags/v5.2.0.tar.gz -O WRFHYDRO.5.2.tar.gz
  tar -xvzf WRFHYDRO.5.2.tar.gz -C $WRFHYDRO_FOLDER/


  #Modifying WRF-HYDRO Environment
  #Echo commands use due to lack of knowledge
  cd $WRFHYDRO_FOLDER/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS/template

  sed -i 's/SPATIAL_SOIL=0/SPATIAL_SOIL=1/g' setEnvar.sh
  echo " " >> setEnvar.sh
  echo "# Large netcdf file support: 0=Off, 1=On." >> setEnvar.sh
  echo "export WRFIO_NCD_LARGE_FILE_SUPPORT=1" >> setEnvar.sh
  ln setEnvar.sh $WRFHYDRO_FOLDER/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS

  #Configure & Compile WRF HYDRO in Standalone Mode
  #Compile WRF-Hydro offline with the NoahMP
  cd $WRFHYDRO_FOLDER/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS
  source setEnvar.sh
  echo 2 | ./configure     # Gfortran
  ./compile_offline_NoahMP.sh setEnvar.sh

  ls -lah Run/*.exe  #Test to see if .exe files have compiled


  echo " "
  ######################### Testing WRF HYDRO Compliation #########################
  cd $WRFHYDRO_FOLDER/
  mkdir -p $WRFHYDRO_FOLDER/domain/NWM

  #Copy the *.TBL files to the NWM directory.
  cp wrf_hydro_nwm_public*/trunk/NDHMS/Run/*.TBL domain/NWM
  #Copy the wrf_hydro.exe file to the NWM directory.
  cp wrf_hydro_nwm_public*/trunk/NDHMS/Run/wrf_hydro.exe domain/NWM

  #Download test case for WRF HYDRO and move to NWM
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4  https://github.com/NCAR/wrf_hydro_nwm_public/releases/download/v5.2.0/croton_NY_training_example_v5.2.tar.gz
  tar -xzvf croton_NY_training_example_v5.2.tar.gz

  cp -r example_case/FORCING $WRFHYDRO_FOLDER/domain/NWM
  cp -r example_case/NWM/DOMAIN $WRFHYDRO_FOLDER/domain/NWM
  cp -r example_case/NWM/RESTART $WRFHYDRO_FOLDER/domain/NWM
  cp -r example_case/NWM/nudgingTimeSliceObs $WRFHYDRO_FOLDER/domain/NWM
  cp -r example_case/NWM/referenceSim $WRFHYDRO_FOLDER/domain/NWM
  cp example_case/NWM/namelist.hrldas $WRFHYDRO_FOLDER/domain/NWM
  cp example_case/NWM/hydro.namelist $WRFHYDRO_FOLDER/domain/NWM

  #Run Croton NY Test Case
  cd $WRFHYDRO_FOLDER/domain/NWM
  ./wrf_hydro.exe
  ls -lah HYDRO_RST*
  echo "IF HYDRO_RST files exist and have data then wrf_hydro.exe sucessful"
  echo " "

  ########################### Test script for output data  ###################################

  #Installing Miniconda3 to WRF directory and updating libraries
  export Miniconda_Install_DIR=$WRFHYDRO_FOLDER/miniconda3

  mkdir -p $Miniconda_Install_DIR


  if [ "$Ubuntu_32bit_GNU" = "1" ]; then
  wget -c -4 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86.sh -O $Miniconda_Install_DIR/miniconda.sh
  else
  wget -c -4 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $Miniconda_Install_DIR/miniconda.sh
  fi

  bash $Miniconda_Install_DIR/miniconda.sh -b -u -p $Miniconda_Install_DIR

  rm -rf $Miniconda_Install_DIR/miniconda.sh

  export PATH=$WRFHYDRO_FOLDER/miniconda3/bin:$PATH

  source $Miniconda_Install_DIR/etc/profile.d/conda.sh

  $Miniconda_Install_DIR/bin/conda init bash
  $Miniconda_Install_DIR/bin/conda init zsh
  $Miniconda_Install_DIR/bin/conda init tcsh
  $Miniconda_Install_DIR/bin/conda init xonsh
  $Miniconda_Install_DIR/bin/conda init powershell

  conda config --add channels conda-forge
  conda config --set auto_activate_base false
  conda update -n root --all -y


  export $PATH

  ##################### WRF Python           ##################
  ########### WRf-Python compiled via Conda  ##################
  ########### This is the preferred method by NCAR      ##################
  ##### https://wrf-python.readthedocs.io/en/latest/installation.html  ##################
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n wrf-python -c conda-forge wrf-python -y
  conda activate wrf-python
  conda update -n wrf-python --all -y
  conda activate wrf-python
  conda install -c conda-forge matplotlib -y
  conda install -c conda-forge NETCDF4 -y

  ################ NEEDS TO BE IN Master folder #######################
  cp  $HOME/WRF-MASTER/SurfaceRunoff.py $WRFHYDRO_FOLDER/domain/NWM


  cd $WRFHYDRO_FOLDER/domain/NWM

  python3 SurfaceRunoff.py

  okular SurfaceRunoff.pdf


  echo " "
  #####################################BASH Script Finished##############################
  echo "WRF HYDRO Standalone sucessfully configured and compiled"
  read -r -t 5 -p "Congratulations! You've successfully installed all required files to run the Weather Research Forecast Model HYDRO verison 5.2."

  ##########################  Export PATH and LD_LIBRARY_PATH ################################
  cd $HOME



fi


if [ "$macos_64bit_GNU" = "1" ] && [ "$WRFHYDRO_STANDALONE_PICK" = "1" ]; then

## WRF installation with parallel process.
# Download and install required library and data files for WRF.
# Tested in macOS Catalina 10.15.7
# Tested in 32-bit
# Tested with current available libraries on 01/01/2023
# If newer libraries exist edit script paths for changes
#Estimated Run Time ~ 90 - 150 Minutes with 10mb/s downloadspeed.
#Special thanks to  Youtube's meteoadriatic and GitHub user jamal919.

#############################basic package managment############################

  brew install wget git
  brew install gcc libtool automake autoconf make m4 java ksh  mpich grads ksh tcsh
  brew install snap
  brew install python@3.9
  brew install gcc libtool automake autoconf make m4 java ksh git wget mpich grads ksh tcsh python@3.9 cmake xorgproto xorgrgb xauth curl

  ##############################Directory Listing############################

  export HOME=`cd;pwd`

  mkdir $HOME/WRFHYDRO
  export WRFHYDRO_FOLDER=$HOME/WRFHYDRO_STANDALONE
  cd $WRFHYDRO_FOLDER/
  mkdir Downloads
  mkdir Libs
  export DIR=$WRFHYDRO_FOLDER/Libs
  mkdir Libs/grib2
  mkdir Libs/NETCDF

  echo " "
  ##############################Downloading Libraries############################

  cd Downloads
  wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz
  wget -c -4 https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_2.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz
  wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.39.tar.gz
  wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
  wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz



  echo " "
  #############################Compilers############################


  export CC=/usr/local/Cellar/gcc/1*/bin/gcc-1*
  export CXX=/usr/local/Cellar/gcc/1*/bin/g++-1*
  export FC=/usr/local/Cellar/gcc/1*/bin/gfortran-1*
  export F77=/usr/local/Cellar/gcc/1*/bin/gfortran-1*
  export CFLAGS="-fPIC -fPIE -O3 -Wno-implicit-function-declaration"

  echo " "
  #############################zlib############################
  #Uncalling compilers due to comfigure issue with zlib1.2.12
  #With CC & CXX definied ./configure uses different compiler Flags

  cd $WRFHYDRO_FOLDER/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/
  ./configure --prefix=$DIR/grib2
  make
  make install
  #make check

  echo " "
  #############################libpng############################
  cd $WRFHYDRO_FOLDER/Downloads
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

  cd $WRFHYDRO_FOLDER/Downloads
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

  cd $WRFHYDRO_FOLDER/Downloads
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
  cd $WRFHYDRO_FOLDER/Downloads
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

  cd $WRFHYDRO_FOLDER/Downloads
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
  mkdir -p $WRFHYDRO_FOLDER/Tests/Environment
  mkdir -p $WRFHYDRO_FOLDER/Tests/Compatibility


  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar


  tar -xvf Fortran_C_tests.tar -C $WRFHYDRO_FOLDER/Tests/Environment
  tar -xvf Fortran_C_NETCDF_MPI_tests.tar -C $WRFHYDRO_FOLDER/Tests/Compatibility
  export one="1"
  echo " "
  ############## Testing Environment #####

  cd $WRFHYDRO_FOLDER/Tests/Environment

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

  cd $WRFHYDRO_FOLDER/Tests/Compatibility

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



  echo " "
  ############################# WRF HYDRO V5.2.0 #################################
  # Version 5.2.0
  # Standalone mode
  ################################################################################

  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4  https://github.com/NCAR/wrf_hydro_nwm_public/archive/refs/tags/v5.2.0.tar.gz -O WRFHYDRO.5.2.tar.gz
  tar -xvzf WRFHYDRO.5.2.tar.gz -C $WRFHYDRO_FOLDER/


  #Modifying WRF-HYDRO Environment
  #Echo commands use due to lack of knowledge
  cd $WRFHYDRO_FOLDER/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS/template

  sed -i 's/SPATIAL_SOIL=0/SPATIAL_SOIL=1/g' setEnvar.sh
  echo " " >> setEnvar.sh
  echo "# Large netcdf file support: 0=Off, 1=On." >> setEnvar.sh
  echo "export WRFIO_NCD_LARGE_FILE_SUPPORT=1" >> setEnvar.sh
  ln setEnvar.sh $WRFHYDRO_FOLDER/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS

  #Configure & Compile WRF HYDRO in Standalone Mode
  #Compile WRF-Hydro offline with the NoahMP
  cd $WRFHYDRO_FOLDER/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS

  echo 2 | ./configure     # Option 2
  ./compile_offline_NoahMP.sh setEnvar.sh

  ls -lah RUN/*.exe  #Test to see if .exe files have compiled


  echo " "
  ######################### Testing WRF HYDRO Compliation #########################
  cd $WRFHYDRO_FOLDER/
  mkdir -p $WRFHYDRO_FOLDER/domain/NWM

  #Copy the *.TBL files to the NWM directory.
  cp wrf_hydro_nwm_public*/trunk/NDHMS/Run/*.TBL domain/NWM
  #Copy the wrf_hydro.exe file to the NWM directory.
  cp wrf_hydro_nwm_public*/trunk/NDHMS/Run/wrf_hydro.exe domain/NWM

  #Download test case for WRF HYDRO and move to NWM
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4  https://github.com/NCAR/wrf_hydro_nwm_public/releases/download/v5.2.0/croton_NY_training_example_v5.2.tar.gz
  tar -xzvf croton_NY_training_example_v5.2.tar.gz

  cp -r example_case/FORCING $WRFHYDRO_FOLDER/domain/NWM
  cp -r example_case/NWM/DOMAIN $WRFHYDRO_FOLDER/domain/NWM
  cp -r example_case/NWM/RESTART $WRFHYDRO_FOLDER/domain/NWM
  cp -r example_case/NWM/nudgingTimeSliceObs $WRFHYDRO_FOLDER/domain/NWM
  cp -r example_case/NWM/referenceSim $WRFHYDRO_FOLDER/domain/NWM
  cp example_case/NWM/namelist.hrldas $WRFHYDRO_FOLDER/domain/NWM
  cp example_case/NWM/hydro.namelist $WRFHYDRO_FOLDER/domain/NWM

  #Run Croton NY Test Case
  cd $WRFHYDRO_FOLDER/domain/NWM
  mpirun -np 6 ./wrf_hydro.exe
  ls -lah HYDRO_RST*
  echo "IF HYDRO_RST files exist and have data then wrf_hydro.exe sucessful"
  echo " "


  echo " "
  ########################### Test script for output data  ###################################

  #Installing Miniconda3 to WRF directory and updating libraries
  export Miniconda_Install_DIR=$WRFHYDRO_FOLDER/miniconda3

  mkdir -p $Miniconda_Install_DIR

  wget -c -4 https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O $Miniconda_Install_DIR/miniconda.sh
  bash $Miniconda_Install_DIR/miniconda.sh -b -u -p $Miniconda_Install_DIR

  rm -rf $Miniconda_Install_DIR/miniconda.sh

  export PATH=$WRFHYDRO_FOLDER/miniconda3/bin:$PATH

  source $Miniconda_Install_DIR/etc/profile.d/conda.sh

  $Miniconda_Install_DIR/bin/conda init bash
  $Miniconda_Install_DIR/bin/conda init zsh
  $Miniconda_Install_DIR/bin/conda init tcsh
  $Miniconda_Install_DIR/bin/conda init xonsh
  $Miniconda_Install_DIR/bin/conda init powershell

  conda config --add channels conda-forge
  conda config --set auto_activate_base false
  conda update -n root --all -y


  export $PATH
  ##################### WRF Python           ##################
  ########### WRf-Python compiled via Conda  ##################
  ########### This is the preferred method by NCAR      ##################
  ##### https://wrf-python.readthedocs.io/en/latest/installation.html  ##################
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n wrf-python -c conda-forge wrf-python -y
  conda activate wrf-python
  conda update -n wrf-python --all -y
  conda activate wrf-python
  conda install -c conda-forge matplotlib -y
  conda install -c conda-forge NETCDF4 -y

  cp  $HOME/WRF-MASTER/SurfaceRunoff.py $WRFHYDRO_FOLDER/domain/NWM


  cd $WRFHYDRO_FOLDER/domain/NWM

  python3 SurfaceRunoff.py

  open SurfaceRunoff.pdf


  echo " "
  echo "WRF HYDRO Standalone sucessfully configured and compiled"
  echo "Congratulations! You've successfully installed all required files to run the Weather Research Forecast Model HYDRO verison 5.2."
  echo "Thank you for using this script"

fi

if [ "$Ubuntu_64bit_Intel" = "1" ] && [ "$WRFHYDRO_STANDALONE" = "1" ]; then


  ############################# Basic package managment ############################

  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade

  # download the key to system keyring; this and the following echo command are
  # needed in order to install the Intel compilers
  wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
  | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null


  # add signed entry to apt sources and configure the APT client to use Intel repository:
  echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list

  # this update should get the Intel package info from the Intel repository
  echo $PASSWD | sudo -S apt -y update

  # necessary binary packages (especially pkg-config and build-essential)
  echo $PASSWD | sudo -S apt -y install git apt gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh tcsh okular cmake time xorg openbox xauth python3 python3-dev python2 python2-dev mlocate curl libcurl4-openssl-dev pkg-config

  # install the Intel compilers
  echo $PASSWD | sudo -S apt -y install intel-basekit intel-hpckit intel-aikit
  echo $PASSWD | sudo -S apt -y update


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
  ############################# CPU Core Management ####################################

  export CPU_CORE=$(nproc)                                   # number of available threads on system
  export CPU_6CORE="6"
  export CPU_HALF=$(($CPU_CORE / 2))                         # half of availble cores on system
  # Forces CPU cores to even number to avoid partial core export. ie 7 cores would be 3.5 cores.
  export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))

  # If statement for low core systems.  Forces computers to only use 1 core if there are 4 cores or less on the system.
  if [ $CPU_CORE -le $CPU_6CORE ]
  then
    export CPU_HALF_EVEN="2"
  else
    export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))
  fi

  echo "##########################################"
  echo "Number of Threads being used $CPU_HALF_EVEN"
  echo "##########################################"

  echo " "
  ##############################Directory Listing############################
  export HOME=`cd;pwd`

  mkdir $HOME/WRFHYDRO_STANDALONE_INTEL
  export WRFHYDRO_FOLDER=$HOME/WRFHYDRO_STANDALONE_INTEL
  cd $WRFHYDRO_FOLDER/
  mkdir Downloads
  mkdir Libs
  export DIR=$WRFHYDRO_FOLDER/Libs
  mkdir Libs/grib2
  mkdir Libs/NETCDF
  mkdir Libs/MPICH
  echo " "
  ##############################Downloading Libraries############################
  cd Downloads
  wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz
  wget -c -4 https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_2.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz
  wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.39.tar.gz
  wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip



  echo " "

  #############################zlib############################
  #Uncalling compilers due to comfigure issue with zlib1.2.12
  #With CC & CXX definied ./configure uses different compiler Flags

  cd $WRFHYDRO_FOLDER/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/
    CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  echo " "
  #############################libpng############################
  cd $WRFHYDRO_FOLDER/Downloads
  export LDFLAGS=-L$DIR/grib2/lib
  export CPPFLAGS=-I$DIR/grib2/include
  tar -xvzf libpng-1.6.39.tar.gz
  cd libpng-1.6.39/
    CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check
  echo " "
  #############################JasPer############################
  cd $WRFHYDRO_FOLDER/Downloads
  unzip jasper-1.900.1.zip
  cd jasper-1.900.1/
  autoreconf -i
    CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check
  export JASPERLIB=$DIR/grib2/lib
  export JASPERINC=$DIR/grib2/include

  echo " "

  #############################hdf5 library for netcdf4 functionality############################
  cd $WRFHYDRO_FOLDER/Downloads
  tar -xvzf hdf5-1_13_2.tar.gz
  cd hdf5-hdf5-1_13_2
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2  --enable-hl --enable-fortran --enable-parallel
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  export HDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
  export PHDF5=$DIR/grib2
  echo " "

  #############################Install Parallel-netCDF##############################
#Make file created with half of available cpu cores
#Hard path for MPI added
##################################################################################
cd $WRFHYDRO_FOLDER/Downloads
wget -c -4  https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz
tar -xvzf pnetcdf-1.12.3.tar.gz
cd pnetcdf-1.12.3
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2  --enable-shared --enable-static

make -j $CPU_HALF_EVEN
make -j $CPU_HALF_EVEN install
#make check

export PNETCDF=$DIR/grib2



  ##############################Install NETCDF C Library############################
  cd $WRFHYDRO_FOLDER/Downloads
  tar -xzvf v4.9.0.tar.gz
  cd netcdf-c-4.9.0/
  export CPPFLAGS=-I$DIR/grib2/include
  export LDFLAGS=-L$DIR/grib2/lib
  export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lgfortran -lgcc -lm -ldl"
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/NETCDF --with-zlib=$DIR/grib2 --disable-dap --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-pnetcdf --enable-cdf5 --enable-parallel-tests
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  export PATH=$DIR/NETCDF/bin:$PATH
  export NETCDF=$DIR/NETCDF

  echo " "
  ##############################NetCDF fortran library############################
  cd $WRFHYDRO_FOLDER/Downloads
  tar -xvzf v4.6.0.tar.gz
  cd netcdf-fortran-4.6.0/
  export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
  export CPPFLAGS="-I$DIR/NETCDF/include -I$DIR/grib2/include"
  export LDFLAGS="-L$DIR/NETCDF/lib -L$DIR/grib2/lib"
  export LIBS="-lnetcdf -pnetcdf -lm -lcurl -lhdf5_hl -lhdf5 -lz -ldl"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-parallel-tests --enable-hdf5
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check


  echo " "


  #################################### System Environment Tests ##############
  mkdir -p $WRFHYDRO_FOLDER/Tests/Environment
  mkdir -p $WRFHYDRO_FOLDER/Tests/Compatibility


  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar


  tar -xvf Fortran_C_tests.tar -C $WRFHYDRO_FOLDER/Tests/Environment
  tar -xvf Fortran_C_NETCDF_MPI_tests.tar -C $WRFHYDRO_FOLDER/Tests/Compatibility
  export one="1"
  echo " "
  ############## Testing Environment #####

  cd $WRFHYDRO_FOLDER/Tests/Environment

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

  cd $WRFHYDRO_FOLDER/Tests/Compatibility

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
  mpiifort -c 02_fortran+c+netcdf+mpi_f.f
  mpiicc -c 02_fortran+c+netcdf+mpi_c.c
  mpiifort 02_fortran+c+netcdf+mpi_f.o \
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




  ############################# WRF HYDRO V5.2.0 #################################
  # Version 5.2.0
  # Standalone mode
  # GNU
  ################################################################################

  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4  https://github.com/NCAR/wrf_hydro_nwm_public/archive/refs/tags/v5.2.0.tar.gz -O WRFHYDRO.5.2.tar.gz
  tar -xvzf WRFHYDRO.5.2.tar.gz -C $WRFHYDRO_FOLDER/


  #Modifying WRF-HYDRO Environment
  #Echo commands use due to lack of knowledge
  cd $WRFHYDRO_FOLDER/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS/template

  sed -i 's/SPATIAL_SOIL=0/SPATIAL_SOIL=1/g' setEnvar.sh
  echo " " >> setEnvar.sh
  echo "# Large netcdf file support: 0=Off, 1=On." >> setEnvar.sh
  echo "export WRFIO_NCD_LARGE_FILE_SUPPORT=1" >> setEnvar.sh
  ln setEnvar.sh $WRFHYDRO_FOLDER/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS

  #Configure & Compile WRF HYDRO in Standalone Mode
  #Compile WRF-Hydro offline with the NoahMP
  cd $WRFHYDRO_FOLDER/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS
  source setEnvar.sh

  echo 3 | ./configure

  sed -i '63s/mpif90/mpiifort/g' $WRFHYDRO_FOLDER/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS/macros

  ./compile_offline_NoahMP.sh setEnvar.sh

  ls -lah Run/*.exe  #Test to see if .exe files have compiled


  echo " "
  ######################### Testing WRF HYDRO Compliation #########################
  cd $WRFHYDRO_FOLDER/
  mkdir -p $WRFHYDRO_FOLDER/domain/NWM

  #Copy the *.TBL files to the NWM directory.
  cp wrf_hydro_nwm_public*/trunk/NDHMS/Run/*.TBL domain/NWM
  #Copy the wrf_hydro.exe file to the NWM directory.
  cp wrf_hydro_nwm_public*/trunk/NDHMS/Run/wrf_hydro.exe domain/NWM

  #Download test case for WRF HYDRO and move to NWM
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4  https://github.com/NCAR/wrf_hydro_nwm_public/releases/download/v5.2.0/croton_NY_training_example_v5.2.tar.gz
  tar -xzvf croton_NY_training_example_v5.2.tar.gz

  cp -r example_case/FORCING $WRFHYDRO_FOLDER/domain/NWM
  cp -r example_case/NWM/DOMAIN $WRFHYDRO_FOLDER/domain/NWM
  cp -r example_case/NWM/RESTART $WRFHYDRO_FOLDER/domain/NWM
  cp -r example_case/NWM/nudgingTimeSliceObs $WRFHYDRO_FOLDER/domain/NWM
  cp -r example_case/NWM/referenceSim $WRFHYDRO_FOLDER/domain/NWM
  cp example_case/NWM/namelist.hrldas $WRFHYDRO_FOLDER/domain/NWM
  cp example_case/NWM/hydro.namelist $WRFHYDRO_FOLDER/domain/NWM

  #Run Croton NY Test Case
  cd $WRFHYDRO_FOLDER/domain/NWM
  ./wrf_hydro.exe
  ls -lah HYDRO_RST*
  echo "IF HYDRO_RST files exist and have data then wrf_hydro.exe sucessful"
  echo " "

  ########################### Test script for output data  ###################################

  #Installing Miniconda3 to WRF directory and updating libraries
  export Miniconda_Install_DIR=$WRFHYDRO_FOLDER/miniconda3

  mkdir -p $Miniconda_Install_DIR


  wget -c -4 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $Miniconda_Install_DIR/miniconda.sh

  bash $Miniconda_Install_DIR/miniconda.sh -b -u -p $Miniconda_Install_DIR

  rm -rf $Miniconda_Install_DIR/miniconda.sh

  export PATH=$WRFHYDRO_FOLDER/miniconda3/bin:$PATH

  source $Miniconda_Install_DIR/etc/profile.d/conda.sh

  $Miniconda_Install_DIR/bin/conda init bash
  $Miniconda_Install_DIR/bin/conda init zsh
  $Miniconda_Install_DIR/bin/conda init tcsh
  $Miniconda_Install_DIR/bin/conda init xonsh
  $Miniconda_Install_DIR/bin/conda init powershell

  conda config --add channels conda-forge
  conda config --set auto_activate_base false
  conda update -n root --all -y


  export $PATH

  ##################### WRF Python           ##################
  ########### WRf-Python compiled via Conda  ##################
  ########### This is the preferred method by NCAR      ##################
  ##### https://wrf-python.readthedocs.io/en/latest/installation.html  ##################
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n wrf-python -c conda-forge wrf-python -y
  conda activate wrf-python
  conda update -n wrf-python --all -y
  conda activate wrf-python
  conda install -c conda-forge matplotlib -y
  conda install -c conda-forge NETCDF4 -y

  ################ NEEDS TO BE IN Master folder #######################
  cp  $HOME/WRF-MASTER/SurfaceRunoff.py $WRFHYDRO_FOLDER/domain/NWM


  cd $WRFHYDRO_FOLDER/domain/NWM

  python3 SurfaceRunoff.py

  okular SurfaceRunoff.pdf


  echo " "
  #####################################BASH Script Finished##############################
  echo "WRF HYDRO Standalone sucessfully configured and compiled"
  read -r -t 5 -p "Congratulations! You've successfully installed all required files to run the Weather Research Forecast Model HYDRO verison 5.2."

  ##########################  Export PATH and LD_LIBRARY_PATH ################################
  cd $HOME



fi



################################### WRF Hydro Coupled ##############
## WRFHYDRO Coupled installation with parallel process.
# Download and install required library and data files for WRFHYDRO Coupled.
# Tested in Ubuntu 20.04.4 LTS & Ubuntu 22.04 & MacOS Ventura 64bit
# Built in 64-bit system
# Built with Intel or GNU compilers
# Tested with current available libraries on 01/01/2023
# If newer libraries exist edit script paths for changes
#Estimated Run Time ~ 90 - 150 Minutes with 10mb/s downloadspeed.
# Special thanks to:
# Youtube's meteoadriatic, GitHub user jamal919.
# University of Manchester's  Doug L
# University of Tunis El Manar's Hosni
# GSL's Jordan S.
# NCAR's Mary B., Christine W., & Carl D.
# DTC's Julie P., Tara J., George M., & John H.
# UCAR's Katelyn F., Jim B., Jordan P., Kevin M.,
##############################################################




if [ "$Ubuntu_64bit_GNU" = "1" ] && [ "$WRFHYDRO_COUPLED_PICK" = "1" ]; then



  #############################basic package managment############################
  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade
  echo $PASSWD | sudo -S apt -y install apt gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh tcsh okular cmake time xorg openbox xauth git python3 python3-dev python2 python2-dev mlocate curl libcurl4-openssl-dev pkg-config build-essential
  echo " "
  ##############################Directory Listing############################
  export HOME=`cd;pwd`
  mkdir $HOME/WRFHYDRO_COUPLED
  export WRFHYDRO_FOLDER=$HOME/WRFHYDRO_COUPLED
  export DIR=$WRFHYDRO_FOLDER/Libs
  cd $WRFHYDRO_FOLDER/
  mkdir Downloads
  mkdir $WRFHYDRO_FOLDER/Hydro-Basecode
  mkdir Libs
  export DIR=$WRFHYDRO_FOLDER/Libs
  mkdir Libs/grib2
  mkdir Libs/NETCDF
  mkdir Libs/MPICH
  mkdir -p Tests/Environment
  mkdir -p Tests/Compatibility

  echo " "
  #############################Core Management####################################

  export CPU_CORE=$(nproc)                                             # number of available threads on system
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
  echo "Number of Threads being used $CPU_HALF_EVEN"
  echo "##########################################"

  echo " "
  ##############################Downloading Libraries############################
  cd Downloads
  wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz
  wget -c -4 https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_2.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz
  wget -c -4 https://github.com/pmodels/mpich/releases/download/v4.0.3/mpich-4.0.3.tar.gz
  wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.39.tar.gz
  wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
  wget -c -4 https://sourceforge.net/projects/opengrads/files/grads2/2.2.1.oga.1/Linux%20%2864%20Bits%29/opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz



  echo " "
  #############################Compilers############################
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


  echo " "
  #############################zlib############################
  #Uncalling compilers due to comfigure issue with zlib1.2.13
  #With CC & CXX definied ./configure uses different compiler Flags

  cd $WRFHYDRO_FOLDER/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/
  ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  echo " "
  ##############################MPICH############################
  cd $WRFHYDRO_FOLDER/Downloads
  tar -xvzf mpich-4.0.3.tar.gz
  cd mpich-4.0.3/
  F90= ./configure --prefix=$DIR/MPICH --with-device=ch3 FFLAGS="$fallow_argument -m64" FCFLAGS="$fallow_argument -m64"

  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check


  export PATH=$DIR/MPICH/bin:$PATH

  export MPIFC=$DIR/MPICH/bin/mpifort
  export MPIF77=$DIR/MPICH/bin/mpifort
  export MPIF90=$DIR/MPICH/bin/mpifort
  export MPICC=$DIR/MPICH/bin/mpicc
  export MPICXX=$DIR/MPICH/bin/mpicxx


  echo " "
  #############################libpng############################
  cd $WRFHYDRO_FOLDER/Downloads
  export LDFLAGS=-L$DIR/grib2/lib
  export CPPFLAGS=-I$DIR/grib2/include
  tar -xvzf libpng-1.6.39.tar.gz
  cd libpng-1.6.39/
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check
  echo " "
  #############################JasPer############################
  cd $WRFHYDRO_FOLDER/Downloads
  unzip jasper-1.900.1.zip
  cd jasper-1.900.1/
  autoreconf -i
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  export JASPERLIB=$DIR/grib2/lib
  export JASPERINC=$DIR/grib2/include


  echo " "
  #############################hdf5 library for netcdf4 functionality############################
  cd $WRFHYDRO_FOLDER/Downloads
  tar -xvzf hdf5-1_13_2.tar.gz
  cd hdf5-hdf5-1_13_2
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran --enable-parallel
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  export HDF5=$DIR/grib2
  export PHDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH


  #############################Install Parallel-netCDF##############################
  #Make file created with half of available cpu cores
  #Hard path for MPI added
  ##################################################################################
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4  https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz
  tar -xvzf pnetcdf-1.12.3.tar.gz
  cd pnetcdf-1.12.3
  export MPIFC=$DIR/MPICH/bin/mpifort
  export MPIF77=$DIR/MPICH/bin/mpifort
  export MPIF90=$DIR/MPICH/bin/mpifort
  export MPICC=$DIR/MPICH/bin/mpicc
  export MPICXX=$DIR/MPICH/bin/mpicxx
  ./configure --prefix=$DIR/grib2  --enable-shared --enable-static

  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  export PNETCDF=$DIR/grib2

  ##############################Install NETCDF C Library############################
  cd $WRFHYDRO_FOLDER/Downloads
  tar -xzvf v4.9.0.tar.gz
  cd netcdf-c-4.9.0/
  export CPPFLAGS=-I$DIR/grib2/include
  export LDFLAGS=-L$DIR/grib2/lib
  export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lgfortran -lgcc -lm -ldl"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --disable-dap --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-pnetcdf --enable-cdf5 --enable-parallel-tests
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  export PATH=$DIR/NETCDF/bin:$PATH
  export NETCDF=$DIR/NETCDF
  echo " "
  ##############################NetCDF fortran library############################
  cd $WRFHYDRO_FOLDER/Downloads
  tar -xvzf v4.6.0.tar.gz
  cd netcdf-fortran-4.6.0/
  export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
  export CPPFLAGS="-I$DIR/NETCDF/include -I$DIR/grib2/include"
  export LDFLAGS="-L$DIR/NETCDF/lib -L$DIR/grib2/lib"
  export LIBS="-lnetcdf -lpnetcdf -lcurl -lhdf5_hl -lhdf5 -lz -lm -ldl -lgcc -lgfortran"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-parallel-tests --enable-hdf5
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  echo " "

  #################################### System Environment Tests ##############

  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar


  tar -xvf Fortran_C_tests.tar -C $WRFHYDRO_FOLDER/Tests/Environment
  tar -xvf Fortran_C_NETCDF_MPI_tests.tar -C $WRFHYDRO_FOLDER/Tests/Compatibility
  export one="1"
  echo " "
  ############## Testing Environment #####

  cd $WRFHYDRO_FOLDER/Tests/Environment

    cp ${NETCDF}/include/netcdf.inc .

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

  cd $WRFHYDRO_FOLDER/Tests/Compatibility

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



  ###############################NCEPlibs#####################################
  #The libraries are built and installed with
  # ./make_ncep_libs.sh -s MACHINE -c COMPILER -d NCEPLIBS_DIR -o OPENMP [-m mpi] [-a APPLICATION]
  #It is recommended to install the NCEPlibs into their own directory, which must be created before running the installer. Further information on the command line arguments can be obtained with
  # ./make_ncep_libs.sh -h

  #If iand error occurs go to https://github.com/NCAR/NCEPlibs/pull/16/files make adjustment and re-run ./make_ncep_libs.sh
  ############################################################################


  cd $WRFHYDRO_FOLDER/Downloads
  git clone https://github.com/NCAR/NCEPlibs.git
  cd NCEPlibs
  mkdir $DIR/nceplibs


  export JASPER_INC=$DIR/grib2/include
  export PNG_INC=$DIR/grib2/include
  export NETCDF=$DIR/NETCDF

  #for loop to edit linux.gnu for nceplibs to install
  #make if statement for gcc-9 or older
  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
  then
    y="24 28 32 36 40 45 49 53 56 60 64 68 69 73 74 79"
    for X in $y; do
      sed -i "${X}s/= /= $fallow_argument $boz_argument /g" $WRFHYDRO_FOLDER/Downloads/NCEPlibs/macros.make.linux.gnu
    done
  else
    echo ""
    echo "Loop not needed"
  fi

  if [ ${auto_config} -eq 1 ]
    then
      echo yes | ./make_ncep_libs.sh -s linux -c gnu -d $DIR/nceplibs -o 0 -m 1 -a upp
    else
      ./make_ncep_libs.sh -s linux -c gnu -d $DIR/nceplibs -o 0 -m 1 -a upp
  fi

  export PATH=$DIR/nceplibs:$PATH

  echo " "
  ################################UPPv4.1######################################
  #Previous verison of UPP
  #WRF Support page recommends UPPV4.1 due to too many changes to WRF and UPP code
  #since the WRF was written
  #Option 8 gfortran compiler with distributed memory
  #############################################################################
  cd $WRFHYDRO_FOLDER/
  git clone -b dtc_post_v4.1.0 --recurse-submodules https://github.com/NOAA-EMC/EMC_post UPPV4.1
  cd UPPV4.1
  mkdir postprd
  export NCEPLIBS_DIR=$DIR/nceplibs
  export NETCDF=$DIR/NETCDF

  if [ ${auto_config} -eq 1 ]
    then
      echo 8 | ./configure  #Option 8 gfortran compiler with distributed memory
    else
      ./configure  #Option 8 gfortran compiler with distributed memory
  fi

  echo " "
  #make if statement for gcc-9 or older
  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
  then
    z="58 63"
    for X in $z; do
      sed -i "${X}s/(FOPT)/(FOPT) $fallow_argument $boz_argument  /g" $WRFHYDRO_FOLDER/UPPV4.1/configure.upp
    done
  else
    echo ""
    echo "Loop not needed"
  fi


  ./compile | tee upp_compile.log
  cd $WRFHYDRO_FOLDER/UPPV4.1/scripts
  chmod +x run_unipost




  echo " "
  ######################## ARWpost V3.1  ############################
  ## ARWpost
  ##Configure #3
  ###################################################################
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz
  tar -xvzf ARWpost_V3.tar.gz -C $WRFHYDRO_FOLDER/
  cd $WRFHYDRO_FOLDER/ARWpost
  ./clean -a
  sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $WRFHYDRO_FOLDER/ARWpost/src/Makefile
  export NETCDF=$DIR/NETCDF

  if [ ${auto_config} -eq 1 ]
    then
      echo 3 | ./configure  #Option 3 gfortran compiler with distributed memory
    else
      ./configure  #Option 3 gfortran compiler with distributed memory
  fi


  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
  then
    sed -i '32s/-ffree-form -O -fno-second-underscore -fconvert=big-endian -frecord-marker=4/-ffree-form -O -fno-second-underscore -fconvert=big-endian -frecord-marker=4 ${fallow_argument} /g' configure.arwp
  fi


  sed -i -e 's/-C -P -traditional/-P -traditional/g' $WRFHYDRO_FOLDER/ARWpost/configure.arwp
  ./compile


  export PATH=$WRFHYDRO_FOLDER/ARWpost/ARWpost.exe:$PATH

  echo " "
  ################################OpenGrADS######################################
  #Verison 2.2.1 64bit of Linux
  #############################################################################
  cd $WRFHYDRO_FOLDER/Downloads
  tar -xzvf opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz -C $WRFHYDRO_FOLDER/
  cd $WRFHYDRO_FOLDER/
  mv $WRFHYDRO_FOLDER/opengrads-2.2.1.oga.1  $WRFHYDRO_FOLDER/GrADS
  cd GrADS/Contents
  wget -c -4 https://github.com/regisgrundig/SIMOP/blob/master/g2ctl.pl
  chmod +x g2ctl.pl
  wget -c -4 https://sourceforge.net/projects/opengrads/files/wgrib2/0.1.9.4/wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
  tar -xzvf wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
  cd wgrib2-v0.1.9.4/bin
  mv wgrib2 $WRFHYDRO_FOLDER/GrADS/Contents
  cd $WRFHYDRO_FOLDER/GrADS/Contents
  rm wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
  rm -r wgrib2-v0.1.9.4


  export PATH=$WRFHYDRO_FOLDER/GrADS/Contents:$PATH

  echo " "
  ##################### NCAR COMMAND LANGUAGE           ##################
  ########### NCL compiled via Conda                    ##################
  ########### This is the preferred method by NCAR      ##################
  ########### https://www.ncl.ucar.edu/index.shtml      ##################

  #Installing Miniconda3 to WRF-Hydro directory and updating libraries

  export Miniconda_Install_DIR=$WRFHYDRO_FOLDER/miniconda3

  mkdir -p $Miniconda_Install_DIR

  wget -c -4 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $Miniconda_Install_DIR/miniconda.sh
  bash $Miniconda_Install_DIR/miniconda.sh -b -u -p $Miniconda_Install_DIR

  rm -rf $Miniconda_Install_DIR/miniconda.sh

  export PATH=$WRFHYDRO_FOLDER/miniconda3/bin:$PATH

  source $Miniconda_Install_DIR/etc/profile.d/conda.sh

  $Miniconda_Install_DIR/bin/conda init bash
  $Miniconda_Install_DIR/bin/conda init zsh
  $Miniconda_Install_DIR/bin/conda init tcsh
  $Miniconda_Install_DIR/bin/conda init xonsh
  $Miniconda_Install_DIR/bin/conda init powershell

  conda config --add channels conda-forge
  conda config --set auto_activate_base false
  conda update -n root --all -y


  export $PATH


  echo " "


  echo " "
  #Installing NCL via Conda
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n ncl_stable -c conda-forge ncl -y
  conda activate ncl_stable
  conda update -n ncl_stable --all -y
  conda deactivate
  conda deactivate
  conda deactivate

  echo " "

  ############################OBSGRID###############################
  ## OBSGRID
  ## Downloaded from git tagged releases
  ## Option #2
  ########################################################################
  cd $WRFHYDRO_FOLDER/
  git clone https://github.com/wrf-model/OBSGRID.git
  cd $WRFHYDRO_FOLDER/OBSGRID

  ./clean -a
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate ncl_stable


  export HOME=`cd;pwd`
  export DIR=$WRFHYDRO_FOLDER/Libs
  export NETCDF=$DIR/NETCDF

  if [ ${auto_config} -eq 1 ]
    then
        echo 2 | ./configure #Option 2 for gfortran/gcc and distribunted memory
      else
        ./configure   #Option 2 for gfortran/gcc and distribunted memory
    fi




    sed -i '27s/-lnetcdf -lnetcdff/ -lnetcdff -lnetcdf/g' configure.oa

    sed -i '31s/-lncarg -lncarg_gks -lncarg_c -lX11 -lm -lcairo/-lncarg -lncarg_gks -lncarg_c -lX11 -lm -lcairo -lfontconfig -lpixman-1 -lfreetype -lhdf5 -lhdf5_hl /g' configure.oa

    sed -i '39s/-frecord-marker=4/-frecord-marker=4 ${fallow_argument} /g' configure.oa

    sed -i '44s/=	/=	${fallow_argument} /g' configure.oa

    sed -i '45s/-C -P -traditional/-P -traditional/g' configure.oa


    echo " "

  ./compile

  conda deactivate
  conda deactivate
  conda deactivate
  # IF statement to check that all files were created.
   cd $WRFHYDRO_FOLDER/OBSGRID
   n=$(ls ./*.exe | wc -l)
   if (( $n == 3 ))
    then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing OBSGRID. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi

  echo " "
  ############################## RIP4 #####################################
  mkdir $WRFHYDRO_FOLDER/RIP4
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/RIP_47.tar.gz
  tar -xvzf RIP_47.tar.gz -C $WRFHYDRO_FOLDER/RIP4
  cd $WRFHYDRO_FOLDER/RIP4/RIP_47
  mv * ..
  cd $WRFHYDRO_FOLDER/RIP4
  rm -rd RIP_47
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda activate ncl_stable
  conda install -c conda-forge ncl c-compiler fortran-compiler cxx-compiler -y


  export RIP_ROOT=$WRFHYDRO_FOLDER/RIP4
  export NETCDF=$DIR/NETCDF
  export NCARG_ROOT=$WRFHYDRO_FOLDER/miniconda3/envs/ncl_stable


  sed -i '349s|-L${NETCDF}/lib -lnetcdf $NETCDFF|-L${NETCDF}/lib $NETCDFF -lnetcdff -lnetcdf -lnetcdf -lnetcdff_C -lhdf5 |g' $WRFHYDRO_FOLDER/RIP4/configure

  sed -i '27s|NETCDFLIB	= -L${NETCDF}/lib -lnetcdf CONFIGURE_NETCDFF_LIB|NETCDFLIB	= -L</usr/lib/x86_64-linux-gnu/libm.a> -lm -L${NETCDF}/lib CONFIGURE_NETCDFF_LIB -lnetcdf -lhdf5 -lhdf5_hl -lgfortran -lgcc -lz |g' $WRFHYDRO_FOLDER/RIP4/arch/preamble

  sed -i '31s|-L${NCARG_ROOT}/lib -lncarg -lncarg_gks -lncarg_c -lX11 -lXext -lpng -lz CONFIGURE_NCARG_LIB| -L${NCARG_ROOT}/lib -lncarg -lncarg_gks -lncarg_c -lX11 -lXext -lpng -lz -lcairo -lfontconfig -lpixman-1 -lfreetype -lexpat -lpthread -lbz2 -lXrender -lgfortran -lgcc -L</usr/lib/x86_64-linux-gnu/> -lm -lhdf5 -lhdf5_hl |g' $WRFHYDRO_FOLDER/RIP4/arch/preamble

  sed -i '33s| -O|-fallow-argument-mismatch -O |g' $WRFHYDRO_FOLDER/RIP4/arch/configure.defaults

  sed -i '35s|=|= -L$WRFHYDRO_FOLDER/LIBS/grib2/lib -lhdf5 -lhdf5_hl |g' $WRFHYDRO_FOLDER/RIP4/arch/configure.defaults

  if [ ${auto_config} -eq 1 ]
    then
      echo 3 | ./configure  #Option 3 gfortran compiler with distributed memory
    else
      ./configure  #Option 3 gfortran compiler with distributed memory
  fi

  ./compile


  conda deactivate
  conda deactivate
  conda deactivate
  # IF statement to check that all files were created.
   cd $WRFHYDRO_FOLDER/RIP4
   n=$(find . -type l -ls | wc -l)
   if (( $n == 12 ))
      then
        echo "All expected files created."
        read -r -t 5 -p "Finished installing RIP4. I am going to wait for 5 seconds only ..."
      else
        echo "Missing one or more expected files. Exiting the script."
        read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
        exit
   fi

  echo " "



  echo " "
  ##################### WRF Python           ##################
  ########### WRf-Python compiled via Conda  ##################
  ########### This is the preferred method by NCAR      ##################
  ##### https://wrf-python.readthedocs.io/en/latest/installation.html  ##################
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n wrf-python -c conda-forge wrf-python -y
  conda activate wrf-python
  conda update -n wrf-python --all -y
  conda deactivate
  conda deactivate
  conda deactivate

  echo " "
  ########################## WRF Hydro GIS PreProcessor ##############################
  #  Compiled with Conda
  #  https://github.com/NCAR/wrf_hydro_gis_preprocessor
  ####################################################################################

  conda init bash
  conda activate base
  conda config --add channels conda-forge
  conda create -n wrfh_gis_env -c conda-forge python=3.6 gdal netCDF4 numpy pyproj whitebox=1.5.0 -y
  conda activate wrfh_gis_env
  conda update -n wrfh_gis_env --all -y
  conda deactivate
  conda deactivate
  conda deactivate
  cd $WRFHYDRO_FOLDER/
  git clone https://github.com/NCAR/wrf_hydro_gis_preprocessor.git  $WRFHYDRO_FOLDER/WRF-Hydro-GIS-PreProcessor

  echo " "
  ############################# WRF HYDRO V5.2.0 #################################
  # Version 5.2.0
  # Standalone mode
  ################################################################################
  export NETCDF_INC=$DIR/NETCDF/include
  export NETCDF_LIB=$DIR/NETCDF/lib
  mkdir
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://github.com/NCAR/wrf_hydro_nwm_public/archive/refs/tags/v5.2.0.tar.gz -O WRFHYDRO.5.2.tar.gz
  tar -xvzf WRFHYDRO.5.2.tar.gz -C $WRFHYDRO_FOLDER/Hydro-Basecode


  #Modifying WRF-HYDRO Environment
  #Echo commands use due to lack of knowledge
  cd $WRFHYDRO_FOLDER/Hydro-Basecode/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS/template

  sed -i 's/SPATIAL_SOIL=0/SPATIAL_SOIL=1/g' setEnvar.sh                      # Spatially distributed parameters for NoahMP: 0=Off, 1=On.
  sed -i 's/WRF_HYDRO_NUDGING=0/WRF_HYDRO_NUDGING=1/g' setEnvar.sh                     # Streamflow nudging: 0=Off, 1=On.
  echo " " >> setEnvar.sh
  echo "# Large netcdf file support: 0=Off, 1=On." >> setEnvar.sh
  echo "export WRFIO_NCD_LARGE_FILE_SUPPORT=1" >> setEnvar.sh
  cp -r setEnvar.sh $WRFHYDRO_FOLDER/Hydro-Basecode/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS

  cd $WRFHYDRO_FOLDER/Hydro-Basecode/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS


  if [ ${auto_config} -eq 1 ]
    then
      echo 2 | ./configure
    else
      ./configure  #option 2 for gfortran
  fi

  ./compile_offline_NoahMP.sh setEnvar.sh | tee noahmp.log


  read -r -t 5 -p "I am going to wait for 5 seconds only ..."
  echo " "
  ############################ WRF 4.4.2  #################################
  ## WRF v4.4.2
  ## Downloaded from git tagged releases
  # option 34, option 1 for gfortran and distributed memory w/basic nesting
  # large file support enable with WRFiO_NCD_LARGE_FILE_SUPPORT=1
  # In the namelist.input, the following settings support pNetCDF by setting value to 11:
  # io_form_boundary
  # io_form_history
  # io_form_auxinput2
  # io_form_auxhist2
  # Note that you need set nocolons = .true. in the section &time_control of namelist.input
  ########################################################################
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz -O WRF-4.4.2.tar.gz
  tar -xvzf WRF-4.4.2.tar.gz -C $WRFHYDRO_FOLDER/
  cd $WRFHYDRO_FOLDER/WRFV4.4.2
  export WRFIO_NCD_LARGE_FILE_SUPPORT=1

  #Replace old version of WRF-Hydro distributed with WRF with updated WRF-Hydro source code
  rm -r $WRFHYDRO_FOLDER/WRFV4.4.2/hydro/
  cp -r $WRFHYDRO_FOLDER/Hydro-Basecode/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS $WRFHYDRO_FOLDER/WRFV4.4.2/hydro

  cd $WRFHYDRO_FOLDER/WRFV4.4.2/hydro
  source setEnvar.sh
  cd $WRFHYDRO_FOLDER/WRFV4.4.2

  ./clean

  # SED statements to fix configure error
  sed -i '186s/==/=/g' $WRFHYDRO_FOLDER/WRFV4.4.2/configure
  sed -i '318s/==/=/g' $WRFHYDRO_FOLDER/WRFV4.4.2/configure
  sed -i '919s/==/=/g' $WRFHYDRO_FOLDER/WRFV4.4.2/configure


  if [ ${auto_config} -eq 1 ]
    then
        sed -i '428s/.*/  $response = "34 \\n";/g' $WRFHYDRO_FOLDER/WRFV4.4.2/arch/Config.pl # Answer for compiler choice
        sed -i '869s/.*/  $response = "1 \\n";/g' $WRFHYDRO_FOLDER/WRFV4.4.2/arch/Config.pl  #Answer for basic nesting
        ./configure
    else
      ./configure  #Option 34 gfortran compiler with distributed memory option 1 for basic nesting
  fi

  ./compile -j $CPU_HALF_EVEN em_real

  export WRF_DIR=$WRFHYDRO_FOLDER/WRFV4.4.2

  # IF statement to check that all files were created.
  cd $WRFHYDRO_FOLDER/WRFV4.4.2/main
  n=$(ls ./*.exe | wc -l)
  if (($n >= 3))
   then
   echo "All expected files created."
   read -r -t 5 -p "Finished installing WRF. I am going to wait for 5 seconds only ..."
  else
   echo "Missing one or more expected files. Exiting the script."
   read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
   exit
  fi

  echo " "
  ############################WPSV4.4#####################################
  ## WPS v4.4
  ## Downloaded from git tagged releases
  #Option 3 for gfortran and distributed memory
  ########################################################################

  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WPS/archive/refs/tags/v4.4.tar.gz -O WPS-4.4.tar.gz
  tar -xvzf WPS-4.4.tar.gz -C $WRFHYDRO_FOLDER/
  cd $WRFHYDRO_FOLDER/WPS-4.4
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        echo 3 | ./configure #Option 3 for gfortran and distributed memory
      else
        ./configure  #Option 3 gfortran compiler with distributed memory
    fi
  ./compile


  echo " "
  # IF statement to check that all files were created.
   cd $WRFHYDRO_FOLDER/WPS-4.4
   n=$(ls ./*.exe | wc -l)
   if (($n == 3))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing WPS. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
   fi

  echo " "



################## WPS Domain Setup Tools ########################
  ## DomainWizard
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 http://esrl.noaa.gov/gsd/wrfportal/domainwizard/WRFDomainWizard.zip
  mkdir $WRFHYDRO_FOLDER/WRFDomainWizard
  unzip WRFDomainWizard.zip -d $WRFHYDRO_FOLDER/WRFDomainWizard
  chmod +x $WRFHYDRO_FOLDER/WRFDomainWizard/run_DomainWizard

  echo " "
  ######################## WPF Portal Setup Tools ########################
  ## WRFPortal
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://esrl.noaa.gov/gsd/wrfportal/portal/wrf-portal.zip
  mkdir $WRFHYDRO_FOLDER/WRFPortal
  unzip wrf-portal.zip -d $WRFHYDRO_FOLDER/WRFPortal
  chmod +x $WRFHYDRO_FOLDER/WRFPortal/runWRFPortal



  echo " "
  ######################## Static Geography Data inc/ Optional ####################
  # http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  # These files are large so if you only need certain ones comment the others off
  # All files downloaded and untarred is 200GB
  # https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  #################################################################################
  cd $WRFHYDRO_FOLDER/Downloads
  mkdir $WRFHYDRO_FOLDER/GEOG
  mkdir $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

  echo " "
  echo "Mandatory WRF Preprocessing System (WPS) Geographical Input Data Mandatory Fields Downloads"
  echo " "
  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
  tar -xvzf geog_high_res_mandatory.tar.gz -C $WRFHYDRO_FOLDER/GEOG/

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz
  tar -xvzf geog_low_res_mandatory.tar.gz -C $WRFHYDRO_FOLDER/GEOG/
  mv $WRFHYDRO_FOLDER/GEOG/WPS_GEOG_LOW_RES/ $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

  if [ ${WPS_Specific_Applications} -eq 1 ]
    then
      echo " "
      echo " WPS Geographical Input Data Mandatory for Specific Applications"
      echo " "
      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
      tar -xvzf geog_thompson28_chem.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
      tar -xvzf geog_noahmp.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4  https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
      tar -xvzf irrigation.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
      tar -xvzf geog_px.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
      tar -xvzf geog_urban.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
      tar -xvzf geog_ssib.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
      tar -xvf lake_depth.tar.bz2 -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/topobath_30s.tar.bz2
      tar -xvf topobath_30s.tar.bz2 -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG


      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/gsl_gwd.tar.bz2
      tar -xvf gsl_gwd.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG
      fi


  if [ ${Optional_GEOG} -eq 1 ]
    then
      echo " "
      echo "Optional WPS Geographical Input Data"
      echo " "


      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_older_than_2000.tar.gz
      tar -xvzf geog_older_than_2000.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s_with_lakes.tar.gz
      tar -xvzf modis_landuse_20class_15s_with_lakes.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_alt_lsm.tar.gz
      tar -xvzf geog_alt_lsm.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/nlcd2006_ll_9s.tar.bz2
      tar -xvf nlcd2006_ll_9s.tar.bz2 -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/updated_Iceland_LU.tar.gz
      tar -xvf updated_Iceland_LU.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s.tar.bz2
      tar -xvf modis_landuse_20class_15s.tar.bz2 -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG


  fi



fi

if [ "$Ubuntu_64bit_Intel" = "1" ] && [ "$WRFHYDRO_COUPLED_PICK" = "1" ]; then


  ############################# Basic package managment ############################

  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade

  # download the key to system keyring; this and the following echo command are
  # needed in order to install the Intel compilers
  wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
  | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null


  # add signed entry to apt sources and configure the APT client to use Intel repository:
  echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list

  # this update should get the Intel package info from the Intel repository
  echo $PASSWD | sudo -S apt -y update

  # necessary binary packages (especially pkg-config and build-essential)
  echo $PASSWD | sudo -S apt -y install git apt gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh tcsh okular cmake time xorg openbox xauth python3 python3-dev python2 python2-dev mlocate curl libcurl4-openssl-dev build-essential pkg-config

  # install the Intel compilers
  echo $PASSWD | sudo -S apt -y install intel-basekit intel-hpckit intel-aikit
  echo $PASSWD | sudo -S apt -y update


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
  export CFLAGS="-fPIC -fPIE -O3"
  export FFLAGS="-m64"
  export FCFLAGS="-m64"
  ############################# CPU Core Management ####################################

  export CPU_CORE=$(nproc)                                   # number of available threads on system
  export CPU_6CORE="6"
  export CPU_HALF=$(($CPU_CORE / 2))                         # half of availble cores on system
  # Forces CPU cores to even number to avoid partial core export. ie 7 cores would be 3.5 cores.
  export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))

  # If statement for low core systems.  Forces computers to only use 1 core if there are 4 cores or less on the system.
  if [ $CPU_CORE -le $CPU_6CORE ]
    then
      export CPU_HALF_EVEN="2"
    else
      export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))
  fi

  echo "##########################################"
  echo "Number of Threads being used $CPU_HALF_EVEN"
  echo "##########################################"

  ############################## Directory Listing ############################
  # makes necessary directories
  ## If you want WRFCHEM or WRF-Hydro change "WRF" in this variable to either "WRFCHEM" or "WRF-Hydro"
  ############################################################################


  export HOME=`cd;pwd`
  export WRFHYDRO_FOLDER=$HOME/WRFHYDRO_COUPLED_Intel
  export DIR=$WRFHYDRO_FOLDER/Libs
  mkdir $WRFHYDRO_FOLDER
  cd $WRFHYDRO_FOLDER
  mkdir Downloads
  mkdir Libs
  mkdir Libs/grib2
  mkdir Libs/NETCDF
  mkdir Libs/MPICH

  mkdir -p Tests/Environment
  mkdir -p Tests/Compatibility

  echo " "
  ############################## Downloading Libraries ############################

  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz
  wget -c -4 https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_2.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz
  wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.39.tar.gz
  wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
  wget -c -4 https://sourceforge.net/projects/opengrads/files/grads2/2.2.1.oga.1/Linux%20%2864%20Bits%29/opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz

  echo " "
  ############################# ZLib ############################

  cd $WRFHYDRO_FOLDER/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3"  ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN | tee zlib.make.log
  # make check | tee zlib.makecheck.log
  make -j $CPU_HALF_EVEN install | tee zlib.makeinstall.log

  echo " "
  ############################# LibPNG ############################

  cd $WRFHYDRO_FOLDER/Downloads

  # other libraries below need these variables to be set
  export LDFLAGS=-L$DIR/grib2/lib
  export CPPFLAGS=-I$DIR/grib2/include

  tar -xvzf libpng-1.6.39.tar.gz
  cd libpng-1.6.39/

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3"   ./configure --prefix=$DIR/grib2

  make -j $CPU_HALF_EVEN | tee libpng.make.log
  #make -j $CPU_HALF_EVEN check | tee libpng.makecheck.log
  make -j $CPU_HALF_EVEN install | tee libpng.makeinstall.log

  echo " "
  ############################# JasPer ############################

  cd $WRFHYDRO_FOLDER/Downloads
  unzip jasper-1.900.1.zip
  cd jasper-1.900.1/

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3"   ./configure --prefix=$DIR/grib2

  make -j $CPU_HALF_EVEN | tee jasper.make.log
  make  -j $CPU_HALF_EVEN install | tee jasper.makeinstall.log

  # other libraries below need these variables to be set
  export JASPERLIB=$DIR/grib2/lib
  export JASPERINC=$DIR/grib2/include

  echo " "
  ############################# HDF5 library for NetCDF4 & parallel functionality ############################

  cd $WRFHYDRO_FOLDER/Downloads
  tar -xvzf hdf5-1_13_2.tar.gz
  cd hdf5-hdf5-1_13_2

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3" ./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran --enable-parallel

  make -j $CPU_HALF_EVEN | tee hdf5.make.log
  make -j $CPU_HALF_EVEN install | tee hdf5.makeinstall.log

  # other libraries below need these variables to be set
  export HDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
  export PATH=$HDF5/bin:$PATH
  export PHDF5=$DIR/grib2

  echo " "

  #############################Install Parallel-netCDF##############################
   #Make file created with half of available cpu cores
   #Hard path for MPI added
   ##################################################################################
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4  https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz
  tar -xvzf pnetcdf-1.12.3.tar.gz
  cd pnetcdf-1.12.3
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
  export FFLAGS="-m64"
  export FCFLAGS="-m64"
   ./configure --prefix=$DIR/grib2  --enable-shared --enable-static

  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  export PNETCDF=$DIR/grib2


  ############################## Install NETCDF-C Library ############################

  cd $WRFHYDRO_FOLDER/Downloads
  tar -xzvf v4.9.0.tar.gz
  cd netcdf-c-4.9.0/

  # these variables need to be set for the NetCDF-C install to work
  export CPPFLAGS=-I$DIR/grib2/include
  export LDFLAGS=-L$DIR/grib2/lib
  export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lm -ldl"

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3" ./configure --prefix=$DIR/NETCDF --disable-dap --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-pnetcdf --enable-cdf5 --enable-parallel-tests | tee netcdf.configure.log

  make -j $CPU_HALF_EVEN | tee netcdf.make.log
  make -j $CPU_HALF_EVEN install | tee netcdf.makeinstall.log

  # other libraries below need these variables to be set
  export PATH=$DIR/NETCDF/bin:$PATH
  export NETCDF=$DIR/NETCDF

  echo " "
  ############################## NetCDF-Fortran library ############################

  cd $WRFHYDRO_FOLDER/Downloads
  tar -xvzf v4.6.0.tar.gz
  cd netcdf-fortran-4.6.0/

  # these variables need to be set for the NetCDF-Fortran install to work
  export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
  export CPPFLAGS="-I$DIR/NETCDF/include -I$DIR/grib2/include"
  export LDFLAGS="-L$DIR/NETCDF/lib -L$DIR/grib2/lib"
  export LIBS="-lnetcdf -lpnetcdf -lcurl -lm -lcurl -lhdf5_hl -lhdf5 -lz -ldl"

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3"   ./configure --prefix=$DIR/NETCDF --enable-netcdf-4 --enable-netcdf4 --enable-parallel-tests --enable-hdf5

  make -j $CPU_HALF_EVEN | tee netcdf-f.make.log
  make  -j $CPU_HALF_EVEN install | tee netcdf-f.makeinstall.log


  echo " "
  #################################### System Environment Tests ##############

  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar

  tar -xvf Fortran_C_tests.tar -C $WRFHYDRO_FOLDER/Tests/Environment
  tar -xvf Fortran_C_NETCDF_MPI_tests.tar -C $WRFHYDRO_FOLDER/Tests/Compatibility

  export one="1"
  echo " "
  ############## Testing Environment #####

  cd $WRFHYDRO_FOLDER/Tests/Environment

  echo " "
  echo " "
  echo "Environment Testing "
  echo "Test 1"
  ifort TEST_1_fortran_only_fixed.f
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
  ifort TEST_2_fortran_only_free.f90
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
  icc TEST_3_c_only.c
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
  icc -c -m64 TEST_4_fortran+c_c.c
  ifort -c -m64 TEST_4_fortran+c_f.f90
  ifort -m64 TEST_4_fortran+c_f.o TEST_4_fortran+c_c.o
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

  cd $WRFHYDRO_FOLDER/Tests/Compatibility

  cp ${NETCDF}/include/netcdf.inc .

  echo " "
  echo " "
  echo "Library Compatibility Tests "
  echo "Test 1"
  ifort -c 01_fortran+c+netcdf_f.f
  icc -c 01_fortran+c+netcdf_c.c
  ifort 01_fortran+c+netcdf_f.o 01_fortran+c+netcdf_c.o \
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
  mpiifort -c 02_fortran+c+netcdf+mpi_f.f
  mpiicc -c 02_fortran+c+netcdf+mpi_c.c
  mpiifort 02_fortran+c+netcdf+mpi_f.o \
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
  ###############################NCEPlibs#####################################
  #The libraries are built and installed with
  # ./make_ncep_libs.sh -s MACHINE -c COMPILER -d NCEPLIBS_DIR -o OPENMP [-m mpi] [-a APPLICATION]
  #It is recommended to install the NCEPlibs into their own directory, which must be created before running the installer. Further information on the command line arguments can be obtained with
  # ./make_ncep_libs.sh -h

  #If iand error occurs go to https://github.com/NCAR/NCEPlibs/pull/16/files make adjustment and re-run ./make_ncep_libs.sh
  ############################################################################



  cd $WRFHYDRO_FOLDER/Downloads
  git clone https://github.com/NCAR/NCEPlibs.git
  cd NCEPlibs
  mkdir $DIR/nceplibs

  export JASPER_INC=$DIR/grib2/include
  export PNG_INC=$DIR/grib2/include
  export NETCDF=$DIR/NETCDF



  if [ ${auto_config} -eq 1 ]
    then
      echo yes | ./make_ncep_libs.sh -s linux -c intel -d $DIR/nceplibs -o 0 -m 1 -a upp
    else
      ./make_ncep_libs.sh -s linux -c intel -d $DIR/nceplibs -o 0 -m 1 -a upp | tee make_nceplibs.log
  fi
  export PATH=$DIR/nceplibs:$PATH

  echo " "
  ################################UPPv4.1######################################
  #Previous verison of UPP
  #WRF Support page recommends UPPV4.1 due to too many changes to WRF and UPP code
  #since the WRF was written
  #Option 4 gfortran compiler with distributed memory
  #############################################################################
  cd $WRFHYDRO_FOLDER
  git clone -b dtc_post_v4.1.0 --recurse-submodules https://github.com/NOAA-EMC/EMC_post UPPV4.1
  cd UPPV4.1
  mkdir postprd
  export NCEPLIBS_DIR=$DIR/nceplibs
  export NETCDF=$DIR/NETCDF

  if [ ${auto_config} -eq 1 ]
    then
      echo 4 | ./configure  #Option 4 intel compiler with distributed memory
    else
      ./configure #Option 4 intel compiler with distributed memory
  fi

  sed -i '24s/ mpif90/ mpiifort/g' $WRFHYDRO_FOLDER/UPPV4.1/configure.upp
  sed -i '25s/ mpif90/ mpiifort/g' $WRFHYDRO_FOLDER/UPPV4.1/configure.upp
  sed -i '26s/ mpicc/ mpiicc/g' $WRFHYDRO_FOLDER/UPPV4.1/configure.upp


  ./compile | tee upp_compile.log
  cd $WRFHYDRO_FOLDER/UPPV4.1/scripts
  chmod +x run_unipost

  # IF statement to check that all files were created.
   cd $WRFHYDRO_FOLDER/UPPV4.1/exec
   n=$(ls ./*.exe | wc -l)
   if (( $n == 1 ))
    then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing UPPV4.1. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi

  echo " "



  ######################## ARWpost V3.1  ############################
  ## ARWpost
  ##Configure #3
  ###################################################################
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz
  tar -xvzf ARWpost_V3.tar.gz -C $WRFHYDRO_FOLDER
  cd $WRFHYDRO_FOLDER/ARWpost
  ./clean -a
  sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $WRFHYDRO_FOLDER/ARWpost/src/Makefile
  export NETCDF=$DIR/NETCDF

  if [ ${auto_config} -eq 1 ]
    then
      echo 2 | ./configure  #Option 2 intel compiler with distributed memory
    else
      ./configure  #Option 2 intel compiler with distributed memory
  fi

  sed -i -e 's/-C -P -traditional/-P -traditional/g' $WRFHYDRO_FOLDER/ARWpost/configure.arwp
  ./compile

  export PATH=$WRFHYDRO_FOLDER/ARWpost/ARWpost.exe:$PATH

  echo " "
  ################################OpenGrADS######################################
  #Verison 2.2.1 64bit of Linux
  #############################################################################
  if [[ $GRADS_PICK -eq 1 ]]; then

  cd $WRFHYDRO_FOLDER/Downloads
  tar -xzvf opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz -C $WRFHYDRO_FOLDER/
  cd $WRFHYDRO_FOLDER/
  mv $WRFHYDRO_FOLDER/opengrads-2.2.1.oga.1  $WRFHYDRO_FOLDER/GrADS
  cd GrADS/Contents
  wget -c -4 https://github.com/regisgrundig/SIMOP/blob/master/g2ctl.pl
  chmod +x g2ctl.pl
  wget -c -4 https://sourceforge.net/projects/opengrads/files/wgrib2/0.1.9.4/wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
  tar -xzvf wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
  cd wgrib2-v0.1.9.4/bin
  mv wgrib2 $WRFHYDRO_FOLDER/GrADS/Contents
  cd $WRFHYDRO_FOLDER/GrADS/Contents
  rm wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
  rm -r wgrib2-v0.1.9.4


  export PATH=$WRFHYDRO_FOLDER/GrADS/Contents:$PATH

  fi

  ################################## GrADS ###############################
  # Version  2.2.1
  # Sublibs library instructions: http://cola.gmu.edu/grads/gadoc/supplibs2.html
  # GrADS instructions: http://cola.gmu.edu/grads/downloads.php
  ########################################################################
  if [[ $GRADS_PICK -eq 2 ]]; then

    echo $PASSWD | sudo -S apt -y install grads

  fi



  ##################### NCAR COMMAND LANGUAGE           ##################
  ########### NCL compiled via Conda                    ##################
  ########### This is the preferred method by NCAR      ##################
  ########### https://www.ncl.ucar.edu/index.shtml      ##################
  echo " "
  #Installing Miniconda3 to WRF directory and updating libraries

  export Miniconda_Install_DIR=$WRFHYDRO_FOLDER/miniconda3

  mkdir -p $Miniconda_Install_DIR

  wget -c -4 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $Miniconda_Install_DIR/miniconda.sh
  bash $Miniconda_Install_DIR/miniconda.sh -b -u -p $Miniconda_Install_DIR

  rm -rf $Miniconda_Install_DIR/miniconda.sh

  export PATH=$WRFHYDRO_FOLDER/miniconda3/bin:$PATH

  source $Miniconda_Install_DIR/etc/profile.d/conda.sh

  $Miniconda_Install_DIR/bin/conda init bash
  $Miniconda_Install_DIR/bin/conda init zsh
  $Miniconda_Install_DIR/bin/conda init tcsh
  $Miniconda_Install_DIR/bin/conda init xonsh
  $Miniconda_Install_DIR/bin/conda init powershell

  conda config --add channels conda-forge
  conda config --set auto_activate_base false
  conda update -n root --all -y


  export $PATH
  #Special Thanks to @_WaylonWalker for code development


  echo " "
  #Installing NCL via Conda
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n ncl_stable -c conda-forge ncl -y
  conda activate ncl_stable
  conda update -n ncl_stable --all -y
  conda deactivate
  conda deactivate
  conda deactivate
  echo " "


  ##################### WRF Python           ##################
  ########### WRf-Python compiled via Conda  ##################
  ########### This is the preferred method by NCAR      ##################
  ##### https://wrf-python.readthedocs.io/en/latest/installation.html  ##################
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n wrf-python -c conda-forge wrf-python -y
  conda activate wrf-python
  conda update -n wrf-python --all -y
  conda deactivate
  conda deactivate
  conda deactivate
  echo " "

  ########################## WRF Hydro GIS PreProcessor ##############################
  #  Compiled with Conda
  #  https://github.com/NCAR/wrf_hydro_gis_preprocessor
  ####################################################################################

  conda init bash
  conda activate base
  conda create -n wrfh_gis_env -c conda-forge python=3.6 gdal netCDF4 numpy pyproj whitebox=1.5.0 -y
  conda activate wrfh_gis_env
  conda update -n wrfh_gis_env --all -y
  conda deactivate
  conda deactivate
  conda deactivate
  cd $WRFHYDRO_FOLDER
  git clone https://github.com/NCAR/wrf_hydro_gis_preprocessor.git  $WRFHYDRO_FOLDER/WRF-Hydro-GIS-PreProcessor

  echo " "

  ############################# WRF HYDRO V5.2.0 #################################
  # Version 5.2.0
  # Standalone mode
  ################################################################################
  export NETCDF_INC=$DIR/NETCDF/include
  export NETCDF_LIB=$DIR/NETCDF/lib
  mkdir $WRFHYDRO_FOLDER/Hydro-Basecode
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://github.com/NCAR/wrf_hydro_nwm_public/archive/refs/tags/v5.2.0.tar.gz -O WRFHYDRO.5.2.tar.gz
  tar -xvzf WRFHYDRO.5.2.tar.gz -C $WRFHYDRO_FOLDER/Hydro-Basecode


  #Modifying WRF-HYDRO Environment
  #Echo commands use due to lack of knowledge
  cd $WRFHYDRO_FOLDER/Hydro-Basecode/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS/template

  sed -i 's/SPATIAL_SOIL=0/SPATIAL_SOIL=1/g' setEnvar.sh                      # Spatially distributed parameters for NoahMP: 0=Off, 1=On.
  sed -i 's/WRF_HYDRO_NUDGING=0/WRF_HYDRO_NUDGING=1/g' setEnvar.sh                     # Streamflow nudging: 0=Off, 1=On.
  echo " " >> setEnvar.sh
  echo "# Large netcdf file support: 0=Off, 1=On." >> setEnvar.sh
  echo "export WRFIO_NCD_LARGE_FILE_SUPPORT=1" >> setEnvar.sh
  cp -r setEnvar.sh $WRFHYDRO_FOLDER/Hydro-Basecode/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS

  cd $WRFHYDRO_FOLDER/Hydro-Basecode/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS


  if [ ${auto_config} -eq 1 ]
    then
        echo 3 | ./configure
    else
      ./configure  #Option 3 intel with distributed memory option 1 for basic nesting
  fi

  sed -i '63s/mpif90/mpiifort/g' $WRFHYDRO_FOLDER/Hydro-Basecode/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS/macros



  ./compile_offline_NoahMP.sh setEnvar.sh | tee noahmp.log

  # IF statement to check that all files were created.
   cd $WRFHYDRO_FOLDER/Hydro-Basecode/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS/Run

   n=$(ls ./*.exe | wc -l)
   if (($n == 2))
    then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing WRF Hydro Basecode. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi
   echo " "



  read -r -t 5 -p "I am going to wait for 5 seconds only ..."
  echo " "

  ############################ WRF 4.4.2  #################################
  ## WRF v4.4.2
  ## Downloaded from git tagged releases
  # option 15, option 1 for intel and distributed memory w/basic nesting
  # large file support enable with WRFiO_NCD_LARGE_FILE_SUPPORT=1
  # In the namelist.input, the following settings support pNetCDF by setting  value to 11:
  # io_form_boundary
  # io_form_history
  # io_form_auxinput2
  # io_form_auxhist2
  # Note that you need set nocolons = .true. in the section &time_control of namelist.input
  ########################################################################

  cd $WRFHYDRO_FOLDER/Downloads

  wget -c -4 https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz -O WRF-4.4.2.tar.gz
  tar -xvzf WRF-4.4.2.tar.gz -C $WRFHYDRO_FOLDER/
  cd $WRFHYDRO_FOLDER/WRFV4.4.2

  export WRFIO_NCD_LARGE_FILE_SUPPORT=1


  #Replace old version of WRF-Hydro distributed with WRF with updated WRF-Hydro source code
  rm -r $WRFHYDRO_FOLDER/WRFV4.4.2/hydro/
  cp -r $WRFHYDRO_FOLDER/Hydro-Basecode/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS $WRFHYDRO_FOLDER/WRFV4.4.2/hydro

  cd $WRFHYDRO_FOLDER/WRFV4.4.2/hydro
  source setEnvar.sh
  cd $WRFHYDRO_FOLDER/WRFV4.4.2


  ./clean

  # SED statements to fix configure error
  sed -i '186s/==/=/g' $WRFHYDRO_FOLDER/WRFV4.4.2/configure
  sed -i '318s/==/=/g' $WRFHYDRO_FOLDER/WRFV4.4.2/configure
  sed -i '919s/==/=/g' $WRFHYDRO_FOLDER/WRFV4.4.2/configure



  if [ ${auto_config} -eq 1 ]
    then
        sed -i '428s/.*/  $response = "15 \\n";/g' $WRFHYDRO_FOLDER/WRFV4.4.2/arch/Config.pl # Answer for compiler choice
        sed -i '869s/.*/  $response = "1 \\n";/g' $WRFHYDRO_FOLDER/WRFV4.4.2/arch/Config.pl  #Answer for basic nesting
        ./configure
    else
      ./configure  #Option 15 intel compiler with distributed memory option 1 for basic nesting
  fi


  sed -i '63s/mpif90/mpiifort/g' $WRFHYDRO_FOLDER/WRFV4.4.2/hydro/macros
  #Need to remove mpich/GNU config calls to Intel config calls
  sed -i '170s|mpif90 -f90=$(SFC)|mpiifort|g' $WRFHYDRO_FOLDER/WRFV4.4.2/configure.wrf
  sed -i '171s|mpicc -cc=$(SCC)|mpiicc|g' $WRFHYDRO_FOLDER/WRFV4.4.2/configure.wrf



  ./compile -j $CPU_HALF_EVEN em_real | tee em_real_intel.log

  export WRF_DIR=$WRFHYDRO_FOLDER/WRFV4.4.2


  # IF statement to check that all files were created.
  cd $WRFHYDRO_FOLDER/WRFV4.4.2/main
  n=$(ls ./*.exe | wc -l)
  if (($n >= 3))
   then
     echo "All expected files created."
     read -r -t 5 -p "Finished installing WRF. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
  fi
  echo " "
  ############################WPSV4.4#####################################
  ## WPS v4.4
  ## Downloaded from git tagged releases
  #Option 3 for gfortran and distributed memory
  ########################################################################

  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WPS/archive/refs/tags/v4.4.tar.gz -O WPS-4.4.tar.gz
  tar -xvzf WPS-4.4.tar.gz -C $WRFHYDRO_FOLDER/
  cd $WRFHYDRO_FOLDER/WPS-4.4
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
      echo 19 | ./configure #Option 19 for intel and distributed memory
    else
      ./configure  #Option 19 intel compiler with distributed memory
  fi

  sed -i '67s|mpif90|mpiifort|g' $WRFHYDRO_FOLDER/WPS-4.4/configure.wps
  sed -i '68s|mpicc|mpiicc|g' $WRFHYDRO_FOLDER/WPS-4.4/configure.wps


  ./compile


  echo " "
  # IF statement to check that all files were created.
   cd $WRFHYDRO_FOLDER/WPS-4.4
   n=$(ls ./*.exe | wc -l)
   if (($n == 3))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing WPS. I am going to wait for 5 seconds only ..."
   else
      echo "Missing one or more expected files. Exiting the script."
      read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
      exit
   fi
   echo " "

  ######################## WPS Domain Setup Tools ########################
  ## DomainWizard
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 http://esrl.noaa.gov/gsd/wrfportal/domainwizard/WRFDomainWizard.zip
  mkdir $WRFHYDRO_FOLDER/WRFDomainWizard
  unzip WRFDomainWizard.zip -d $WRFHYDRO_FOLDER/WRFDomainWizard
  chmod +x $WRFHYDRO_FOLDER/WRFDomainWizard/run_DomainWizard

  echo " "
  ######################## WPF Portal Setup Tools ########################
  ## WRFPortal
  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://esrl.noaa.gov/gsd/wrfportal/portal/wrf-portal.zip
  mkdir $WRFHYDRO_FOLDER/WRFPortal
  unzip wrf-portal.zip -d $WRFHYDRO_FOLDER/WRFPortal
  chmod +x $WRFHYDRO_FOLDER/WRFPortal/runWRFPortal


  echo " "

  ######################## Static Geography Data inc/ Optional ####################
  # http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  # These files are large so if you only need certain ones comment the others off
  # All files downloaded and untarred is 200GB
  # https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  #################################################################################
  cd $WRFHYDRO_FOLDER/Downloads
  mkdir $WRFHYDRO_FOLDER/GEOG
  mkdir $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

  echo " "
  echo "Mandatory WRF Preprocessing System (WPS) Geographical Input Data Mandatory Fields Downloads"
  echo " "
  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
  tar -xvzf geog_high_res_mandatory.tar.gz -C $WRFHYDRO_FOLDER/GEOG/

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz
  tar -xvzf geog_low_res_mandatory.tar.gz -C $WRFHYDRO_FOLDER/GEOG/
  mv $WRFHYDRO_FOLDER/GEOG/WPS_GEOG_LOW_RES/ $WRFHYDRO_FOLDER/GEOG/WPS_GEOG


  if [ ${WPS_Specific_Applications} -eq 1 ]
    then
      echo " "
      echo " WPS Geographical Input Data Mandatory for Specific Applications"
      echo " "

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
      tar -xvzf geog_thompson28_chem.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
      tar -xvzf geog_noahmp.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4  https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
      tar -xvzf irrigation.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
      tar -xvzf geog_px.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
      tar -xvzf geog_urban.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
      tar -xvzf geog_ssib.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
      tar -xvf lake_depth.tar.bz2 -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/topobath_30s.tar.bz2
      tar -xvf topobath_30s.tar.bz2 -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/gsl_gwd.tar.bz2
      tar -xvf gsl_gwd.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG
  fi


  if [ ${Optional_GEOG} -eq 1 ]
    then
      echo " "
      echo "Optional WPS Geographical Input Data"
      echo " "


      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_older_than_2000.tar.gz
      tar -xvzf geog_older_than_2000.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s_with_lakes.tar.gz
      tar -xvzf modis_landuse_20class_15s_with_lakes.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_alt_lsm.tar.gz
      tar -xvzf geog_alt_lsm.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/nlcd2006_ll_9s.tar.bz2
      tar -xvf nlcd2006_ll_9s.tar.bz2 -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/updated_Iceland_LU.tar.gz
      tar -xvf updated_Iceland_LU.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s.tar.bz2
      tar -xvf modis_landuse_20class_15s.tar.bz2 -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG
  fi

fi


if [ "$macos_64bit_GNU" = "1" ] && [ "$WRFHYDRO_COUPLED_PICK" = "1" ]; then



  #############################basic package managment############################

  brew install wget git
  brew install gcc libtool automake autoconf make m4 java ksh  mpich grads ksh tcsh
  brew install snap
  brew install python@3.9
  brew install gcc libtool automake autoconf make m4 java ksh git wget mpich grads ksh tcsh python@3.9

  ##############################Directory Listing############################

  export HOME=`cd;pwd`
  mkdir $HOME/WRFHYDRO_COUPLED
  export WRFHYDRO_FOLDER=$HOME/WRFHYDRO_COUPLED
  cd $WRFHYDRO_FOLDER/
  mkdir Downloads
  mkdir $WRFHYDRO_FOLDER/Hydro-Basecode
  mkdir Libs
  export DIR=$WRFHYDRO_FOLDER/Libs
  mkdir Libs/grib2
  mkdir Libs/NETCDF
  mkdir Libs/MPICH
  mkdir -p Tests/Environment
  mkdir -p Tests/Compatibility

  echo " "

  ##############################Downloading Libraries############################

  cd Downloads
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

  echo "Please enter password for linking GNU libraries"
  echo $PASSWD | sudo -S ln -sf /usr/local/bin/gcc-1* /usr/local/bin/gcc
  echo $PASSWD | sudo -S ln -sf /usr/local/bin/g++-1* /usr/local/bin/g++
  echo $PASSWD | sudo -S ln -sf /usr/local/bin/gfortran-1* /usr/local/bin/gfortran

  export CC=gcc
  export CXX=g++
  export FC=gfortran
  export F77=gfortran
  export CFLAGS="-fPIC -fPIE -O3 -Wno-implicit-function-declaration"

  echo " "
  #############################zlib############################
  #Uncalling compilers due to comfigure issue with zlib1.2.12
  #With CC & CXX definied ./configure uses different compiler Flags

  cd $WRFHYDRO_FOLDER/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/
  ./configure --prefix=$DIR/grib2
  make
  make install
  #make check

  echo " "
  #############################libpng############################
  cd $WRFHYDRO_FOLDER/Downloads
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

  cd $WRFHYDRO_FOLDER/Downloads
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

  cd $WRFHYDRO_FOLDER/Downloads
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
  cd $WRFHYDRO_FOLDER/Downloads
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

  cd $WRFHYDRO_FOLDER/Downloads
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
  mkdir -p $WRFHYDRO_FOLDER/Tests/Environment
  mkdir -p $WRFHYDRO_FOLDER/Tests/Compatibility


  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar


  tar -xvf Fortran_C_tests.tar -C $WRFHYDRO_FOLDER/Tests/Environment
  tar -xvf Fortran_C_NETCDF_MPI_tests.tar -C $WRFHYDRO_FOLDER/Tests/Compatibility
  export one="1"
  echo " "
  ############## Testing Environment #####

  cd $WRFHYDRO_FOLDER/Tests/Environment

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

  cd $WRFHYDRO_FOLDER/Tests/Compatibility

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

  ############## ARWPOST ##################
  # No compatibile compiler for gcc/gfortran
  #########################################


  #Installing Miniconda3 to WRF directory and updating libraries
  export Miniconda_Install_DIR=$WRFHYDRO_FOLDER/miniconda3

  mkdir -p $Miniconda_Install_DIR

  wget -c -4 https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O $Miniconda_Install_DIR/miniconda.sh
  bash $Miniconda_Install_DIR/miniconda.sh -b -u -p $Miniconda_Install_DIR

  rm -rf $Miniconda_Install_DIR/miniconda.sh

  export PATH=$WRFHYDRO_FOLDER/miniconda3/bin:$PATH

  source $Miniconda_Install_DIR/etc/profile.d/conda.sh

  $Miniconda_Install_DIR/bin/conda init bash
  $Miniconda_Install_DIR/bin/conda init zsh
  $Miniconda_Install_DIR/bin/conda init tcsh
  $Miniconda_Install_DIR/bin/conda init xonsh
  $Miniconda_Install_DIR/bin/conda init powershell

  conda config --add channels conda-forge
  conda config --set auto_activate_base false
  conda update -n root --all -y


  export $PATH


  echo " "

  #Installing NCL via Conda
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n ncl_stable -c conda-forge ncl -y
  conda activate ncl_stable
  conda update -n ncl_stable --all -y
  conda deactivate
  conda deactivate
  conda deactivate
  echo " "


  ############################OBSGRID###############################
  ## OBSGRID
  ## Downloaded from git tagged releases
  ## Not compatibile with gcc/gfortran on macos
  ########################################################################


  ##################### WRF Python           ##################
  ########### WRf-Python compiled via Conda  ##################
  ########### This is the preferred method by NCAR      ##################
  ##### https://wrf-python.readthedocs.io/en/latest/installation.html  ##################
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n wrf-python -c conda-forge wrf-python -y
  conda activate wrf-python
  conda update -n wrf-python --all -y
  conda deactivate
  conda deactivate
  conda deactivate

  echo " "
  ########################## WRF Hydro GIS PreProcessor ##############################
  #  Compiled with Conda
  #  https://github.com/NCAR/wrf_hydro_gis_preprocessor
  ####################################################################################

  conda init bash
  conda activate base
  conda config --add channels conda-forge
  conda create -n wrfh_gis_env -c conda-forge python=3.6 gdal netCDF4 numpy pyproj whitebox=1.5.0 -y
  conda activate wrfh_gis_env
  conda update -n wrfh_gis_env --all -y
  conda deactivate
  conda deactivate
  conda deactivate

  cd $WRFHYDRO_FOLDER/
  git clone https://github.com/NCAR/wrf_hydro_gis_preprocessor.git  $WRFHYDRO_FOLDER/WRF-Hydro-GIS-PreProcessor
  echo " "

  ############################# WRF HYDRO V5.2.0 #################################
  # Version 5.2.0
  # Standalone mode
  ################################################################################
  export NETCDF_INC=$DIR/NETCDF/include
  export NETCDF_LIB=$DIR/NETCDF/lib


  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://github.com/NCAR/wrf_hydro_nwm_public/archive/refs/tags/v5.2.0.tar.gz -O WRFHYDRO.5.2.tar.gz
  tar -xvzf WRFHYDRO.5.2.tar.gz -C $WRFHYDRO_FOLDER/Hydro-Basecode


  #Modifying WRF-HYDRO Environment
  #Echo commands use due to lack of knowledge
  cd $WRFHYDRO_FOLDER/Hydro-Basecode/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS/template

  sed -i'' -e  's/SPATIAL_SOIL=0/SPATIAL_SOIL=1/g' setEnvar.sh                      # Spatially distributed parameters for NoahMP: 0=Off, 1=On.
  sed -i'' -e  's/WRF_HYDRO_NUDGING=0/WRF_HYDRO_NUDGING=1/g' setEnvar.sh                     # Streamflow nudging: 0=Off, 1=On.
  echo " " >> setEnvar.sh
  echo "# Large netcdf file support: 0=Off, 1=On." >> setEnvar.sh
  echo "export WRFIO_NCD_LARGE_FILE_SUPPORT=1" >> setEnvar.sh
  cp -r setEnvar.sh $WRFHYDRO_FOLDER/Hydro-Basecode/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS

  cd $WRFHYDRO_FOLDER/Hydro-Basecode/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS

  echo 2 | ./configure     # Option 2


  ./compile_offline_NoahMP.sh setEnvar.sh | tee noahmp.log

  ls -lah RUN/*.exe  #Test to see if .exe files have compiled

  echo " "
  ############################ WRF 4.4.2  #################################
  ## WRF v4.4.2
  ## Downloaded from git tagged releases
  # option 21, option 1 for gfortran and distributed memory w/basic nesting
  # large file support enable with WRFiO_NCD_LARGE_FILE_SUPPORT=1
  ########################################################################

  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz -O WRF-4.4.2.tar.gz
  tar -xvzf WRF-4.4.2.tar.gz -C $WRFHYDRO_FOLDER/
  cd $WRFHYDRO_FOLDER/WRFV4.4.2
  export WRFIO_NCD_LARGE_FILE_SUPPORT=1


  #Replace old version of WRF-Hydro distributed with WRF with updated WRF-Hydro source code
  rm -r $WRFHYDRO_FOLDER/WRFV4.4.2/hydro/
  cp -r $WRFHYDRO_FOLDER/Hydro-Basecode/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS $WRFHYDRO_FOLDER/WRFV4.4.2/hydro

  cd $WRFHYDRO_FOLDER/WRFV4.4.2/hydro
  source setEnvar.sh
  cd $WRFHYDRO_FOLDER/WRFV4.4.2


  ./clean

  if [ ${auto_config} -eq 1 ]
    then
        sed -i'' -e '428s/.*/  $response = "17 \\n";/g' $WRFHYDRO_FOLDER/WRFV4.4.2/arch/Config.pl # Answer for compiler choice
        sed -i'' -e  '869s/.*/  $response = "1 \\n";/g' $WRFHYDRO_FOLDER/WRFV4.4.2/arch/Config.pl  #Answer for basic nesting
      ./configure
    else
    ./configure  #Option 17 gfortran compiler with distributed memory option 1 for basic nesting
  fi

  sed -i'' -e '145s/-c/-c -fPIC -fPIE -O3 -Wno-error=implicit-function-declaration/g' configure.wrf

  ./compile em_real

  export WRF_DIR=$WRFHYDRO_FOLDER/WRFV4.4.2

  # IF statement to check that all files were created.
  cd $WRFHYDRO_FOLDER/WRFV4.4.2/main
  n=$(ls ./*.exe | wc -l)
  if (($n >= 3))
   then
     echo "All expected files created."
     read -r -t 5 -p "Finished installing WRF. I am going to wait for 5 seconds only ..."
  else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
  fi
  echo " "
  ############################WPSV4.4#####################################
  ## WPS v4.4
  ## Downloaded from git tagged releases
  #Option 3 for gfortran and distributed memory
  ########################################################################

  cd $WRFHYDRO_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WPS/archive/refs/tags/v4.4.tar.gz -O WPS-4.4.tar.gz
  tar -xvzf WPS-4.4.tar.gz -C $WRFHYDRO_FOLDER/
  cd $WRFHYDRO_FOLDER/WPS-4.4
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        echo 19 | ./configure #Option 19 for gfortran and distributed memory
      else
        ./configure  #Option 19 gfortran compiler with distributed memory
    fi
  ./compile

  # IF statement to check that all files were created.
   cd $WRFHYDRO_FOLDER/WPS-4.4
   n=$(ls ./*.exe | wc -l)
   if (($n == 3))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing WPS. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
   fi

  echo " "

  ######################## WPS Domain Setup Tools ########################
  ## DomainWizard

  cd $WRFHYDRO_FOLDER/Downloads
  wget http://esrl.noaa.gov/gsd/wrfportal/domainwizard/WRFDomainWizard.zip
  mkdir $WRFHYDRO_FOLDER/WRFDomainWizard
  unzip WRFDomainWizard.zip -d $WRFHYDRO_FOLDER/WRFDomainWizard
  chmod +x $WRFHYDRO_FOLDER/WRFDomainWizard/run_DomainWizard

  echo " "
  ######################## WPF Portal Setup Tools ########################
  ## WRFPortal
  cd $WRFHYDRO_FOLDER/Downloads
  wget https://esrl.noaa.gov/gsd/wrfportal/portal/wrf-portal.zip
  mkdir $WRFHYDRO_FOLDER/WRFPortal
  unzip wrf-portal.zip -d $WRFHYDRO_FOLDER/WRFPortal
  chmod +x $WRFHYDRO_FOLDER/WRFPortal/runWRFPortal




  echo " "
  ######################## Static Geography Data inc/ Optional ####################
  # http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  # These files are large so if you only need certain ones comment the others off
  # All files downloaded and untarred is 200GB
  # https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  #################################################################################
  cd $WRFHYDRO_FOLDER/Downloads
  mkdir $WRFHYDRO_FOLDER/GEOG
  mkdir $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

  echo " "
  echo "Mandatory WRF Preprocessing System (WPS) Geographical Input Data Mandatory Fields Downloads"
  echo " "
  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
  tar -xvzf geog_high_res_mandatory.tar.gz -C $WRFHYDRO_FOLDER/GEOG/

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz
  tar -xvzf geog_low_res_mandatory.tar.gz -C $WRFHYDRO_FOLDER/GEOG/
  mv $WRFHYDRO_FOLDER/GEOG/WPS_GEOG_LOW_RES/ $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

  if [ ${WPS_Specific_Applications} -eq 1 ]
    then
      echo " "
      echo " WPS Geographical Input Data Mandatory for Specific Applications"
      echo " "

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
      tar -xvzf geog_thompson28_chem.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
      tar -xvzf geog_noahmp.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4  https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
      tar -xvzf irrigation.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
      tar -xvzf geog_px.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
      tar -xvzf geog_urban.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
      tar -xvzf geog_ssib.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
      tar -xvf lake_depth.tar.bz2 -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/topobath_30s.tar.bz2
      tar -xvf topobath_30s.tar.bz2 -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG


      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/gsl_gwd.tar.bz2
      tar -xvf gsl_gwd.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG
  fi


  if [ ${Optional_GEOG} -eq 1 ]
    then
      echo " "
      echo "Optional WPS Geographical Input Data"
      echo " "


      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_older_than_2000.tar.gz
      tar -xvzf geog_older_than_2000.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s_with_lakes.tar.gz
      tar -xvzf modis_landuse_20class_15s_with_lakes.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_alt_lsm.tar.gz
      tar -xvzf geog_alt_lsm.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/nlcd2006_ll_9s.tar.bz2
      tar -xvf nlcd2006_ll_9s.tar.bz2 -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/updated_Iceland_LU.tar.gz
      tar -xvf updated_Iceland_LU.tar.gz -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s.tar.bz2
      tar -xvf modis_landuse_20class_15s.tar.bz2 -C $WRFHYDRO_FOLDER/GEOG/WPS_GEOG
  fi



fi


########################### WRF CHEM ##########################
## WRFCHEM installation with parallel process.
# Download and install required library and data files for WRFCHEM/KPP $ WRF 3DVAR for Chemistry.
# Tested in Ubuntu 20.04.4 LTS & Ubuntu 22.04 & MacOS Ventura 64bit
# Built in 64-bit system
# Built with Intel or GNU compilers
# Tested with current available libraries on 01/01/2023
# If newer libraries exist edit script paths for changes
#Estimated Run Time ~ 90 - 150 Minutes with 10mb/s downloadspeed.
# Special thanks to:
# Youtube's meteoadriatic, GitHub user jamal919.
# University of Manchester's  Doug L
# University of Tunis El Manar's Hosni
# GSL's Jordan S.
# NCAR's Mary B., Christine W., & Carl D.
# DTC's Julie P., Tara J., George M., & John H.
# UCAR's Katelyn F., Jim B., Jordan P., Kevin M.,
##############################################################


if [ "$Ubuntu_64bit_GNU" = "1" ] && [ "$WRFCHEM_PICK" = "1" ]; then


  #############################basic package managment############################
  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade
  echo $PASSWD | sudo -S apt -y install gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git build-essential unzip mlocate byacc flex python3 python3-dev python2 python2-dev cmake curl mlocate libcurl4-openssl-dev pkg-config build-essential



  echo " "
  ##############################Directory Listing############################
  export HOME=`cd;pwd`

  mkdir $HOME/WRFCHEM
  export WRFCHEM_FOLDER=$HOME/WRFCHEM
  cd $WRFCHEM_FOLDER/
  mkdir Downloads
  mkdir Libs
  export DIR=$WRFCHEM_FOLDER/Libs
  mkdir Libs/grib2
  mkdir Libs/NETCDF
  mkdir Libs/MPICH
  mkdir -p Tests/Environment
  mkdir -p Tests/Compatibility
  echo " "
  #############################Core Management####################################
  export CPU_CORE=$(nproc)                                             # number of available threads on system
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
  echo "Number of Threads being used $CPU_HALF_EVEN"
  echo "##########################################"
  echo " "
  ##############################Downloading Libraries############################
  cd Downloads
  wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz
  wget -c -4 https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_2.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz
  wget -c -4 https://github.com/pmodels/mpich/releases/download/v4.0.3/mpich-4.0.3.tar.gz
  wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.39.tar.gz
  wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
  wget -c -4 https://sourceforge.net/projects/opengrads/files/grads2/2.2.1.oga.1/Linux%20%2864%20Bits%29/opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz

  echo " "
  #############################Compilers############################
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



  echo " "
  #############################zlib############################
  #Uncalling compilers due to comfigure issue with zlib1.2.13
  #With CC & CXX definied ./configure uses different compiler Flags

  cd $WRFCHEM_FOLDER/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/
  ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  echo " "
  ##############################MPICH############################
  cd $WRFCHEM_FOLDER/Downloads
  tar -xvzf mpich-4.0.3.tar.gz
  cd mpich-4.0.3/
  F90= ./configure --prefix=$DIR/MPICH --with-device=ch3 FFLAGS="$fallow_argument -m64" FCFLAGS="$fallow_argument -m64"

  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check


  export PATH=$DIR/MPICH/bin:$PATH

  export MPIFC=$DIR/MPICH/bin/mpifort
  export MPIF77=$DIR/MPICH/bin/mpifort
  export MPIF90=$DIR/MPICH/bin/mpifort
  export MPICC=$DIR/MPICH/bin/mpicc
  export MPICXX=$DIR/MPICH/bin/mpicxx


  echo " "
  #############################libpng############################
  cd $WRFCHEM_FOLDER/Downloads
  export LDFLAGS=-L$DIR/grib2/lib
  export CPPFLAGS=-I$DIR/grib2/include
  tar -xvzf libpng-1.6.39.tar.gz
  cd libpng-1.6.39/
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check
  echo " "
  #############################JasPer############################
  cd $WRFCHEM_FOLDER/Downloads
  unzip jasper-1.900.1.zip
  cd jasper-1.900.1/
  autoreconf -i
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  export JASPERLIB=$DIR/grib2/lib
  export JASPERINC=$DIR/grib2/include


  echo " "
  #############################hdf5 library for netcdf4 functionality############################
  cd $WRFCHEM_FOLDER/Downloads
  tar -xvzf hdf5-1_13_2.tar.gz
  cd hdf5-hdf5-1_13_2
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran --enable-parallel
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  export HDF5=$DIR/grib2
  export PHDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH

  echo " "


  #############################Install Parallel-netCDF##############################
  #Make file created with half of available cpu cores
  #Hard path for MPI added
  ##################################################################################
  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4  https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz
  tar -xvzf pnetcdf-1.12.3.tar.gz
  cd pnetcdf-1.12.3
  export MPIFC=$DIR/MPICH/bin/mpifort
  export MPIF77=$DIR/MPICH/bin/mpifort
  export MPIF90=$DIR/MPICH/bin/mpifort
  export MPICC=$DIR/MPICH/bin/mpicc
  export MPICXX=$DIR/MPICH/bin/mpicxx
  ./configure --prefix=$DIR/grib2  --enable-shared --enable-static

  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  export PNETCDF=$DIR/grib2



  ##############################Install NETCDF C Library############################
  cd $WRFCHEM_FOLDER/Downloads
  tar -xzvf v4.9.0.tar.gz
  cd netcdf-c-4.9.0/
  export CPPFLAGS=-I$DIR/grib2/include
  export LDFLAGS=-L$DIR/grib2/lib
  export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lgfortran -lgcc -lm -ldl"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --disable-dap --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-pnetcdf --enable-cdf5 --enable-parallel-tests
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  export PATH=$DIR/NETCDF/bin:$PATH
  export NETCDF=$DIR/NETCDF
  echo " "
  ##############################NetCDF fortran library############################
  cd $WRFCHEM_FOLDER/Downloads
  tar -xvzf v4.6.0.tar.gz
  cd netcdf-fortran-4.6.0/
  export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
  export CPPFLAGS="-I$DIR/NETCDF/include -I$DIR/grib2/include"
  export LDFLAGS="-L$DIR/NETCDF/lib -L$DIR/grib2/lib"
  export LIBS="-lnetcdf -lpnetcdf -lcurl -lhdf5_hl -lhdf5 -lz -lm -ldl -lgcc -lgfortran"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-parallel-tests --enable-hdf5
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check


  echo " "
  #################################### System Environment Tests ##############

  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar


  tar -xvf Fortran_C_tests.tar -C $WRFCHEM_FOLDER/Tests/Environment
  tar -xvf Fortran_C_NETCDF_MPI_tests.tar -C $WRFCHEM_FOLDER/Tests/Compatibility
  export one="1"
  echo " "
  ############## Testing Environment #####

  cd $WRFCHEM_FOLDER/Tests/Environment
  cp ${NETCDF}/include/netcdf.inc .

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



  ###############################NCEPlibs#####################################
  #The libraries are built and installed with
  # ./make_ncep_libs.sh -s MACHINE -c COMPILER -d NCEPLIBS_DIR -o OPENMP [-m mpi] [-a APPLICATION]
  #It is recommended to install the NCEPlibs into their own directory, which must be created before running the installer. Further information on the command line arguments can be obtained with
  # ./make_ncep_libs.sh -h

  #If iand error occurs go to https://github.com/NCAR/NCEPlibs/pull/16/files make adjustment and re-run ./make_ncep_libs.sh
  ############################################################################


  cd $WRFCHEM_FOLDER/Downloads
  git clone https://github.com/NCAR/NCEPlibs.git
  cd NCEPlibs
  mkdir $DIR/nceplibs

  export JASPER_INC=$DIR/grib2/include
  export PNG_INC=$DIR/grib2/include
  export NETCDF=$DIR/NETCDF

  #for loop to edit linux.gnu for nceplibs to install
  #make if statement for gcc-9 or older
  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
  then
    y="24 28 32 36 40 45 49 53 56 60 64 68 69 73 74 79"
    for X in $y; do
      sed -i "${X}s/= /= $fallow_argument $boz_argument /g" $WRFCHEM_FOLDER/Downloads/NCEPlibs/macros.make.linux.gnu
    done
  else
    echo ""
    echo "Loop not needed"
  fi

  if [ ${auto_config} -eq 1 ]
    then
      echo yes | ./make_ncep_libs.sh -s linux -c gnu -d $DIR/nceplibs -o 0 -m 1 -a upp
    else
      ./make_ncep_libs.sh -s linux -c gnu -d $DIR/nceplibs -o 0 -m 1 -a upp
  fi

  export PATH=$DIR/nceplibs:$PATH

  echo " "
  ################################UPPv4.1######################################
  #Previous verison of UPP
  #WRF Support page recommends UPPV4.1 due to too many changes to WRF and UPP code
  #since the WRF was written
  #Option 8 gfortran compiler with distributed memory
  #############################################################################
  cd $WRFCHEM_FOLDER/
  git clone -b dtc_post_v4.1.0 --recurse-submodules https://github.com/NOAA-EMC/EMC_post UPPV4.1
  cd UPPV4.1
  mkdir postprd
  export NCEPLIBS_DIR=$DIR/nceplibs
  export NETCDF=$DIR/NETCDF

  if [ ${auto_config} -eq 1 ]
    then
      echo 8 | ./configure  #Option 8 gfortran compiler with distributed memory
    else
      ./configure  #Option 8 gfortran compiler with distributed memory
  fi


  echo " "
  #make if statement for gcc-9 or older
  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
  then
    z="58 63"
    for X in $z; do
      sed -i "${X}s/(FOPT)/(FOPT) $fallow_argument $boz_argument  /g" $WRFCHEM_FOLDER/UPPV4.1/configure.upp
    done
  else
    echo ""
    echo "Loop not needed"
  fi


  ./compile
  cd $WRFCHEM_FOLDER/UPPV4.1/scripts
  chmod +x run_unipost



  echo " "
  ######################## ARWpost V3.1  ############################
  ## ARWpost
  ##Configure #3
  ###################################################################
  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz
  tar -xvzf ARWpost_V3.tar.gz -C $WRFCHEM_FOLDER/
  cd $WRFCHEM_FOLDER/ARWpost
  ./clean -a
  sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $WRFCHEM_FOLDER/ARWpost/src/Makefile
  export NETCDF=$DIR/NETCDF

  if [ ${auto_config} -eq 1 ]
    then
      echo 3 | ./configure  #Option 3 gfortran compiler with distributed memory
    else
      ./configure  #Option 3 gfortran compiler with distributed memory
  fi



  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
  then
    sed -i '32s/-ffree-form -O -fno-second-underscore -fconvert=big-endian -frecord-marker=4/-ffree-form -O -fno-second-underscore -fconvert=big-endian -frecord-marker=4 ${fallow_argument} /g' configure.arwp
  fi


  sed -i -e 's/-C -P -traditional/-P -traditional/g' $WRFCHEM_FOLDER/ARWpost/configure.arwp
  ./compile


  export PATH=$WRFCHEM_FOLDER/ARWpost/ARWpost.exe:$PATH

  echo " "
  ################################ OpenGrADS ##################################
  #Verison 2.2.1 32bit of Linux
  #############################################################################
  if [[ $GRADS_PICK -eq 1 ]]; then

    cd $WRFCHEM_FOLDER/Downloads
    tar -xzvf opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz -C $WRFCHEM_FOLDER/
    cd $WRFCHEM_FOLDER/
    mv $WRFCHEM_FOLDER/opengrads-2.2.1.oga.1  $WRFCHEM_FOLDER/GrADS
    cd GrADS/Contents
    wget -c -4 https://github.com/regisgrundig/SIMOP/blob/master/g2ctl.pl
    chmod +x g2ctl.pl
    wget -c -4 https://sourceforge.net/projects/opengrads/files/wgrib2/0.1.9.4/wgrib2-v0.1.9.4-bin-i686-glib2.5-linux-gnu.tar.gz
    tar -xzvf wgrib2-v0.1.9.4-bin-i686-glib2.5-linux-gnu.tar.gz
    cd wgrib2-v0.1.9.4/bin
    mv wgrib2 $WRFCHEM_FOLDER/GrADS/Contents
    cd $WRFCHEM_FOLDER/GrADS/Contents
    rm wgrib2-v0.1.9.4-bin-i686-glib2.5-linux-gnu.tar.gz
    rm -r wgrib2-v0.1.9.4

    export PATH=$WRFCHEM_FOLDER/GrADS/Contents:$PATH

  fi

  echo " "


  ################################## GrADS ###############################
  # Version  2.2.1
  # Sublibs library instructions: http://cola.gmu.edu/grads/gadoc/supplibs2.html
  # GrADS instructions: http://cola.gmu.edu/grads/downloads.php
  ########################################################################
  if [[ $GRADS_PICK -eq 2 ]]; then

    echo $PASSWD | sudo -S apt -y install grads

  fi

  ##################### NCAR COMMAND LANGUAGE           ##################
  ########### NCL compiled via Conda                    ##################
  ########### This is the preferred method by NCAR      ##################
  ########### https://www.ncl.ucar.edu/index.shtml      ##################
  echo " "
  #Installing Miniconda3 to WRF directory and updating libraries
  export Miniconda_Install_DIR=$WRFCHEM_FOLDER/miniconda3

  mkdir -p $Miniconda_Install_DIR

  wget -c -4 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $Miniconda_Install_DIR/miniconda.sh
  bash $Miniconda_Install_DIR/miniconda.sh -b -u -p $Miniconda_Install_DIR

  rm -rf $Miniconda_Install_DIR/miniconda.sh

  export PATH=$WRFHYDRO_FOLDER/miniconda3/bin:$PATH

  source $Miniconda_Install_DIR/etc/profile.d/conda.sh

  $Miniconda_Install_DIR/bin/conda init bash
  $Miniconda_Install_DIR/bin/conda init zsh
  $Miniconda_Install_DIR/bin/conda init tcsh
  $Miniconda_Install_DIR/bin/conda init xonsh
  $Miniconda_Install_DIR/bin/conda init powershell

  conda config --add channels conda-forge
  conda config --set auto_activate_base false
  conda update -n root --all -y


  export $PATH


  echo " "



  echo " "
  #Installing NCL via Conda
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n ncl_stable -c conda-forge ncl -y
  conda activate ncl_stable
  conda update -n ncl_stable --all -y
  conda deactivate
  conda deactivate
  conda deactivate

  echo " "

  ############################OBSGRID###############################
  ## OBSGRID
  ## Downloaded from git tagged releases
  ## Option #2
  ########################################################################
  cd $WRFCHEM_FOLDER/
  git clone https://github.com/wrf-model/OBSGRID.git
  cd $WRFCHEM_FOLDER/OBSGRID

  ./clean -a
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate ncl_stable


  export HOME=`cd;pwd`
  export DIR=$WRFCHEM_FOLDER/Libs
  export NETCDF=$DIR/NETCDF

  if [ ${auto_config} -eq 1 ]
    then
        echo 2 | ./configure #Option 2 for gfortran/gcc and distribunted memory
      else
        ./configure   #Option 2 for gfortran/gcc and distribunted memory
    fi

    sed -i '27s/-lnetcdf -lnetcdff/ -lnetcdff -lnetcdf/g' configure.oa

    sed -i '31s/-lncarg -lncarg_gks -lncarg_c -lX11 -lm -lcairo/-lncarg -lncarg_gks -lncarg_c -lX11 -lm -lcairo -lfontconfig -lpixman-1 -lfreetype -lhdf5 -lhdf5_hl /g' configure.oa

    sed -i '39s/-frecord-marker=4/-frecord-marker=4 ${fallow_argument} /g' configure.oa

    sed -i '44s/=	/=	${fallow_argument} /g' configure.oa

    sed -i '45s/-C -P -traditional/-P -traditional/g' configure.oa


    echo " "


  ./compile

  conda deactivate
  conda deactivate
  conda deactivate

  # IF statement to check that all files were created.
   cd $WRFCHEM_FOLDER/OBSGRID
   n=$(ls ./*.exe | wc -l)
   if (( $n == 3 ))
      then
          echo "All expected files created."
          read -r -t 5 -p "Finished installing OBSGRID. I am going to wait for 5 seconds only ..."
      else
          echo "Missing one or more expected files. Exiting the script."
          read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
          exit
   fi

  echo " "
  ############################## RIP4 #####################################
  mkdir $WRFCHEM_FOLDER/RIP4
  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/RIP_47.tar.gz
  tar -xvzf RIP_47.tar.gz -C $WRFCHEM_FOLDER/RIP4
  cd $WRFCHEM_FOLDER/RIP4/RIP_47
  mv * ..
  cd $WRFCHEM_FOLDER/RIP4
  rm -rd RIP_47
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda activate ncl_stable
  conda install -c conda-forge ncl c-compiler fortran-compiler cxx-compiler -y


  export RIP_ROOT=$WRFCHEM_FOLDER/RIP4
  export NETCDF=$DIR/NETCDF
  export NCARG_ROOT=$WRFCHEM_FOLDER/miniconda3/envs/ncl_stable


  sed -i '349s|-L${NETCDF}/lib -lnetcdf $NETCDFF|-L${NETCDF}/lib $NETCDFF -lnetcdff -lnetcdf -lnetcdf -lnetcdff_C -lhdf5 |g' $WRFCHEM_FOLDER/RIP4/configure

  sed -i '27s|NETCDFLIB	= -L${NETCDF}/lib -lnetcdf CONFIGURE_NETCDFF_LIB|NETCDFLIB	= -L</usr/lib/x86_64-linux-gnu/libm.a> -lm -L${NETCDF}/lib CONFIGURE_NETCDFF_LIB -lnetcdf -lhdf5 -lhdf5_hl -lgfortran -lgcc -lz |g' $WRFCHEM_FOLDER/RIP4/arch/preamble

  sed -i '31s|-L${NCARG_ROOT}/lib -lncarg -lncarg_gks -lncarg_c -lX11 -lXext -lpng -lz CONFIGURE_NCARG_LIB| -L${NCARG_ROOT}/lib -lncarg -lncarg_gks -lncarg_c -lX11 -lXext -lpng -lz -lcairo -lfontconfig -lpixman-1 -lfreetype -lexpat -lpthread -lbz2 -lXrender -lgfortran -lgcc -L</usr/lib/x86_64-linux-gnu/> -lm -lhdf5 -lhdf5_hl |g' $WRFCHEM_FOLDER/RIP4/arch/preamble

  sed -i '33s| -O|-fallow-argument-mismatch -O |g' $WRFCHEM_FOLDER/RIP4/arch/configure.defaults

  sed -i '35s|=|= -L$WRFCHEM_FOLDER/LIBS/grib2/lib -lhdf5 -lhdf5_hl |g' $WRFCHEM_FOLDER/RIP4/arch/configure.defaults


  if [ ${auto_config} -eq 1 ]
    then
      echo 3 | ./configure  #Option 3 gfortran compiler with distributed memory
    else
      ./configure  #Option 3 gfortran compiler with distributed memory
  fi

  ./compile

  conda deactivate
  conda deactivate
  conda deactivate

  # IF statement to check that all files were created.
   cd $WRFCHEM_FOLDER/RIP4
   n=$(find . -type l -ls | wc -l)
   if (( $n == 12 ))
    then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing RIP4. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi

  echo " "


  echo " "
  ##################### WRF Python           ##################
  ########### WRf-Python compiled via Conda  ##################
  ########### This is the preferred method by NCAR      ##################
  ##### https://wrf-python.readthedocs.io/en/latest/installation.html  ##################
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n wrf-python -c conda-forge wrf-python -y
  conda activate wrf-python
  conda update -n wrf-python --all -y
  conda deactivate
  conda deactivate
  conda deactivate



  echo " "

  ############################WRFDA 3DVAR###############################
  ## WRFDA v4.4.2 3DVAR
  ## Downloaded from git tagged releases
  ## Does not include RTTOV Libarary for radiation data.  If wanted will need to install library then reconfigure
  ##Note: if you intend to run both 3DVAR and 4DVAR experiments, it is not necessary to compile the code twice.
  #Option 34 for gfortran/gcc and distribunted memory
  ########################################################################
  cd $WRFCHEM_FOLDER/Downloads
  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz -O WRF-4.4.2.tar.gz
  mkdir $WRFCHEM_FOLDER/WRFDA
  tar -xvzf WRF-4.4.2.tar.gz -C $WRFCHEM_FOLDER/WRFDA
    cd $WRFCHEM_FOLDER/WRFDA/WRFV4.4.2
  mv * $WRFCHEM_FOLDER/WRFDA
  cd $WRFCHEM_FOLDER/WRFDA
  rm -r WRFV4.4.2/
  cd $WRFCHEM_FOLDER/WRFDA

  ulimit -s unlimited
  export WRF_EM_CORE=1
  export WRF_NMM_CORE=0
  export WRF_CHEM=1
  export WRFIO_NCD_LARGE_FILE_SUPPORT=1

  ./clean -a

  # SED statements to fix configure error
sed -i '186s/==/=/g' $WRFCHEM_FOLDER/WRFDA/configure
sed -i '318s/==/=/g' $WRFCHEM_FOLDER/WRFDA/configure
sed -i '919s/==/=/g' $WRFCHEM_FOLDER/WRFDA/configure

  if [ ${auto_config} -eq 1 ]
    then
        echo 34 | ./configure wrfda  #Option 34 for gfortran/gcc and distribunted memory
      else
        ./configure  wrfda  #Option 34 for gfortran/gcc and distribunted memory
  fi
  echo " "
  ./compile -j $CPU_HALF_EVEN all_wrfvar | tee compile1.log
  echo " "
  # IF statement to check that all files were created.
   cd $WRFCHEM_FOLDER/WRFDA/var/da
   n=$(ls ./*.exe | wc -l)
   cd $WRFCHEM_FOLDER/WRFDA/var/obsproc/src
   m=$(ls ./*.exe | wc -l)
   if (( ( $n == 43 ) && ( $m == 1) ))
    then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing WRFDA-CHEM 3DVAR. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi
  echo " "

  ############################ WRFCHEM 4.4.2 #################################
  ## WRF CHEM v4.4.2
  ## Downloaded from git tagged releases
  # option 34, option 1 for gfortran and distributed memory w/basic nesting
  # If the script comes back asking to locate a file (libfl.a)
  # Use locate command to find file. in a new terminal and then copy that location
  #locate *name of file*
  #Optimization set to 0 due to buffer overflow dump
  #sed -i -e 's/="-O"/="-O0/' configure_kpp
  # io_form_boundary
  # io_form_history
  # io_form_auxinput2
  # io_form_auxhist2
  # Note that you need set nocolons = .true. in the section &time_control of namelist.input
  ########################################################################
  #Setting up WRF-CHEM/KPP
  cd $WRFCHEM_FOLDER/Downloads

  ulimit -s unlimited
  export WRF_EM_CORE=1
  export WRF_NMM_CORE=0
  export WRF_CHEM=1
  export WRF_KPP=1
  export YACC='/usr/bin/yacc -d'
  export FLEX=/usr/bin/flex
  export FLEX_LIB_DIR=/usr/lib/x86_64-linux-gnu/
  export KPP_HOME=$WRFCHEM_FOLDER/WRFV4.4.2/chem/KPP/kpp/kpp-2.1
  export WRF_SRC_ROOT_DIR=$WRFCHEM_FOLDER/WRFV4.4.2
  export PATH=$KPP_HOME/bin:$PATH
  export SED=/usr/bin/sed
  export WRFIO_NCD_LARGE_FILE_SUPPORT=1

  #Downloading WRF code

  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz -O WRF-4.4.2.tar.gz
  tar -xvzf WRF-4.4.2.tar.gz -C $WRFCHEM_FOLDER/
  cd $WRFCHEM_FOLDER/WRFV4.4.2

  cd chem/KPP
  sed -i -e 's/="-O"/="-O0"/' configure_kpp
  cd -

  ./clean -a


  # SED statements to fix configure error
  sed -i '186s/==/=/g' $WRFCHEM_FOLDER/WRFV4.4.2/configure
  sed -i '318s/==/=/g' $WRFCHEM_FOLDER/WRFV4.4.2/configure
  sed -i '919s/==/=/g' $WRFCHEM_FOLDER/WRFV4.4.2/configure

  if [ ${auto_config} -eq 1 ]
    then
        sed -i '428s/.*/  $response = "34 \\n";/g' $WRFCHEM_FOLDER/WRFV4.4.2/arch/Config.pl # Answer for compiler choice
        sed -i '869s/.*/  $response = "1 \\n";/g' $WRFCHEM_FOLDER/WRFV4.4.2/arch/Config.pl  #Answer for basic nesting
        ./configure
    else
      ./configure  #Option 34 gfortran compiler with distributed memory option 1 for basic nesting
  fi

  ./compile -j $CPU_HALF_EVEN em_real

  export WRF_DIR=$WRFCHEM_FOLDER/WRFV4.4.2
  # IF statement to check that all files were created.
  cd $WRFCHEM_FOLDER/WRFV4.4.2/main
  n=$(ls ./*.exe | wc -l)
  if (($n >= 3))
   then
   echo "All expected files created."
   read -r -t 5 -p "Finished installing WRF. I am going to wait for 5 seconds only ..."
  else
   echo "Missing one or more expected files. Exiting the script."
   read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
   exit
  fi
  echo " "
  ############################WPSV4.4#####################################
  ## WPS v4.4
  ## Downloaded from git tagged releases
  #Option 3 for gfortran and distributed memory
  ########################################################################

  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WPS/archive/refs/tags/v4.4.tar.gz -O WPS-4.4.tar.gz
  tar -xvzf WPS-4.4.tar.gz -C $WRFCHEM_FOLDER/
  cd $WRFCHEM_FOLDER/WPS-4.4

  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        echo 3 | ./configure #Option 3 for gfortran and distributed memory
      else
        ./configure  #Option 3 gfortran compiler with distributed memory
    fi
  ./compile

  echo " "
  # IF statement to check that all files were created.
   cd $WRFCHEM_FOLDER/WPS-4.4
   n=$(ls ./*.exe | wc -l)
   if (($n == 3))
    then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing WPS. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi

  echo " "





  ######################## WPS Domain Setup Tools ########################
  ## DomainWizard
  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 http://esrl.noaa.gov/gsd/wrfportal/domainwizard/WRFDomainWizard.zip
  mkdir $WRFCHEM_FOLDER/WRFDomainWizard
  unzip WRFDomainWizard.zip -d $WRFCHEM_FOLDER/WRFDomainWizard
  chmod +x $WRFCHEM_FOLDER/WRFDomainWizard/run_DomainWizard

  echo " "
  ######################## WPF Portal Setup Tools ########################
  ## WRFPortal
  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 https://esrl.noaa.gov/gsd/wrfportal/portal/wrf-portal.zip
  mkdir $WRFCHEM_FOLDER/WRFPortal
  unzip wrf-portal.zip -d $WRFCHEM_FOLDER/WRFPortal
  chmod +x $WRFCHEM_FOLDER/WRFPortal/runWRFPortal



  echo " "
  ######################## Static Geography Data inc/ Optional ####################
  # http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  # These files are large so if you only need certain ones comment the others off
  # All files downloaded and untarred is 200GB
  # https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  #################################################################################
  cd $WRFCHEM_FOLDER/Downloads
  mkdir $WRFCHEM_FOLDER/GEOG
  mkdir $WRFCHEM_FOLDER/GEOG/WPS_GEOG

  echo " "
  echo "Mandatory WRF Preprocessing System (WPS) Geographical Input Data Mandatory Fields Downloads"
  echo " "
  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
  tar -xvzf geog_high_res_mandatory.tar.gz -C $WRFCHEM_FOLDER/GEOG/

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz
  tar -xvzf geog_low_res_mandatory.tar.gz -C $WRFCHEM_FOLDER/GEOG/
  mv $WRFCHEM_FOLDER/GEOG/WPS_GEOG_LOW_RES/ $WRFCHEM_FOLDER/GEOG/WPS_GEOG

  if [ ${WPS_Specific_Applications} -eq 1 ]
    then
      echo " "
      echo " WPS Geographical Input Data Mandatory for Specific Applications"
      echo " "
      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
      tar -xvzf geog_thompson28_chem.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
      tar -xvzf geog_noahmp.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4  https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
      tar -xvzf irrigation.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
      tar -xvzf geog_px.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
      tar -xvzf geog_urban.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
      tar -xvzf geog_ssib.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
      tar -xvf lake_depth.tar.bz2 -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/topobath_30s.tar.bz2
      tar -xvf topobath_30s.tar.bz2 -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/gsl_gwd.tar.bz2
      tar -xvf gsl_gwd.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG
  fi

  if [ ${Optional_GEOG} -eq 1 ]
    then

      echo " "
      echo "Optional WPS Geographical Input Data"
      echo " "


      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_older_than_2000.tar.gz
      tar -xvzf geog_older_than_2000.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s_with_lakes.tar.gz
      tar -xvzf modis_landuse_20class_15s_with_lakes.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_alt_lsm.tar.gz
      tar -xvzf geog_alt_lsm.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/nlcd2006_ll_9s.tar.bz2
      tar -xvf nlcd2006_ll_9s.tar.bz2 -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/updated_Iceland_LU.tar.gz
      tar -xvf updated_Iceland_LU.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s.tar.bz2
      tar -xvf modis_landuse_20class_15s.tar.bz2 -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

  fi


fi

if [ "$Ubuntu_64bit_Intel" = "1" ] && [ "$WRFCHEM_PICK" = "1" ]; then

  ############################# Basic package managment ############################

  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade

  # download the key to system keyring; this and the following echo command are
  # needed in order to install the Intel compilers
  wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
  | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null


  # add signed entry to apt sources and configure the APT client to use Intel repository:
  echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list

  # this update should get the Intel package info from the Intel repository
  echo $PASSWD | sudo -S apt -y update

  # necessary binary packages (especially pkg-config and build-essential)
  echo $PASSWD | sudo -S apt -y install git gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh python3 python3-dev python2 python2-dev mlocate curl cmake libcurl4-openssl-dev pkg-config build-essential

  # install the Intel compilers
  echo $PASSWD | sudo -S apt -y install intel-basekit intel-hpckit intel-aikit
  echo $PASSWD | sudo -S apt -y update


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
  export CFLAGS="-fPIC -fPIE -O3"
  export FFLAGS="-m64"
  export FCFLAGS="-m64"
  ############################# CPU Core Management ####################################

  export CPU_CORE=$(nproc)                                   # number of available threads on system
  export CPU_6CORE="6"
  export CPU_HALF=$(($CPU_CORE / 2))                         # half of availble cores on system
  # Forces CPU cores to even number to avoid partial core export. ie 7 cores would be 3.5 cores.
  export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))

  # If statement for low core systems.  Forces computers to only use 1 core if there are 4 cores or less on the system.
  if [ $CPU_CORE -le $CPU_6CORE ]
    then
      export CPU_HALF_EVEN="2"
    else
      export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))
  fi

  echo "##########################################"
  echo "Number of Threads being used $CPU_HALF_EVEN"
  echo "##########################################"

  ############################## Directory Listing ############################
  # makes necessary directories
  ## If you want WRFCHEM or WRF-Hydro change "WRF" in this variable to either "WRFCHEM" or "WRF-Hydro"
  ############################################################################


  export HOME=`cd;pwd`
  export WRFCHEM_FOLDER=$HOME/WRFCHEM_Intel
  export DIR=$WRFCHEM_FOLDER/Libs
  mkdir $WRFCHEM_FOLDER
  cd $WRFCHEM_FOLDER
  mkdir Downloads
  mkdir WRFDA
  mkdir Libs
  mkdir Libs/grib2
  mkdir Libs/NETCDF
  mkdir Libs/MPICH

  mkdir -p Tests/Environment
  mkdir -p Tests/Compatibility

  echo " "
  ############################## Downloading Libraries ############################

  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz
  wget -c -4 https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_2.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz
  wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.39.tar.gz
  wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
  wget -c -4 https://sourceforge.net/projects/opengrads/files/grads2/2.2.1.oga.1/Linux%20%2864%20Bits%29/opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz

  echo " "
  ############################# ZLib ############################

  cd $WRFCHEM_FOLDER/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3" ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN | tee zlib.make.log
  # make check | tee zlib.makecheck.log
  make -j $CPU_HALF_EVEN install | tee zlib.makeinstall.log

  echo " "
  ############################# LibPNG ############################

  cd $WRFCHEM_FOLDER/Downloads

  # other libraries below need these variables to be set
  export LDFLAGS=-L$DIR/grib2/lib
  export CPPFLAGS=-I$DIR/grib2/include

  tar -xvzf libpng-1.6.39.tar.gz
  cd libpng-1.6.39/

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3"   ./configure --prefix=$DIR/grib2

  make -j $CPU_HALF_EVEN | tee libpng.make.log
  #make -j $CPU_HALF_EVEN check | tee libpng.makecheck.log
  make -j $CPU_HALF_EVEN install | tee libpng.makeinstall.log

  echo " "
  ############################# JasPer ############################

  cd $WRFCHEM_FOLDER/Downloads
  unzip jasper-1.900.1.zip
  cd jasper-1.900.1/

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3"  ./configure --prefix=$DIR/grib2

  make -j $CPU_HALF_EVEN | tee jasper.make.log
  make  -j $CPU_HALF_EVEN install | tee jasper.makeinstall.log

  # other libraries below need these variables to be set
  export JASPERLIB=$DIR/grib2/lib
  export JASPERINC=$DIR/grib2/include

  echo " "
  ############################# HDF5 library for NetCDF4 & parallel functionality ############################

  cd $WRFCHEM_FOLDER/Downloads
  tar -xvzf hdf5-1_13_2.tar.gz
  cd hdf5-hdf5-1_13_2

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3"  ./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran --enable-parallel

  make -j $CPU_HALF_EVEN | tee hdf5.make.log
  make -j $CPU_HALF_EVEN install | tee hdf5.makeinstall.log

  # other libraries below need these variables to be set
  export HDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
  export PATH=$HDF5/bin:$PATH
  export PHDF5=$DIR/grib2

  echo " "

  #############################Install Parallel-netCDF##############################
  #Make file created with half of available cpu cores
  #Hard path for MPI added
  ##################################################################################
  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4  https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz
  tar -xvzf pnetcdf-1.12.3.tar.gz
  cd pnetcdf-1.12.3
  ./configure --prefix=$DIR/grib2  --enable-shared --enable-static

  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  export PNETCDF=$DIR/grib2



  ############################## Install NETCDF-C Library ############################

  cd $WRFCHEM_FOLDER/Downloads
  tar -xzvf v4.9.0.tar.gz
  cd netcdf-c-4.9.0/

  # these variables need to be set for the NetCDF-C install to work
  export CPPFLAGS=-I$DIR/grib2/include
  export LDFLAGS=-L$DIR/grib2/lib
  export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lgfortran -lgcc -lm -ldl"

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3"   ./configure --prefix=$DIR/NETCDF --disable-dap --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-pnetcdf --enable-cdf5 --enable-parallel-tests | tee netcdf.configure.log

  make -j $CPU_HALF_EVEN | tee netcdf.make.log
  make -j $CPU_HALF_EVEN install | tee netcdf.makeinstall.log

  # other libraries below need these variables to be set
  export PATH=$DIR/NETCDF/bin:$PATH
  export NETCDF=$DIR/NETCDF

  echo " "
  ############################## NetCDF-Fortran library ############################

  cd $WRFCHEM_FOLDER/Downloads
  tar -xvzf v4.6.0.tar.gz
  cd netcdf-fortran-4.6.0/

  # these variables need to be set for the NetCDF-Fortran install to work
  export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
  export CPPFLAGS="-I$DIR/NETCDF/include -I$DIR/grib2/include"
  export LDFLAGS="-L$DIR/NETCDF/lib -L$DIR/grib2/lib"
  export LIBS="-lnetcdf -lpnetcdf -lcurl -lhdf5_hl -lhdf5 -lz -lm -ldl -lgcc -lgfortran"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-parallel-tests --enable-hdf5

  make -j $CPU_HALF_EVEN | tee netcdf-f.make.log
  make  -j $CPU_HALF_EVEN install | tee netcdf-f.makeinstall.log


  echo " "
  #################################### System Environment Tests ##############

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
  ifort TEST_1_fortran_only_fixed.f
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
  ifort TEST_2_fortran_only_free.f90
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
  icc TEST_3_c_only.c
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
  icc -c -m64 TEST_4_fortran+c_c.c
  ifort -c -m64 TEST_4_fortran+c_f.f90
  ifort -m64 TEST_4_fortran+c_f.o TEST_4_fortran+c_c.o
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
  ifort -c 01_fortran+c+netcdf_f.f
  icc -c 01_fortran+c+netcdf_c.c
  ifort 01_fortran+c+netcdf_f.o 01_fortran+c+netcdf_c.o \
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
  mpiifort -c 02_fortran+c+netcdf+mpi_f.f
  mpiicc -c 02_fortran+c+netcdf+mpi_c.c
  mpiifort 02_fortran+c+netcdf+mpi_f.o \
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
  ###############################NCEPlibs#####################################
  #The libraries are built and installed with
  # ./make_ncep_libs.sh -s MACHINE -c COMPILER -d NCEPLIBS_DIR -o OPENMP [-m mpi] [-a APPLICATION]
  #It is recommended to install the NCEPlibs into their own directory, which must be created before running the installer. Further information on the command line arguments can be obtained with
  # ./make_ncep_libs.sh -h

  #If iand error occurs go to https://github.com/NCAR/NCEPlibs/pull/16/files make adjustment and re-run ./make_ncep_libs.sh
  ############################################################################



  cd $WRFCHEM_FOLDER/Downloads
  git clone https://github.com/NCAR/NCEPlibs.git
  cd NCEPlibs
  mkdir $DIR/nceplibs

  export JASPER_INC=$DIR/grib2/include
  export PNG_INC=$DIR/grib2/include
  export NETCDF=$DIR/NETCDF



  if [ ${auto_config} -eq 1 ]
    then
      echo yes | ./make_ncep_libs.sh -s linux -c intel -d $DIR/nceplibs -o 0 -m 1 -a upp
    else
      ./make_ncep_libs.sh -s linux -c intel -d $DIR/nceplibs -o 0 -m 1 -a upp
  fi
 export PATH=$DIR/nceplibs:$PATH

  echo " "
  ################################UPPv4.1######################################
  #Previous verison of UPP
  #WRF Support page recommends UPPV4.1 due to too many changes to WRF and UPP code
  #since the WRF was written
  #Option 8 gfortran compiler with distributed memory
  #############################################################################
  cd $WRF_FOLDER
  git clone -b dtc_post_v4.1.0 --recurse-submodules https://github.com/NOAA-EMC/EMC_post UPPV4.1
  cd UPPV4.1
  mkdir postprd
  export NCEPLIBS_DIR=$DIR/nceplibs
  export NETCDF=$DIR/NETCDF

  if [ ${auto_config} -eq 1 ]
    then
      echo 4 | ./configure  #Option 4 intel compiler with distributed memory
    else
      ./configure  #Option 4 intel compiler with distributed memory
  fi

  sed -i '24s/ mpif90/ mpiifort/g' $WRFCHEM_FOLDER/UPPV4.1/configure.upp
  sed -i '25s/ mpif90/ mpiifort/g' $WRFCHEM_FOLDER/UPPV4.1/configure.upp
  sed -i '26s/ mpicc/ mpiicc/g' $WRFCHEM_FOLDER/UPPV4.1/configure.upp

  ./compile
  cd $WRFCHEM_FOLDER/UPPV4.1/scripts
  chmod +x run_unipost

  # IF statement to check that all files were created.
   cd $WRFCHEM_FOLDER/UPPV4.1/exec
   n=$(ls ./*.exe | wc -l)
   if (( $n == 1 ))
    then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing UPPV4.1. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi

  echo " "



  ######################## ARWpost V3.1  ############################
  ## ARWpost
  ##Configure #3
  ###################################################################
  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz
  tar -xvzf ARWpost_V3.tar.gz -C $WRF_FOLDER
  cd $WRFCHEM_FOLDER/ARWpost
  ./clean -a
  sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $WRFCHEM_FOLDER/ARWpost/src/Makefile
  export NETCDF=$DIR/NETCDF

  if [ ${auto_config} -eq 1 ]
    then
      echo 2 | ./configure  #Option 2 intel compiler with distributed memory
    else
      ./configure  #Option 2 intel compiler with distributed memory
  fi

  sed -i -e 's/-C -P -traditional/-P -traditional/g' $WRFCHEM_FOLDER/ARWpost/configure.arwp
  ./compile

  export PATH=$WRFCHEM_FOLDER/ARWpost/ARWpost.exe:$PATH

  echo " "
  ################################OpenGrADS######################################
  #Verison 2.2.1 64bit of Linux
  #############################################################################
  if [[ $GRADS_PICK -eq 1 ]]; then
    cd $WRFCHEM_FOLDER/Downloads
    tar -xzvf opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz -C $WRFCHEM_FOLDER/
    cd $WRFCHEM_FOLDER/
    mv $WRFCHEM_FOLDER/opengrads-2.2.1.oga.1  $WRFCHEM_FOLDER/GrADS
    cd GrADS/Contents
    wget -c -4 https://github.com/regisgrundig/SIMOP/blob/master/g2ctl.pl
    chmod +x g2ctl.pl
    wget -c -4 https://sourceforge.net/projects/opengrads/files/wgrib2/0.1.9.4/wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
    tar -xzvf wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
    cd wgrib2-v0.1.9.4/bin
    mv wgrib2 $WRFCHEM_FOLDER/GrADS/Contents
    cd $WRFCHEM_FOLDER/GrADS/Contents
    rm wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
    rm -r wgrib2-v0.1.9.4


    export PATH=$WRFCHEM_FOLDER/GrADS/Contents:$PATH
  fi
  ################################## GrADS ###############################
  # Version  2.2.1
  # Sublibs library instructions: http://cola.gmu.edu/grads/gadoc/supplibs2.html
  # GrADS instructions: http://cola.gmu.edu/grads/downloads.php
  ########################################################################
  if [[ $GRADS_PICK -eq 2 ]]; then

    echo $PASSWD | sudo -S apt -y install grads

  fi



  ##################### NCAR COMMAND LANGUAGE           ##################
  ########### NCL compiled via Conda                    ##################
  ########### This is the preferred method by NCAR      ##################
  ########### https://www.ncl.ucar.edu/index.shtml      ##################
  echo " "
  #Installing Miniconda3 to WRF directory and updating libraries

  export Miniconda_Install_DIR=$WRFCHEM_FOLDER/miniconda3

  mkdir -p $Miniconda_Install_DIR

  wget -c -4 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $Miniconda_Install_DIR/miniconda.sh
  bash $Miniconda_Install_DIR/miniconda.sh -b -u -p $Miniconda_Install_DIR

  rm -rf $Miniconda_Install_DIR/miniconda.sh

  export PATH=$WRFCHEM_FOLDER/miniconda3/bin:$PATH

  source $Miniconda_Install_DIR/etc/profile.d/conda.sh

  $Miniconda_Install_DIR/bin/conda init bash
  $Miniconda_Install_DIR/bin/conda init zsh
  $Miniconda_Install_DIR/bin/conda init tcsh
  $Miniconda_Install_DIR/bin/conda init xonsh
  $Miniconda_Install_DIR/bin/conda init powershell

  conda config --add channels conda-forge
  conda config --set auto_activate_base false
  conda update -n root --all -y


  export $PATH
  #Special Thanks to @_WaylonWalker for code development

  #Installing NCL via Conda
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n ncl_stable -c conda-forge ncl -y
  conda activate ncl_stable
  conda update -n ncl_stable --all -y
  conda deactivate
  conda deactivate
  conda deactivate

  echo " "


  ##################### WRF Python           ##################
  ########### WRf-Python compiled via Conda  ##################
  ########### This is the preferred method by NCAR      ##################
  ##### https://wrf-python.readthedocs.io/en/latest/installation.html  ##################
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n wrf-python -c conda-forge wrf-python -y
  conda activate wrf-python
  conda update -n wrf-python --all -y
  conda deactivate
  conda deactivate
  conda deactivate

  echo " "



  ############################WRFDA 3DVAR###############################
  ## WRFDA v4.4.2 3DVAR
  ## Downloaded from git tagged releases
  ## Does not include RTTOV Libarary for radiation data.  If wanted will need to install library then reconfigure
  ##Note: if you intend to run both 3DVAR and 4DVAR experiments, it is not necessary to compile the code twice.
  #Option 34 for gfortran/gcc and distribunted memory
  ########################################################################
  cd $WRFCHEM_FOLDER/Downloads
  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz -O WRF-4.4.2.tar.gz
  mkdir $WRFCHEM_FOLDER/WRFDA
  tar -xvzf WRF-4.4.2.tar.gz -C $WRFCHEM_FOLDER/WRFDA
    cd $WRFCHEM_FOLDER/WRFDA/WRFV4.4.2
  mv * $WRFCHEM_FOLDER/WRFDA
  cd $WRFCHEM_FOLDER/WRFDA
  rm -r WRFV4.4.2/
  cd $WRFCHEM_FOLDER/WRFDA

  ulimit -s unlimited
  export WRF_EM_CORE=1
  export WRF_NMM_CORE=0
  export WRF_CHEM=1
  export WRFIO_NCD_LARGE_FILE_SUPPORT=1

  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        echo 15 | ./configure wrfda  #Option 15 for intel and distribunted memory
      else
        ./configure  wrfda  #Option 15 for intel and distribunted memory
  fi
  echo " "

  #Need to remove mpich/GNU config calls to Intel config calls
  sed -i '170s|mpif90 -f90=$(SFC)|mpiifort|g' $WRFCHEM_FOLDER/WRFDA/configure.wrf
  sed -i '171s|mpicc -cc=$(SCC)|mpiicc|g' $WRFCHEM_FOLDER/WRFDA/configure.wrf

  ./compile -j $CPU_HALF_EVEN all_wrfvar | tee compile1.log
  echo " "
  # IF statement to check that all files were created.
   cd $WRFCHEM_FOLDER/WRFDA/var/da
   n=$(ls ./*.exe | wc -l)
   cd $WRFCHEM_FOLDER/WRFDA/var/obsproc/src
   m=$(ls ./*.exe | wc -l)
   if (( ( $n == 43 ) && ( $m == 1) ))
    then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing WRFDA-CHEM 3DVAR. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi
  echo " "



  ############################ WRF 4.4.2  #################################
  ## WRF v4.4.2
  ## Downloaded from git tagged releases
  # option 15, option 1 for intel and distributed memory w/basic nesting
  # large file support enable with WRFiO_NCD_LARGE_FILE_SUPPORT=1
  ########################################################################

  cd $WRFCHEM_FOLDER/Downloads

  ulimit -s unlimited
  export WRF_EM_CORE=1
  export WRF_NMM_CORE=0
  export WRF_CHEM=1
  export WRF_KPP=1
  export YACC='/usr/bin/yacc -d'
  export FLEX=/usr/bin/flex
  export FLEX_LIB_DIR=/usr/lib/x86_64-linux-gnu/
  export KPP_HOME=$WRFCHEM_FOLDER/WRFV4.4.2/chem/KPP/kpp/kpp-2.1
  export WRF_SRC_ROOT_DIR=$WRFCHEM_FOLDER/WRFV4.4.2
  export PATH=$KPP_HOME/bin:$PATH
  export SED=/usr/bin/sed
  export WRFIO_NCD_LARGE_FILE_SUPPORT=1



  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz -O WRF-4.4.2.tar.gz
  tar -xvzf WRF-4.4.2.tar.gz -C $WRFCHEM_FOLDER/
  cd $WRFCHEM_FOLDER/WRFV4.4.2

  cd chem/KPP
  sed -i -e 's/="-O"/="-O0"/' configure_kpp
  cd -


  export WRFIO_NCD_LARGE_FILE_SUPPORT=1
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        sed -i '428s/.*/  $response = "15 \\n";/g' $WRFCHEM_FOLDER/WRFV4.4.2/arch/Config.pl # Answer for compiler choice
        sed -i '869s/.*/  $response = "1 \\n";/g' $WRFCHEM_FOLDER/WRFV4.4.2/arch/Config.pl  #Answer for basic nesting
        ./configure
    else
      ./configure  #Option 15 intel compiler with distributed memory option 1 for basic nesting
  fi

  #Need to remove mpich/GNU config calls to Intel config calls
  sed -i '170s|mpif90 -f90=$(SFC)|mpiifort|g' $WRFCHEM_FOLDER/WRFV4.4.2/configure.wrf
  sed -i '171s|mpicc -cc=$(SCC)|mpiicc|g' $WRFCHEM_FOLDER/WRFV4.4.2/configure.wrf

  ./compile -j $CPU_HALF_EVEN em_real | tee em_real_intel.log

  export WRF_DIR=$WRFCHEM_FOLDER/WRFV4.4.2


  # IF statement to check that all files were created.
  cd $WRFCHEM_FOLDER/WRFV4.4.2/main
  n=$(ls ./*.exe | wc -l)
  if (($n >= 3))
   then
   echo "All expected files created."
   read -r -t 5 -p "Finished installing WRF. I am going to wait for 5 seconds only ..."
  else
   echo "Missing one or more expected files. Exiting the script."
   read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
   exit
  fi
  echo " "
  ############################WPSV4.4#####################################
  ## WPS v4.4
  ## Downloaded from git tagged releases
  #Option 3 for gfortran and distributed memory
  ########################################################################

  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WPS/archive/refs/tags/v4.4.tar.gz -O WPS-4.4.tar.gz
  tar -xvzf WPS-4.4.tar.gz -C $WRFCHEM_FOLDER/
  cd $WRFCHEM_FOLDER/WPS-4.4
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
      echo 19 | ./configure #Option 19 for intel and distributed memory
    else
        ./configure  #Option 19 intel compiler with distributed memory
    fi

    sed -i '67s|mpif90|mpiifort|g' $WRFCHEM_FOLDER/WPS-4.4/configure.wps
    sed -i '68s|mpicc|mpiicc|g' $WRFCHEM_FOLDER/WPS-4.4/configure.wps


  ./compile


  echo " "
  # IF statement to check that all files were created.
   cd $WRFCHEM_FOLDER/WPS-4.4
   n=$(ls ./*.exe | wc -l)
   if (($n == 3))
      then
        echo "All expected files created."
        read -r -t 5 -p "Finished installing WPS. I am going to wait for 5 seconds only ..."
      else
        echo "Missing one or more expected files. Exiting the script."
        read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
        exit
   fi
   echo " "

  ######################## WPS Domain Setup Tools ########################
  ## DomainWizard
  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 http://esrl.noaa.gov/gsd/wrfportal/domainwizard/WRFDomainWizard.zip
  mkdir $WRFCHEM_FOLDER/WRFDomainWizard
  unzip WRFDomainWizard.zip -d $WRFCHEM_FOLDER/WRFDomainWizard
  chmod +x $WRFCHEM_FOLDER/WRFDomainWizard/run_DomainWizard

  echo " "
  ######################## WPF Portal Setup Tools ########################
  ## WRFPortal
  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 https://esrl.noaa.gov/gsd/wrfportal/portal/wrf-portal.zip
  mkdir $WRFCHEM_FOLDER/WRFPortal
  unzip wrf-portal.zip -d $WRFCHEM_FOLDER/WRFPortal
  chmod +x $WRFCHEM_FOLDER/WRFPortal/runWRFPortal


  echo " "

  ######################## Static Geography Data inc/ Optional ####################
  # http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  # These files are large so if you only need certain ones comment the others off
  # All files downloaded and untarred is 200GB
  # https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  #################################################################################
  cd $WRFCHEM_FOLDER/Downloads
  mkdir $WRFCHEM_FOLDER/GEOG
  mkdir $WRFCHEM_FOLDER/GEOG/WPS_GEOG

  echo " "
  echo "Mandatory WRF Preprocessing System (WPS) Geographical Input Data Mandatory Fields Downloads"
  echo " "
  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
  tar -xvzf geog_high_res_mandatory.tar.gz -C $WRFCHEM_FOLDER/GEOG/

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz
  tar -xvzf geog_low_res_mandatory.tar.gz -C $WRFCHEM_FOLDER/GEOG/
  mv $WRFCHEM_FOLDER/GEOG/WPS_GEOG_LOW_RES/ $WRFCHEM_FOLDER/GEOG/WPS_GEOG


  if [ ${WPS_Specific_Applications} -eq 1 ]
    then
      echo " "
      echo " WPS Geographical Input Data Mandatory for Specific Applications"
      echo " "

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
      tar -xvzf geog_thompson28_chem.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
      tar -xvzf geog_noahmp.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4  https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
      tar -xvzf irrigation.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
      tar -xvzf geog_px.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
      tar -xvzf geog_urban.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
      tar -xvzf geog_ssib.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
      tar -xvf lake_depth.tar.bz2 -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/topobath_30s.tar.bz2
      tar -xvf topobath_30s.tar.bz2 -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/gsl_gwd.tar.bz2
      tar -xvf gsl_gwd.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG
  fi


  if [ ${Optional_GEOG} -eq 1 ]
    then
      echo " "
      echo "Optional WPS Geographical Input Data"
      echo " "

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_older_than_2000.tar.gz
      tar -xvzf geog_older_than_2000.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s_with_lakes.tar.gz
      tar -xvzf modis_landuse_20class_15s_with_lakes.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_alt_lsm.tar.gz
      tar -xvzf geog_alt_lsm.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/nlcd2006_ll_9s.tar.bz2
      tar -xvf nlcd2006_ll_9s.tar.bz2 -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/updated_Iceland_LU.tar.gz
      tar -xvf updated_Iceland_LU.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s.tar.bz2
      tar -xvf modis_landuse_20class_15s.tar.bz2 -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG
  fi




fi

if [ "$macos_64bit_GNU" = "1" ] && [ "$WRFCHEM_PICK" = "1" ]; then


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
  mkdir WRFDA
  mkdir Libs
  export DIR=$WRFCHEM_FOLDER/Libs
  mkdir -p Libs/grib2
  mkdir -p Libs/NETCDF
  mkdir -p Tests/Environment
  mkdir -p Tests/Compatibility

  ##############################Downloading Libraries############################

  cd Downloads
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

  echo "Please enter password for linking GNU libraries"
  echo $PASSWD | sudo -S ln -sf /usr/local/bin/gcc-1* /usr/local/bin/gcc
  echo $PASSWD | sudo -S ln -sf /usr/local/bin/g++-1* /usr/local/bin/g++
  echo $PASSWD | sudo -S ln -sf /usr/local/bin/gfortran-1* /usr/local/bin/gfortran

  export CC=gcc
  export CXX=g++
  export FC=gfortran
  export F77=gfortran
  export CFLAGS="-fPIC -fPIE -O3 -Wno-implicit-function-declaration"

  echo " "

  #############################zlib############################
  #Uncalling compilers due to comfigure issue with zlib1.2.12
  #With CC & CXX definied ./configure uses different compiler Flags

  cd $WRFCHEM_FOLDER/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/
  ./configure --prefix=$DIR/grib2
  make
  make install
  #make check

  echo " "
  #############################libpng############################
  cd $WRFCHEM_FOLDER/Downloads
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

  cd $WRFCHEM_FOLDER/Downloads
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

  cd $WRFCHEM_FOLDER/Downloads
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
  cd $WRFCHEM_FOLDER/Downloads
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

  cd $WRFCHEM_FOLDER/Downloads
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

  ############## ARWPOST ##################
  # No compatibile compiler for gcc/gfortran
  #########################################


  #Installing Miniconda3 to WRF directory and updating libraries
  export Miniconda_Install_DIR=$WRFCHEM_FOLDER/miniconda3

  mkdir -p $Miniconda_Install_DIR

  wget -c -4 https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O $Miniconda_Install_DIR/miniconda.sh
  bash $Miniconda_Install_DIR/miniconda.sh -b -u -p $Miniconda_Install_DIR

  rm -rf $Miniconda_Install_DIR/miniconda.sh

  export PATH=$WRFHYDRO_FOLDER/miniconda3/bin:$PATH

  source $Miniconda_Install_DIR/etc/profile.d/conda.sh

  $Miniconda_Install_DIR/bin/conda init bash
  $Miniconda_Install_DIR/bin/conda init zsh
  $Miniconda_Install_DIR/bin/conda init tcsh
  $Miniconda_Install_DIR/bin/conda init xonsh
  $Miniconda_Install_DIR/bin/conda init powershell

  conda config --add channels conda-forge
  conda config --set auto_activate_base false
  conda update -n root --all -y


  export $PATH


  echo " "

  #Installing NCL via Conda
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n ncl_stable -c conda-forge ncl -y
  conda activate ncl_stable
  conda update -n ncl_stable --all -y
  conda deactivate
  conda deactivate
  conda deactivate
  echo " "


  ############################OBSGRID###############################
  ## OBSGRID
  ## Downloaded from git tagged releases
  ## Not compatibile with gcc/gfortran on macos
  ########################################################################


  ##################### WRF Python           ##################
  ########### WRf-Python compiled via Conda  ##################
  ########### This is the preferred method by NCAR      ##################
  ##### https://wrf-python.readthedocs.io/en/latest/installation.html  ##################
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n wrf-python -c conda-forge wrf-python -y
  conda activate wrf-python
  conda update -n wrf-python --all -y
  conda deactivate
  conda deactivate
  conda deactivate

  echo " "


  echo " "
  ############################ WRFCHEM 4.4.2 #################################
  ## WRF CHEM v4.4.2
  ## Downloaded from git tagged releases
  # option 17, option 1 for gfortran and distributed memory w/basic nesting
  # If the script comes back asking to locate a file (libfl.a)
  # Use locate command to find file. in a new terminal and then copy that location
  #locate *name of file*
  #Optimization set to 0 due to buffer overflow dump
  #sed -i -e 's/="-O"/="-O0/' configure_kpp
  ########################################################################
  #Setting up WRF-CHEM/KPP
  cd $WRFCHEM_FOLDER/Downloads

  ulimit -s unlimited
  export MALLOC_CHECK_=0
  export WRF_EM_CORE=1
  export WRF_NMM_CORE=0
  export WRF_CHEM=1



  export WRFIO_NCD_LARGE_FILE_SUPPORT=1

  #Downloading WRF code
  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz -O WRF-4.4.2.tar.gz
  tar -xvzf WRF-4.4.2.tar.gz -C $WRFCHEM_FOLDER/
  cd $WRFCHEM_FOLDER/WRFV4.4.2


  ./clean -a


  if [ ${auto_config} -eq 1 ]
    then
      sed -i'' -e '428s/.*/  $response = "17 \\n";/g' $WRFCHEM_FOLDER/WRFV4.4.2/arch/Config.pl # Answer for compiler choice
      sed -i'' -e '869s/.*/  $response = "1 \\n";/g' $WRFCHEM_FOLDER/WRFV4.4.2/arch/Config.pl  #Answer for basic nesting
      ./configure
    else
    ./configure  #Option 17 gfortran compiler with distributed memory option 1 for basic nesting
  fi

  sed -i'' -e 's/-w -O3 -c/-w -O3 -c -fPIC -fPIE -Wno-implicit-function-declaration/g' $WRFCHEM_FOLDER/WRFV4.4.2/configure.wrf


  ./compile em_real | tee em_real_compile.log

  export WRF_DIR=$WRFCHEM_FOLDER/WRFV4.4.2

  # IF statement to check that all files were created.
  cd $WRFCHEM_FOLDER/WRFV4.4.2/main
  n=$(ls ./*.exe | wc -l)
  if (($n >= 3))
    then
        echo "All expected files created."
        read -r -t 5 -p "Finished installing WRF. I am going to wait for 5 seconds only ..."
      else
        echo "Missing one or more expected files. Exiting the script."
        read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
        exit
  fi
  echo " "
  ############################WPSV4.4#####################################
  ## WPS v4.4
  ## Downloaded from git tagged releases
  #Option 3 for gfortran and distributed memory
  ########################################################################

  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WPS/archive/refs/tags/v4.4.tar.gz -O WPS-4.4.tar.gz
  tar -xvzf WPS-4.4.tar.gz -C $WRFCHEM_FOLDER/
  cd $WRFCHEM_FOLDER/WPS-4.4
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
      echo 19 | ./configure #Option 19 for gfortran and distributed memory
    else
      ./configure  #Option 19 gfortran compiler with distributed memory
  fi

  ./compile | tee compile19.log

  # IF statement to check that all files were created.
  cd $WRFCHEM_FOLDER/WPS-4.4
  n=$(ls ./*.exe | wc -l)
  if (($n == 3))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing WPS. I am going to wait for 5 seconds only ..."
    else
      echo "Missing one or more expected files. Exiting the script."
      read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
      exit
  fi
  echo " "


  ############################WRFDA 3DVAR###############################
  ## WRFDA v4.4.2 3DVAR
  ## Downloaded from git tagged releases
  ## Does not include RTTOV Libarary for radiation data.  If wanted will need to install library then reconfigure
  ##Note: if you intend to run both 3DVAR and 4DVAR experiments, it is not necessary to compile the code twice.
  #Option 34 for gfortran/gcc and distribunted memory
  ########################################################################
  cd $WRFCHEM_FOLDER/Downloads
  cd $WRFCHEM_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz -O WRF-4.4.2.tar.gz
  mkdir $WRFCHEM_FOLDER/WRFDA
  tar -xvzf WRF-4.4.2.tar.gz -C $WRFCHEM_FOLDER/WRFDA
    cd $WRFCHEM_FOLDER/WRFDA/WRFV4.4.2
  mv * $WRFCHEM_FOLDER/WRFDA
  cd $WRFCHEM_FOLDER/WRFDA
  rm -r WRFV4.4.2/
  cd $WRFCHEM_FOLDER/WRFDA


  export WRF_EM_CORE=1
  export WRF_NMM_CORE=0
  export WRF_CHEM=1
  export WRFIO_NCD_LARGE_FILE_SUPPORT=1

  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        echo 17 | ./configure wrfda  #Option 17 for gfortran/gcc and distribunted memory
      else
        ./configure  wrfda  #Option 17 for gfortran/gcc and distribunted memory
  fi
  echo " "
  ./compile all_wrfvar | tee compile1.log
  echo " "
  # IF statement to check that all files were created.
   cd $WRFCHEM_FOLDER/WRFDA/var/da
   n=$(ls ./*.exe | wc -l)
   cd $WRFCHEM_FOLDER/WRFDA/var/obsproc/src
   m=$(ls ./*.exe | wc -l)
   if (( ( $n == 43 ) && ( $m == 1) ))
      then
        echo "All expected files created."
        read -r -t 5 -p "Finished installing WRFDA-CHEM 3DVAR. I am going to wait for 5 seconds only ..."
      else
        echo "Missing one or more expected files. Exiting the script."
        read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
        exit
   fi
  echo " "



  ######################## WPS Domain Setup Tools ########################
  ## DomainWizard

  cd $WRFCHEM_FOLDER/Downloads
  wget http://esrl.noaa.gov/gsd/wrfportal/domainwizard/WRFDomainWizard.zip
  mkdir $WRFCHEM_FOLDER/WRFDomainWizard
  unzip WRFDomainWizard.zip -d $WRFCHEM_FOLDER/WRFDomainWizard
  chmod +x $WRFCHEM_FOLDER/WRFDomainWizard/run_DomainWizard

  echo " "
  ######################## WPF Portal Setup Tools ########################
  ## WRFPortal
  cd $WRFCHEM_FOLDER/Downloads
  wget https://esrl.noaa.gov/gsd/wrfportal/portal/wrf-portal.zip
  mkdir $WRFCHEM_FOLDER/WRFPortal
  unzip wrf-portal.zip -d $WRFCHEM_FOLDER/WRFPortal
  chmod +x $WRFCHEM_FOLDERWRFPortal/runWRFPortal




  echo " "
  ######################## Static Geography Data inc/ Optional ####################
  # http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  # These files are large so if you only need certain ones comment the others off
  # All files downloaded and untarred is 200GB
  # https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  #################################################################################
  cd $WRFCHEM_FOLDER/Downloads
  mkdir $WRFCHEM_FOLDER/GEOG
  mkdir $WRFCHEM_FOLDER/GEOG/WPS_GEOG

  echo " "
  echo "Mandatory WRF Preprocessing System (WPS) Geographical Input Data Mandatory Fields Downloads"
  echo " "
  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
  tar -xvzf geog_high_res_mandatory.tar.gz -C $WRFCHEM_FOLDER/GEOG/

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz
  tar -xvzf geog_low_res_mandatory.tar.gz -C $WRFCHEM_FOLDER/GEOG/
  mv $WRFCHEM_FOLDER/GEOG/WPS_GEOG_LOW_RES/ $WRFCHEM_FOLDER/GEOG/WPS_GEOG


  if [ ${WPS_Specific_Applications} -eq 1 ]
    then
      echo " "
      echo " WPS Geographical Input Data Mandatory for Specific Applications"
      echo " "

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
      tar -xvzf geog_thompson28_chem.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
      tar -xvzf geog_noahmp.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4  https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
      tar -xvzf irrigation.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
      tar -xvzf geog_px.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
      tar -xvzf geog_urban.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
      tar -xvzf geog_ssib.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
      tar -xvf lake_depth.tar.bz2 -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/topobath_30s.tar.bz2
      tar -xvf topobath_30s.tar.bz2 -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG


      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/gsl_gwd.tar.bz2
      tar -xvf gsl_gwd.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

  fi

  if [ ${Optional_GEOG} -eq 1 ]
    then

      echo " "
      echo "Optional WPS Geographical Input Data"
      echo " "


      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_older_than_2000.tar.gz
      tar -xvzf geog_older_than_2000.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s_with_lakes.tar.gz
      tar -xvzf modis_landuse_20class_15s_with_lakes.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_alt_lsm.tar.gz
      tar -xvzf geog_alt_lsm.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/nlcd2006_ll_9s.tar.bz2
      tar -xvf nlcd2006_ll_9s.tar.bz2 -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/updated_Iceland_LU.tar.gz
      tar -xvf updated_Iceland_LU.tar.gz -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s.tar.bz2
      tar -xvf modis_landuse_20class_15s.tar.bz2 -C $WRFCHEM_FOLDER/GEOG/WPS_GEOG

  fi


fi


########################### WRF  ##########################
## WRF installation with parallel process.
# Download and install required library and data files for WRF, WRFPLUS, WRFDA 4DVAR, WPS.
# Tested in Ubuntu 20.04.4 LTS & Ubuntu 22.04 & MacOS Ventura 64bit
# Built in 64-bit system
# Built with Intel or GNU compilers
# Tested with current available libraries on 01/01/2023
# If newer libraries exist edit script paths for changes
#Estimated Run Time ~ 90 - 150 Minutes with 10mb/s downloadspeed.
# Special thanks to:
# Youtube's meteoadriatic, GitHub user jamal919.
# University of Manchester's  Doug L
# University of Tunis El Manar's Hosni
# GSL's Jordan S.
# NCAR's Mary B., Christine W., & Carl D.
# DTC's Julie P., Tara J., George M., & John H.
# UCAR's Katelyn F., Jim B., Jordan P., Kevin M.,
##############################################################


if [ "$Ubuntu_64bit_GNU" = "1" ] && [ "$WRF_PICK" = "1" ]; then

  #############################basic package managment############################
  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade
  echo $PASSWD | sudo -S apt -y install gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git python3 python3-dev python2 python2-dev mlocate curl cmake libcurl4-openssl-dev build-essential pkg-config

  echo " "
  ##############################Directory Listing############################
  export HOME=`cd;pwd`

  mkdir $HOME/WRF
  export WRF_FOLDER=$HOME/WRF
  cd $WRF_FOLDER/
  mkdir Downloads
  mkdir WRFPLUS
  mkdir WRFDA
  mkdir Libs
  export DIR=$WRF_FOLDER/Libs
  mkdir Libs/grib2
  mkdir Libs/NETCDF
  mkdir Libs/MPICH
  mkdir -p Tests/Environment
  mkdir -p Tests/Compatibility

  echo " "
  #############################Core Management####################################

  export CPU_CORE=$(nproc)                                             # number of available threads on system
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
  echo "Number of Threads being used $CPU_HALF_EVEN"
  echo "##########################################"


  echo " "
  ##############################Downloading Libraries############################
  #Force use of ipv4 with -4
  cd Downloads
  wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz
  wget -c -4 https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_2.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz
  wget -c -4 https://github.com/pmodels/mpich/releases/download/v4.0.3/mpich-4.0.3.tar.gz
  wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.39.tar.gz
  wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
  wget -c -4 https://sourceforge.net/projects/opengrads/files/grads2/2.2.1.oga.1/Linux%20%2864%20Bits%29/opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz



  echo " "
  ####################################Compilers#####################################
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




  echo " "
  #############################zlib############################
  #Uncalling compilers due to comfigure issue with zlib1.2.13
  #With CC & CXX definied ./configure uses different compiler Flags

  cd $WRF_FOLDER/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/
  ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  echo " "
  ##############################MPICH############################
  #F90= due to compiler issues with mpich install
  cd $WRF_FOLDER/Downloads
  tar -xvzf mpich-4.0.3.tar.gz
  cd mpich-4.0.3/
  F90= ./configure --prefix=$DIR/MPICH --with-device=ch3 FFLAGS=$fallow_argument FCFLAGS=$fallow_argument

  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  # make check



  export PATH=$DIR/MPICH/bin:$PATH

  export MPIFC=$DIR/MPICH/bin/mpifort
  export MPIF77=$DIR/MPICH/bin/mpifort
  export MPIF90=$DIR/MPICH/bin/mpifort
  export MPICC=$DIR/MPICH/bin/mpicc
  export MPICXX=$DIR/MPICH/bin/mpicxx


  echo " "
  #############################libpng############################
  cd $WRF_FOLDER/Downloads
  export LDFLAGS=-L$DIR/grib2/lib
  export CPPFLAGS=-I$DIR/grib2/include
  tar -xvzf libpng-1.6.39.tar.gz
  cd libpng-1.6.39/
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check
  echo " "
  #############################JasPer############################
  cd $WRF_FOLDER/Downloads
  unzip jasper-1.900.1.zip
  cd jasper-1.900.1/
  ./configure --prefix=$DIR/grib2
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  export JASPERLIB=$DIR/grib2/lib
  export JASPERINC=$DIR/grib2/include


  echo " "
  #############################hdf5 library for netcdf4 functionality############################
  cd $WRF_FOLDER/Downloads
  tar -xvzf hdf5-1_13_2.tar.gz
  cd hdf5-hdf5-1_13_2
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran --enable-parallel
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  export HDF5=$DIR/grib2
  export PHDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH


  echo " "
  #############################Install Parallel-netCDF##############################
  #Make file created with half of available cpu cores
  #Hard path for MPI added
  ##################################################################################
  cd $WRF_FOLDER/Downloads
  wget -c -4  https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz
  tar -xvzf pnetcdf-1.12.3.tar.gz
  cd pnetcdf-1.12.3
  export MPIFC=$DIR/MPICH/bin/mpifort
  export MPIF77=$DIR/MPICH/bin/mpifort
  export MPIF90=$DIR/MPICH/bin/mpifort
  export MPICC=$DIR/MPICH/bin/mpicc
  export MPICXX=$DIR/MPICH/bin/mpicxx
  ./configure --prefix=$DIR/grib2  --enable-shared --enable-static

  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  export PNETCDF=$DIR/grib2


  ##############################Install NETCDF C Library############################
  cd $WRF_FOLDER/Downloads
  tar -xzvf v4.9.0.tar.gz
  cd netcdf-c-4.9.0/
  export CPPFLAGS=-I$DIR/grib2/include
  export LDFLAGS=-L$DIR/grib2/lib
  export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lgfortran -lgcc -lm -ldl"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --disable-dap --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-pnetcdf --enable-cdf5 --enable-parallel-tests
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  export PATH=$DIR/NETCDF/bin:$PATH
  export NETCDF=$DIR/NETCDF
  echo " "
  ##############################NetCDF fortran library############################
  cd $WRF_FOLDER/Downloads
  tar -xvzf v4.6.0.tar.gz
  cd netcdf-fortran-4.6.0/
  export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
  export CPPFLAGS="-I$DIR/NETCDF/include -I$DIR/grib2/include"
  export LDFLAGS="-L$DIR/NETCDF/lib -L$DIR/grib2/lib"
  export LIBS="-lnetcdf -lpnetcdf -lcurl -lhdf5_hl -lhdf5 -lz -lm -ldl -lgcc -lgfortran"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-parallel-tests --enable-hdf5
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  echo " "
  #################################### System Environment Tests ##############

  cd $WRF_FOLDER/Downloads
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar

  tar -xvf Fortran_C_tests.tar -C $WRF_FOLDER/Tests/Environment
  tar -xvf Fortran_C_NETCDF_MPI_tests.tar -C $WRF_FOLDER/Tests/Compatibility

  export one="1"
  echo " "
  ############## Testing Environment #####

  cd $WRF_FOLDER/Tests/Environment

  cp ${NETCDF}/include/netcdf.inc .

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

  cd $WRF_FOLDER/Tests/Compatibility

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



  ###############################NCEPlibs#####################################
  #The libraries are built and installed with
  # ./make_ncep_libs.sh -s MACHINE -c COMPILER -d NCEPLIBS_DIR -o OPENMP [-m mpi] [-a APPLICATION]
  #It is recommended to install the NCEPlibs into their own directory, which must be created before running the installer. Further information on the command line arguments can be obtained with
  # ./make_ncep_libs.sh -h

  #If iand error occurs go to https://github.com/NCAR/NCEPlibs/pull/16/files make adjustment and re-run ./make_ncep_libs.sh
  ############################################################################



  cd $WRF_FOLDER/Downloads
  git clone https://github.com/NCAR/NCEPlibs.git
  cd NCEPlibs
  mkdir $DIR/nceplibs

  export JASPER_INC=$DIR/grib2/include
  export PNG_INC=$DIR/grib2/include
  export NETCDF=$DIR/NETCDF

  #for loop to edit linux.gnu for nceplibs to install
  #make if statement for gcc-9 or older
  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
  then
    y="24 28 32 36 40 45 49 53 56 60 64 68 69 73 74 79"
    for X in $y; do
      sed -i "${X}s/= /= $fallow_argument $boz_argument /g" $WRF_FOLDER/Downloads/NCEPlibs/macros.make.linux.gnu
    done
  else
    echo ""
    echo "Loop not needed"
  fi

  if [ ${auto_config} -eq 1 ]
    then
      echo yes | ./make_ncep_libs.sh -s linux -c gnu -d $DIR/nceplibs -o 0 -m 1 -a upp
    else
      ./make_ncep_libs.sh -s linux -c gnu -d $DIR/nceplibs -o 0 -m 1 -a upp
  fi

  export PATH=$DIR/nceplibs:$PATH

  echo " "
  ################################UPPv4.1######################################
  #Previous verison of UPP
  #WRF Support page recommends UPPV4.1 due to too many changes to WRF and UPP code
  #since the WRF was written
  #Option 8 gfortran compiler with distributed memory
  #############################################################################
  cd $WRF_FOLDER/
  git clone -b dtc_post_v4.1.0 --recurse-submodules https://github.com/NOAA-EMC/EMC_post UPPV4.1
  cd UPPV4.1
  mkdir postprd
  export NCEPLIBS_DIR=$DIR/nceplibs
  export NETCDF=$DIR/NETCDF

  if [ ${auto_config} -eq 1 ]
    then
      echo 8 | ./configure  #Option 8 gfortran compiler with distributed memory
    else
      ./configure  #Option 8 gfortran compiler with distributed memory
  fi


  #make if statement for gcc-9 or older
  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
    then
      z="58 63"
      for X in $z; do
        sed -i "${X}s/(FOPT)/(FOPT) $fallow_argument $boz_argument  /g" $WRF_FOLDER/UPPV4.1/configure.upp
      done
    else
      echo ""
      echo "Loop not needed"
  fi

  ./compile
  cd $WRF_FOLDER/UPPV4.1/scripts
  chmod +x run_unipost

  # IF statement to check that all files were created.
   cd $WRF_FOLDER/UPPV4.1/exec
   n=$(ls ./*.exe | wc -l)
   if (( $n == 1 ))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing UPPV4.1. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
   fi

  echo " "



  ######################## ARWpost V3.1  ############################
  ## ARWpost
  ##Configure #3
  ###################################################################
  cd $WRF_FOLDER/Downloads
  wget -c -4 http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz
  tar -xvzf ARWpost_V3.tar.gz -C $WRF_FOLDER/
  cd $WRF_FOLDER/ARWpost
  ./clean -a
  sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $WRF_FOLDER/ARWpost/src/Makefile
  export NETCDF=$DIR/NETCDF


  if [ ${auto_config} -eq 1 ]
    then
      echo 3 | ./configure  #Option 3 gfortran compiler with distributed memory
    else
      ./configure  #Option 3 gfortran compiler with distributed memory
  fi


  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
  then
    sed -i '32s/-ffree-form -O -fno-second-underscore -fconvert=big-endian -frecord-marker=4/-ffree-form -O -fno-second-underscore -fconvert=big-endian -frecord-marker=4 ${fallow_argument} /g' configure.arwp
  fi


  sed -i -e 's/-C -P -traditional/-P -traditional/g' $WRF_FOLDER/ARWpost/configure.arwp
  ./compile


  export PATH=$WRF_FOLDER/ARWpost/ARWpost.exe:$PATH

  echo " "
  ################################ OpenGrADS ##################################
  #Verison 2.2.1 32bit of Linux
  #############################################################################
  if [[ $GRADS_PICK -eq 1 ]]; then
    cd $WRF_FOLDER/Downloads
    tar -xzvf opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz -C $WRF_FOLDER/
    cd $WRF_FOLDER/
    mv $WRF_FOLDER/opengrads-2.2.1.oga.1  $WRF_FOLDER/GrADS
    cd GrADS/Contents
    wget -c -4 https://github.com/regisgrundig/SIMOP/blob/master/g2ctl.pl
    chmod +x g2ctl.pl
    wget -c -4 https://sourceforge.net/projects/opengrads/files/wgrib2/0.1.9.4/wgrib2-v0.1.9.4-bin-i686-glib2.5-linux-gnu.tar.gz
    tar -xzvf wgrib2-v0.1.9.4-bin-i686-glib2.5-linux-gnu.tar.gz
    cd wgrib2-v0.1.9.4/bin
    mv wgrib2 $WRF_FOLDER/GrADS/Contents
    cd $WRF_FOLDER/GrADS/Contents
    rm wgrib2-v0.1.9.4-bin-i686-glib2.5-linux-gnu.tar.gz
    rm -r wgrib2-v0.1.9.4


    export PATH=$WRF_FOLDER/GrADS/Contents:$PATH


  echo " "
  fi
  ################################## GrADS ###############################
  # Version  2.2.1
  # Sublibs library instructions: http://cola.gmu.edu/grads/gadoc/supplibs2.html
  # GrADS instructions: http://cola.gmu.edu/grads/downloads.php
  ########################################################################
  if [[ $GRADS_PICK -eq 2 ]]; then

    echo $PASSWD | sudo -S apt -y install grads

  fi

  ##################### NCAR COMMAND LANGUAGE           ##################
  ########### NCL compiled via Conda                    ##################
  ########### This is the preferred method by NCAR      ##################
  ########### https://www.ncl.ucar.edu/index.shtml      ##################
  #Installing Miniconda3 to WRF-Hydro directory and updating libraries

  export Miniconda_Install_DIR=$WRF_FOLDER/miniconda3

  mkdir -p $Miniconda_Install_DIR

  wget -c -4 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $Miniconda_Install_DIR/miniconda.sh
  bash $Miniconda_Install_DIR/miniconda.sh -b -u -p $Miniconda_Install_DIR

  rm -rf $Miniconda_Install_DIR/miniconda.sh

  export PATH=$WRF_FOLDER/miniconda3/bin:$PATH

  source $Miniconda_Install_DIR/etc/profile.d/conda.sh

  $Miniconda_Install_DIR/bin/conda init bash
  $Miniconda_Install_DIR/bin/conda init zsh
  $Miniconda_Install_DIR/bin/conda init tcsh
  $Miniconda_Install_DIR/bin/conda init xonsh
  $Miniconda_Install_DIR/bin/conda init powershell

  conda config --add channels conda-forge
  conda config --set auto_activate_base false
  conda update -n root --all -y


  export $PATH


  echo " "





  echo " "
  #Installing NCL via Conda
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n ncl_stable -c conda-forge ncl -y
  conda activate ncl_stable
  conda update -n ncl_stable --all -y
  conda deactivate
  conda deactivate
  conda deactivate

  echo " "

  ############################OBSGRID###############################
  ## OBSGRID
  ## Downloaded from git tagged releases
  ## Option #2
  ########################################################################
  cd $WRF_FOLDER/
  git clone https://github.com/wrf-model/OBSGRID.git
  cd $WRF_FOLDER/OBSGRID

  ./clean -a
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate ncl_stable


  export HOME=`cd;pwd`
  export DIR=$WRF_FOLDER/Libs
  export NETCDF=$DIR/NETCDF


  if [ ${auto_config} -eq 1 ]
    then
        echo 2 | ./configure #Option 2 for gfortran/gcc and distribunted memory
      else
        ./configure   #Option 2 for gfortran/gcc and distribunted memory
  fi


  sed -i '27s/-lnetcdf -lnetcdff/ -lnetcdff -lnetcdf/g' configure.oa

  sed -i '31s/-lncarg -lncarg_gks -lncarg_c -lX11 -lm -lcairo/-lncarg -lncarg_gks -lncarg_c -lX11 -lm -lcairo -lfontconfig -lpixman-1 -lfreetype -lhdf5 -lhdf5_hl /g' configure.oa

  sed -i '39s/-frecord-marker=4/-frecord-marker=4 ${fallow_argument} /g' configure.oa

  sed -i '44s/=	/=	${fallow_argument} /g' configure.oa

  sed -i '45s/-C -P -traditional/-P -traditional/g' configure.oa


  echo " "
  ./compile

  conda deactivate
  conda deactivate
  conda deactivate

  echo " "
  # IF statement to check that all files were created.
   cd $WRF_FOLDER/OBSGRID
   n=$(ls ./*.exe | wc -l)
   if (( $n == 3 ))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing OBSGRID. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
   fi

  echo " "
  ############################## RIP4 #####################################
  mkdir $WRF_FOLDER/RIP4
  cd $WRF_FOLDER/Downloads
  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/RIP_47.tar.gz
  tar -xvzf RIP_47.tar.gz -C $WRF_FOLDER/RIP4
  cd $WRF_FOLDER/RIP4/RIP_47
  mv * ..
  cd $WRF_FOLDER/RIP4
  rm -rd RIP_47
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda activate ncl_stable
  conda install -c conda-forge ncl c-compiler fortran-compiler cxx-compiler -y


  export RIP_ROOT=$WRF_FOLDER/RIP4
  export NETCDF=$DIR/NETCDF
  export NCARG_ROOT=$WRF_FOLDER/miniconda3/envs/ncl_stable


  sed -i '349s|-L${NETCDF}/lib -lnetcdf $NETCDFF|-L${NETCDF}/lib $NETCDFF -lnetcdff -lnetcdf -lnetcdf -lnetcdff_C -lhdf5 |g' $WRF_FOLDER/RIP4/configure

  sed -i '27s|NETCDFLIB	= -L${NETCDF}/lib -lnetcdf CONFIGURE_NETCDFF_LIB|NETCDFLIB	= -L</usr/lib/x86_64-linux-gnu/libm.a> -lm -L${NETCDF}/lib CONFIGURE_NETCDFF_LIB -lnetcdf -lhdf5 -lhdf5_hl -lgfortran -lgcc -lz |g' $WRF_FOLDER/RIP4/arch/preamble

  sed -i '31s|-L${NCARG_ROOT}/lib -lncarg -lncarg_gks -lncarg_c -lX11 -lXext -lpng -lz CONFIGURE_NCARG_LIB| -L${NCARG_ROOT}/lib -lncarg -lncarg_gks -lncarg_c -lX11 -lXext -lpng -lz -lcairo -lfontconfig -lpixman-1 -lfreetype -lexpat -lpthread -lbz2 -lXrender -lgfortran -lgcc -L</usr/lib/x86_64-linux-gnu/> -lm -lhdf5 -lhdf5_hl |g' $WRF_FOLDER/RIP4/arch/preamble

  sed -i '33s| -O|-fallow-argument-mismatch -O |g' $WRF_FOLDER/RIP4/arch/configure.defaults

  sed -i '35s|=|= -L$WRF_FOLDER/LIBS/grib2/lib -lhdf5 -lhdf5_hl |g' $WRF_FOLDER/RIP4/arch/configure.defaults


  if [ ${auto_config} -eq 1 ]
    then
      echo 3 | ./configure  #Option 3 gfortran compiler with distributed memory
    else
      ./configure  #Option 3 gfortran compiler with distributed memory
  fi

  ./compile

  conda deactivate
  conda deactivate
  conda deactivate


  echo " "
  ##################### WRF Python           ##################
  ########### WRf-Python compiled via Conda  ##################
  ########### This is the preferred method by NCAR      ##################
  ##### https://wrf-python.readthedocs.io/en/latest/installation.html  ##################
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n wrf-python -c conda-forge wrf-python -y
  conda activate wrf-python
  conda update -n wrf-python --all -y
  conda deactivate
  conda deactivate
  conda deactivate



  echo " "
  ############################ WRF 4.4.2  #################################
  ## WRF v4.4.2
  ## Downloaded from git tagged releases
  # option 34, option 1 for gfortran and distributed memory w/basic nesting
  # large file support enable with WRFiO_NCD_LARGE_FILE_SUPPORT=1
  # In the namelist.input, the following settings support pNetCDF by setting value to 11:
  # io_form_boundary
  # io_form_history
  # io_form_auxinput2
  # io_form_auxhist2
  # Note that you need set nocolons = .true. in the section &time_control of namelist.input
  ########################################################################
  cd $WRF_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz -O WRF-4.4.2.tar.gz
  tar -xvzf WRF-4.4.2.tar.gz -C $WRF_FOLDER/
  cd $WRF_FOLDER/WRFV4.4.2
  export WRFIO_NCD_LARGE_FILE_SUPPORT=1
  ./clean -a

# SED statements to fix configure error
  sed -i '186s/==/=/g' $WRF_FOLDER/WRFV4.4.2/configure
  sed -i '318s/==/=/g' $WRF_FOLDER/WRFV4.4.2/configure
  sed -i '919s/==/=/g' $WRF_FOLDER/WRFV4.4.2/configure


  if [ ${auto_config} -eq 1 ]
    then
        sed -i '428s/.*/  $response = "34 \\n";/g' $WRF_FOLDER/WRFV4.4.2/arch/Config.pl # Answer for compiler choice
        sed -i '869s/.*/  $response = "1 \\n";/g' $WRF_FOLDER/WRFV4.4.2/arch/Config.pl  #Answer for basic nesting
        ./configure
    else
      ./configure  #Option 34 gfortran compiler with distributed memory option 1 for basic nesting
  fi

  ./compile -j $CPU_HALF_EVEN em_real

  export WRF_DIR=$WRF_FOLDER/WRFV4.4.2


  # IF statement to check that all files were created.
  cd $WRF_FOLDER/WRFV4.4.2/main
  n=$(ls ./*.exe | wc -l)
  if (($n >= 3))
   then
   echo "All expected files created."
   read -r -t 5 -p "Finished installing WRF. I am going to wait for 5 seconds only ..."
  else
   echo "Missing one or more expected files. Exiting the script."
   read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
   exit
  fi
  echo " "
  ############################WPSV4.4#####################################
  ## WPS v4.4
  ## Downloaded from git tagged releases
  #Option 3 for gfortran and distributed memory
  ########################################################################

  cd $WRF_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WPS/archive/refs/tags/v4.4.tar.gz -O WPS-4.4.tar.gz
  tar -xvzf WPS-4.4.tar.gz -C $WRF_FOLDER/
  cd $WRF_FOLDER/WPS-4.4
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        echo 3 | ./configure #Option 3 for gfortran and distributed memory
      else
        ./configure  #Option 3 gfortran compiler with distributed memory
  fi
  ./compile


  echo " "
  # IF statement to check that all files were created.
   cd $WRF_FOLDER/WPS-4.4
   n=$(ls ./*.exe | wc -l)
   if (($n == 3))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing WPS. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
   fi
   echo " "
  ############################WRFPLUS 4DVAR###############################
  ## WRFPLUS v4.4.2 4DVAR
  ## Downloaded from git tagged releases
  ## WRFPLUS is built within the WRF git folder
  ## Does not include RTTOV Libarary for radiation data.  If wanted will need to install library then reconfigure
  ##Note: if you intend to run both 3DVAR and 4DVAR experiments, it is not necessary to compile the code twice.
  #Option 18 for gfortran/gcc and distribunted memory
  ########################################################################
  cd $WRF_FOLDER/Downloads
  tar -xvzf WRF-4.4.2.tar.gz -C $WRF_FOLDER/WRFPLUS
  cd $WRF_FOLDER/WRFPLUS/WRFV4.4.2
  mv * $WRF_FOLDER/WRFPLUS
  cd $WRF_FOLDER/WRFPLUS
  rm -r WRFV4.4.2/
  export NETCDF=$DIR/NETCDF
  export HDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        echo 18 | ./configure wrfplus  #Option 18 for gfortran/gcc and distribunted memory
      else
        ./configure  wrfplus  #Option 18 for gfortran/gcc and distribunted memory
    fi
  echo " "
  ./compile -j $CPU_HALF_EVEN wrfplus
  export WRFPLUS_DIR=$WRF_FOLDER/WRFPLUS


  echo " "
  # IF statement to check that all files were created.
   cd $WRF_FOLDER/WRFPLUS/main
   n=$(ls ./wrfplus.exe | wc -l)
   if (( $n == 1 ))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing WRF Plus 4DVAR. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
   fi
  echo " "
  ############################WRFDA 4DVAR###############################
  ## WRFDA v4.4.2 4DVAR
  ## Downloaded from git tagged releases
  ## WRFDA is built within the WRFPLUS folder
  ## Does not include RTTOV Libarary for radiation data.  If wanted will need to install library then reconfigure
  ##Note: if you intend to run both 3DVAR and 4DVAR experiments, it is not necessary to compile the code twice.
  #Option 18 for gfortran/gcc and distribunted memory
  ########################################################################
  cd $WRF_FOLDER/Downloads
  mkdir $WRF_FOLDER/WRFDA
  tar -xvzf WRF-4.4.2.tar.gz -C $WRF_FOLDER/WRFDA
    cd $WRF_FOLDER/WRFDA/WRFV4.4.2
  mv * $WRF_FOLDER/WRFDA
  cd $WRF_FOLDER/WRFDA
  rm -r WRFV4.4.2/
  export NETCDF=$DIR/NETCDF
  export HDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
  export WRFPLUS_DIR=$WRF_FOLDER/WRFPLUS
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        echo 18 | ./configure 4dvar  #Option 18 for gfortran/gcc and distribunted memory
      else
        ./configure  4dvar  #Option 18 for gfortran/gcc and distribunted memory
  fi
  echo " "
  ./compile all_wrfvar | tee compile1.log
  echo " "
  # IF statement to check that all files were created.
   cd $WRF_FOLDER/WRFDA/var/da
   n=$(ls ./*.exe | wc -l)
   cd $WRF_FOLDER/WRFDA/var/obsproc/src
   m=$(ls ./*.exe | wc -l)
   if (( ( $n == 43 ) && ( $m == 1) ))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing WRFDA 4DVAR. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
   fi
  echo " "

  echo " "
  ######################## WPS Domain Setup Tools ########################
  ## DomainWizard
  cd $WRF_FOLDER/Downloads
  wget -c -4 http://esrl.noaa.gov/gsd/wrfportal/domainwizard/WRFDomainWizard.zip
  mkdir $WRF_FOLDER/WRFDomainWizard
  unzip WRFDomainWizard.zip -d $WRF_FOLDER/WRFDomainWizard
  chmod +x $WRF_FOLDER/WRFDomainWizard/run_DomainWizard

  echo " "
  ######################## WPF Portal Setup Tools ########################
  ## WRFPortal
  cd $WRF_FOLDER/Downloads
  wget -c -4 https://esrl.noaa.gov/gsd/wrfportal/portal/wrf-portal.zip
  mkdir $WRF_FOLDER/WRFPortal
  unzip wrf-portal.zip -d $WRF_FOLDER/WRFPortal
  chmod +x $WRF_FOLDER/WRFPortal/runWRFPortal


  echo " "

  ######################## Static Geography Data inc/ Optional ####################
  # http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  # These files are large so if you only need certain ones comment the others off
  # All files downloaded and untarred is 200GB
  # https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  #################################################################################
  cd $WRF_FOLDER/Downloads
  mkdir $WRF_FOLDER/GEOG
  mkdir $WRF_FOLDER/GEOG/WPS_GEOG

  echo " "
  echo "Mandatory WRF Preprocessing System (WPS) Geographical Input Data Mandatory Fields Downloads"
  echo " "
  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
  tar -xvzf geog_high_res_mandatory.tar.gz -C $WRF_FOLDER/GEOG/

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz
  tar -xvzf geog_low_res_mandatory.tar.gz -C $WRF_FOLDER/GEOG/
  mv $WRF_FOLDER/GEOG/WPS_GEOG_LOW_RES/ $WRF_FOLDER/GEOG/WPS_GEOG


  if [ ${WPS_Specific_Applications} -eq 1 ]
    then
      echo " "
      echo " WPS Geographical Input Data Mandatory for Specific Applications"
      echo " "

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
      tar -xvzf geog_thompson28_chem.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
      tar -xvzf geog_noahmp.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4  https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
      tar -xvzf irrigation.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
      tar -xvzf geog_px.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
      tar -xvzf geog_urban.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
      tar -xvzf geog_ssib.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
      tar -xvf lake_depth.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/topobath_30s.tar.bz2
      tar -xvf topobath_30s.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/gsl_gwd.tar.bz2
      tar -xvf gsl_gwd.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG
  fi


  if [ ${Optional_GEOG} -eq 1 ]
    then
      echo " "
      echo "Optional WPS Geographical Input Data"
      echo " "


      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_older_than_2000.tar.gz
      tar -xvzf geog_older_than_2000.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s_with_lakes.tar.gz
      tar -xvzf modis_landuse_20class_15s_with_lakes.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_alt_lsm.tar.gz
      tar -xvzf geog_alt_lsm.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/nlcd2006_ll_9s.tar.bz2
      tar -xvf nlcd2006_ll_9s.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/updated_Iceland_LU.tar.gz
      tar -xvf updated_Iceland_LU.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s.tar.bz2
      tar -xvf modis_landuse_20class_15s.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG


  fi







fi

if [ "$Ubuntu_64bit_Intel" = "1" ] && [ "$WRF_PICK" = "1" ]; then

  ############################# Basic package managment ############################

  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade

  # download the key to system keyring; this and the following echo command are
  # needed in order to install the Intel compilers
  wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
  | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null


  # add signed entry to apt sources and configure the APT client to use Intel repository:
  echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list

  # this update should get the Intel package info from the Intel repository
  echo $PASSWD | sudo -S apt -y update

  # necessary binary packages (especially pkg-config and build-essential)
  echo $PASSWD | sudo -S apt -y install git gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh python3 python3-dev python2 python2-dev mlocate curl cmake libcurl4-openssl-dev pkg-config build-essential

  # install the Intel compilers
  echo $PASSWD | sudo -S apt -y install intel-basekit intel-hpckit intel-aikit
  echo $PASSWD | sudo -S apt -y update


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
  export CFLAGS="-fPIC -fPIE -O3"
  export FFLAGS="-m64"
  export FCFLAGS="-m64"
  ############################# CPU Core Management ####################################

  export CPU_CORE=$(nproc)                                   # number of available threads on system
  export CPU_6CORE="6"
  export CPU_HALF=$(($CPU_CORE / 2))                         # half of availble cores on system
  # Forces CPU cores to even number to avoid partial core export. ie 7 cores would be 3.5 cores.
  export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))

  # If statement for low core systems.  Forces computers to only use 1 core if there are 4 cores or less on the system.
  if [ $CPU_CORE -le $CPU_6CORE ]
  then
    export CPU_HALF_EVEN="2"
  else
    export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))
  fi

  echo "##########################################"
  echo "Number of Threads being used $CPU_HALF_EVEN"
  echo "##########################################"

  ############################## Directory Listing ############################
  # makes necessary directories
  ## If you want WRFCHEM or WRF-Hydro change "WRF" in this variable to either "WRFCHEM" or "WRF-Hydro"
  ############################################################################


  export HOME=`cd;pwd`
  export WRF_FOLDER=$HOME/WRF_Intel  # If you want WRFCHEM or WRF-Hydro change "WRF" in this variable to either "WRFCHEM" or "WRF-Hydro"
  export DIR=$WRF_FOLDER/Libs
  mkdir $WRF_FOLDER
  cd $WRF_FOLDER
  mkdir Downloads
  mkdir WRFPLUS
  mkdir WRFDA
  mkdir Libs
  mkdir Libs/grib2
  mkdir Libs/NETCDF
  mkdir Libs/MPICH
  mkdir -p Tests/Environment
  mkdir -p Tests/Compatibility


  echo " "
  ############################## Downloading Libraries ############################

  cd $WRF_FOLDER/Downloads
  wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz
  wget -c -4 https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_2.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz
  wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.39.tar.gz
  wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
  wget -c -4 https://sourceforge.net/projects/opengrads/files/grads2/2.2.1.oga.1/Linux%20%2864%20Bits%29/opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz

  echo " "
  ############################# ZLib ############################

  cd $WRF_FOLDER/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3"  ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN | tee zlib.make.log
  # make check | tee zlib.makecheck.log
  make -j $CPU_HALF_EVEN install | tee zlib.makeinstall.log

  echo " "
  ############################# LibPNG ############################

  cd $WRF_FOLDER/Downloads

  # other libraries below need these variables to be set
  export LDFLAGS=-L$DIR/grib2/lib
  export CPPFLAGS=-I$DIR/grib2/include

  tar -xvzf libpng-1.6.39.tar.gz
  cd libpng-1.6.39/

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3"  ./configure --prefix=$DIR/grib2

  make -j $CPU_HALF_EVEN | tee libpng.make.log
  #make -j $CPU_HALF_EVEN check | tee libpng.makecheck.log
  make -j $CPU_HALF_EVEN install | tee libpng.makeinstall.log

  echo " "
  ############################# JasPer ############################

  cd $WRF_FOLDER/Downloads
  unzip jasper-1.900.1.zip
  cd jasper-1.900.1/

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3"  ./configure --prefix=$DIR/grib2

  make -j $CPU_HALF_EVEN | tee jasper.make.log
  make  -j $CPU_HALF_EVEN install | tee jasper.makeinstall.log

  # other libraries below need these variables to be set
  export JASPERLIB=$DIR/grib2/lib
  export JASPERINC=$DIR/grib2/include

  echo " "
  ############################# HDF5 library for NetCDF4 & parallel functionality ############################

  cd $WRF_FOLDER/Downloads
  tar -xvzf hdf5-1_13_2.tar.gz
  cd hdf5-hdf5-1_13_2

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3" ./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran --enable-parallel

  make -j $CPU_HALF_EVEN | tee hdf5.make.log
  make -j $CPU_HALF_EVEN install | tee hdf5.makeinstall.log

  # other libraries below need these variables to be set
  export HDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
  export PATH=$HDF5/bin:$PATH
  export PHDF5=$DIR/grib2

  echo " "


  #############################Install Parallel-netCDF##############################
  #Make file created with half of available cpu cores
  #Hard path for MPI added
  ##################################################################################
  cd $WRF_FOLDER/Downloads
  wget -c -4  https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz
  tar -xvzf pnetcdf-1.12.3.tar.gz
  cd pnetcdf-1.12.3
  ./configure --prefix=$DIR/grib2  --enable-shared --enable-static

  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  export PNETCDF=$DIR/grib2


  ############################## Install NETCDF-C Library ############################

  cd $WRF_FOLDER/Downloads
  tar -xzvf v4.9.0.tar.gz
  cd netcdf-c-4.9.0/

  # these variables need to be set for the NetCDF-C install to work
  export CPPFLAGS=-I$DIR/grib2/include
  export LDFLAGS=-L$DIR/grib2/lib
  export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lgfortran -lgcc -lm -ldl"

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3"  ./configure --prefix=$DIR/NETCDF --disable-dap --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-pnetcdf --enable-cdf5 --enable-parallel-tests | tee netcdf.configure.log

  make -j $CPU_HALF_EVEN | tee netcdf.make.log
  make -j $CPU_HALF_EVEN install | tee netcdf.makeinstall.log

  # other libraries below need these variables to be set
  export PATH=$DIR/NETCDF/bin:$PATH
  export NETCDF=$DIR/NETCDF

  echo " "
  ############################## NetCDF-Fortran library ############################

  cd $WRF_FOLDER/Downloads
  tar -xvzf v4.6.0.tar.gz
  cd netcdf-fortran-4.6.0/

  # these variables need to be set for the NetCDF-Fortran install to work
  export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
  export CPPFLAGS="-I$DIR/NETCDF/include -I$DIR/grib2/include"
  export LDFLAGS="-L$DIR/NETCDF/lib -L$DIR/grib2/lib"
  export LIBS="-lnetcdf -lpnetcdf -lcurl -lhdf5_hl -lhdf5 -lz -lm -ldl -lgcc -lgfortran"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -fPIE -diag-disable=10441 -O3"  ./configure --prefix=$DIR/NETCDF --enable-netcdf-4 --enable-netcdf4 --enable-parallel-tests --enable-hdf5

  make -j $CPU_HALF_EVEN | tee netcdf-f.make.log
  make  -j $CPU_HALF_EVEN install | tee netcdf-f.makeinstall.log


  echo " "
  #################################### System Environment Tests ##############

  cd $WRF_FOLDER/Downloads
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar

  tar -xvf Fortran_C_tests.tar -C $WRF_FOLDER/Tests/Environment
  tar -xvf Fortran_C_NETCDF_MPI_tests.tar -C $WRF_FOLDER/Tests/Compatibility

  export one="1"
  echo " "
  ############## Testing Environment #####

  cd $WRF_FOLDER/Tests/Environment

  echo " "
  echo " "
  echo "Environment Testing "
  echo "Test 1"
  ifort TEST_1_fortran_only_fixed.f
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
  ifort TEST_2_fortran_only_free.f90
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
  icc TEST_3_c_only.c
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
  icc -c -m64 TEST_4_fortran+c_c.c
  ifort -c -m64 TEST_4_fortran+c_f.f90
  ifort -m64 TEST_4_fortran+c_f.o TEST_4_fortran+c_c.o
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

  cd $WRF_FOLDER/Tests/Compatibility

  cp ${NETCDF}/include/netcdf.inc .

  echo " "
  echo " "
  echo "Library Compatibility Tests "
  echo "Test 1"
  ifort -c 01_fortran+c+netcdf_f.f
  icc -c 01_fortran+c+netcdf_c.c
  ifort 01_fortran+c+netcdf_f.o 01_fortran+c+netcdf_c.o \
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
  mpiifort -c 02_fortran+c+netcdf+mpi_f.f
  mpiicc -c 02_fortran+c+netcdf+mpi_c.c
  mpiifort 02_fortran+c+netcdf+mpi_f.o \
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
  ###############################NCEPlibs#####################################
  #The libraries are built and installed with
  # ./make_ncep_libs.sh -s MACHINE -c COMPILER -d NCEPLIBS_DIR -o OPENMP [-m mpi] [-a APPLICATION]
  #It is recommended to install the NCEPlibs into their own directory, which must be created before running the installer. Further information on the command line arguments can be obtained with
  # ./make_ncep_libs.sh -h

  #If iand error occurs go to https://github.com/NCAR/NCEPlibs/pull/16/files make adjustment and re-run ./make_ncep_libs.sh
  ############################################################################



  cd $WRF_FOLDER/Downloads
  git clone https://github.com/NCAR/NCEPlibs.git
  cd NCEPlibs
  mkdir $DIR/nceplibs

  export JASPER_INC=$DIR/grib2/include
  export PNG_INC=$DIR/grib2/include
  export NETCDF=$DIR/NETCDF



  if [ ${auto_config} -eq 1 ]
    then
      echo yes | ./make_ncep_libs.sh -s linux -c intel -d $DIR/nceplibs -o 0 -m 1 -a upp
    else
      ./make_ncep_libs.sh -s linux -c intel -d $DIR/nceplibs -o 0 -m 1 -a upp
  fi

  export PATH=$DIR/nceplibs:$PATH

  echo " "
  ################################UPPv4.1######################################
  #Previous verison of UPP
  #WRF Support page recommends UPPV4.1 due to too many changes to WRF and UPP code
  #since the WRF was written
  #Option 8 gfortran compiler with distributed memory
  #############################################################################
  cd $WRF_FOLDER
  git clone -b dtc_post_v4.1.0 --recurse-submodules https://github.com/NOAA-EMC/EMC_post UPPV4.1
  cd UPPV4.1
  mkdir postprd
  export NCEPLIBS_DIR=$DIR/nceplibs
  export NETCDF=$DIR/NETCDF

  if [ ${auto_config} -eq 1 ]
    then
      echo 4 | ./configure  #Option 4 intel compiler with distributed memory
    else
      ./configure  #Option 4 intel compiler with distributed memory
  fi

  sed -i '24s/ mpif90/ mpiifort/g' $WRF_FOLDER/UPPV4.1/configure.upp
  sed -i '25s/ mpif90/ mpiifort/g' $WRF_FOLDER/UPPV4.1/configure.upp
  sed -i '26s/ mpicc/ mpiicc/g' $WRF_FOLDER/UPPV4.1/configure.upp

  ./compile
  cd $WRF_FOLDER/UPPV4.1/scripts
  chmod +x run_unipost

  # IF statement to check that all files were created.
   cd $WRF_FOLDER/UPPV4.1/exec
   n=$(ls ./*.exe | wc -l)
   if (( $n == 1 ))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing UPPV4.1. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
   fi

  echo " "



  ######################## ARWpost V3.1  ############################
  ## ARWpost
  ##Configure #3
  ###################################################################
  cd $WRF_FOLDER/Downloads
  wget -c -4 http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz
  tar -xvzf ARWpost_V3.tar.gz -C $WRF_FOLDER
  cd $WRF_FOLDER/ARWpost
  ./clean -a
  sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $WRF_FOLDER/ARWpost/src/Makefile
  export NETCDF=$DIR/NETCDF

  if [ ${auto_config} -eq 1 ]
    then
      echo 2 | ./configure  #Option 2 intel compiler with distributed memory
    else
      ./configure  #Option 2 intel compiler with distributed memory
  fi

  sed -i -e 's/-C -P -traditional/-P -traditional/g' $WRF_FOLDER/ARWpost/configure.arwp
  ./compile

  export PATH=$WRF_FOLDER/ARWpost/ARWpost.exe:$PATH

  echo " "
  ################################OpenGrADS######################################
  #Verison 2.2.1 64bit of Linux
  #############################################################################
  if [[ $GRADS_PICK -eq 1 ]]; then
    cd $WRF_FOLDER/Downloads
    tar -xzvf opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz -C $WRF_FOLDER/
    cd $WRF_FOLDER/
    mv $WRF_FOLDER/opengrads-2.2.1.oga.1  $WRF_FOLDER/GrADS
    cd GrADS/Contents
    wget -c -4 https://github.com/regisgrundig/SIMOP/blob/master/g2ctl.pl
    chmod +x g2ctl.pl
    wget -c -4 https://sourceforge.net/projects/opengrads/files/wgrib2/0.1.9.4/wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
    tar -xzvf wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
    cd wgrib2-v0.1.9.4/bin
    mv wgrib2 $WRF_FOLDER/GrADS/Contents
    cd $WRF_FOLDER/GrADS/Contents
    rm wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
    rm -r wgrib2-v0.1.9.4


    export PATH=$WRF_FOLDER/GrADS/Contents:$PATH
  fi
  ################################## GrADS ###############################
  # Version  2.2.1
  # Sublibs library instructions: http://cola.gmu.edu/grads/gadoc/supplibs2.html
  # GrADS instructions: http://cola.gmu.edu/grads/downloads.php
  ########################################################################
  if [[ $GRADS_PICK -eq 2 ]]; then

    echo $PASSWD | sudo -S apt -y install grads

  fi



  ##################### NCAR COMMAND LANGUAGE           ##################
  ########### NCL compiled via Conda                    ##################
  ########### This is the preferred method by NCAR      ##################
  ########### https://www.ncl.ucar.edu/index.shtml      ##################
  echo " "
  echo " "
  #Installing Miniconda3 to WRF directory and updating libraries

  export Miniconda_Install_DIR=$WRF_FOLDER/miniconda3

  mkdir -p $Miniconda_Install_DIR

  wget -c -4 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $Miniconda_Install_DIR/miniconda.sh
  bash $Miniconda_Install_DIR/miniconda.sh -b -u -p $Miniconda_Install_DIR

  rm -rf $Miniconda_Install_DIR/miniconda.sh

  export PATH=$WRF_FOLDER/miniconda3/bin:$PATH

  source $Miniconda_Install_DIR/etc/profile.d/conda.sh

  $Miniconda_Install_DIR/bin/conda init bash
  $Miniconda_Install_DIR/bin/conda init zsh
  $Miniconda_Install_DIR/bin/conda init tcsh
  $Miniconda_Install_DIR/bin/conda init xonsh
  $Miniconda_Install_DIR/bin/conda init powershell

  conda config --add channels conda-forge
  conda config --set auto_activate_base false
  conda update -n root --all -y


  export $PATH
  #Special Thanks to @_WaylonWalker for code development
  echo " "
  #Installing NCL via Conda
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n ncl_stable -c conda-forge ncl -y
  conda activate ncl_stable
  conda update -n ncl_stable --all -y
  conda deactivate
  conda deactivate
  conda deactivate


  echo " "


  ##################### WRF Python           ##################
  ########### WRf-Python compiled via Conda  ##################
  ########### This is the preferred method by NCAR      ##################
  ##### https://wrf-python.readthedocs.io/en/latest/installation.html  ##################
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n wrf-python -c conda-forge wrf-python -y
  conda activate wrf-python
  conda update -n wrf-python --all -y
  conda deactivate
  conda deactivate
  conda deactivate

  echo " "
  ############################ WRF 4.4.2  #################################
  ## WRF v4.4.2
  ## Downloaded from git tagged releases
  # option 15, option 1 for intel and distributed memory w/basic nesting
  # large file support enable with WRFiO_NCD_LARGE_FILE_SUPPORT=1
  ########################################################################
  cd $WRF_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz -O WRF-4.4.2.tar.gz
  tar -xvzf WRF-4.4.2.tar.gz -C $WRF_FOLDER/
  cd $WRF_FOLDER/WRFV4.4.2
  export WRFIO_NCD_LARGE_FILE_SUPPORT=1
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        sed -i '428s/.*/  $response = "15 \\n";/g' $WRF_FOLDER/WRFV4.4.2/arch/Config.pl # Answer for compiler choice
        sed -i '869s/.*/  $response = "1 \\n";/g' $WRF_FOLDER/WRFV4.4.2/arch/Config.pl  #Answer for basic nesting
        ./configure
    else
      ./configure  #Option 15 intel compiler with distributed memory option 1 for basic nesting
  fi

  #Need to remove mpich/GNU config calls to Intel config calls
  sed -i '170s|mpif90 -f90=$(SFC)|mpiifort|g' $WRF_FOLDER/WRFV4.4.2/configure.wrf
  sed -i '171s|mpicc -cc=$(SCC)|mpiicc|g' $WRF_FOLDER/WRFV4.4.2/configure.wrf

  ./compile -j $CPU_HALF_EVEN em_real

  export WRF_DIR=$WRF_FOLDER/WRFV4.4.2


  # IF statement to check that all files were created.
  cd $WRF_FOLDER/WRFV4.4.2/main
  n=$(ls ./*.exe | wc -l)
  if (($n >= 3))
   then
   echo "All expected files created."
   read -r -t 5 -p "Finished installing WRF. I am going to wait for 5 seconds only ..."
  else
   echo "Missing one or more expected files. Exiting the script."
   read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
   exit
  fi
  echo " "
  ############################WPSV4.4#####################################
  ## WPS v4.4
  ## Downloaded from git tagged releases
  #Option 3 for gfortran and distributed memory
  ########################################################################

  cd $WRF_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WPS/archive/refs/tags/v4.4.tar.gz -O WPS-4.4.tar.gz
  tar -xvzf WPS-4.4.tar.gz -C $WRF_FOLDER/
  cd $WRF_FOLDER/WPS-4.4
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
      echo 19 | ./configure #Option 19 for intel and distributed memory
      else
        ./configure  #Option 19 intel compiler with distributed memory
    fi

    sed -i '67s|mpif90|mpiifort|g' $WRF_FOLDER/WPS-4.4/configure.wps
    sed -i '68s|mpicc|mpiicc|g' $WRF_FOLDER/WPS-4.4/configure.wps


  ./compile | tee compile.wps.log


  echo " "
  # IF statement to check that all files were created.
   cd $WRF_FOLDER/WPS-4.4
   n=$(ls ./*.exe | wc -l)
   if (($n == 3))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing WPS. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
   fi
   echo " "
  ############################WRFPLUS 4DVAR###############################
  ## WRFPLUS v4.4.2 4DVAR
  ## Downloaded from git tagged releases
  ## WRFPLUS is built within the WRF git folder
  ## Does not include RTTOV Libarary for radiation data.  If wanted will need to install library then reconfigure
  ##Note: if you intend to run both 3DVAR and 4DVAR experiments, it is not necessary to compile the code twice.
  #Option 8 for intel and distribunted memory
  ########################################################################
  cd $WRF_FOLDER/Downloads
  mkdir $WRF_FOLDER/WRFPLUS
  tar -xvzf WRF-4.4.2.tar.gz -C $WRF_FOLDER/WRFPLUS
  cd $WRF_FOLDER/WRFPLUS/WRFV4.4.2
  mv * $WRF_FOLDER/WRFPLUS
  cd $WRF_FOLDER/WRFPLUS
  rm -r WRFV4.4.2/
  export NETCDF=$DIR/NETCDF
  export HDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        echo 8 | ./configure wrfplus  #Option 8 for intel and distribunted memory
      else
        ./configure  wrfplus  #Option 8 for intel and distribunted memory
    fi
  echo " "

  sed -i '170s|mpif90 -f90=$(SFC)|mpiifort|g' $WRF_FOLDER/WRFPLUS/configure.wrf
  sed -i '171s|mpicc -cc=$(SCC)|mpiicc|g' $WRF_FOLDER/WRFPLUS/configure.wrf


  ./compile -j $CPU_HALF_EVEN wrfplus | tee wrfplus.compile.log
  export WRFPLUS_DIR=$WRF_FOLDER/WRFPLUS


  echo " "
  # IF statement to check that all files were created.
   cd $WRF_FOLDER/WRFPLUS/main
   n=$(ls ./wrfplus.exe | wc -l)
   if (( $n == 1 ))
    then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing WRF Plus 4DVAR. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi
  echo " "
  ############################WRFDA 4DVAR###############################
  ## WRFDA v4.4.2 4DVAR
  ## Downloaded from git tagged releases
  ## WRFDA is built within the WRFPLUS folder
  ## Does not include RTTOV Libarary for radiation data.  If wanted will need to install library then reconfigure
  ##Note: if you intend to run both 3DVAR and 4DVAR experiments, it is not necessary to compile the code twice.
  #Option 8 for intel and distribunted memory
  ########################################################################
  cd $WRF_FOLDER/Downloads
  tar -xvzf WRF-4.4.2.tar.gz -C $WRF_FOLDER/WRFDA
  cd $WRF_FOLDER/WRFDA/WRFV4.4.2
  mv * $WRF_FOLDER/WRFDA
  cd $WRF_FOLDER/WRFDA
  rm -r WRFV4.4.2/
  export NETCDF=$DIR/NETCDF
  export HDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
  export WRFPLUS_DIR=$WRF_FOLDER/WRFPLUS
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        echo 8 | ./configure 4dvar  #Option 8 for intel and distribunted memory
      else
        ./configure  4dvar  #Option 8 for intel and distribunted memory
    fi
  echo " "

  sed -i '170s|mpif90 -f90=$(SFC)|mpiifort|g' $WRF_FOLDER/WRFDA/configure.wrf
  sed -i '171s|mpicc -cc=$(SCC)|mpiicc|g' $WRF_FOLDER/WRFDA/configure.wrf


  ./compile all_wrfvar | tee wrfda.compile.log
  echo " "
  # IF statement to check that all files were created.
   cd $WRF_FOLDER/WRFDA/var/da
   n=$(ls ./*.exe | wc -l)
   cd $WRF_FOLDER/WRFDA/var/obsproc/src
   m=$(ls ./*.exe | wc -l)
   if (( ( $n == 43 ) && ( $m == 1) ))
    then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing WRFDA 4DVAR. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi

  echo " "
  ######################## WPS Domain Setup Tools ########################
  ## DomainWizard
  cd $WRF_FOLDER/Downloads
  wget -c -4 http://esrl.noaa.gov/gsd/wrfportal/domainwizard/WRFDomainWizard.zip
  mkdir $WRF_FOLDER/WRFDomainWizard
  unzip WRFDomainWizard.zip -d $WRF_FOLDER/WRFDomainWizard
  chmod +x $WRF_FOLDER/WRFDomainWizard/run_DomainWizard

  echo " "
  ######################## WPF Portal Setup Tools ########################
  ## WRFPortal
  cd $WRF_FOLDER/Downloads
  wget -c -4 https://esrl.noaa.gov/gsd/wrfportal/portal/wrf-portal.zip
  mkdir $WRF_FOLDER/WRFPortal
  unzip wrf-portal.zip -d $WRF_FOLDER/WRFPortal
  chmod +x $WRF_FOLDER/WRFPortal/runWRFPortal


  echo " "

  ######################## Static Geography Data inc/ Optional ####################
  # http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  # These files are large so if you only need certain ones comment the others off
  # All files downloaded and untarred is 200GB
  # https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  #################################################################################
  cd $WRF_FOLDER/Downloads
  mkdir $WRF_FOLDER/GEOG
  mkdir $WRF_FOLDER/GEOG/WPS_GEOG

  echo " "
  echo "Mandatory WRF Preprocessing System (WPS) Geographical Input Data Mandatory Fields Downloads"
  echo " "
  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
  tar -xvzf geog_high_res_mandatory.tar.gz -C $WRF_FOLDER/GEOG/

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz
  tar -xvzf geog_low_res_mandatory.tar.gz -C $WRF_FOLDER/GEOG/
  mv $WRF_FOLDER/GEOG/WPS_GEOG_LOW_RES/ $WRF_FOLDER/GEOG/WPS_GEOG


  if [ ${WPS_Specific_Applications} -eq 1 ]
    then
      echo " "
      echo " WPS Geographical Input Data Mandatory for Specific Applications"
      echo " "

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
      tar -xvzf geog_thompson28_chem.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
      tar -xvzf geog_noahmp.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4  https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
      tar -xvzf irrigation.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
      tar -xvzf geog_px.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
      tar -xvzf geog_urban.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
      tar -xvzf geog_ssib.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
      tar -xvf lake_depth.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/topobath_30s.tar.bz2
      tar -xvf topobath_30s.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/gsl_gwd.tar.bz2
      tar -xvf gsl_gwd.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG
  fi


  if [ ${Optional_GEOG} -eq 1 ]
    then
      echo " "
      echo "Optional WPS Geographical Input Data"
      echo " "


      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_older_than_2000.tar.gz
      tar -xvzf geog_older_than_2000.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s_with_lakes.tar.gz
      tar -xvzf modis_landuse_20class_15s_with_lakes.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_alt_lsm.tar.gz
      tar -xvzf geog_alt_lsm.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/nlcd2006_ll_9s.tar.bz2
      tar -xvf nlcd2006_ll_9s.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/updated_Iceland_LU.tar.gz
      tar -xvf updated_Iceland_LU.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s.tar.bz2
      tar -xvf modis_landuse_20class_15s.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG
  fi





fi


if [ "$macos_64bit_GNU" = "1" ] && [ "$WRF_PICK" = "1" ]; then

  #############################basic package managment############################
  brew install wget git
  brew install gcc libtool automake autoconf make m4 java ksh  mpich grads ksh tcsh
  brew install snap
  brew install python@3.9
  brew install gcc libtool automake autoconf make m4 java ksh git wget mpich grads ksh tcsh python@3.9 cmake xorgproto xorgrgb xauth curl


  ##############################Directory Listing############################

  export HOME=`cd;pwd`
  mkdir $HOME/WRF
  export WRF_FOLDER=$HOME/WRF
  cd $WRF_FOLDER/
  mkdir Downloads
  mkdir WRFPLUS
  mkdir WRFDA
  mkdir Libs
  export DIR=$WRF_FOLDER/Libs
  mkdir -p Libs/grib2
  mkdir -p Libs/NETCDF
  mkdir -p Tests/Environment
  mkdir -p Tests/Compatibility

##############################Downloading Libraries############################

  cd Downloads
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
  echo "Please enter password for linking GNU libraries"
  echo $PASSWD | sudo -S ln -sf /usr/local/bin/gcc-1* /usr/local/bin/gcc
  echo $PASSWD | sudo -S ln -sf /usr/local/bin/g++-1* /usr/local/bin/g++
  echo $PASSWD | sudo -S ln -sf /usr/local/bin/gfortran-1* /usr/local/bin/gfortran

  export CC=gcc
  export CXX=g++
  export FC=gfortran
  export F77=gfortran
  export CFLAGS="-fPIC -fPIE -O3 -Wno-implicit-function-declaration"

  echo " "

  #############################zlib############################
  #Uncalling compilers due to comfigure issue with zlib1.2.12
  #With CC & CXX definied ./configure uses different compiler Flags

  cd $WRF_FOLDER/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/
  ./configure --prefix=$DIR/grib2
  make
  make install
  #make check

  echo " "
  #############################libpng############################
  cd $WRF_FOLDER/Downloads
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

  cd $WRF_FOLDER/Downloads
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

  cd $WRF_FOLDER/Downloads
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
  cd $WRF_FOLDER/Downloads
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

  cd $WRF_FOLDER/Downloads
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
  mkdir -p $WRF_FOLDER/Tests/Environment
  mkdir -p $WRF_FOLDER/Tests/Compatibility


  cd $WRF_FOLDER/Downloads
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
  wget -c -4 https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar


  tar -xvf Fortran_C_tests.tar -C $WRF_FOLDER/Tests/Environment
  tar -xvf Fortran_C_NETCDF_MPI_tests.tar -C $WRF_FOLDER/Tests/Compatibility
  export one="1"
  echo " "
  ############## Testing Environment #####

  cd $WRF_FOLDER/Tests/Environment

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

  cd $WRF_FOLDER/Tests/Compatibility

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

  ############## ARWPOST ##################
  # No compatibile compiler for gcc/gfortran
  #########################################


  #Installing Miniconda3 to WRF directory and updating libraries
  export Miniconda_Install_DIR=$WRF_FOLDER/miniconda3

  mkdir -p $Miniconda_Install_DIR

  wget -c -4 https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O $Miniconda_Install_DIR/miniconda.sh
  bash $Miniconda_Install_DIR/miniconda.sh -b -u -p $Miniconda_Install_DIR

  rm -rf $Miniconda_Install_DIR/miniconda.sh

  export PATH=$WRFHYDRO_FOLDER/miniconda3/bin:$PATH

  source $Miniconda_Install_DIR/etc/profile.d/conda.sh

  $Miniconda_Install_DIR/bin/conda init bash
  $Miniconda_Install_DIR/bin/conda init zsh
  $Miniconda_Install_DIR/bin/conda init tcsh
  $Miniconda_Install_DIR/bin/conda init xonsh
  $Miniconda_Install_DIR/bin/conda init powershell

  conda config --add channels conda-forge
  conda config --set auto_activate_base false
  conda update -n root --all -y


  export $PATH


  echo " "

  #Installing NCL via Conda
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n ncl_stable -c conda-forge ncl -y
  conda activate ncl_stable
  conda update -n ncl_stable --all -y
  conda deactivate
  conda deactivate
  conda deactivate
  echo " "


  ############################OBSGRID###############################
  ## OBSGRID
  ## Downloaded from git tagged releases
  ## Not compatibile with gcc/gfortran on macos
  ########################################################################


  ##################### WRF Python           ##################
  ########### WRf-Python compiled via Conda  ##################
  ########### This is the preferred method by NCAR      ##################
  ##### https://wrf-python.readthedocs.io/en/latest/installation.html  ##################
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n wrf-python -c conda-forge wrf-python -y
  conda activate wrf-python
  conda update -n wrf-python --all -y
  conda deactivate
  conda deactivate
  conda deactivate

  echo " "


  echo " "
  ############################ WRF 4.4.2  #################################
  ## WRF v4.4.2
  ## Downloaded from git tagged releases
  # option 17, option 1 for gfortran and distributed memory w/basic nesting
  # large file support enable with WRFiO_NCD_LARGE_FILE_SUPPORT=1
  ########################################################################

  export WRFIO_NCD_LARGE_FILE_SUPPORT=1
  cd $WRF_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz -O WRF-4.4.2.tar.gz
  tar -xvzf WRF-4.4.2.tar.gz -C $WRF_FOLDER/
  cd $WRF_FOLDER/WRFV4.4.2

  ./clean

  if [ ${auto_config} -eq 1 ]
    then
        sed -i'' -e '428s/.*/  $response = "17 \\n";/g' $WRF_FOLDER/WRFV4.4.2/arch/Config.pl # Answer for compiler choice
        sed -i'' -e '869s/.*/  $response = "1 \\n";/g' $WRF_FOLDER/WRFV4.4.2/arch/Config.pl  #Answer for basic nesting
        ./configure
    else
      ./configure  #Option 17 gfortran compiler with distributed memory option 1 for basic nesting
  fi

  ./compile em_real

  export WRF_DIR=$WRF_FOLDER/WRFV4.4.2

  # IF statement to check that all files were created.
  cd $WRF_FOLDER/WRFV4.4.2/main
  n=$(ls ./*.exe | wc -l)
  if (($n >= 3))
   then
     echo "All expected files created."
     read -r -t 5 -p "Finished installing WRF. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
  fi
  echo " "
  ############################WPSV4.4#####################################
  ## WPS v4.4
  ## Downloaded from git tagged releases
  #Option 3 for gfortran and distributed memory
  ########################################################################

  cd $WRF_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WPS/archive/refs/tags/v4.4.tar.gz -O WPS-4.4.tar.gz
  tar -xvzf WPS-4.4.tar.gz -C $WRF_FOLDER/
  cd $WRF_FOLDER/WPS-4.4
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        echo 19 | ./configure #Option 19 for gfortran and distributed memory
      else
        ./configure  #Option 19 gfortran compiler with distributed memory
    fi

    ./compile | tee compile19.log

  # IF statement to check that all files were created.
   cd $WRF_FOLDER/WPS-4.4
   n=$(ls ./*.exe | wc -l)
   if (($n == 3))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing WPS. I am going to wait for 5 seconds only ..."
    else
      echo "Missing one or more expected files. Exiting the script."
      read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
      exit
   fi
   echo " "


  ############################WRFPLUS 4DVAR###############################
  ## WRFPLUS v4.4.2 4DVAR
  ## Downloaded from git tagged releases
  ## WRFPLUS is built within the WRF git folder
  ## Does not include RTTOV Libarary for radiation data.  If wanted will need to install library then reconfigure
  ##Note: if you intend to run both 3DVAR and 4DVAR experiments, it is not necessary to compile the code twice.
  #Option 10 for gfortran/gcc and distribunted memory
  ########################################################################

  cd $WRF_FOLDER/Downloads
  tar -xvzf WRF-4.4.2.tar.gz -C $WRF_FOLDER/WRFPLUS
  cd $WRF_FOLDER/WRFPLUS/WRFV4.4.2
  mv * $WRF_FOLDER/WRFPLUS
  cd $WRF_FOLDER/WRFPLUS
  rm -r WRFV4.4.2/
  export NETCDF=$DIR/NETCDF
  export HDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH



  if [ ${auto_config} -eq 1 ]
    then
        echo 10 | ./configure wrfplus  #Option 10 for gfortran/gcc and distribunted memory
      else
        ./configure  wrfplus  #Option 10 for gfortran/gcc and distribunted memory
    fi

  ./compile wrfplus
  export WRFPLUS_DIR=$WRF_FOLDER/WRFPLUS

  # IF statement to check that all files were created.
   cd $WRF_FOLDER/WRFPLUS/main
   n=$(ls ./wrfplus.exe | wc -l)
   if (( $n == 1 ))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing WRF Plus 4DVAR. I am going to wait for 5 seconds only ..."
    else
      echo "Missing one or more expected files. Exiting the script."
      read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
      exit
   fi


  echo " "
  ############################WRFDA 4DVAR###############################
  ## WRFDA v4.4.2 4DVAR
  ## Downloaded from git tagged releases
  ## WRFDA is built within the WRFPLUS folder
  ## Does not include RTTOV Libarary for radiation data.  If wanted will need to install library then reconfigure
  ##Note: if you intend to run both 3DVAR and 4DVAR experiments, it is not necessary to compile the code twice.
  #Option 10 for gfortran/clang and distribunted memory
  ########################################################################

  cd $WRF_FOLDER/Downloads
  tar -xvzf WRF-4.4.2.tar.gz -C $WRF_FOLDER/WRFDA
  cd $WRF_FOLDER/WRFDA/WRFV4.4.2
  mv * $WRF_FOLDER/WRFDA
  cd $WRF_FOLDER/WRFDA
  rm -r WRFV4.4.2/
  export NETCDF=$DIR/NETCDF
  export HDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
  export WRFPLUS_DIR=$WRF_FOLDER/WRFPLUS



  if [ ${auto_config} -eq 1 ]
    then
        echo 10 | ./configure 4dvar  #Option 18 for gfortran/gcc and distribunted memory
      else
        ./configure  4dvar  #Option 18 for gfortran/gcc and distribunted memory
    fi


  ./compile  all_wrfvar

  # IF statement to check that all files were created.
   cd $WRF_FOLDER/WRFDA/var/da
   n=$(ls ./*.exe | wc -l)
   cd $WRF_FOLDER/WRFDA/var/obsproc/src
   m=$(ls ./*.exe | wc -l)
   if (( ( $n == 43 ) && ( $m == 1) ))
    then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing WRFDA 4DVAR. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi


  echo " "

  ######################## WPS Domain Setup Tools ########################
  ## DomainWizard

  cd $WRF_FOLDER/Downloads
  wget http://esrl.noaa.gov/gsd/wrfportal/domainwizard/WRFDomainWizard.zip
  mkdir $WRF_FOLDER/WRFDomainWizard
  unzip WRFDomainWizard.zip -d $WRF_FOLDER/WRFDomainWizard
  chmod +x $WRF_FOLDER/WRFDomainWizard/run_DomainWizard

  echo " "
  ######################## WPF Portal Setup Tools ########################
  ## WRFPortal
  cd $WRF_FOLDER/Downloads
  wget https://esrl.noaa.gov/gsd/wrfportal/portal/wrf-portal.zip
  mkdir $WRF_FOLDER/WRFPortal
  unzip wrf-portal.zip -d $WRF_FOLDER/WRFPortal
  chmod +x $WRF_FOLDER/WRFPortal/runWRFPortal




  echo " "
  ######################## Static Geography Data inc/ Optional ####################
  # http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  # These files are large so if you only need certain ones comment the others off
  # All files downloaded and untarred is 200GB
  # https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  #################################################################################
  cd $WRF_FOLDER/Downloads
  mkdir $WRF_FOLDER/GEOG
  mkdir $WRF_FOLDER/GEOG/WPS_GEOG

  echo " "
  echo "Mandatory WRF Preprocessing System (WPS) Geographical Input Data Mandatory Fields Downloads"
  echo " "
  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
  tar -xvzf geog_high_res_mandatory.tar.gz -C $WRF_FOLDER/GEOG/

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz
  tar -xvzf geog_low_res_mandatory.tar.gz -C $WRF_FOLDER/GEOG/
  mv $WRF_FOLDER/GEOG/WPS_GEOG_LOW_RES/ $WRF_FOLDER/GEOG/WPS_GEOG


  if [ ${WPS_Specific_Applications} -eq 1 ]
    then
      echo " "
      echo " WPS Geographical Input Data Mandatory for Specific Applications"
      echo " "

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
      tar -xvzf geog_thompson28_chem.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
      tar -xvzf geog_noahmp.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4  https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
      tar -xvzf irrigation.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
      tar -xvzf geog_px.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
      tar -xvzf geog_urban.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
      tar -xvzf geog_ssib.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
      tar -xvf lake_depth.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/topobath_30s.tar.bz2
      tar -xvf topobath_30s.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG


      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/gsl_gwd.tar.bz2
      tar -xvf gsl_gwd.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

  fi

  if [ ${Optional_GEOG} -eq 1 ]
    then

      echo " "
      echo "Optional WPS Geographical Input Data"
      echo " "


      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_older_than_2000.tar.gz
      tar -xvzf geog_older_than_2000.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s_with_lakes.tar.gz
      tar -xvzf modis_landuse_20class_15s_with_lakes.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_alt_lsm.tar.gz
      tar -xvzf geog_alt_lsm.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/nlcd2006_ll_9s.tar.bz2
      tar -xvf nlcd2006_ll_9s.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/updated_Iceland_LU.tar.gz
      tar -xvf updated_Iceland_LU.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s.tar.bz2
      tar -xvf modis_landuse_20class_15s.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG

  fi


fi



################################################################
## HWRF installation with parallel process.
# Download and install required library and data files for HWRF.
# Tested in Ubuntu 20.04.4 LTS & Ubuntu 22.04 LTS
# Built in 64-bit system
# Tested with current available libraries on 01/01/2023
# Intel compilers utilized
# Compatibile only with WRF 4.3.3 & WPS 4.3.1 with NMM core
# If newer libraries exist edit script paths for changes
# Estimated Run Time ~ 45 - 90 Minutes with 10mb/s downloadspeed.
# Special thanks to:
# Youtube's meteoadriatic, GitHub user jamal919.
# University of Manchester's  Doug L
# University of Tunis El Manar's Hosni
# GSL's Jordan S.
# NCAR's Mary B., Christine W., & Carl D.
# DTC's Julie P., Tara J., George M., & John H.
# UCAR's Katelyn F., Jim B., Jordan P., Kevin M.,
##############################################################


if [ "$HWRF_PICK" = "1" ]; then


  ############################# Basic package managment ############################

  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade

  # download the key to system keyring; this and the following echo command are
  # needed in order to install the Intel compilers
  wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
  | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null

  # add signed entry to apt sources and configure the APT client to use Intel repository:
  echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list

  # this update should get the Intel package info from the Intel repository
  echo $PASSWD | sudo -S apt -y update

  # necessary binary packages (especially pkg-config and build-essential)
  echo $PASSWD | sudo -S apt -y install gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh python3 python3-dev python2 python2-dev mlocate curl cmake libcurl4-openssl-dev pkg-config build-essential

  # install the Intel compilers
  echo $PASSWD | sudo -S apt -y install intel-basekit intel-hpckit intel-aikit
  echo $PASSWD | sudo -S apt -y update

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

  ############################# CPU Core Management ####################################

  export CPU_CORE=$(nproc)                                   # number of available cores on system
  export CPU_6CORE="6"
  export CPU_HALF=$(($CPU_CORE / 2))                         # half of availble cores on system
  # Forces CPU cores to even number to avoid partial core export. ie 7 cores would be 3.5 cores.
  export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))

  # If statement for low core systems.  Forces computers to only use 1 core if there are 4 cores or less on the system.
  if [ $CPU_CORE -le $CPU_6CORE ]
  then
    export CPU_HALF_EVEN="2"
  else
    export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))
  fi

  echo "##########################################"
  echo "Number of cores being used $CPU_HALF_EVEN"
  echo "##########################################"

  ############################## Directory Listing ############################
  # makes necessary directories

  export HOME=`cd;pwd`
  mkdir $HOME/HWRF
  export HWRF_FOLDER=$HOME/HWRF
  cd $HWRF_FOLDER
  mkdir Downloads
  mkdir Libs
  export DIR=$HWRF_FOLDER/Libs
  mkdir Libs/grib2
  mkdir Libs/NETCDF
  mkdir Libs/LAPACK

  ############################## Downloading Libraries ############################
  # these are all the libraries we're installing, including HWRF itself

  cd Downloads
  wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.13.tar.gz
  wget -c -4 https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_2.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz
  wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz
  wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.39.tar.gz
  wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
  wget -c -4 https://parallel-netcdf.github.io/Release/pnetcdf-1.12.3.tar.gz
  wget -c -4 https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.10.1.tar.gz

  wget -c -4 https://dtcenter.org/sites/default/files/HWRF_v4.0a_hwrf-utilities.tar.gz
  wget -c -4 https://dtcenter.org/sites/default/files/HWRF_v4.0a_pomtc.tar.gz
  wget -c -4 https://dtcenter.org/sites/default/files/HWRF_v4.0a_ncep-coupler.tar.gz
  wget -c -4 https://dtcenter.org/sites/default/files/HWRF_v4.0a_gfdl-vortextracker.tar.gz
  wget -c -4 https://dtcenter.org/sites/default/files/HWRF_v4.0a_GSI.tar.gz
  wget -c -4 https://dtcenter.org/sites/default/files/HWRF_v4.0a_UPP.tar.gz
  wget -c -4 https://dtcenter.org/sites/default/files/HWRF_v4.0a_hwrfrun.tar.gz
  wget -c -4 https://dtcenter.org/community-code/hurricane-wrf-hwrf/datasets#data-4

  ############################# ZLib ############################

  cd $HWRF_FOLDER/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -diag-disable=10441" ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN | tee zlib.make.log
  # make check | tee zlib.makecheck.log
  make -j $CPU_HALF_EVEN install | tee zlib.makeinstall.log

  ############################# LibPNG ############################

  cd $HWRF_FOLDER/Downloads

  # other libraries below need these variables to be set
  export LDFLAGS=-L$DIR/grib2/lib
  export CPPFLAGS=-I$DIR/grib2/include

  tar -xvzf libpng-1.6.39.tar.gz
  cd libpng-1.6.39/

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -diag-disable=10441" ./configure --prefix=$DIR/grib2

  make -j $CPU_HALF_EVEN | tee libpng.make.log
  #make -j $CPU_HALF_EVEN check | tee libpng.makecheck.log
  make -j $CPU_HALF_EVEN install | tee libpng.makeinstall.log

  ############################# JasPer ############################

  cd $HWRF_FOLDER/Downloads
  unzip jasper-1.900.1.zip
  cd jasper-1.900.1/

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -diag-disable=10441" ./configure --prefix=$DIR/grib2

  make -j $CPU_HALF_EVEN | tee jasper.make.log
  #make -j $CPU_HALF_EVEN check | tee jasper.makecheck.log
  make -j $CPU_HALF_EVEN install | tee jasper.makeinstall.log

  # other libraries below need these variables to be set
  export JASPERLIB=$DIR/grib2/lib
  export JASPERINC=$DIR/grib2/include

  ############################# HDF5 library for NetCDF4 & parallel functionality ############################

  cd $HWRF_FOLDER/Downloads
  tar -xvzf hdf5-1_13_2.tar.gz
  cd hdf5-hdf5-1_13_2

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -diag-disable=10441"  ./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran --enable-parallel

  make -j $CPU_HALF_EVEN | tee hdf5.make.log
  #make VERBOSE=1 -j $CPU_HALF_EVEN check | tee hdf5.makecheck.log
  make -j $CPU_HALF_EVEN install | tee hdf5.makeinstall.log

  # other libraries below need these variables to be set
  export HDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
  export PATH=$HDF5/bin:$PATH
  export PHDF5=$DIR/grib2

  ############################# Install Parallel-NetCDF ##############################

  cd $HWRF_FOLDER/Downloads
  tar -xvzf pnetcdf-1.12.3.tar.gz
  cd pnetcdf-1.12.3

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -diag-disable=10441" ./configure --prefix=$DIR/grib2

  make -j $CPU_HALF_EVEN | tee pnetcdf.make.log
  #make check | tee pnetcdf.makecheck.log
  #make ptests | tee ptests.log
  make -j $CPU_HALF_EVEN install | tee pnetcdf.makeinstall.log

  # other libraries below need these variables to be set
  export PNETCDF=$DIR/grib2
  export LD_LIBRARY_PATH=$PNETCDF/lib:$LD_LIBRARY_PATH
  export PATH=$PNETCDF/bin:$PATH

  ############################## Install NETCDF-C Library ############################

  cd $HWRF_FOLDER/Downloads
  tar -xzvf v4.9.0.tar.gz
  cd netcdf-c-4.9.0/

  # these variables need to be set for the NetCDF-C install to work
  export CPPFLAGS=-I$DIR/grib2/include
  export LDFLAGS=-L$DIR/grib2/lib
  export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lpnetcdf -lm -ldl"

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -diag-disable=10441"  ./configure --prefix=$DIR/NETCDF --disable-dap --enable-netcdf-4 --enable-netcdf4 --enable-pnetcdf --enable-parallel-tests | tee netcdf.configure.log
  make -j $CPU_HALF_EVEN | tee netcdf.make.log
  #make check | tee netcdf.makecheck.log
  make -j $CPU_HALF_EVEN install | tee netcdf.makeinstall.log

  # other libraries below need these variables to be set
  export PATH=$DIR/NETCDF/bin:$PATH
  export NETCDF=$DIR/NETCDF

  ############################## NetCDF-Fortran library ############################

  cd $HWRF_FOLDER/Downloads
  tar -xvzf v4.6.0.tar.gz
  cd netcdf-fortran-4.6.0/

  # these variables need to be set for the NetCDF-Fortran install to work
  export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
  export CPPFLAGS="-I$DIR/NETCDF/include -I$DIR/grib2/include"
  export LDFLAGS="-L$DIR/NETCDF/lib -L$DIR/grib2/lib"
  export LIBS="-lnetcdf -lpnetcdf -lm -lcurl -lhdf5_hl -lhdf5 -lz -ldl"

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 CFLAGS="-fPIC -diag-disable=10441"  ./configure --prefix=$DIR/NETCDF --enable-netcdf-4 --enable-netcdf4 --enable-parallel-tests --enable-hdf5

  make -j $CPU_HALF_EVEN | tee netcdf-f.make.log
  #make check | tee netcdf-f.makecheck.log
  make -j $CPU_HALF_EVEN install | tee netcdf-f.makeinstall.log

  ############################ WRF 4.3.3 #################################
  ## WRF v4.3.3
  ## NMM core version 3.2
  ## Downloaded from git tagged release
  # ifort/icc
  # option 15, distributed memory (dmpar)
  # large file support enable with WRFIO_NCD_LARGE_FILE_SUPPORT=1
  ########################################################################

  cd $HWRF_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WRF/archive/refs/tags/v4.3.3.tar.gz -O WRF-4.3.3.tar.gz
  mkdir $HWRF_FOLDER/WRF
  tar -xvzf WRF-4.3.3.tar.gz -C $HWRF_FOLDER/WRF
  cd $HWRF_FOLDER/WRF/WRF-4.3.3

  ./clean -a

  # these variables need to be set for the WRF install to work
  export HWRF=1
  export WRF_NMM_CORE=1
  export WRF_NMM_NEST=1
  export JASPERLIB=$DIR/grib2/lib
  export JASPERINC=$DIR/grib2/include
  export PNETCDF_QUILT=1
  export WRFIO_NCD_LARGE_FILE_SUPPORT=1
  export NETCDF_classic=

  # Removing user input for configure.  Choosing correct option for configure with Intel compilers
  sed -i '420s/<STDIN>/15/g' $HWRF_FOLDER/WRF/WRF-4.3.3/arch/Config.pl

  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure # option 15

  # Need to remove mpich/GNU config calls to Intel config calls
  sed -i '170s|mpif90 -f90=$(SFC)|mpiifort|g' $HWRF_FOLDER/WRF/WRF-4.3.3/configure.wrf
  sed -i '171s|mpicc -cc=$(SCC)|mpiicc|g' $HWRF_FOLDER/WRF/WRF-4.3.3/configure.wrf

  ./compile -j $CPU_HALF_EVEN nmm_real | tee wrf.nmm.log

  export WRF_DIR=$HWRF_FOLDER/WRF/WRF-4.3.3

  # IF statement to check that all files were created.
  cd $HWRF_FOLDER/WRF/WRF-4.3.3/main
  n=$(ls ./*.exe | wc -l)
  if (($n == 2))
   then
   echo "All expected files created."
   read -r -t 5 -p "Finished installing WRF. I am going to wait for 5 seconds only ..."
  else
   echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
  fi

  ############################ WPS 4.3.1 #####################################
  ## Downloaded from git tagged releases
  # Option 19 for gfortran and distributed memory
  ########################################################################
  cd $HWRF_FOLDER/Downloads
  wget -c -4 https://github.com/wrf-model/WPS/archive/refs/tags/v4.3.1.tar.gz -O WPS-4.3.1.tar.gz
  tar -xvzf WPS-4.3.1.tar.gz -C $HWRF_FOLDER/WRF
  cd $HWRF_FOLDER/WRF/WPS-4.3.1

  ./clean -a

  # Removing user input for configure.  Choosing correct option for configure with Intel compilers
  sed -i '141s/<STDIN>/19/g' $HWRF_FOLDER/WRF/WPS-4.3.1/arch/Config.pl

  ./configure -D #Option 19 for Intel and distributed memory

  sed -i '65s|mpif90|mpiifort|g' $HWRF_FOLDER/WRF/WPS-4.3.1/configure.wps
  sed -i '66s|mpicc|mpiicc|g' $HWRF_FOLDER/WRF/WPS-4.3.1/configure.wps

  ./compile | tee compile_wps.log

  # IF statement to check that all files were created.
   cd $HWRF_FOLDER/WRF/WPS-4.3.1
   n=$(ls ./*.exe | wc -l)
   if (($n == 3))
    then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing WPS. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi

  ################### LAPACK ###########################

  cd $HWRF_FOLDER/Downloads
  tar -xvzf v3.10.1.tar.gz
  cd lapack-3.10.1
  cp make.inc.example make.inc

  # changing some variables and flags for the cmake build process
  sed -i '9s/ gcc/ icc /g' make.inc
  sed -i '20s/ gfortran/ ifort /g' make.inc
  sed -i '21s/ -O2 -frecursive/  -O2/g' make.inc
  sed -i '23s/ -O0 -frecursive/  -O0/g' make.inc
  sed -i '40s/#TIMER = EXT_ETIME/TIMER = EXT_ETIME/g' make.inc
  sed -i '46s/TIMER = INT_ETIME/#TIMER = INT_ETIME/g' make.inc

  mkdir build && cd build

  # this library uses cmake instead of make to build itself
  cmake -DCMAKE_INSTALL_LIBDIR=$HWRF_FOLDER/Libs/LAPACK ..
  cmake --build . -j $CPU_HALF_EVEN --target install

  # other libraries below need these variables to be set
  export LAPACK_DIR=$HWRF_FOLDER/Libs/LAPACK
  export LD_LIBRARY_PATH=$LAPACK_DIR:$LD_LIBRARY_PATH

  ######################################## HWRF-Utilities ##################################

  cd $HWRF_FOLDER/Downloads
  tar -xvzf HWRF_v4.0a_hwrf-utilities.tar.gz -C $HWRF_FOLDER/
  cd $HWRF_FOLDER/
  mv $HWRF_FOLDER/hwrf-utilities $HWRF_FOLDER/HWRF_UTILITIES
  cd $HWRF_FOLDER/HWRF_UTILITIES

  ###### SED statements required due to syntax error in original configure script ####
  sed -i '130c\ if [ -z "$MKLROOT" ] && [ ! -z "$MKL" ] ; then' $HWRF_FOLDER/HWRF_UTILITIES/configure
  sed -i '132c\ elif [ ! -z "$MKLROOT" ] && [ -z "$MKL" ] ; then' $HWRF_FOLDER/HWRF_UTILITIES/configure
  sed -i '136c\ if [ ! -z "$JASPERINC" ] && [ ! -z "$JASPERLIB" ] ; then' $HWRF_FOLDER/HWRF_UTILITIES/configure
  sed -i '139c\     if [ ! -z "$PNG_LDFLAGS" ] ; then' $HWRF_FOLDER/HWRF_UTILITIES/configure
  sed -i '144c\    if [ ! -z "$Z_INC" ] ; then' $HWRF_FOLDER/HWRF_UTILITIES/configure
  sed -i '147c\     if [ ! -z "$PNG_CFLAGS" ] ; then' $HWRF_FOLDER/HWRF_UTILITIES/configure
  sed -i '151c\ if [ ! -z "$PNETCDF" ] ; then' $HWRF_FOLDER/HWRF_UTILITIES/configure

  # these variables need to be set for the HWRF-Utilities install to work
  export MKL=$MKLROOT
  export NETCDF=$HWRF_FOLDER/Libs/NETCDF
  export WRF_DIR=$HWRF_FOLDER/WRF/WRF-4.3.3
  export JASPERLIB=$DIR/grib2/lib
  export JASPERINC=$DIR/grib2/include
  export LAPACK_PATH=$LAPACK_DIR


  # Removing user input for configure.  Choosing correct option for configure with Intel compilers
  sed -i '155s/<STDIN>/7/g' $HWRF_FOLDER/HWRF_UTILITIES/arch/Config.pl

  ./configure #option 7

  # sed commands to change to Intel compiler format
  sed -i '30s/-openmp/-qopenmp/g' $HWRF_FOLDER/HWRF_UTILITIES/configure.hwrf
  sed -i '47s/ mpif90 -f90=ifort/ mpiifort/g' $HWRF_FOLDER/HWRF_UTILITIES/configure.hwrf
  sed -i '48s/mpif90 -free -f90=ifort/mpiifort -free/g' $HWRF_FOLDER/HWRF_UTILITIES/configure.hwrf
  sed -i '49s/mpicc -cc=icc/mpiicc/g' $HWRF_FOLDER/HWRF_UTILITIES/configure.hwrf

  ./compile 2>&1 | tee hwrfutilities.build.log

  # IF statement to check that all files were created.
   cd $HWRF_FOLDER/HWRF_UTILITIES/exec
   n=$(ls ./*.exe | wc -l)
   cd $HWRF_FOLDER/HWRF_UTILITIES/libs
   m=$(ls ./*.a | wc -l)
   if (($n == 79)) && (($m == 28))
     then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing HWRF-UTILITIES. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi

  ##################################  MPIPOM-TC  ##############################

  cd $HWRF_FOLDER/Downloads
  tar -xvzf HWRF_v4.0a_pomtc.tar.gz -C $HWRF_FOLDER/
  cd $HWRF_FOLDER/
  mv $HWRF_FOLDER/pomtc $HWRF_FOLDER/MPIPOM-TC
  cd $HWRF_FOLDER/MPIPOM-TC

  # these variables need to be set for the MPIPOM-TC install to work
  export JASPER=$HWRF_FOLDER/Libs/grib2/
  export LIB_JASPER_PATH=$HWRF_FOLDER/Libs/grib2/lib
  export LIB_PNG_PATH=$HWRF_FOLDER/Libs/grib2/lib
  export LIB_Z_PATH=$HWRF_FOLDER/Libs/grib2/
  export LIB_W3_PATH=$HWRF_FOLDER/HWRF_UTILITIES/libs/
  export LIB_SP_PATH=$HWRF_FOLDER/HWRF_UTILITIES/libs/
  export LIB_SFCIO_PATH=$HWRF_FOLDER/HWRF_UTILITIES/libs/
  export LIB_BACIO_PATH=$HWRF_FOLDER/HWRF_UTILITIES/libs/
  export LIB_NEMSIO_PATH=$HWRF_FOLDER/HWRF_UTILITIES/libs/
  export LIB_G2_PATH=$HWRF_FOLDER/HWRF_UTILITIES/libs/
  export LIB_BLAS_PATH=$HWRF_FOLDER/HWRF_UTILITIES/libs/
  export PNETCDF=$DIR/grib2

  ###### SED statements required due to syntax error in original configure script ####
  sed -i 's/\[\[/\[/g' $HWRF_FOLDER/MPIPOM-TC/configure
  sed -i 's/\]\]/\]/g' $HWRF_FOLDER/MPIPOM-TC/configure
  sed -i 's/==/=/g' $HWRF_FOLDER/MPIPOM-TC/configure
  sed -i '272c\    if [ -s $ldir/libjasper.a ] || [ -s $ldir/libjasper.so ] ; then' $HWRF_FOLDER/MPIPOM-TC/configure
  sed -i '288c\    if [ -s $ldir/libpng.a ] || [ -s $ldir/libpng.so ] ; then' $HWRF_FOLDER/MPIPOM-TC/configure
  sed -i '304c\    if [ -s $ldir/libz.a ] || [ -s $ldir/libz.so ] ; then' $HWRF_FOLDER/MPIPOM-TC/configure

  # Removing user input for configure.  Choosing correct option for configure with Intel compilers
  sed -i '101s/<STDIN>/3/g' $HWRF_FOLDER/MPIPOM-TC/arch/Config.pl

  /bin/bash ./configure  #option 3

  # sed commands to change to intel compiler format
  sed -i '32s/ -openmp/ -qopenmp/g' $HWRF_FOLDER/MPIPOM-TC/configure.pom
  sed -i '41s/ mpif90 -f90=$(SFC)/ mpiifort/g' $HWRF_FOLDER/MPIPOM-TC/configure.pom
  sed -i '42s/ mpif90 -f90=$(SFC) -free / mpiifort -free/g' $HWRF_FOLDER/MPIPOM-TC/configure.pom

  ./compile | tee ocean.log

  # IF statement to check that all files were created.
  cd $HWRF_FOLDER/MPIPOM-TC/ocean_exec
  n=$(ls ./*.exe | wc -l)
  m=$(ls ./*.xc | wc -l)
   if (($n == 9)) && (($m == 12))
     then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing MPIPOM-TC. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi

  ################################## GFDL Vortex Tracker ##############################

  cd $HWRF_FOLDER/Downloads
  tar -xvzf HWRF_v4.0a_gfdl-vortextracker.tar.gz -C $HWRF_FOLDER/
  cd $HWRF_FOLDER/
  mv $HWRF_FOLDER/gfdl-vortextracker $HWRF_FOLDER/GFDL_VORTEX_TRACKER
  cd $HWRF_FOLDER/GFDL_VORTEX_TRACKER

  # these variables need to be set for the GFDL Vortex Tracker install to work
  export LIB_JASPER_PATH=$HWRF_FOLDER/Libs/grib2/lib
  export LIB_PNG_PATH=$HWRF_FOLDER/Libs/grib2/lib
  export LIB_Z_PATH=$HWRF_FOLDER/Libs/grib2/
  export LIB_W3_PATH=$HWRF_FOLDER/HWRF_UTILITIES/libs/
  export LIB_BACIO_PATH=$HWRF_FOLDER/HWRF_UTILITIES/libs/
  export LIB_G2_PATH=$HWRF_FOLDER/HWRF_UTILITIES/libs/

  sed -i 's/\[\[/\[/g' $HWRF_FOLDER/GFDL_VORTEX_TRACKER/configure
  sed -i 's/\]\]/\]/g' $HWRF_FOLDER/GFDL_VORTEX_TRACKER/configure
  sed -i 's/==/=/g' $HWRF_FOLDER/GFDL_VORTEX_TRACKER/configure

  # Removing user input for configure.  Choosing correct option for configure with Intel compilers
  sed -i '154s/<STDIN>/2/g' $HWRF_FOLDER/GFDL_VORTEX_TRACKER/arch/Config.pl

  ./configure  #option 2

  # sed commands to change to Intel compiler format
  sed -i '38s/ mpif90 -fc=$(SFC)/ mpiifort/g' $HWRF_FOLDER/GFDL_VORTEX_TRACKER/configure.trk
  sed -i '39s/ mpif90 -fc=$(SFC) -free/ mpiifort -free/g' $HWRF_FOLDER/GFDL_VORTEX_TRACKER/configure.trk
  sed -i '40s/ mpicc/ mpiicc/g' $HWRF_FOLDER/GFDL_VORTEX_TRACKER/configure.trk

  ./compile 2>&1 | tee tracker.log

  # IF statement to check that all files were created.
   cd $HWRF_FOLDER/GFDL_VORTEX_TRACKER/trk_exec
   n=$(ls ./*.exe | wc -l)
   if (($n == 3))
     then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing GFDL_VORTEX_TRACKER. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi



  ################################## NCEP Coupler ##############################

  cd $HWRF_FOLDER/Downloads
  tar -xvzf HWRF_v4.0a_ncep-coupler.tar.gz -C $HWRF_FOLDER/
  cd $HWRF_FOLDER/
  mv $HWRF_FOLDER/ncep-coupler $HWRF_FOLDER/NCEP_COUPLER
  cd $HWRF_FOLDER/NCEP_COUPLER

  # Removing user input for configure.  Choosing correct option for configure with intel compilers
  sed -i '84s/<STDIN>/3/g' $HWRF_FOLDER/NCEP_COUPLER/arch/Config.pl

  ./configure  #option 3

  # sed commands to change to intel compiler format
  sed -i '26s/ mpif90 -fc=$(SFC)/ mpiifort/g' $HWRF_FOLDER/NCEP_COUPLER/configure.cpl
  sed -i '27s/ mpif90 -fc=$(SFC) -free/ mpiifort -free/g' $HWRF_FOLDER/NCEP_COUPLER/configure.cpl

  ./compile 2>&1 | tee coupler.log

  # IF statement to check that all files were created.
   cd $HWRF_FOLDER/NCEP_COUPLER/cpl_exec
   n=$(ls ./*.exe | wc -l)
   if (($n == 1))
     then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing NCEP_COUPLER. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi

  ################################## Unified Post Processor (UPP) ##############################

  cd $HWRF_FOLDER/Downloads
  tar -xvzf HWRF_v4.0a_UPP.tar.gz -C $HWRF_FOLDER/
  cd $HWRF_FOLDER/UPP

  # these variables need to be set for the UPP install to work
  export HWRF=1
  export WRF_DIR=$HWRF_FOLDER/WRF/WRF-4.3.3
  export JASPERLIB=$DIR/grib2/lib
  export JASPERINC=$DIR/grib2/include

  # Removing user input for configure.  Choosing correct option for configure with intel compilers
  sed -i '197s/<STDIN>/4/g' $HWRF_FOLDER/UPP/arch/Config.pl

  ./configure  #compile opiton 4

  # sed commands to change to intel compiler format
  sed -i '26s/ mpif90 -fc=$(SFC)/ mpiifort/g' $HWRF_FOLDER/NCEP_COUPLER/configure.cpl
  sed -i '27s/ mpif90 -fc=$(SFC) -free/ mpiifort -free/g' $HWRF_FOLDER/NCEP_COUPLER/configure.cpl

  # sed commands to change to intel compiler format
  sed -i '27s/ mpif90 -f90=$(SFC)/ mpiifort/g' $HWRF_FOLDER/UPP/configure.upp
  sed -i '28s/ mpif90 -f90=$(SFC) -free/ mpiifort -free/g' $HWRF_FOLDER/UPP/configure.upp
  sed -i '29s/ mpicc/ mpiicc/g' $HWRF_FOLDER/UPP/configure.upp

  ./compile 2>&1 | tee build.log

  # IF statement to check that all files were created.
   cd $HWRF_FOLDER/UPP/bin
   n=$(ls ./*.exe | wc -l)
   cd $HWRF_FOLDER/UPP/lib
   m=$(ls ./*.a | wc -l)
   if (($n == 6)) && (($m == 13))
     then
    echo "All expected files created."
    read -r -t 5 -p "Finished installing UPP. I am going to wait for 5 seconds only ..."
   else
    echo "Missing one or more expected files. Exiting the script."
    read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
    exit
   fi

  ############################### HWRF RUN ######################################
  # This section unpacks the runtime files for HWRF
  # The HWRF User Guide and other documentation are downloaded as well;
  # see chapter 3 of the User Guide for details on running HWRF.
  ###############################################################################

  cd $HWRF_FOLDER/Downloads
  tar -xvzf HWRF_v4.0a_hwrfrun.tar.gz -C $HWRF_FOLDER/
  cd $HOME/HWRF
  mv $HWRF_FOLDER/hwrfrun $HWRF_FOLDER/HWRF_RUN
  cd $HWRF_FOLDER/HWRF_RUN

  #HWRF v4.0a Users Guide
  wget -c -4 https://dtcenter.org/sites/default/files/community-code/hwrf/docs/users_guide/HWRF-UG-2018.pdf
  #HWRF Scientific Documentation - November 2018
  wget -c -4 https://dtcenter.org/sites/default/files/community-code/hwrf/docs/scientific_documents/HWRFv4.0a_ScientificDoc.pdf
  #WRF-NMM V4 User's Guide
  wget -c -4 https://dtcenter.org/sites/default/files/community-code/hwrf/docs/scientific_documents/WRF-NMM_2018.pdf

  ######################## Static geographic gata incl/ optional files ####################
  # http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  # These files are LARGE so if you only need certain ones, comment the others off with #
  # All of these files downloaded and untarred come out to roughly 250GB
  # https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
  #################################################################################

  cd $HWRF_FOLDER/Downloads
  mkdir $HWRF_FOLDER/GEOG
  mkdir $HWRF_FOLDER/GEOG/WPS_GEOG

  # Mandatory WRF Preprocessing System (WPS) Geographical Input Data Mandatory Fields

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
  tar -xvzf geog_high_res_mandatory.tar.gz -C $HWRF_FOLDER/GEOG/

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz
  tar -xvzf geog_low_res_mandatory.tar.gz -C $HWRF_FOLDER/GEOG/
  mv $HWRF_FOLDER/GEOG/WPS_GEOG_LOW_RES/ $HWRF_FOLDER/GEOG/WPS_GEOG


  # WPS Geographical Input Data - Mandatory for Specific Applications

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
  tar -xvzf geog_thompson28_chem.tar.gz -C $HWRF_FOLDER/GEOG/WPS_GEOG

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
  tar -xvzf geog_noahmp.tar.gz -C $HWRF_FOLDER/GEOG/WPS_GEOG

  wget -c  -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
  tar -xvzf irrigation.tar.gz -C $HWRF_FOLDER/GEOG/WPS_GEOG

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
  tar -xvzf geog_px.tar.gz -C $HWRF_FOLDER/GEOG/WPS_GEOG

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
  tar -xvzf geog_urban.tar.gz -C $HWRF_FOLDER/GEOG/WPS_GEOG

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
  tar -xvzf geog_ssib.tar.gz -C $HWRF_FOLDER/GEOG/WPS_GEOG

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
  tar -xvf lake_depth.tar.bz2 -C $HWRF_FOLDER/GEOG/WPS_GEOG

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/topobath_30s.tar.bz2
  tar -xvf topobath_30s.tar.bz2 -C $HWRF_FOLDER/GEOG/WPS_GEOG

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/gsl_gwd.tar.bz2
  tar -xvf gsl_gwd.tar.gz -C $HWRF_FOLDER/GEOG/WPS_GEOG


  # Optional WPS Geographical Input Data

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_older_than_2000.tar.gz
  tar -xvzf geog_older_than_2000.tar.gz -C $HWRF_FOLDER/GEOG/WPS_GEOG

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s_with_lakes.tar.gz
  tar -xvzf modis_landuse_20class_15s_with_lakes.tar.gz -C $HWRF_FOLDER/GEOG/WPS_GEOG

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_alt_lsm.tar.gz
  tar -xvzf geog_alt_lsm.tar.gz -C $HWRF_FOLDER/GEOG/WPS_GEOG

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/nlcd2006_ll_9s.tar.bz2
  tar -xvf nlcd2006_ll_9s.tar.bz2 -C $HWRF_FOLDER/GEOG/WPS_GEOG

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/updated_Iceland_LU.tar.gz
  tar -xvf updated_Iceland_LU.tar.gz -C $HWRF_FOLDER/GEOG/WPS_GEOG

  wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s.tar.bz2
  tar -xvf modis_landuse_20class_15s.tar.bz2 -C $HWRF_FOLDER/GEOG/WPS_GEOG


  echo "Congratulations! You've successfully installed all required files to run the Hurricane Weather Research Forecast (HWRF) Model verison 4.0a utilizing the intel compilers."
  echo "Thank you for using this script."


fi


##########################  Export PATH and LD_LIBRARY_PATH ################################
cd $HOME

while read -r -p "Would to append your exports to your terminal profile (bashrc)?
  This will allow users to execute all the programs installed in this script.

  Please note that if users choose YES the user will not be able to install another WRF version in parallel with the one the user installed on the same system.

  For example:  Users could not have WRF AND WRFCHEM installed if YES is chosen.
  if NO is chosen then users could have WRF OR WRFCHEM installed on the same sytem if NO is chosen.

  Please answer (Y/N) )and press enter (case sensative).
  " yn; do

    case $yn in
    [Yy]* )
      echo "-------------------------------------------------- "
      echo " "
      echo "Exporting to bashrc"
      echo "export PATH=$DIR/bin:$PATH" >> ~/.bashrc
      echo "export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
      break
      ;;
    [Nn]* )
      echo "-------------------------------------------------- "
      echo " "
      echo "Exports will NOT be added to bashrc"
      break
      ;;
      * )
     echo " "
     echo "Please answer YES or NO (case sensative).";;

  esac
done







#####################################BASH Script Finished##############################



end=`date`
END=$(date +"%s")
DIFF=$(($END-$START))
echo "Install Start Time: ${start}"
echo "Install End Time: ${end}"
echo "Install Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
