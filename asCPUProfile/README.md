
### **asCPUProfile: Optimize Your WoW Performance**

**Introduction** Blizzard has introduced a new API in Patch 11.0.7 that provides detailed information on addon CPU usage. Leveraging this feature, I've created **asCPUProfile** to help you identify and address performance bottlenecks caused by your addons.

**How it works** Once installed, asCPUProfile displays a window that ranks your addons based on their potential impact on your frame rate during the most recent combat.

*   **Addon Name:** The name of the addon.
*   **PeakTime:** The maximum amount of time the addon consumed CPU resources. Lower is generally better, but non-combat usage is less critical.
*   **BossAvg:** The average CPU usage during boss encounters.
*   **Over1ms, 5ms, 10ms, 50ms, 100ms:** The number of times the addon consumed CPU resources for more than the specified duration. Higher values indicate a greater potential impact on performance.
*   **OverSum:** A weighted sum of the values from 1ms to 100ms, used to rank addons based on their overall CPU consumption.

**Tips**

*   **WeakAuras:** To isolate the impact of individual WeakAuras, test them one at a time during combat.
*   **Activation:** The addon is inactive when the window is closed. Use the `/asCPU` command to reopen it after combat. The profiler must be enabled by checking the "Enable Profiler" checkbox. If unchecked, the CPU usage monitoring for addons and the base WoW client will not function.

---


### **asCPUProfile: WoW 성능 최적화 도우미**

**소개** 블리자드는 패치 11.0.7에서 애드온의 CPU 사용량에 대한 자세한 정보를 제공하는 새로운 API를 도입했습니다. 이 기능을 활용하여, 저는 여러분의 애드온으로 인한 성능 병목 현상을 식별하고 해결하는 데 도움을 주는 **asCPUProfile**을 만들었습니다.

**작동 방식** 설치 후, asCPUProfile은 가장 최근 전투 동안 프레임 속도에 미치는 잠재적 영향에 따라 애드온 순위를 표시하는 창을 보여줍니다.

*   **애드온 이름:** 애드온의 이름입니다.
*   **PeakTime:** 애드온이 CPU 리소스를 소비한 최대 시간입니다. 일반적으로 낮을수록 좋지만, 비전투 사용량은 덜 중요합니다.
*   **BossAvg:** 보스 조우 중 평균 CPU 사용량입니다.
*   **Over1ms, 5ms, 10ms, 50ms, 100ms:** 애드온이 지정된 시간 이상 CPU 리소스를 소비한 횟수입니다. 값이 높을수록 성능에 미치는 잠재적 영향이 큽니다.
*   **OverSum:** 1ms부터 100ms까지의 값을 가중 합산한 값으로, 전체 CPU 소비량을 기준으로 애드온 순위를 매기는 데 사용됩니다.

**팁**

*   **WeakAuras:** 개별 WeakAuras의 영향을 분리하려면, 전투 중에 하나씩 테스트해보세요.
*   **활성화:** 창이 닫혀 있으면 애드온이 비활성화됩니다. 전투 후 `/asCPU` 명령어를 사용하여 다시 열 수 있습니다. Enable Profiler Check box를 채크해야 동작합니다. 비 Check 시 애드온 및 와우 기본 Client의 CPU Check하는 기능은 동작하지 않습니다. 


![](https://media.forgecdn.net/attachments/1043/11/ascpuprofile.jpg)

<iframe width="560" height="315" src="https://www.youtube.com/embed/f-_wZDT4Ik8?si=mfP1Sw42-r7atIsj" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>