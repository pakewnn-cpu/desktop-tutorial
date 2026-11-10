# 02 · 本地大模型 Ollama

**Ollama** 让你在**自己的电脑**上跑大模型，数据不出本机，离线也能用。
这是「本地优先」AI 环境的核心。

## 1. 安装

```bash
brew install ollama
brew services start ollama      # 设为开机自启，后台常驻
```

验证：打开浏览器访问 `http://localhost:11434`，能打开就是跑起来了。

## 2. 拉一个模型

模型要下载一次，之后本地复用。我常用 `qwen-codex:27b`（适合写代码）：

```bash
ollama pull qwen-codex:27b
ollama list                    # 看本地有哪些模型
```

> 27B 参数较大，吃内存。Mac 内存小的话，可换更轻的：
> `ollama pull qwen2.5:7b` 或 `ollama pull llama3.1:8b`。

## 3. 跑起来

```bash
# 一次性问答
ollama run qwen-codex:27b "用一句话解释什么是向量数据库"

# 进入对话模式（Ctrl+C 退出）
ollama run qwen-codex:27b
```

## 4. 让别的程序能调用它

Ollama 自带一个本地 HTTP 接口，地址是 `http://localhost:11434`。
后面 Codex 桌面版、各种 AI 工具，都能通过它调用本地模型，
**不用再把数据发给云厂商**。

## 小结

- ✅ 本地模型跑起来了，数据不出本机
- ✅ 知道接口地址 `http://localhost:11434`

下一步：[03 · 桌面 AI 助手 Codex](03-Codex桌面版.md)。
