rm -rf local remote
mkdir -p local
cp *.c local
mkdir -p remote
cd remote
wget http://www.mrtc.mdh.se/projects/wcet/wcet_bench.zip
unzip wcet_bench.zip
rm -rf __MACOSX wcet_bench.zip
wget http://www.mrtc.mdh.se/projects/wcet/wcet_bench/ndes/ndes.c
wget http://www.mrtc.mdh.se/projects/wcet/wcet_bench/st/st.c
wget http://www.mrtc.mdh.se/projects/wcet/wcet_bench/whet/whet.c
#for f in `git ls-files | grep '.c$'` ; do
#    cp $f $f.orig
#    git checkout $f
#done
