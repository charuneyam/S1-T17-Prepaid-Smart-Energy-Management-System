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
![Overall Circuit](https://github.com/user-attachments/assets/bc69ff6f-98e4-486c-8ca1-e6ddfcd16ccb)


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

  ### Modules

```

//Counter
module T_FF (input T, input clk, input reset, output reg Q);  //T flipflop module
    always @(posedge clk or posedge reset) begin
        if (reset)
            Q <= 0;
        else if (T)
            Q <= ~Q;
    end
endmodule
module Mod256Counter (input sensor, input date_1, output [9:0] units_cons);
    wire [7:0] T;
    wire [7:0] Q;

    assign T[0] = 1;
    assign T[1] = Q[0];
    assign T[2] = Q[0] & Q[1];
    assign T[3] = Q[0] & Q[1] & Q[2];
    assign T[4] = Q[0] & Q[1] & Q[2] & Q[3];
    assign T[5] = Q[0] & Q[1] & Q[2] & Q[3] & Q[4];
    assign T[6] = Q[0] & Q[1] & Q[2] & Q[3] & Q[4] & Q[5];
    assign T[7] = Q[0] & Q[1] & Q[2] & Q[3] & Q[4] & Q[5] & Q[6];

    T_FF tff0 (T[0], sensor, date_1, Q[0]);
    T_FF tff1 (T[1], sensor, date_1, Q[1]);
    T_FF tff2 (T[2], sensor, date_1, Q[2]);
    T_FF tff3 (T[3], sensor, date_1, Q[3]);
    T_FF tff4 (T[4], sensor, date_1, Q[4]);
    T_FF tff5 (T[5], sensor, date_1, Q[5]);
    T_FF tff6 (T[6], sensor, date_1, Q[6]);
    T_FF tff7 (T[7], sensor, date_1, Q[7]);

    assign units_cons = Q;
endmodule

//Comparator for free limit
module comparator1(input [9:0] units_cons,
                   output reg F);

    reg [9:0] free_limit;
    
    initial
    free_limit = 10'b0000110010; //free limit = upto 50 units

    always @ (*)
     begin
       if(units_cons>free_limit)
         F = 1;
       else
         F = 0;
     end
endmodule

//Subtractor to get units consumed after free limit
module subtractor_10bit(input [9:0] units_cons, 
                       input F,
                       output reg [9:0] Diff);

    reg [9:0] free_limit;

    initial
       free_limit = 10'b0000110010; //50 units

    always @ (*)
    begin
        if(F)
        Diff = units_cons - free_limit;
        else
        Diff = 10'b0000000000;
    end
endmodule

//Module to get no.of units consumed in range 1
   /*key:-
     units_aft_fl = units consumed after free limit
     units_out = units consumed in range 1
     ll = lower limit of range 1 = 1 unit
     ul = upper limit of range 1 = 50 units*/
module range1(input [9:0] units_aft_fl,
              output reg [9:0] units_out,
              output reg next);

    reg [9:0] inactive, ll, ul;
    reg A,B;

    initial
    begin
        ll = 10'b0000000001; //1 unit
        ul = 10'b0000110010; // 50 units
        inactive = 10'b0000000000;
    end

    always @ (*)
    begin
        A = units_aft_fl >= ll;
        B = units_aft_fl <= ul;
        next = ~B;
        if(A && B)
           units_out = units_aft_fl;
        else
        begin
            if(~A)
            units_out = inactive;
            else
            units_out = ul;
        end
    end
endmodule

//Module to get no.of units consumed in range 2
   /*key:-
     units_aft_fl = units consumed after free limit
     units_out = units consumed in range 2
     ul1 = upper limit of range 1 = 50 units
     ul2 = upper limit of range 2 = 150 units
     tot_units = total units in range 2
     prev = input from range 1 indicating if units consumed is greater than range 1 or not*/
module range2(input [9:0] units_aft_fl,
              input prev,
              output reg [9:0] units_out,
              output reg next);

    reg [9:0] inactive, ul1, ul2, tot_units;
    reg A,B;

    initial
    begin
        ul1 = 10'b0000110010; //50 units
        ul2 = 10'b0010010110; //150 units
        tot_units = 10'b0001100100; //100 units
        inactive = 10'b0000000000;
    end

    always @ (*)
    begin
        A = units_aft_fl <= ul2;
        if(~prev)
           next = 0;
        else
           next = ~A;
        if(~prev)
           units_out = inactive;
        else
        begin
            if(A)
            begin
                units_out = units_aft_fl - ul1;
            end
            else
            units_out = tot_units;
        end
    end
endmodule

//Module to get no.of units consumed in range 3
    /*key:-
      units_aft_fl = units consumed after free limit
      units_out = units consumed in range 2
      ul1 = upper limit of range 2 = 150 units
      prev = input from range 2 indicating if units consumed is greater than range 2 or not*/
module range3(input [9:0] units_aft_fl,
              input prev,
              output reg [9:0] units_out);

    reg [9:0] inactive, ul;
    
    initial
    begin
        ul = 10'b0010010110; //150 units
        inactive = 10'b0000000000;
    end
    always @ (*)
    begin
       if(prev)
        units_out = units_aft_fl - ul;
       else
         units_out = inactive;
    end
endmodule

//Module to get total price for units consumed in range 2
module mul2 (input [9:0] units_out,
             output reg [9:0] cost_cons_in_r2);

    reg[1:0] price;
    initial price = 2'b10;

    always @ (*) 
        begin
          cost_cons_in_r2 = units_out*price;
        end
endmodule

//Module to get total price for units consumed in range 3
module mul3 (input [9:0] units_out,
             output reg [9:0] cost_cons_in_r3);

    reg[1:0] price;
    initial price = 2'b11;

    always @ (*) 
        begin
          cost_cons_in_r3 = units_out*price;
        end
endmodule

//Module to get total price consumed
module price_adder (input[9:0] R1,R2,R3,
              output reg [9:0] tot_cost_cons);

    always @(*) begin
         tot_cost_cons = R1 + R2 + R3;
    end
endmodule

//Subtractor Module to find balance amount from prepaid amount
module subtractor_balance(input[9:0] prepaid, tot_cost_cons,
                          output reg [9:0] balance);

    always @(*) begin
        balance = prepaid - tot_cost_cons;
    end
    
endmodule

//comparator for alerts
module alert(input[9:0] balance,
             output reg alert1, alert2);

    reg [5:0] danger_lvl;
    initial danger_lvl = 45;

    always @ (*) begin
        if(balance <= danger_lvl)
           alert1 = 1;
        else 
           alert1 = 0;
        if(balance == 0)
          alert2 = 1;
        else 
          alert2 = 0;
    end
endmodule

//Module to find approximate Average consumption per day
module find_avg(input [9:0] tot_cost_cons,
                input [4:0] date,
                output reg [9:0] avg_per_day);

    always @ (date)
    begin
        avg_per_day = tot_cost_cons/date;
    end
endmodule

//approximately how many more days will the plan last
module days_lasting(input [9:0] balance,
                input [9:0] avg_per_day,
                output reg [9:0] days_lasting);

    always @ (avg_per_day)
    begin
        days_lasting = balance/avg_per_day;
    end
endmodule

//MAIN MODULE
module main(input sensor, date_1, 
            input [9:0] prepaid,
            output reg [9:0] balance, avg_per_day, days_lasting, units_cons,
            output reg alert1,alert2);

       wire F;
       wire next1;
       wire next2;
       wire [9:0] units_aft_fl;
       wire [9:0] units_out1;
       wire [9:0] units_out2;
       wire [9:0] units_out3;
       wire [9:0] cost_cons_in_r2;
       wire [9:0] cost_cons_in_r3;
       wire [9:0] tot_cost_cons;
       
       Mod256Counter dut1(sensor,date_1,units_cons);
       
       comparator1 dut2(units_cons,F);

       subtractor_10bit dut3(units_cons,F,units_aft_fl);

       range1 dut4(units_aft_fl,units_out1,next1);

       range2 dut5(units_aft_fl,next1,units_out2,next2);

       range3 dut6(units_aft_fl,next2,units_out3);

       mul2 dut7(units_out2,cost_cons_in_r2);

       mul3 dut8(units_out3,cost_cons_in_r3);

       price_adder dut9(units_out1,cost_cons_in_r2,cost_cons_in_r3,tot_cost_cons);

       subtractor_balance dut10(prepaid,tot_cost_cons,balance);

       alert dut11(balance,alert1,alert2);
       
       find_avg dut12(tot_cost_cons,date,avg_per_day);

       days_lasting dut13(balance,avg_per_day,days_lasting);

endmodule
```
### Test Bench
```
module tb;
    
   reg sensor, date_1;
   reg [9:0] prepaid;
   wire [9:0] balance;
   wire [9:0] avg_per_day;
   wire [9:0] days_lasting;
   wire [9:0] units_cons;
   wire alert1;
   wire alert2;

   main dut(sensor, date_1, prepaid, balance, avg_per_day, days_lasting, units_cons, alert1, alert2);

   initial begin
    sensor = 0;
    forever #10 sensor = ~sensor;
   end

   initial begin
    date_1 = 1;
    #10
    date_1 = 0;
    #30
    date_1 = 1;
    #10
    date_1 = 0;

    #5000

    $finish;
   end

   initial begin
    prepaid = 300;
   end

   initial begin
    $monitor("Time=%0d   sensor=%b  date_1=%b  prepaid=%b  balance=%b  units=%b  alert1=%1b  alert2=%1b",$time,sensor,date_1,prepaid,balance,avg_per_day,days_lasting,units_cons,alert1,alert2);
   end
endmodule

</details>

## References
<details>
  <summary>Detail</summary>
