#!/usr/bin/env bash
#
# setup.sh — 一键搭建 Mac AI 桌面环境
#
# 它会依次完成：
#   1. 检查是否在 macOS 上
#   2. 安装 Homebrew（如果还没有）
#   3. 安装 Ollama 并设为开机自启
#   4. 拉取一个本地大模型
#   5. 配置 git 身份（可选）
#
# 用法：
#   bash scripts/setup.sh
#
# 说明：每一步都会先检查「是否已经装好」，所以重复运行是安全的。
# 想换模型： MODEL=llama3.1:8b bash scripts/setup.sh

set -euo pipefail

# ---------- 小工具：统一输出颜色 ----------
info() { printf '\033[1;34m[信息]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[完成]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[跳过]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[错误]\033[0m %s\n' "$*" >&2; }

# 要拉取的模型，可在运行前用环境变量覆盖
MODEL="${MODEL:-qwen-codex:27b}"

# ---------- 1. 检查系统 ----------
if [ "$(uname)" != "Darwin" ]; then
  fail "本脚本目前只支持 macOS（检测到：$(uname)）。"
  exit 1
fi
ok "系统是 macOS，继续。"

# ---------- 2. 安装 Homebrew ----------
if command -v brew >/dev/null 2>&1; then
  ok "Homebrew 已安装。"
else
  info "开始安装 Homebrew（这一步会要密码，输入后回车）……"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon 的 brew 在 /opt/homebrew，Intel 在 /usr/local
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  ok "Homebrew 安装完成。"
fi

# ---------- 3. 安装 Ollama ----------
if command -v ollama >/dev/null 2>&1; then
  ok "Ollama 已安装。"
else
  info "开始安装 Ollama……"
  brew install ollama
  ok "Ollama 安装完成。"
fi

# 设为后台常驻（已开过也不会报错）
info "把 Ollama 设为后台常驻……"
brew services start ollama || warn "brew services 启动失败，可稍后手动运行：ollama serve"

# ---------- 4. 拉取模型 ----------
if ollama list 2>/dev/null | grep -q "^${MODEL}"; then
  ok "模型 ${MODEL} 已存在，跳过下载。"
else
  info "开始下载模型 ${MODEL}（首次较大，耐心等）……"
  ollama pull "${MODEL}"
  ok "模型 ${MODEL} 下载完成。"
fi

# ---------- 5. 配置 git 身份（可选） ----------
if git config --global user.name >/dev/null 2>&1; then
  ok "git 身份已配置，跳过。"
else
  info "配置 git 身份（绿格子认的是提交者，一定要配）……"
  read -r -p "  你的 GitHub 用户名（回车默认 pakewnn-cpu）：" name
  name="${name:-pakewnn-cpu}"
  read -r -p "  你的邮箱（回车默认 your-email@example.com）：" email
  email="${email:-your-email@example.com}"
  git config --global user.name  "${name}"
  git config --global user.email "${email}"
  ok "git 身份已写入。"
fi

# ---------- 收尾 ----------
echo
ok "全部完成！"
echo "  本地模型接口：http://localhost:11434"
echo "  试一下：      ollama run ${MODEL} \"你好\""
echo "  下一步：      打开 Codex 桌面版，把模型来源指向 http://localhost:11434"
