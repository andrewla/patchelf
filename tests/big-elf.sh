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
  stat -c %s $SCRATCHFILE
  doit --add-needed $LIBFILE_PATH
  $SCRATCHFILE
done
