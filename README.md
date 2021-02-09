# teachingDocker

To avoid large file transfers and other Docker issues in the future, we established this GitHub repository:

https://github.com/grexor/teachingDocker

I would kindly ask you to check the Dockerfile in this repository (https://github.com/grexor/teachingDocker/blob/main/Dockerfile).

I edited the file to add the user “student”, install R, some R libraries, salmon etc. However we would need to edit this further to install all BIO 609/610/634 required software.

Using this Docker image is now super easy.

You clone the repository:

`git clone https://github.com/grexor/teachingDocker.git`

and then build (only first time, or when Dockerfile changes):

```
build.sh
```

To run the container (login with username `student`) simple execute:

```
run.sh
```

With executing `run.sh`, you are logged into the Docker container with username `student`. At the same time, a folder called `data` is created on your local drive, which is mapped to `/home/student/data` on the local container.

This setup should avoid us any major trouble in future classes (let’s hope).
