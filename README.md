# ASLRT-Docker

This is the repo that contains instructions to create the environment for the ASLRT Project.

These are the main dependencies of the ASLRT environment:

- Python 3.8 (via Miniconda)
- OpenCV (built with `cmake` to include GPU support)
- CUDA 10.2
- cuDNN 7, 8
- HTK
- ESPnet (contains PyTorch with GPU support)
- Tensorflow (with GPU Support)
- Kaldi (with GPU Support)
- Azure Kinect SDK
- TensorFlow 2.9
- PyTorch 1.11 (from ESPnet)
- Other Python Dependencies (NumPy, pandas, etc.)

It is recommended to simply pull the docker image from Docker Hub. Here is the link to the Docker Hub Repository for CopyCat: [https://hub.docker.com/r/gurudesh/copycat](https://hub.docker.com/r/gurudesh/copycat)

To <u>build</u> the docker image, type `docker-compose up --build -d` with the dockerfile in same directory as your terminal. **This step takes 1 hour on Ebisu and took 8 hours on Guru's local computer**

To <u>open</u> the docker container, type `docker exec -it container_id bash`

## Python Environment
Here is the output of `pip freeze`, which displays the Python packages used and their versions
```
absl-py==1.2.0
aiofiles==22.1.0
aiohttp==3.8.1
aiosignal==1.2.0
antlr4-python3-runtime==4.8
appdirs==1.4.4
argon2-cffi==21.3.0
argon2-cffi-bindings==21.2.0
asttokens==2.0.8
astunparse==1.6.3
async-timeout==4.0.2
attrs==22.1.0
audioread==3.0.0
Babel==2.10.3
backcall==0.2.0
beautifulsoup4==4.11.1
bert-score==0.3.11
bleach==5.0.1
Bottleneck==1.3.5
brotlipy==0.7.0
cachetools==5.2.0
certifi @ file:///opt/conda/conda-bld/certifi_1655968806487/work/certifi
cffi @ file:///opt/conda/conda-bld/cffi_1642701102775/work
# Editable Git install with no remote (chainer==6.0.0)
-e /espnet/tools/chainer
# Editable Git install with no remote (chainer-ctc==1.0)
-e /espnet/tools/chainer_ctc
charset-normalizer @ file:///tmp/build/80754af9/charset-normalizer_1630003229654/work
ci-sdr==0.0.0
click==8.1.3
clldutils==3.12.0
colorama @ file:///tmp/build/80754af9/colorama_1607707115595/work
colorlog==6.6.0
conda==4.13.0
conda-content-trust @ file:///tmp/build/80754af9/conda-content-trust_1617045594566/work
conda-package-handling @ file:///tmp/build/80754af9/conda-package-handling_1649087926789/work
ConfigArgParse==1.5.3
cryptography @ file:///tmp/build/80754af9/cryptography_1652083738073/work
csvw==3.1.1
ctc-segmentation==1.7.1
cupy-cuda102==11.0.0
cycler==0.11.0
Cython==0.29.32
datasets==2.4.0
debugpy==1.6.3
decorator==4.4.2
defusedxml==0.7.1
dill==0.3.5.1
Distance==0.1.3
dlinfo==1.2.1
docker-pycreds==0.4.0
editdistance==0.5.2
einops==0.4.1
entrypoints==0.4
# Editable Git install with no remote (espnet==202207)
-e /espnet
espnet-model-zoo==0.1.7
espnet-tts-frontend==0.0.3
executing==0.10.0
fairscale==0.4.8
# Editable Git install with no remote (fairseq==1.0.0a0+313ff05)
-e /espnet/tools/fairseq
fast-bss-eval==0.1.3
fastdtw==0.3.4
fastjsonschema==2.16.1
fastrlock==0.8
ffmpeg-python==0.2.0
ffprobe-python==1.0.3
filelock==3.8.0
filterpy==1.4.5
flatbuffers==1.12
fonttools==4.36.0
frozenlist==1.3.1
fsspec==2022.7.1
future==0.18.2
g2p-en==2.1.0
gast==0.4.0
gdown==4.5.1
gensim==3.8.3
gitdb==4.0.9
GitPython==3.1.27
google-auth==2.11.0
google-auth-oauthlib==0.4.6
google-pasta==0.2.0
grpcio==1.47.0
gtn==0.0.0
h5py==3.7.0
huggingface-hub==0.8.1
humanfriendly==10.0
hydra-core==1.0.7
HyperPyYAML==1.0.1
idna @ file:///tmp/build/80754af9/idna_1637925883363/work
imageio==2.24.0
imageio-ffmpeg==0.4.8
importlib-metadata==4.12.0
importlib-resources==5.9.0
inflect==6.0.0
ipykernel==6.15.1
ipython==8.4.0
ipython-genutils==0.2.0
ipywidgets==8.0.1
isodate==0.6.1
jaconv==0.3
jamo==0.4.1
jedi==0.18.1
Jinja2==3.1.2
joblib==1.1.0
jsonschema==4.13.0
jupyter==1.0.0
jupyter-client==7.3.4
jupyter-console==6.4.4
jupyter-core==4.11.1
jupyterlab-pygments==0.2.2
jupyterlab-widgets==3.0.2
kaldiio==2.17.2
kaleido==0.2.1
# Editable Git install with no remote (kenlm==0.0.0)
-e /espnet/tools/kenlm
keras==2.9.0
Keras-Preprocessing==1.1.2
kiwisolver==1.4.4
language-tags==1.1.0
libclang==14.0.6
librosa==0.9.2
llvmlite==0.39.0
longformer @ git+https://github.com/roshansh-cmu/longformer.git@625355817c85cd35c87a9fe6f3e00f92c3b23caf
lxml==4.9.1
Markdown==3.4.1
MarkupSafe==2.1.1
matplotlib==3.5.3
matplotlib-inline==0.1.6
mediapipe==0.8.10.1
mir-eval==0.7
mistune==0.8.4
mkl-fft==1.3.1
mkl-random @ file:///tmp/build/80754af9/mkl_random_1626186064646/work
mkl-service==2.4.0
# Editable Git install with no remote (mmseg==1.3.0)
-e /espnet/tools/py3mmseg
Morfessor==2.0.6
moviepy==1.0.3
multidict==6.0.2
multiprocess==0.70.13
musdb==0.4.0
museval==0.4.0
nara-wpe==0.0.8
nbclient==0.6.6
nbconvert==6.5.3
nbformat==5.4.0
nest-asyncio==1.5.5
nlg-eval @ git+https://github.com/Maluuba/nlg-eval.git@7f7993035a2f4729a15d20040fd904933ea58767
nltk==3.7
nnmnkwii==0.1.1
notebook==6.4.12
numba==0.56.0
numpy==1.21.4
oauthlib==3.2.0
omegaconf==2.0.6
opt-einsum==3.3.0
p-tqdm==1.3.3
packaging==20.9
pandas==1.4.3
pandocfilters==1.5.0
parso==0.8.3
pathos==0.2.9
pathtools==0.1.2
pexpect==4.8.0
phonemizer==3.0
pickleshare==0.7.5
Pillow==9.2.0
pkgutil_resolve_name==1.3.10
plotly==5.10.0
pooch==1.6.0
portalocker==2.5.1
pox==0.3.1
ppft==1.7.6.5
proglog==0.1.10
prometheus-client==0.14.1
promise==2.3
prompt-toolkit==3.0.30
protobuf==3.19.4
psutil==5.9.1
ptyprocess==0.7.0
pure-eval==0.2.2
pyaml==21.10.1
pyarrow==9.0.0
pyasn1==0.4.8
pyasn1-modules==0.2.8
pycosat==0.6.3
pycparser @ file:///tmp/build/80754af9/pycparser_1636541352034/work
pydantic==1.9.2
Pygments==2.13.0
pyk4a==1.4.0
pympi-ling==1.70.2
# Editable Git install with no remote (pyopenjtalk==0.1.6+37046ef)
-e /espnet/tools/pyopenjtalk
pyOpenSSL @ file:///opt/conda/conda-bld/pyopenssl_1643788558760/work
pyparsing==3.0.9
pypinyin==0.44.0
pyrsistent==0.18.1
PySocks @ file:///tmp/build/80754af9/pysocks_1605305779399/work
pysptk==0.1.21
pystoi==0.3.3
python-dateutil==2.8.2
python-version==0.0.2
pytorch-ranger==0.1.1
pytorch-wpe==0.0.1
pytransform3d==1.14.0
pytz==2022.2.1
pyworld==0.3.0
PyYAML==6.0
pyzmq==23.2.1
qtconsole==5.3.1
QtPy==2.2.0
rdflib==6.2.0
regex==2022.8.17
requests @ file:///opt/conda/conda-bld/requests_1641824580448/work
requests-oauthlib==1.3.1
resampy==0.4.0
responses==0.18.0
rfc3986==1.5.0
rouge-score==0.1.2
rsa==4.9
ruamel-yaml-conda @ file:///tmp/build/80754af9/ruamel_yaml_1616016699510/work
ruamel.yaml==0.17.21
ruamel.yaml.clib==0.2.6
sacrebleu==2.2.0
scikit-learn==1.1.2
scipy==1.9.0
segments==2.2.1
Send2Trash==1.8.0
sentencepiece==0.1.97
sentry-sdk==1.9.5
setproctitle==1.3.2
shortuuid==1.0.9
simplejson==3.17.6
six @ file:///tmp/build/80754af9/six_1644875935023/work
smart-open==6.0.0
smmap==5.0.0
SoundFile==0.10.3.post1
soupsieve==2.3.2.post1
speechbrain==0.5.11
stack-data==0.4.0
stempeg==0.2.3
tabulate==0.8.10
tenacity==8.0.1
tensorboard==2.9.0
tensorboard-data-server==0.6.1
tensorboard-plugin-wit==1.8.1
tensorflow @ file:///tmp/tensorflow_pkg/tensorflow-2.9.1-cp38-cp38-linux_x86_64.whl
tensorflow-estimator==2.9.0
tensorflow-hub==0.12.0
tensorflow-io-gcs-filesystem==0.26.0
tensorflowjs==3.19.0
termcolor==1.1.0
terminado==0.15.0
tf-bodypix==0.4.1
tfjs-graph-converter==1.6.2
Theano==1.0.5
threadpoolctl==3.1.0
tinycss2==1.1.1
tokenizers==0.12.1
torch==1.11.0
torch-complex==0.4.3
torch-optimizer==0.3.0
torchaudio==0.11.0
tornado==6.2
tqdm @ file:///opt/conda/conda-bld/tqdm_1647339053476/work
traitlets==5.3.0
transformers==4.21.1
typeguard==2.13.3
typing_extensions @ file:///tmp/abs_ben9emwtky/croots/recipe/typing_extensions_1659638822008/work
Unidecode==1.3.4
uritemplate==4.1.1
urllib3==1.26.11
wandb==0.13.1
# Editable install with no version control (warprnnt-pytorch==0.1)
-e /espnet/tools/warp-transducer/pytorch_binding
wcwidth==0.2.5
webencodings==0.5.1
Werkzeug==2.2.2
widgetsnbextension==4.0.2
wrapt==1.14.1
xdg==5.1.1
xxhash==3.0.0
yarl==1.8.1
youtube-dl==2021.12.17
zipp==3.8.1
```
