# 1. 选用您需要的基础镜像（根据需要选择 CPU 或 GPU 镜像）
FROM pytorch/pytorch:2.4.0-cuda12.1-cudnn9-runtime

# 2. 【关键】创建 Hugging Face 专用的非 root 用户（UID 必须是 1000）
RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

# 3. 设置工作目录在用户家目录下
WORKDIR $HOME/app

# 4. 配置 Hugging Face 国内镜像源（虽然 HF 官方服务器在海外，但配置镜像源可作为备用）
ENV HF_ENDPOINT=https://hf-mirror.com

# 5. 复制项目文件，并确保新用户拥有权限
COPY --chown=user . $HOME/app

# 6. 安装依赖（加 --user 参数）
RUN pip install --no-cache-dir --user -r requirements.txt

# 7. 【关键】Hugging Face 强制规定容器内部必须暴露 7860 端口
EXPOSE 7860

# 8. 启动命令（请确保您的 app.py 内部监听的 host 为 "0.0.0.0"，port 为 7860）
CMD ["python", "app.py"]
