# asFixChat

asFixChat is a World of Warcraft addon that enhances chat usability through two main features: smarter chat channel cycling with the Tab key and improved handling of URLs shared in chat.

## Main Features

### 1. Smart Chat Channel Cycling (`asFixChatTab.lua`)

*   **Contextual Tab Cycling**: Modifies the default behavior of the Tab key in the chat input field.
*   Instead of cycling through all chat channels regardless of context, Tab now intelligently switches to the most relevant available channel based on your current situation:
    *   **Party**: If in a party (but not a raid).
    *   **Raid**: If in a raid group.
    *   **Battleground**: If in a battleground or PvP zone.
    *   **Guild**: If in a guild and none of the above apply.
    *   **Instance Chat**: If in a dungeon or instance group (and not raid/battleground).
    *   **Say**: As a general fallback.
*   This helps you quickly switch to the desired channel without tabbing through irrelevant ones (e.g., skipping "Party" if you're solo, or "Raid" if not in a raid).

### 2. Enhanced URL Handling (`asFixChatURL.lua`)

*   **Automatic URL Highlighting**: Detects text patterns resembling URLs (e.g., `www.example.com`, `http://example.com`) in incoming chat messages.
*   **Clickable URL Links**: Transforms detected URLs into clickable, yellow-colored hyperlinks directly within the chat window.
*   **Easy URL Copying**: When you click one of these highlighted URLs:
    *   The URL is automatically placed into your chat edit box.
    *   The text in the edit box is highlighted.
    *   This allows you to easily copy the URL to your clipboard (using Ctrl+C or Cmd+C) for use outside the game.
*   This feature simplifies sharing and accessing web links from chat.

## How to Use

*   **Smart Tab Cycling**: Simply press the Tab key while the chat edit box is active. It will cycle through the relevant channels.
*   **URL Handling**: This feature works automatically. URLs appearing in chat will be highlighted. Click them to populate the edit box for copying.

---

# asFixChat

asFixChat은 두 가지 주요 기능을 통해 채팅 사용성을 향상시키는 월드 오브 워크래프트 애드온입니다: Tab 키를 사용한 스마트한 채팅 채널 순환과 채팅에 공유된 URL 처리 개선입니다.

## 주요 기능

### 1. 스마트 채팅 채널 순환 (`asFixChatTab.lua`)

*   **상황별 Tab 순환**: 채팅 입력창에서 Tab 키의 기본 동작을 수정합니다.
*   상황에 관계없이 모든 채팅 채널을 순환하는 대신, Tab 키는 이제 현재 상황에 따라 가장 관련성 높은 사용 가능한 채널로 지능적으로 전환합니다:
    *   **파티**: 파티에 속해 있는 경우 (공격대가 아닌 경우).
    *   **공격대**: 공격대 그룹에 속해 있는 경우.
    *   **전장**: 전장 또는 PvP 지역에 있는 경우.
    *   **길드**: 위의 상황에 해당하지 않고 길드에 속해 있는 경우.
    *   **인스턴스 대화**: 던전 또는 인스턴스 그룹에 있는 경우 (공격대/전장이 아닌 경우).
    *   **일반 대화**: 일반적인 기본값.
*   이를 통해 관련 없는 채널(예: 혼자인 경우 "파티" 건너뛰기, 공격대가 아닌 경우 "공격대" 건너뛰기)을 거치지 않고 원하는 채널로 빠르게 전환할 수 있습니다.

### 2. 향상된 URL 처리 (`asFixChatURL.lua`)

*   **자동 URL 강조**: 들어오는 채팅 메시지에서 URL과 유사한 텍스트 패턴(예: `www.example.com`, `http://example.com`)을 감지합니다.
*   **클릭 가능한 URL 링크**: 감지된 URL을 채팅 창 내에서 직접 클릭 가능한 노란색 하이퍼링크로 변환합니다.
*   **간편한 URL 복사**: 강조 표시된 URL 중 하나를 클릭하면:
    *   URL이 자동으로 채팅 입력창에 배치됩니다.
    *   입력창의 텍스트가 강조 표시됩니다.
    *   이를 통해 게임 외부에서 사용하기 위해 URL을 클립보드에 쉽게 복사(Ctrl+C 또는 Cmd+C 사용)할 수 있습니다.
*   이 기능은 채팅에서 웹 링크를 공유하고 액세스하는 것을 단순화합니다.

## 사용 방법

*   **스마트 Tab 순환**: 채팅 입력창이 활성화된 상태에서 Tab 키를 누르기만 하면 됩니다. 관련 채널을 순환합니다.
*   **URL 처리**: 이 기능은 자동으로 작동합니다. 채팅에 나타나는 URL이 강조 표시됩니다. 복사를 위해 입력창에 해당 URL을 채우려면 클릭하십시오.
