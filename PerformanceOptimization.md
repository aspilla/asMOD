# WoW Graphics/Sound Optimization Settings Guide (Targeting Minimum FPS Improvement)

## Goal
* The primary goal is to maintain visual quality during Raid/Mythic+/Outdoor gameplay while securing a minimum of 60+ FPS during Bloodlust/Burst and heavy AoE (Adds) phases.
* This guide targets high-end PCs equipped with CPUs having 16 or more cores and GPUs with 12GB or more VRAM.
* Achieving a stable average of 120 FPS with a minimum of 60 FPS delivers a vastly superior gaming experience compared to an inconsistent fluctuation of 300 maximum FPS dropping down to 20 minimum FPS.
* Since WoW's minimum FPS drops are mostly caused by CPU bottlenecks, this guide focuses heavily on minimizing CPU overhead.
* If your PC specs are lower, you can lower other options in addition to the recommended disabled ("Off") settings below. If you have plenty of room in your minimum framerate, you can raise the options.
* While frame generation technologies like AFMF (AMD Fluid Motion Frames) can boost minimum FPS, establishing a baseline of at least 60 native FPS is still required, so frame generation is not covered separately here.

## PC Environment (For Reference, Developer System Specs & Settings)
* **Specs**: Ryzen 7 7800X3D, RX 9070, DDR5 4800MHz 32GB
* **OS/Drivers**: Windows 11 25H2 (Latest Version), Latest Graphics Drivers
* **BIOS Settings**: **SMT (Simultaneous Multithreading) Disabled**. This forces the CPU to utilize 8 physical cores instead of 16 logical threads. While this yields a 3–4% improvement in minimum FPS stability, the difference is minor. If you use your PC for multi-threaded productivity workloads or have a CPU with fewer than 16 cores, keeping SMT ON is recommended.
* **AMD Radeon Software**: Turn **Off** all features except **FSR** (If your monitor does not support FSR, *Enhanced Sync* is recommended instead. For Nvidia users, turning off most optional control panel features should yield a similar stable result).
![AMD setting](https://upload3.inven.co.kr/upload/2026/06/19/bbs/i1969365628.jpg?MW=800)

* **Windows Advanced Graphics Settings**: If you experience stability issues, turn **Off** HAGS (Hardware-Accelerated GPU Scheduling). AutoHDR is only recommended if you are using an OLED monitor.
![Windows setting](https://upload3.inven.co.kr/upload/2026/06/19/bbs/i1328734615.jpg?MW=800)

* **Monitor Max Refresh Rate Configuration**: Install RTSS (RivaTuner Statistics Server) and configure **Async** frame-limiting settings for the absolute best frame-time consistency and FPS stability. Alternatively, you can limit the maximum refresh rate directly within the GPU Driver.
![RTSS setting](https://upload3.inven.co.kr/upload/2026/06/19/bbs/i1629502312.jpg?MW=800)

## In-Game Graphics Settings
* **General Rule**: Disable **critical** options that cause heavy CPU usage, and set the remaining pure GPU-bound settings to maximum/optimal values. (Lower-spec setups will need further compromises outside of the disabled options).
* **Vertical Sync**: Disabled (Handled via FSR).
* **Anti-Aliasing (CRITICAL)**: Image-based, **CMAA or CMAA2** (Offers the best performance-to-visual ratio).
* **Shadow Quality**: High (The most cost-effective performance-to-visual ratio. Lowering this further increases FPS).
* **Liquid Detail**: Good (Balanced for visual quality. Lowering this further increases FPS).
* **Particle Density**: High (Balanced for visual quality. Lowering this further increases FPS).
* **SSAO**: High (Balanced for visual quality. Lowering this further increases FPS).
* **Depth Effects (CRITICAL)**: **Disabled** (High CPU usage with negligible visual return).
* **Compute Effects (CRITICAL)**: **Low or Disabled** (High CPU usage with negligible visual return).
* **Spell Density (CRITICAL)**: **Essential** (Minimizes other players' spell visual effects to reduce clutter. Tanks may consider dropping this to Low).
* **View Distance**: 7 (Environment Detail: 10, Ground Clutter: 10. Does not cause a significant FPS variance in raid instances, balanced for visual quality).
* **Ray Traced Shadows (CRITICAL)**: **Disabled** (Consumes CPU resources. Turn this off immediately if you experience random game crashes/freezes on AMD graphics cards).
* **VRS (Variable Rate Shading) Mode**: **Disabled** (Provides no real-world performance gain and causes subtle, distracting screen flickering/shimmering).
* **In-Game Max FPS Toggles (CRITICAL)**: **Disabled** (It is highly recommended to limit frame rates via RTSS or the GPU Driver level instead).
<iframe width="560" height="315" src="https://www.youtube.com/embed/up337gU1C8g?si=VsxNCm842wlIb2pz" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## In-Game Sound Settings
* **Sound Channels (CRITICAL)**: **32** (Setting this to 128 channels heavily drains CPU resources. If certain addon audio/voice alerts clip or fail to trigger, bump this up to 64).
* **Enable Reverb (CRITICAL)**: **Disabled** (Consumes unnecessary CPU cycles).

## Addon Optimization
* Addons have a massive, direct impact on game minimum FPS.
* Open `ESC > AddOns` and actively manage your suite to keep the **Average CPU Usage** around **1%**.
* *Note*: **Peak Usage** can spike high momentarily when addons initialize their databases upon loading, which is normal behavior.

## LFR 25-Man 4K Gameplay Video
* Minimum FPS holds steadily around 105, with a consistent average of 117 FPS.
<iframe width="560" height="315" src="https://www.youtube.com/embed/8V7uoOiK0ok?si=mtm5CKDubQ65NoE1" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Heroic 30-Man 4K Gameplay Video
* Securing 60+ FPS stably even during Bloodlust burst phases, with a momentary minimum of 50 FPS during heavy AoE phases.
<iframe width="560" height="315" src="https://www.youtube.com/embed/X4GBWola1F0?si=flJ-I2Jr8w5_LUD3" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## References
* [AMD PC Optimization & Performance Fix Guide](https://www.reddit.com/r/AMDHelp/comments/1lnxb8o/ultimate_amd_performance_fix_guide_stop_lag_fps/?share_id=siID34gkiYvcxnC8WBKZe&utm_content=1&utm_medium=android_app&utm_name=androidcss&utm_source=share&utm_term=1)
* [RTSS Setup and Configuration Guide](https://www.youtube.com/watch?v=WZJbTuBeVzE&si=AqgVnkDFQgKrZs2I)
* [WoW In-Depth Graphics Settings Guide](https://www.youtube.com/watch?v=7v2tDNQc2Uo)
* [Sound Channels & CPU Overhead Analysis](https://youtube.com/watch?v=lZRBJ7VJXgM&si=oY9zuQpUZodQ9jpm)
* [FHD vs UHD Raid FPS Benchmark Comparison](https://www.inven.co.kr/board/wow/4739/253503)
* [4K Raid GPU Utilization & Scaling Report](https://www.inven.co.kr/board/wow/4739/239906)

## Recommended Specs for WoW (For Reference)
* **Monitor**: 4K or higher, 120Hz, FSR supported (G-Sync compatible) is recommended. WoW heavily relies on addons, resulting in a text-dense screen. Utilizing a 4K monitor vastly improves overall visibility and text clarity.
* **CPU**: WoW heavily depends on CPU single-core throughput. It is highly recommended to prioritize investing in the CPU—AMD Ryzen 7 7800X3D or higher is recommended.
* **Graphics Card**: For a 4K monitor, an RX 9070 with 16GB VRAM or higher is recommended. For QHD, 12GB VRAM or higher is recommended. Since WoW is frequently bottlenecked by CPU resources, the GPU rarely hits 100% utilization. If you primarily play WoW, over-specifying the graphics card is unnecessary.
---

# 와우 그래픽/사운드 설정 팁 (최소 FPS 개선 목표)

## 목표
* 레이드/쐐기/필드에서 그래픽 품질을 챙기면서 블러드 구간/광 구간 FPS(초당 게임 주사율)를 최소 60이상 확보하는것을 목표로 함.
* 16코어 이상, VRAM 12GB 이상 상급 PC를 대상으로 함.
* 최대 FPS 300, 최소 FPS 20 보다, 평균 FPS 120, 최소 FPS 60이 더 좋은 게임 경험을 제공함.
* 와우 최소 FPS는 대부분 CPU 병목에서 발생 하는 만큼, CPU 병목을 최소화는 방법임.
* 사양이 낮은 경우에는 아래 끔 항목외 옵션을 낮추면 됨, 최소 프레임에 여유가 있다면 옵션을 상향하면 됨.
* AFMF(AMD Fruid Motion Frame)등 프레임 생성 기술로 최소 FPS 를 상승 시킬 수 있으나, 이 또한 최소 60 FPS 확보는 필요해서 별도로 다루지 않음.

## PC 환경 (참고, 개발자 시스템 사향 및 설정)
* 7800x3d, Rx9070, DDR5 4800 32GB.
* Windows 11 25H2 최신버전, Driver 최신.
* BIOS 설정 : SMT 끄기 (CPU를 16코어가 아닌 8코어로만 씀), 최소 FPS 관점 3~4% 개선 효과 있으나 큰 차이 아니므로 다른 업무를 보거나, 16코어 미만은 SMT ON 추천.
* AMD 설정 : FSR 외 모두 Off (FSR 지원 모니터가 아닌경우 Enhanced Sync 추천, Nvidia의 경우 대부분의 Option는 Off 해도 무리 없을것으로 판단 됨)
![AMD setting](https://upload3.inven.co.kr/upload/2026/06/19/bbs/i1969365628.jpg?MW=800)

* Windows 그래픽 상세 설정 - 문제가 생긴다면 HAGS를 끌것, AutoHDR 설정은 OLED 모니터에서만 추천.
![Windows setting](https://upload3.inven.co.kr/upload/2026/06/19/bbs/i1328734615.jpg?MW=800)

* 모니터 최대 주사율 설정 - RTSS 설치후 async 설정, FPS 유지력이 가장 좋음, Driver에서 최대 주사율 설정하는 방법도 있음.
![RTSS setting](https://upload3.inven.co.kr/upload/2026/06/19/bbs/i1629502312.jpg?MW=800)

## 게임 그래픽 설정
* CPU 사용을 하는 **중요** 항목은 끔, 나머지는 최대/최적 설정 (사양이 낮은 경우 끔 항목 외 타협 필요)
* 수직 동기화 : 끔 (FSR 사용)
* **계단 현상 방지 (중요)** : 이미지 기반, CMAA or CMAA2 (품질 대비 성능이 좋음)
* 그림자 품질 : 높음 (품질 대비 성능이 좋음, 낮추면 효과 증가)
* 액체 세부묘사 : 좋음 (품질 고려, 낮추면 효과 증가)
* 입자 밀도 : 높음 (풀질 고려, 낮추면 효과 증가)
* SSAO : 높음 (품질 고려, 낮추면 효과 증가)
* **깊이 기반 효과 (중요)** : 사용 안함 (CPU 사용률 높으며 그래픽 효과가 적은 옵션)
* **계산 효과 (중요)** : 낮음 or 사용 안함 (CPU 사용률 높으며 그래픽 효과가 적은 옵션)
* **주문 밀도 (중요)** : 필수 (다른 플레이어의 마법 효과를 최소화 함. 탱커는 낮음 고려 필요)
* 원거리 사물표현 : 7 (가시거리는 10, 지면 사물 10, 레이드에서 큰 FPS 차이 없음, 품질 고려)
* **광선 추적 그림자 (중요)** : 사용 안함 (CPU 사용률 있음, AMD 그래픽 카드중 게임중 멈추는 증상이 있으면 끌것)
* VRS 모드 : 사용 안함 (좋은거 같지만 큰 차이 없고, 화면이 미세하게 변경되는 증상 있음)
* **FPS 설정은 모두 끔 (중요)** (RTSS 로 설정 or Driver 에서 설정하는 방식 추천)

<iframe width="560" height="315" src="https://www.youtube.com/embed/dVZ1apjDg1s?si=ViT6zcc7t_PreT-f" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 게임 사운드 설정
* **사운드 채널 (중요)**: 32 (사운드 128채널 설정시 CPU 자원 소비, 일부 애드온 음성안내가 끈기거나 안나온다면 64설정 추천)
* **울림 효과 사용 (중요)**: 끔 (CPU 사용함)

## 애드온 관련
* 애드온은 최소 FPS 에 큰 영향을 미침
* `esc > 애드온` 에서 `평균 CPU 사용률`을 `1%` 수준으로 관리할 것을 추천 
* `최대 사용률`은 애드온이 구동 시작하면서 설정하는 경우 다소 높에 올라갈 수 있음

## 공찾 25인 4k 영상
* 최소 FPS 105 정도로 꾸준하게 117확보.
<iframe width="560" height="315" src="https://www.youtube.com/embed/8V7uoOiK0ok?si=mtm5CKDubQ65NoE1" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 영웅 30인 4K 영상
* 블러드 타임 60 FPS 이상 안정적 확보, 광역 구간 순간 최소 50 FPS
<iframe width="560" height="315" src="https://www.youtube.com/embed/X4GBWola1F0?si=flJ-I2Jr8w5_LUD3" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 참고 자료
* [AMD PC 최적화 설정 관련](https://www.reddit.com/r/AMDHelp/comments/1lnxb8o/ultimate_amd_performance_fix_guide_stop_lag_fps/?share_id=siID34gkiYvcxnC8WBKZe&utm_content=1&utm_medium=android_app&utm_name=androidcss&utm_source=share&utm_term=1)
* [RTSS 설정 관련](https://www.youtube.com/watch?v=WZJbTuBeVzE&si=AqgVnkDFQgKrZs2I)
* [와우 그래픽 설정 관련](https://www.youtube.com/watch?v=7v2tDNQc2Uo)
* [사운드 채널 관련](https://youtube.com/watch?v=lZRBJ7VJXgM&si=oY9zuQpUZodQ9jpm)
* [FHD, UHD 레이드 FPS 비교](https://www.inven.co.kr/board/wow/4739/253503)
* [4K, Raid GPU 사용률 관련](https://www.inven.co.kr/board/wow/4739/239906)

## 와우 추천 System (참고)
* 모니터 : 4K 이상, 120Hz, FSR 지원 (G-Sync 지원) 추천 : 와우는 애드온을 많이 사용하여 화면에 글씨가 많음, 4K 모니터 사용시 가시성에 큰 도움이 됨.
* CPU : 와우는 CPU 자원이 중요하여 CPU 에 투자하는 것을 추전, 7800x3d 이상 추천.
* 그래픽 카드 : 4K 모니터 사용시 Rx9070, 16GB VRAM 이상, QHD 모니터 사용시 12GB VRAM 이상 그래픽 카드 추천, 그래픽 카드는 CPU 성능 부족으로 100% 사용이 안되므로 와우만 한다면 너무 좋은 그래픽 카드는 필요 없음.
