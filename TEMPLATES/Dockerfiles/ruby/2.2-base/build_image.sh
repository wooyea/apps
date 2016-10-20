ping mirrors.aliyuncs.com -c 2
[ $? -eq 0 ] && cp ../../common/sources.list.jessie-aliyuncs sources.list.jessie \
    || cp ../../common/sources.list.jessie-163 sources.list.jessie


docker build -t apps/ruby:2.2-base ./

rm sources.list.jessie
