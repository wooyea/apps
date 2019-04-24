
nc -z -v -w 2 mirrors.aliyuncs.com
[ $? -eq 0 ] && cp ../../common/sources.list.stretch-aliyun sources.list \
    || cp ../../common/sources.list.stretch-163 sources.list

docker build -t apps/php:5.6-apache ./

rm sources.list
