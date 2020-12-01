#! /bin/sh -e
SCRATCH=scratch/$(basename $0 .sh)

rm -rf ${SCRATCH}
mkdir -p ${SCRATCH}

SCRATCHFILE=${SCRATCH}/simple
LIBFILE=${SCRATCH}/libbar.so
cp simple $SCRATCHFILE
cp libbar.so $LIBFILE
LIBFILE_PATH=$(readlink -f $LIBFILE)

doit() {
    echo patchelf $*
    ../src/patchelf $* $SCRATCHFILE
}

for x in $(seq 10000)
do
  NXT=${SCRATCH}/simple-$x
  cp $SCRATCHFILE $NXT
  stat -c %s $NXT
  doit --add-needed $LIBFILE_PATH
  echo ../src/patchelf --add-needed $LIBFILE_PATH $NXT
  ../src/patchelf --add-needed $LIBFILE_PATH $NXT
  $NXT
  SCRATCHFILE=$NXT
done
