ping mirrors.aliyuncs.com -c 2
[ $? -eq 0 ] && cp ../../common/sources.list.jessie-aliyun sources.list.jessie \
    || cp ../../common/sources.list.jessie-163 sources.list.jessie


docker build -t woo/ruby:2.2 ./
