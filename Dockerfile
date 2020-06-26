FROM continuumio/miniconda3

RUN apt-get update && apt-get install -y tar git curl nano wget dialog net-tools build-essential
RUN conda update conda && conda create -n this_moon_cow_does_not_exist -c pytorch -c stanfordnlp -c conda-forge python=3.7

RUN [ "/bin/bash", "-c", "source activate this_moon_cow_does_not_exist \
  && conda install pytorch torchvision cpuonly -c pytorch \
  && conda install -c stanfordnlp stanza" ]

RUN [ "/bin/bash", "-c", "source activate this_moon_cow_does_not_exist && python -c 'import stanza; stanza.download(\"en\")'" ]

RUN mkdir -p /app/models
WORKDIR /app/models
RUN curl https://storage.googleapis.com/title-maker-pro-staging/forward-dictionary-model-v1.tar.gz | tar -xz
RUN curl https://storage.googleapis.com/title-maker-pro-staging/inverse-dictionary-model-v1.tar.gz | tar -xz
RUN curl -O https://storage.googleapis.com/this-word-does-not-exist-models/blacklist.pickle.gz && gunzip blacklist.pickle.gz

WORKDIR /app
COPY ./cpu_deploy_environment.yml .

RUN [ "/bin/bash", "-c", "source activate this_moon_cow_does_not_exist && conda env update -f cpu_deploy_environment.yml" ]
RUN [ "/bin/bash", "-c", "source activate this_moon_cow_does_not_exist && python -c 'from transformers import AutoTokenizer; AutoTokenizer.from_pretrained(\"gpt2\")'"]

COPY ./src src

ENTRYPOINT ["/bin/bash", "-c", "source activate this_moon_cow_does_not_exist && \
  PYTHONPATH=.:$PYTHONPATH \
  python src/main.py \
  --forward-model-path models/forward-dictionary-model-v1 \
  --inverse-model-path models/inverse-dictionary-model-v1 \
  --blacklist-path models/blacklist.pickle \
  2> /dev/null | grep '[WORD]' | sed 's/\\[WORD\\]//'"]