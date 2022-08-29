# CopyCat-Docker

This is the repo that contains instructions to create the environment for the CopyCat Project.

These are the main dependencies of the CopyCat environment:

- Python 3.8
- OpenCV (built with `cmake` to include GPU support)
- CUDA
- HTK
- ESPnet (current pipeline development is still a work in progress)
- Kaldi
- Azure Kinect SDK

To <u>build</u> the docker image, type `docker compose up --build -d` with the dockerfile in same directory as your terminal. **This step takes 1 hour on Ebisu and took 6-8 hours on Guru's local computer**

To <u>open</u> the docker container, type `docker exec -it container_id bash`
