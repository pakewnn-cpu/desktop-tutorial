# 如何参与本项目（CONTRIBUTING）

欢迎参与！这是一个自学者的教程仓库，目标是「把过程公开、让教程真的能跑」。
参与前请花 1 分钟读完这里——它能让你的贡献更快被合并，也保护仓库安全。

## 贡献前

1. **先看 [`docs/运营规范.md`](docs/运营规范.md)**：那是本仓库的底线规矩，包含禁止事项。
2. 在动手前，**先开一个 Issue** 说明你想改什么，和我确认方向，避免白做。
3. 搜索现有 Issue，避免重复提问或重复劳动。

## 提 PR 的规矩

- **一次 PR 只解决一个问题**，不夹带无关改动。
- 提交信息（commit message）统一格式：`feat:` / `docs:` / `fix:` / `chore:` 开头，写清改了什么。
  - 例：`docs: 补充 02 篇本地模型的内存要求`
- 重要功能走 PR 评审，`main` 分支始终保证可运行。
- PR 描述里写清：**改了什么、为什么改、怎么验证**。

## 安全红线（务必遵守）

- **不要**提交密钥、数据库信息、客户数据、内部涉密文档。
- **不要**在仓库里写明文密码 / Token / 私钥。
- 不确定某个文件该不该传，先问。

## 怎么开始

```bash
git clone https://github.com/pakewnn-cpu/desktop-tutorial.git
cd desktop-tutorial
git checkout -b feat/你的改动名   # 从 main 拉一个功能分支
# 改完、提交、推送分支，然后在 GitHub 上开 PR
git push origin feat/你的改动名
```

## 有问题？

在 [Issues](https://github.com/pakewnn-cpu/desktop-tutorial/issues) 里留言，带上**复现步骤 + 版本信息**，我会尽快回复。
