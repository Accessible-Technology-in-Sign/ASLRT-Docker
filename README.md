# ASLRT-Docker

This is the repo that contains instructions to create the environment for the ASLRT Project.

These are the main dependencies of the ASLRT environment:

- Python 3.8 (via Miniconda)
- OpenCV (built with `cmake` to include GPU support)
- CUDA 10.2
- cuDNN 8
- HTK
- ESPnet (contains PyTorch with GPU support)
- Tensorflow (with GPU Support)
- Kaldi (with GPU Support) (under `/espnet/tools`)
- Azure Kinect SDK
- TensorFlow 2.9
- PyTorch 1.11 (from ESPnet)
- Other Python Dependencies (NumPy, pandas, etc.)

It is recommended to simply pull the docker image from Docker Hub. Here is the link to the Docker Hub Repository for CopyCat: [https://hub.docker.com/r/gurudesh/copycat](https://hub.docker.com/r/gurudesh/copycat)

To <u>build</u> the docker image, type `docker-compose up --build -d` with the dockerfile in same directory as your terminal. **This step takes 1 hour on Ebisu and took 8 hours on Guru's local computer**

To <u>open</u> the docker container, type `docker exec -it container_id bash`
