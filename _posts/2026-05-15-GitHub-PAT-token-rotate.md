---
layout: post
categories: blog
title: GitHub Personal Access Token 失效与重新生成记录
date: 2026-05-15 17:33:18 +0800
---

# 背景

有一个很早之前创建的 GitHub key 存在泄露风险。这个 key 平时用于通过 HTTPS 执行 `git push`。

最开始需要先判断这个 key 到底是什么：

- 如果在 `Settings` -> `SSH and GPG keys` 里能看到，一般是 SSH key。
- 如果是 `ghp_` 开头，一般是 GitHub Personal Access Token classic。
- 如果是 GitHub 开启双重验证时保存的一组备用码，则是 2FA recovery codes。
- 如果在 `Security keys` 或 `Passkeys` 中出现，则是 WebAuthn/Passkey 类型的二次验证凭据。

这次实际遇到的是 `ghp_` 开头的 token，所以它是 Personal Access Token，不是 SSH key。

# 先处理 2FA recovery codes

如果旧的恢复码图片或文件也存在泄露风险，可以先更新恢复码：

1. 打开 GitHub `Settings`。
2. 进入 `Password and authentication`。
3. 找到 `Recovery codes`。
4. 选择重新生成 recovery codes。

重新生成之后，旧 recovery codes 会失效。这个操作只影响账号恢复码，不会影响 `git push` 用的 token。

# 删除旧 token

`ghp_` 开头的旧 token 需要在 classic token 页面删除：

1. 打开 GitHub `Settings`。
2. 进入 `Developer settings`。
3. 进入 `Personal access tokens`。
4. 打开 `Tokens (classic)`。
5. 找到旧 token。
6. 删除该 token。

删除之后，旧 token 立即失效。

# 验证旧 token 已失效

可以克隆一个自己的仓库，然后创建一个空提交用于测试：

```bash
git clone https://github.com/shecannotsee/she_gtestx.git
cd she_gtestx
git commit --allow-empty -m "test: empty commit for push verification"
git push
```

如果旧 token 已失效，使用旧 token push 时会出现类似错误：

```text
remote: Invalid username or token. Password authentication is not supported for Git operations.
fatal: Authentication failed for 'https://github.com/shecannotsee/she_gtestx.git/'
```

这说明旧 token 已经不能再用于 GitHub HTTPS push。

# 创建新 token

推荐创建 fine-grained personal access token，而不是 classic token。fine-grained token 可以限制仓库范围和权限，更适合长期使用。

创建路径：

1. 打开 GitHub `Settings`。
2. 进入 `Developer settings`。
3. 进入 `Personal access tokens`。
4. 打开 `Fine-grained tokens`。
5. 选择 `Generate new token`。

配置建议：

- `Expiration`：选择 `Custom`，设置明确过期时间。
- `Repository access`：如果只用于单个仓库，选择指定仓库；如果确实需要管理所有仓库，可以选择 `All repositories`。
- `Permissions`：只做普通 `git push` 时，选择 `Repository permissions` 里的 `Contents: Read and write`。
- `Metadata: Read-only` 是 GitHub 自动带的权限，保留即可。

普通代码提交、README、源码文件等 push 场景，`Contents: Read and write` 已经足够。

如果以后需要修改 `.github/workflows/*.yml` 这类 GitHub Actions 工作流文件，可能还需要额外开启 `Workflows: Read and write`。

# 使用新 token push

执行：

```bash
git push
```

GitHub HTTPS 鉴权时：

```text
Username for 'https://github.com':
```

这里填写 GitHub 用户名，例如：

```text
shecannotsee
```

`Password` 位置填写新生成的 personal access token，不是 GitHub 登录密码。

# 结论

本次处理顺序：

1. 更新 2FA recovery codes，让旧恢复码失效。
2. 确认 `ghp_` 开头的 key 是 GitHub Personal Access Token classic。
3. 在 `Tokens (classic)` 中删除旧 token。
4. 通过测试仓库和空提交验证旧 token 已经不能 push。
5. 创建新的 fine-grained token。
6. 设置 `Contents: Read and write` 和默认的 `Metadata: Read-only`。
7. 使用 GitHub 用户名加新 token 完成 HTTPS push。

token 只负责鉴权，不会主动删除仓库中的历史提交。git 历史是否被重写，取决于执行的 git 命令，而不是 token 本身。
