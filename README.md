# teachingDocker

BIO 609 / 610 / 634 teaching Docker

# Installation

Clone the repository:

`git clone https://github.com/grexor/teachingDocker.git`

or download (Code / Download ZIP on the right) and extract to a local folder (Desktop?) on your computer.

You need to have Docker installed (https://www.docker.com/products/docker-desktop).

Then build the container:

```
docker build . --tag biodocker
```

Make sure the build is successful (there is no error).

# Running [Mac, Linux]

To run the container (login with username `student`) execute these commands in the terminal (console):

```
mkdir data
chmod 777 data
docker run -v `pwd`/data:/home/student/data --user student --hostname biodocker -ti biodocker bash --login
```

# Running [Windows]

To run the container (login with username `student`) execute this commands in the Windows Prompt (cmd) terminal:

```
docker run -v "C:/Users/username/Desktop/teachingDocker/data":/home/student/data --hostname biodocker --user student -ti biodocker bash --login
```

The *username* should change depending on your environment. This also assumes you downloaded this repository to `Desktop/teachingDocker`.

# Testing installation

If you are logged into the Docker container with username `student` you should see this:

`(base) student@biodocker:~$`

To make sure your `data` folder is writable, run this in the container:

`touch data/test`

If there is no error, everything works.
