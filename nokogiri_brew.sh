# Having trouble with nokogiri? Got brew? try this:
# taken from: http://nokogiri.org/tutorials/installing_nokogiri.html

# install prereqs using brew:
brew install libxml2 libxslt

HERE=`pwd`
cd /tmp

# build libiconv from source:
wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz
tar xvfz libiconv-1.13.1.tar.gz
cd libiconv-1.13.1
./configure --prefix=/usr/local/Cellar/libiconv/1.13.1
make
sudo make install

# return to this directory
cd $HERE
gem install nokogiri -v '1.5.2' -- \
  --with-xml2-include=/usr/local/Cellar/libxml2/2.7.8/include/libxml2 \
  --with-xml2-lib=/usr/local/Cellar/libxml2/2.7.8/lib \
  --with-xslt-dir=/usr/local/Cellar/libxslt/1.1.26 \
  --with-iconv-include=/usr/local/Cellar/libiconv/1.13.1/include \
  --with-iconv-lib=/usr/local/Cellar/libiconv/1.13.1/lib