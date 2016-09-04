ping mirrors.aliyuncs.com -c 2
[ $? -eq 0 ] && cp ../../common/sources.list.jessie-aliyuncs sources.list.jessie \
    || cp ../../common/sources.list.jessie-163 sources.list.jessie

cp ../../common/gosu-amd64_1.7 ./
cp ../../common/tini_0.9.0 ./

docker build -t woo/ruby:2.2 ./

rm gosu-amd64_1.7
rm tini_0.9.0
rm sources.list.jessie
