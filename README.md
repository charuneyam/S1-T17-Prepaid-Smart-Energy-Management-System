# Prepaid Energy Management System

<!-- First Section -->
## Team Details
<details>
  <summary>Details</summary>
  
  > Semester: 3rd Sem B. Tech. CSE

  > Section: S1

  > Team ID: S1-T17

  > Member-1: Charuneya M, 231CS117, charuneyam.231cs117@nitk.edu.in

  > Member-2: Dhiya N, 231CS121, dhiyan.231cs121@nitk.edu.in

  > Member-3: Neha Chandrashekar, 231CS137, nehachandrashekar.231cs137@nitk.edu.in
</details>

<!-- Second Section -->
## Abstract
<details>
  <summary>Detail</summary>
  
### Motivation
   As global energy consumption continues to rise, efficient power management
   has become increasingly crucial in modern power distribution networks. Traditional energy
   metering systems suffer from issues such as human error in meter readings, delayed billing,
   and energy wastage. These inefficiencies lead to unnecessary costs for both consumers and
   providers, highlighting the need for smarter, more reliable solutions that promote energy conservation and reduce waste.
### Problem Statement
Prepaid smart energy management systems offer a solution to the
limitations of traditional metering by providing real-time energy monitoring, consumption
tracking, and a user-friendly prepaid model. This system allows users to pay for energy in
advance, helping to avoid the pitfalls of delayed billing and untraced consumption. In addition to promoting efficient energy use, prepaid systems reduce power theft and offer greater
transparency in electricity consumption, contributing to a more sustainable energy future.
### Features
This project focuses on designing a prepaid smart energy management system. By
utilizing digital components like comparators, registers, and flip-flops, the system ensures low
power consumption, fast data processing, and robust error handling. Key features include:
1. Real-time energy consumption tracking for accurate monitoring.
2. Prepaid mechanism to allow users to purchase electricity in advance.
3. Automatic activation after the free electricity limit is reached.
4. Displaying average consumption per day along with day-wise warning for limit crossing.
5. Regular alerts on credit exhaustion.
6. Alerts on how many more days credit will last with current usage pattern.
7. Modular design for easy implementation in residential and industrial environments.
This system provides an efficient and scalable solution for modern energy management.

</details>

## Functional Block Diagram
<details>
  <summary>Detail</summary>

  > Block Diagram for Prepaid Smart Energy Management System
![DDS-miniproject-S1-T17 drawio](https://github.com/user-attachments/assets/8fb1c640-0396-48dc-8f56-edfb81a56533)

</details>

<!-- Third Section -->
## Working
<details>
  <summary>Detail</summary>

  
</details>

<!-- Fourth Section -->
## Logisim Circuit Diagram
<details>
  <summary>Detail</summary>

  The "[Logisim](https://github.com/charuneyam/S1-T17-Prepaid-Smart-Energy-Management-System/tree/main/Logisim)" folder consists of the logisim file of overall implementation of our project - Prepaid Energy Management System..
```
    Instructions for using the overall implementation file(.circ file):-
    1. Set the required switches and inputs as instructed in the main.circ in the overall implementation file.
    2. Set 'prepaid money' (which is in bits) as per your wish. (<=512 rupees). Ignore the the Msb, which is the 10th bit i.e Msb is always 0(to keep it overall number positive).
    3. First press 'DATE TRIGGER' to increase date from 1 to 31.
    4. Press the 'SENSOR INPUT' twice to increase electricity units consumed by 1 unit(two presses = 1 unit of electricity consumed).
    5. You will get the outputs(such as total units consumed, balance money, alerts, average consumption on money)on the right end of the main.circ file.
    6. When balance money becomes 0 (shown by alert1) you can set your prepaid amount to next credit you want to purchase.  
```
Overall Circuit
![Overall Circuit](https://github.com/user-attachments/assets/adf832e2-8098-452d-9b6a-e87551f4e989)

SUBTRACTOR_freelimit
![SUBTRACTOR_free limit](https://github.com/user-attachments/assets/57375486-b280-420d-be23-f2e08765fb56)


Range1_units_consumed
![range1_units consumed](https://github.com/user-attachments/assets/0167d526-92d2-4b19-a8a5-f95f8c17aa84)


Range2_units_consumed
![range2_units consumed](https://github.com/user-attachments/assets/31af94a3-f756-4cfc-8342-f99b334b2e6f)


Range3_units_consumed
![range3_units consumed](https://github.com/user-attachments/assets/e096257e-6257-4150-b672-7d3705e6982c)


Date Counter
![Date Counter](https://github.com/user-attachments/assets/e5acb752-8ae4-443a-8308-29d099fb5405)

</details>

<!-- Fifth Section -->
## Verilog Code
<details>
  <summary>Detail</summary>

  > Neatly update the Verilog code in code style only.
</details>

## References
<details>
  <summary>Detail</summary>
