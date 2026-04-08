# Projekt: Digital Stopwatch (Lap) - Dig. Elektronika 1

## 1. Problem Description
Cílem tohoto projektu je návrh a implementace digitálních stopek s funkcí mezičasu (Lap) na FPGA desce Nexys A7. Stopky jsou schopny měřit čas s přesností na setiny sekundy. Zobrazování probíhá na 8místném 7segmentovém displeji pomocí multiplexování. Zařízení se ovládá pomocí fyzických tlačítek (Start/Stop, Lap, Reset), která jsou ošetřena proti mechanickým zákmitům (debouncing).

## 2. Block Diagram
*(obrázek blokového schématu draw.io)*

## 3. Git Flow
Odkaz na historii commitů, která prokazuje spolupráci členů týmu:
[Commit History](https://github.com/xeenwastaken/DE1-Digital-Stopwatch/commits/main/)
* **Student A:** (Žalud Jakub) - Zodpovědný za readme.md 
* **Student B:** (Martinec Robert) - Zodpovědný za ???
  
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
