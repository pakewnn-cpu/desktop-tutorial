# 🖥️ desktop-tutorial · 我的 Mac AI 桌面环境搭建手册

> 一个自学开发者，从零在 macOS 上搭出一套「桌面 AI 助手 + 本地大模型」的完整环境，并把每一步都写成能直接照做的教程。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![CI](https://github.com/pakewnn-cpu/desktop-tutorial/actions/workflows/ci.yml/badge.svg)](.github/workflows/ci.yml)

---

## 这是什么

这是一份**实战型教程**：记录我如何在自己的 Mac 上，用开源工具搭出一套可以日常使用的 AI 工作环境——包括本地跑大模型（Ollama）、桌面 AI 助手（Codex 桌面版）、以及一套能自动检查的 CI 流程。

它不是「看一遍就忘」的文章，而是**能跑起来的东西**：照着 `scripts/setup.sh` 走一遍，就能复现我的环境。

## 目录

| 文档 | 内容 |
| --- | --- |
| [01 · 环境准备](docs/01-环境准备.md) | 装好 git、终端、代理，打好地基 |
| [02 · 本地大模型 Ollama](docs/02-Ollama本地模型.md) | 在本地跑大模型，数据不出本机 |
| [03 · 桌面 AI 助手 Codex](docs/03-Codex桌面版.md) | 装桌面版、接本地模型、日常用法 |
| [04 · 我的 AI 工作流](docs/04-我的AI工作流.md) | 把工具串起来，形成自己的节奏 |
| [30 天 GitHub 运营计划](docs/30天GitHub运营计划.md) | 一个自学者的 30 天成长路线 |
| [05 · 常见问题 FAQ](docs/05-常见问题.md) | 搭建中真实遇到的报错与解决办法 |
| [运营规范](docs/运营规范.md) | 经营本仓库的底线与规矩（含红线） |
| [如何参与 CONTRIBUTING](CONTRIBUTING.md) | 想贡献代码 / 文档，先读这里 |

## 快速开始

```bash
# 1. 克隆本仓库
git clone https://github.com/pakewnn-cpu/desktop-tutorial.git
cd desktop-tutorial

# 2. 一键搭建（macOS）
bash scripts/setup.sh
```

> 详细步骤见 [`docs/`](docs/)，每个文件都写清了「为什么这么做」，不只是「怎么做」。

## 环境依赖

在跑 `setup.sh` 之前，先确认机器满足这些条件：

| 依赖 | 要求 | 说明 |
| --- | --- | --- |
| 操作系统 | macOS（Apple Silicon / Intel） | 本教程以 macOS 为准 |
| 内存 | 建议 16GB 及以上 | 本地大模型较吃内存；内存小可换更小模型 |
| Homebrew | 未装会自动装 | 包管理器，`setup.sh` 会检测并安装 |
| git | 任意新版 | 版本管理 + 绿格子认的是提交者，务必配好身份 |
| Ollama | 脚本自动装 | 本地跑大模型 |
| 代理（可选） | 国内直连慢时开启 | 本教程用「夜煞云」，默认端口 `7892` |

> 内存不够怎么办：换更小模型，`MODEL=qwen2.5:7b bash scripts/setup.sh`。

## 你会得到什么

- ✅ 一套**本地优先**的 AI 环境（隐私、离线、不依赖云）
- ✅ 可复现的**一键安装脚本**
- ✅ 一个**自动检查**的 CI 流程（每次提交自动跑）
- ✅ 一份**给自学者**的成长计划

## 常见问题（FAQ）

搭建中常见的报错和解决办法，已整理进 [`docs/05-常见问题.md`](docs/05-常见问题.md)。
几个高频问题：

- **国内下载慢 / 失败**：开代理，让 git 走 `127.0.0.1:7892`（详见 05 篇）。
- **本地模型内存不够**：换更小模型，`MODEL=qwen2.5:7b bash scripts/setup.sh`。
- **桌面版连不上本地模型**：确认 Ollama 已启动、模型已拉取、来源指向 `http://localhost:11434`。

> 经营本仓库的规矩（含安全红线）见 [`docs/运营规范.md`](docs/运营规范.md)；想贡献代码先看 [`CONTRIBUTING.md`](CONTRIBUTING.md)。

## 关于作者

自学成才的独立开发者，喜欢把「折腾出来的东西」写成别人能直接用的教程。
这个仓库就是「把过程公开」的一部分——用 GitHub 上的每一次提交，证明自己在持续学习、持续动手。

📮 想合作 / 交流：在 [Issues](https://github.com/pakewnn-cpu/desktop-tutorial/issues) 里留言，
或发邮件到 `Pakewnn@gmail.com`。

## 许可证

[MIT](LICENSE) —— 随便用，随意改，保留署名即可。
