FROM httpd:2.4-alpine
COPY ./build/install/pretty-svn-index/ /usr/local/apache2/htdocs/
COPY ./docker/example-data/ /usr/local/apache2/htdocs/
COPY ./docker/httpd.conf /usr/local/apache2/conf/httpd.conf
