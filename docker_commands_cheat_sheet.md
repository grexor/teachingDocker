
# 0. What is Docker, image, container?

You can refer to 
* https://medium.com/platformer-blog/practical-guide-on-writing-a-dockerfile-for-your-application-89376f88b3b5

![docker_image](https://miro.medium.com/max/2520/1*p8k1b2DZTQEW_yf0hYniXw.png)

# 1. Important commands

Check docker image list
```
$ docker image ls
```

Check docker container list
```
$ docker container ls
```

# 2. Docker container operation

Start a container from an image
```
$ docker run -ti <image> bash --login
````

Example, run.sh
```
$ docker run -v `pwd`/data:/home/student/data --user student --hostname biodocker -ti biodocker bash --login
```
* Note: It automatically login the container at the same time.
* Note: to logout, ctrl-D  or *exit*. ctrl-D does not stop the container, but *exit* stops the container

Start a container
```
$ docker container start <container_ID>|<container_name>
```

Stop a container
```
$ docker container stop <container_ID>|<container_name>
```

Remove a container
```
$ docker container rm <container_ID>|<container_name>
```

Commit a container to a image
```
$ docker commit <container_ID>|<container_name> <image_name>:<tag>
```

Login a container
```
$ docker exec -it <container_ID>|<container_name> bash
```

# 3. Docker image operation

Save an image to file 
```
$ docker save <image_name> -o <file.tar>
```

Example
```
$ docker save biodocker -o my_biodocker.tar
```


