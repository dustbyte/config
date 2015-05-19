#!/bin/sh

cp -r bin ~/

for elem in `find . -maxdepth 1 -name "dot.*" | sort -d`
do
    trans=`echo $elem | sed 's/\.\/dot\./\./g'`
    echo ${HOME}/$trans
    if [ ! -e ${HOME}/$trans ] 
    then
      ln -s $PWD/$elem ~/$trans;
    fi
done
