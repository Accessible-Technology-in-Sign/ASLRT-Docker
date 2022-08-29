# ASLRT-Docker

This is the repo that contains instructions to create the environment for the ASLRT Project.

These are the main dependencies of the ASLRT environment:

- Python 3.8
- OpenCV (built with `cmake` to include GPU support)
- CUDA
- cuDNN
- HTK
- ESPnet (current pipeline development is still a work in progress)
- Kaldi
- Azure Kinect SDK
- TensorFlow 2.9
- PyTorch 1.11 (from ESPnet)
- Other Python Dependencies (NumPy, pandas, etc.)

To <u>build</u> the docker image, type `docker compose up --build -d` with the dockerfile in same directory as your terminal. **This step takes 1 hour on Ebisu and took 6-8 hours on Guru's local computer**

To <u>open</u> the docker container, type `docker exec -it container_id bash`
