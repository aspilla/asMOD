# asFixChat

Switch chat channels with the Tab key, display a window for copying URLs when clicked.

## Main Features

### Switch Chat Channels with Tab
![Tab Switching](https://github.com/aspilla/asMOD/blob/main/.Pictures/asFixChatTab.jpg?raw=true)
*   When you press the Tab key while typing in the chat, it switches the channel in the following order. For example, pressing Tab in 'Say' chat switches to 'Party' chat.
    *   **Say**: The default channel.
    *   **Party**: When in a party (but not a raid).
    *   **Raid**: When in a raid group.
    *   **Battleground**: When in a battleground or PvP zone.
    *   **Instance Chat**: When in a dungeon or instance group (not a raid/battleground).
    *   **Guild**: When not in any of the above and in a guild.
    *   **Whisper**: When there is a whisper target (switches to Battle.net whisper if the target is a Battle.net friend).

### URL Copy

![URL Copy](https://github.com/aspilla/asMOD/blob/main/.Pictures/asFixChat.jpg?raw=true)
*   **Automatic URL Highlighting**: Detects URL-like text patterns (e.g., `www.example.com`, `http://example.com`) in incoming chat messages.
*   **Clickable URL Links**: Converts detected URLs into clickable yellow hyperlinks directly within the chat window.
*   **Easy URL Copying**: Clicking on one of the highlighted URLs will:
    *   Automatically place the URL into the chat input box.
    *   Highlight the text in the input box.
    *   This allows you to easily copy the URL to your clipboard (using Ctrl+C or Cmd+C) for use outside the game.

---

# asFixChat

Tab 키로 채팅 채널 전환, URL 클릭시 복사 가능 창 표시

## 주요 기능

### Tab으로 채팅 채널 전환 
![URL](https://github.com/aspilla/asMOD/blob/main/.Pictures/asFixChatTab.jpg?raw=true)
*   채팅 입력 상황에서 Tab 키를 누를경우 다음의 순서로 채널을 전환, `일반 대화`에서 Tab을 누르면 `파티`로 전환 되는 방식
    *   **일반 대화**: 일반적인 기본값.
    *   **파티**: 파티에 속해 있는 경우 (공격대가 아닌 경우).
    *   **공격대**: 공격대 그룹에 속해 있는 경우.
    *   **전장**: 전장 또는 PvP 지역에 있는 경우.
    *   **인스턴스 대화**: 던전 또는 인스턴스 그룹에 있는 경우 (공격대/전장이 아닌 경우).
    *   **길드**: 위의 상황에 해당하지 않고 길드에 속해 있는 경우.
    *   **귓속말**: 귓속말 대상이 있는 경우 (Battlenet 귓속말 대상인 경우는 Battlenet 귓속말로 변경)
    

### URL Copy

![URL](https://github.com/aspilla/asMOD/blob/main/.Pictures/asFixChat.jpg?raw=true)
*   **자동 URL 강조**: 들어오는 채팅 메시지에서 URL과 유사한 텍스트 패턴(예: `www.example.com`, `http://example.com`)을 감지
*   **클릭 가능한 URL 링크**: 감지된 URL을 채팅 창 내에서 직접 클릭 가능한 노란색 하이퍼링크로 변환
*   **간편한 URL 복사**: 강조 표시된 URL 중 하나를 클릭하면:
    *   URL이 자동으로 채팅 입력창에 배치됩니다.
    *   입력창의 텍스트가 강조 표시됩니다.
    *   이를 통해 게임 외부에서 사용하기 위해 URL을 클립보드에 쉽게 복사(Ctrl+C 또는 Cmd+C 사용)할 수 있습니다.
