[ -f "php-5.6.18.tar.xz" ] || wget http://php.net/get/php-5.6.18.tar.xz/from/this/mirror

ping mirrors.aliyuncs.com -c 2
[ $? -eq 0 ] && cp ../../common/sources.list.jessie-aliyun sources.list.jessie \
    || cp ../../common/sources.list.jessie-163 sources.list.jessie

docker build -t apps/php:5.6 ./

rm sources.list.jessie
