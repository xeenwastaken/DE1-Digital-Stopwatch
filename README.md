# Projekt: Digital Stopwatch (Lap) - Dig. Elektronika 1

## 1. Problem Description
Cílem tohoto projektu je návrh a implementace digitálních stopek s funkcí mezičasu (Lap) na FPGA desce Nexys A7. Stopky jsou schopny měřit čas s přesností na setiny sekundy. Zobrazování probíhá na 8místném 7segmentovém displeji pomocí multiplexování. Zařízení se ovládá pomocí fyzických tlačítek (Start/Stop, Lap, Reset), která jsou ošetřena proti mechanickým zákmitům (debouncing).

## 2. Block Diagram
![stopwatch_design](https://github.com/user-attachments/assets/01599b25-6382-4efe-8bd5-442a863b8502)

## 3. Git Flow
Odkaz na historii commitů, která prokazuje spolupráci členů týmu:
[Commit History](https://github.com/xeenwastaken/DE1-Digital-Stopwatch/commits/main/)
* **Student A:** (Žalud Jakub) - Zodpovědný za readme.md 
* **Student B:** (Martinec Robert) - 
  
## 4. Simulations
*(Zde screenshoty z Vivada - Waveforms)*
* **Obrázek 1:** Testbench modulu Debouncer.
* **Obrázek 2:** Testbench modulu Counter (ukázka přetečení a uložení mezičasu).

## 5. Resource Report
Po úspěšné syntéze ve Vivado 2025.2 byly využity následující zdroje na čipu Artix-7:

| Resource | Utilization | Available | Utilization % |
| :--- | :--- | :--- | :--- |
| LUT | *(doplnit)* | 63400 | *(doplnit) %* |
| FF | *(doplnit)* | 126800 | *(doplnit) %* |
| IO | *(doplnit)* | 210 | *(doplnit) %* |

## 6. Vivado Project
Kompletní projektový adresář Vivado 2025.2 bude součástí tohoto repozitáře.

## 7. Other Outputs
* **Video:** [TBD]
* **Poster:** [Link na A3 poster v PDF - TBD]
* **Zdroje:** Přednášky a cvičení BPC-DE1, manuál k Nexys A7.
## 8. Architektura (WIP)

Podmoduly (clock_en, debounce, button_decoder, counter, display_driver).

Hodinové pulzy (z modulu clock_en):
| Název signálu | Datový typ | Zdroj (Výstup z) | Cíl (Vstup do) | Popis |
| :--- | :--- | :--- | :--- | :--- |
| sig_ce_100hz | std_logic | clock_en | debounce, button_decoder, counter | Pulz každou setinu sekundy. Řídí čítání stopek a čtení tlačítek. |
| sig_ce_1khz | std_logic | clock_en | display_driver | Pulz pro rychlé přepínání (multiplexování) znaků displeje. |

Vyčištěná tlačítka (z modulů debounce):
| Název signálu | Datový typ | Zdroj | Cíl | Popis |
| :--- | :--- | :--- | :--- | :--- |
| sig_btn_start_clean| std_logic | debounce (inst. 1) | edge_detector nebo counter | Vyčištěný signál start/stop tlačítka. |
| sig_btn_lap_clean | std_logic | debounce (inst. 2) | button_decoder | Vyčištěný signál lap/reset tlačítka. |

Řídící pulzy pro stopky (z modulu button_decoder a detekce hran):
Poznámka: Abys mohl stopky spustit a zastavit jedním tlačítkem, obvykle se hodí vygenerovat jen krátký pulz (1 hodinový takt) při stisku (tzv. edge detector).
| Název signálu | Datový typ | Zdroj | Cíl | Popis |
| :--- | :--- | :--- | :--- | :--- |
| sig_toggle_tick | std_logic | Detektor hrany | counter | Krátký pulz, který přepne vnitřní stav stopek (běží/stojí). |
| sig_lap_tick | std_logic | button_decoder | counter | Krátký pulz detekující krátký stisk -> uložení mezičasu. |
| sig_reset_tick | std_logic | button_decoder | counter | Krátký pulz detekující dlouhý stisk -> vynulování stopek. |

Datová sběrnice (z modulu counter do display_driver):
| Název signálu | Datový typ | Zdroj | Cíl | Popis |
| :--- | :--- | :--- | :--- | :--- |
| sig_bcd_data | std_logic_vector(31 downto 0) | counter | display_driver | Data k zobrazení. 8 znaků displeje × 4 bity (BCD formát pro každé číslo = 32 bitů). |

## Ovládání stopek (Nexys A7-50T)

| Tlačítko | Akce | Funkce |
|:---:|:---:|:---|
| **BTNC** (Center) | Stisk | **START / STOP** (Spuštění nebo zastavení času) |
| **BTNC** (Center) | Podržení | **COMPLETE RESET** (Celkové vynulování systému) |
| **BTNR** (Right) | Stisk | **SAVE LAP** (Zaznamenání aktuálního mezičasu) |
| **BTNL** (Left) | Stisk | **DELETE LAP** (Smazání aktuálně zobrazeného mezičasu) |
| **BTNL** (Left) | Podržení | **CLEAR ALL** (Vymazání celé paměti mezičasů) |
| **BTNU** (Up) | Stisk | **NEXT LAP** (Listování v paměti směrem nahoru) |
| **BTND** (Down) | Stisk | **PREV LAP** (Listování v paměti směrem dolů) |
