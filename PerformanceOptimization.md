# 와우 설정 최적화 가이드

레이드/쐐기/필드 플레이시 품질도 챙기면서 블러드 구간/광 구간 FPS를 최소 60이상 확보하는것을 목표로 함

## 와우 추천 System
* 모니터 : 4K 이상, 120Hz, FSR 지원 (G-Sync 지원) 추천 : 와우는 애드온을 많이 사용하여 화면에 글씨가 많음, 4K 모니터 사용시 가시성에 큰 도움이 됨
* CPU : 와우는 CPU 자원이 중요하여 CPU 에 투자하는 것을 추전, 7800x3d 이상 추천
* 그래픽 카드 : 4K 모니터 사용시 Rx9070, 16GB VRAM 이상, QHD 모니터 사용시 12GB VRAM 이상 그래픽 카드 추천, 그래픽 카드는 CPU 성능 부족으로 100% 사용이 안되므로 와우만 한다면 너무 좋은 그래픽 카드는 필요 없음

## PC 환경 (개발자 시스템 및 설정)
* 7800x3d, Rx9070, DDR5 4800 32GB
* Windows 11 25H2 최신버전, Driver 최신
* BIOS 설정 : SMT 끄기 (CPU를 16코어가 아닌 8코어로만 씀), Single Core 성능 개선 목표
* AMD 설정 : FSR 외 모두 Off (FSR 지원 모니터가 아닌경우 Enhanced Sync 추천). 
![AMD setting](https://upload3.inven.co.kr/upload/2026/06/19/bbs/i1969365628.jpg?MW=800)

* Windows 그래픽 상세 설정 - 문제가 생긴다면 HAGS를 끌것, AutoHDR 설정은 OLED 모니터에서만 추천.
![Windows setting](https://upload3.inven.co.kr/upload/2026/06/19/bbs/i1328734615.jpg?MW=800)

* 모니터 최대 주사율 설정 - RTSS 설치후 async 설정, FPS 유지력이 가장 좋음.
![RTSS setting](https://upload3.inven.co.kr/upload/2026/06/19/bbs/i1629502312.jpg?MW=800)

## 게임 그래픽 설정
* CPU 많이 잡아먹는 항목 끔, 나머지는 최대로 설정
* 수직 동기화 : 끔 (FSR 사용)
* 계단 현상 방지 : 이미지 기반, CMAA or CMAA2 (중요)
* 그림자 품질 : 높음 (가장 효율적)
* 액체 세부묘사 : 좋음
* 입자 밀도 : 높음
* SSAO : 높음
* **깊이 기반 효과** : 사용 안함 (CPU 사용률 높으며 그래픽 효과가 적은 옵션)
* **계산 효과** : 낮음 or 사용 안함 (CPU 사용률 높으며 그래픽 효과가 적은 옵션)
* 주문 밀도 : 필수 (다른 케릭터의 마법 효과를 줄여 복잡함을 줄여 준다, 탱커는 낮음 고려 필요)
* 원거리 사물표현 : 7 (가시거리는 10, 지면 사물 10)
* 광선 추적 그림자 : 사용 안함 (AMD 그래픽 카드중 게임중 멈추는 증상이 있으면 끌것)
* VRS 모드 : 사용 안함 (좋은거 같지만 실 차이 없고, 화면이 미세하게 변경되는 증상 있음)
* FPS 설정은 모두 끔 (RTSS 로 설정 or Driver 에서 설정하는 방식이 좋음)

<iframe width="560" height="315" src="https://www.youtube.com/embed/dVZ1apjDg1s?si=ViT6zcc7t_PreT-f" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 게임 사운드 설정
* 사운드 채널은 32 (사운드 128채널 설정시 CPU 자원 소비, 일부 애드온 음성안내가 끈기거나 안나온다면 64설정 추천)
* 울림 효과 사용: 끔 (CPU 사용함)

## 애드온 관련
* 애드온은 게임 FPS 에 큰 영향을 미침
* `esc > 애드온` 에서 `평균 CPU 사용률`을 `1%` 수준으로 관리할 것을 추천 
* `최대 사용률`은 애드온이 구동 시작하면서 설정하는 경우 다소 높에 올라갈 수 있음

## 공찾 25인 4k 영상
* 최소 FPS 105 정도로 꾸준하게 117확보

<iframe width="560" height="315" src="https://www.youtube.com/embed/8V7uoOiK0ok?si=n52daSb6_Z6KUa-5" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 참고 자료
* [AMD PC 최적화 설정 관련](https://www.reddit.com/r/AMDHelp/comments/1lnxb8o/ultimate_amd_performance_fix_guide_stop_lag_fps/?share_id=siID34gkiYvcxnC8WBKZe&utm_content=1&utm_medium=android_app&utm_name=androidcss&utm_source=share&utm_term=1)
* [RTSS 설정 관련](https://www.youtube.com/watch?v=WZJbTuBeVzE&si=AqgVnkDFQgKrZs2I)
* [와우 그래픽 설정 관련](https://www.youtube.com/watch?v=7v2tDNQc2Uo)
* [사운드 채널 관련](https://youtube.com/watch?v=lZRBJ7VJXgM&si=oY9zuQpUZodQ9jpm)
* [FHD, UHD 레이드 FPS 비교](https://www.inven.co.kr/board/wow/4739/253503)
* [4K, Raid GPU 사용률 관련](https://www.inven.co.kr/board/wow/4739/239906)
