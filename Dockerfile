FROM python:3.11-slim

# Hugging Face runs containers as user 1000
RUN useradd -m -u 1000 user
WORKDIR /app

# CPU-only torch keeps the image much smaller
RUN pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=user . .
RUN pip install --no-cache-dir -e .

USER user
ENV HOME=/home/user HF_HOME=/home/user/.cache

EXPOSE 7860
CMD ["python", "-m", "esco_skill_extractor", "--host", "0.0.0.0", "--port", "7860", "--device", "cpu"]
