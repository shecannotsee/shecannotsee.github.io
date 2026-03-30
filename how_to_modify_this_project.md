---
layout: page
title: how to modify this project
---

这个文档对应的项目目录是：

```text
/home/shecannotsee/Desktop/shecannotsee.github.io
```

线上仓库与页面分别是：

- 仓库：<https://github.com/shecannotsee/shecannotsee.github.io>
- 页面：<https://shecannotsee.github.io>

## 现在这个站点是怎么组织的

现在首页由两部分组成：

1. 固定信息：`_data/site_profile.yml`
2. 文章内容：`_posts/`

你平时最常改的地方通常是：

- 改首页文案、导航、中英文内容、联系方式：`_data/site_profile.yml`
- 改深浅色和整体样式：`assets/css/main.scss`
- 改主题和语言切换逻辑：`assets/js/site_preferences.js`
- 改首页结构：`_layouts/home.html`
- 改独立页面：`about_me.md`
- 新增文章：`_posts/`

## 最重要的文件

### 1. 站点配置

文件：`_config.yml`

这里控制：

- `title`
- `author`
- `email`
- `url`
- `description`
- 日期格式 `theme_config.date_format`

### 2. 首页数据

文件：`_data/site_profile.yml`

这个文件控制：

- 导航文字：`ui.navigation`
- 深浅色按钮和语言按钮文字：`ui.controls`
- 首页 section 标题：`ui.sections`
- 公共链接和页脚文字：`ui.links`、`ui.copy`
- About 内容：`hero`
- Projects 内容：`projects`
- 联系方式：`contacts`

### 3. 主题和语言切换

相关文件：

- `assets/js/site_preferences.js`
- `assets/css/main.scss`
- `_includes/site_nav.html`

说明：

- 主题切换会在 `light` 和 `dark` 之间切换
- 语言切换会在 `zh` 和 `en` 之间切换
- 这两个设置会写入浏览器的 `localStorage`
- 历史文章正文不会自动翻译，语言切换主要作用在首页和公共 UI

## 如何修改首页内容

### 修改导航

```yaml
ui:
  navigation:
    - title:
        zh: /主页
        en: /home
      url: /
```

### 修改按钮文案

```yaml
ui:
  controls:
    theme_light:
      zh: 浅色
      en: light
    theme_dark:
      zh: 深色
      en: dark
    lang_zh:
      zh: 中文
      en: 中文
    lang_en:
      zh: EN
      en: EN
```

### 修改 About

```yaml
hero:
  image: /logo.png
  image_alt: shecannotsee
  intro:
    zh: >
      这里写中文介绍。
    en: >
      Write the English introduction here.
  facts:
    - zh: 这里写中文要点
      en: Write the English point here
```

### 修改 Projects

```yaml
projects:
  intro:
    zh: 我长期维护并持续实验下面这些项目和方向：
    en: These are the projects I keep maintaining or exploring.
  groups:
    - title:
        zh: 基础库与工具
        en: Libraries & tools
      items:
        - name: sheBase64
          description:
            zh: 中文简介
            en: English description
          url: https://github.com/shecannotsee/sheBase64
```

### 修改联系方式

```yaml
contacts:
  items:
    - prefix:
        zh: github.com/
        en: github.com/
      value:
        zh: shecannotsee
        en: shecannotsee
      url: https://github.com/shecannotsee
```

## 如何新增文章

文章目录：`_posts/`

文件名格式：

```text
YYYY-MM-DD-title.md
```

例如：

```text
2026-03-30-my_new_post.md
```

头部最少写成这样：

```md
---
layout: post
categories: blog
title: 我的新文章
---
```

新文章会自动进入首页的 `Latest Posts` 和总归档页。

## 如何新增独立页面

你可以照着 `about_me.md` 新建一个页面：

```md
---
layout: page
title: my new page
---

这里写正文
```

然后再到 `_data/site_profile.yml` 的 `ui.navigation` 里补一个入口。

## 样式入口

文件：`assets/css/main.scss`

这里控制：

- 颜色变量
- 深浅色主题变量
- 中英文显示切换规则
- 顶部导航和按钮样式
- 首页排版
- 文章页和普通页面排版
- 手机端适配

如果你只改颜色，优先改文件顶部的变量区。

## 本地预览

在项目目录 `/home/shecannotsee/Desktop/shecannotsee.github.io` 下执行：

```bash
bundle exec jekyll serve
```

打开：

```text
http://127.0.0.1:4000
```

如果只是检查构建：

```bash
bundle exec jekyll build
```

## 发布

这是 GitHub Pages 仓库，通常 push 到默认分支后会自动更新。

常见流程：

```bash
git status
git add .
git commit -m "feat: update homepage"
git push
```
