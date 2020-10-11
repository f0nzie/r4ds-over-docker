# BUILD_DATE for R-3.6.3 is 2020-04-24
FROM rocker/verse:3.6.3


RUN . /etc/environment \
    && mkdir /home/rstudio/r4ds

# when copying a folder we have to specify the destination folder as well
COPY book /home/rstudio/r4ds/book/
# we don't copy everything because we have a single file left at the end
COPY DESCRIPTION /home/rstudio/r4ds/

# install dependencies using a package DESCRIPTION file
RUN R -e "devtools::install(\
    '/home/rstudio/r4ds', \
    keep_source=TRUE, \
    args='--install-tests', \
    dependencies=TRUE)"

# output folder for the book
WORKDIR /home/rstudio/r4ds/book

# build gitbook with bookdown
RUN Rscript -e 'bookdown::render_book(input = "index.Rmd",\
                      output_format = "bookdown::gitbook",\
                      output_dir = "public", clean_envir = FALSE)'

# change owner:group to current user
RUN chown -R 1001:1001 public
COPY copy_gitbook.sh /home/rstudio/r4ds
