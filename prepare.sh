DEFAULT_NDK=~/Development/android-ndk-r11c

git submodule update --init

if [ -z ${NDK+x} ]; then 
  echo "NDK does not exists"; 

  if [ -d "$DEFAULT_NDK" ]; 
  then
     # Control will enter here if $DIRECTORY exists.
    echo but default NDK r11 $DEFAULT_NDK does exist and we use it ! 
    NDK=$DEFAULT_NDK 
  else
    echo Default NDK r11 $DEFAULT_NDK does not exist, please download NDK r11 and set it like in README.md suggested
    exit
  fi
else 
  echo "NDK is set to '$NDK'"; 
fi

echo ""
echo "check NDK settings"

grep \$NDK/ * -R | cut -f2 -d "=" |sort -u | while read -r file ; do
  # the "while read" line is printed too, no clue how to get rid of it 
  if [[ ! $file = *"while read"* ]]; then
    eval "cmd='(ls $file >> /dev/null 2>/dev/null && echo exists $file) || echo missing $file'"
    eval $cmd
  fi
done

cp buildScripts/x264/* x264/
cd x264
git checkout origin/stable
./build_android_all.sh

# ffmpeg
cd ../ffmpeg
git checkout origin/release/3.0
cp buildScripts/ffmpeg/* ffmpeg/

# For the output format like this libavcodec-55.so, which is accepted in Android.
# find these codes
#SLIBNAME_WITH_MAJOR='$(SLIBNAME).$(LIBMAJOR)'
#LIB_INSTALL_EXTRA_CMD='$$(RANLIB) "$(LIBDIR)/$(LIBNAME)"'
#SLIB_INSTALL_NAME='$(SLIBNAME_WITH_VERSION)'
#SLIB_INSTALL_LINKS='$(SLIBNAME_WITH_MAJOR) $(SLIBNAME)'

# and remove with these ones
#SLIBNAME_WITH_MAJOR='$(SLIBPREF)$(FULLNAME)-$(LIBMAJOR)$(SLIBSUF)'
#LIB_INSTALL_EXTRA_CMD='$$(RANLIB)"$(LIBDIR)/$(LIBNAME)"'
#SLIB_INSTALL_NAME='$(SLIBNAME_WITH_MAJOR)'
#SLIB_INSTALL_LINKS='$(SLIBNAME)'

line=$(grep -n -m 1 SLIBNAME_WITH_MAJOR= configure | cut -d : -f1)
lineEnd=$(($line+4))
lineIns=$(($line-1))
echo $lineIns
# delete old lines and insert lines to replace
if [ "$(uname)" == "Darwin" ]; then
   sed -i "x.bak" "${line},${lineEnd}d" configure
   sed -i "r.bak" "${lineIns} r ../buildScripts/ffmpeg.template" configure
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
   sed -i "${line},${lineEnd}d" configure
   sed -i "${lineIns} r ../buildScripts/ffmpeg.template" configure
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
   # Do something under 32 bits Windows NT platform
   echo "not implemented"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
   # Do something under 64 bits Windows NT platform
   echo "not implemented"
fi

./build_android_all.sh
