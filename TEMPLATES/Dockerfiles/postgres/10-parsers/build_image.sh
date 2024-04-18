nc -z -w 2 mirrors.aliyuncs.com 80
[ $? -eq 0 ] && cp ../../common/sources.list.stretch-163 sources.list.jessie \
    || cp ../../common/sources.list.jessie-163 sources.list.jessie

[ i]
wget https://github.com/amutu/zhparser/archive/v0.2.0.tar.gz -o

docker build -t apps/postgre:10 ./

rm ssources.list.stretch-163
