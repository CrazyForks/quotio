# Changelog

All notable changes to Quotio will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-12-26

### Added

- **Multi-Provider Support**: Connect accounts from Gemini, Claude, OpenAI Codex, Qwen, Vertex AI, iFlow, Antigravity, Kiro, and GitHub Copilot
- **Real-time Dashboard**: Monitor request traffic, token usage, and success rates live
- **Smart Quota Management**: Visual quota tracking per account with automatic failover strategies
- **Menu Bar Integration**: Quick access to server status, quota overview, and controls from menu bar
  - Custom provider icons display in menu bar
  - Combined provider status indicators
- **Quota Display Improvements**:
  - GitHub Copilot quota display (Chat, Completions, Premium)
  - Antigravity models grouped into Claude, Gemini Pro, and Gemini Flash categories
  - Collapsible model groups with detailed breakdown
  - High precision percentage display
- **Agent Configuration**: Auto-detect and configure AI coding tools (Claude Code, OpenCode, Gemini CLI, Amp CLI, Codex CLI, Factory Droid)
- **API Key Management**: Generate and manage API keys for local proxy
- **System Notifications**: Alerts for low quotas, account cooling periods, and proxy status
- **Settings**:
  - Logging to file toggle with dynamic sidebar visibility
  - Routing strategy configuration (Round Robin / Fill First)
  - Auto-start proxy option
- **About Screen**: App info with donation options (Momo, Bank QR codes)
- **Sparkle Auto-Update**: Automatic update checking and installation
- **Bilingual Support**: English and Vietnamese localization

### Fixed

- Sheet state not resetting when reopening
- Agent configurations persisting correctly on navigation
- CLI agent configurations matching CLIProxyAPI documentation

## [0.0.1] - 2025-12-20

### Added

- Initial release
- Basic proxy management
- Provider authentication via OAuth
- Simple quota display
