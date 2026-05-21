# 桌面端内测 OTA 测试流程

## 目标

先跑通“公开 GitHub 仓库托管测试包 + 桌面端或 AI Agent 自动下载并覆盖安装”的内测流程。

此阶段不解决正式发布问题：

- 不强制签名和公证。
- 不强制 macOS / Windows 版本统一。
- 不做灰度发布。
- 不做复杂回滚。

## 发布流程

1. 在开发仓库打包桌面端。
2. 生成本次测试版本号和 Release Tag。
3. 计算安装包 `sha256` 和文件大小。
4. 上传 macOS arm64 和 Intel 两个 DMG 到 GitHub Release。
5. 更新 `manifests/latest-mac.json` 或 `manifests/latest-windows.json`。
6. 更新 Release 说明文档。
7. 测试机根据 manifest 下载并安装。

## macOS 测试安装流程

1. 根据本机架构下载对应 DMG。
2. 校验哈希。
3. 退出 `Magic.app`。
4. 挂载 DMG。
5. 复制 `Magic.app` 到 `/Applications/Magic.app`。
6. 卸载 DMG。
7. 启动新版本。

## 桌面端未来内置更新器

内测更新器可以先只支持以下状态：

- `idle`：未检查。
- `checking`：正在检查 manifest。
- `available`：发现新版本。
- `downloading`：正在下载。
- `ready`：下载完成，等待重启安装。
- `failed`：检查、下载或安装失败。

UI 不需要复杂，先能让测试人员知道“是否有新包、是否下载成功、是否需要重启”。

## 风险

- GitHub 国内下载速度不稳定。
- 未签名包可能被系统拦截。
- 覆盖安装时如果应用仍在运行，可能失败。
- 直接覆盖安装没有完整回滚能力。

这些风险在内测阶段可以接受，但正式版必须逐项补齐。
