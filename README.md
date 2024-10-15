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
The circuit takes in prepaid amount for your electricity and keeps a track of your balance money as it keeps track of your electricity consumed in terms of units consumed using counters. It also has the feature of date consideration using counters for calculating electricity consumed and average money spent on electricity per day. Sensor Input which is positive edge triggered is used to indicate 1 unit of electricity consumed each time it is positive edge triggered. A counter keeps track of total units consumed. There is range based calculation of price per unit in three different ranges, done by three different modules comprising of series of comparators, multiplexers, multipliers and other logic gates.
(a) 0 to 50 units, No money charged-free limit
(b) 51 to 100 units, 1rs/unit
(c) 101 to 150 units, 2rs/unit
(d) >150 units, 3rs/unit.
Circuit calculates total price spent and shows balance money left from prepaid amount.
It also shows alerts while comparing danger level with balance money.
Using registers and date input, average consumption in terms of money and warning of how many more days the plan might last is also available as output.
Additionally, when balance becomes 0, user can buy extra credits too.
  
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

module date_counter(
    input date_1,
    input reset,
    output reg [4:0] date
);

    always @(posedge date_1 or posedge reset) begin
        if (reset)
            date <= 5'd1;  // Reset to day 1
        else if (date == 5'd31)
            date <= 5'd1;  // Wrap around to day 1 after day 31
        else
            date <= date + 1'd1;  // Increment the date on positive edge of date_1
    end
endmodule


module Mod256Counter (
    input sensor,
    input date_1,
    input reset,
    output reg [9:0] units_cons
);
    always @(posedge sensor or posedge reset) begin
        if (reset)
            units_cons <= 10'd0;
        else
            units_cons <= (units_cons == 10'd255) ? 10'd0 : units_cons + 1'd1;
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


module comparator1(
    input [9:0] units_cons,
    output reg F
);
    parameter FREE_LIMIT = 10'd50; // Assuming 50 units as the free limit

    always @(*) begin
        if (units_cons > FREE_LIMIT)
            F = 1'b1;
        else
            F = 1'b0;
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
module price_adder(
    input [9:0] R1, R2, R3,
    output reg [9:0] tot_cost_cons
);
    always @(*) begin
        tot_cost_cons = R1 + R2 + R3;
    end
endmodule
//Subtractor Module to find balance amount from prepaid amount
module subtractor_balance(
    input [9:0] prepaid, 
    input [9:0] tot_cost_cons,
    output reg [9:0] balance
);
    always @(*) begin
        if (prepaid >= tot_cost_cons)
            balance = prepaid - tot_cost_cons;
        else
            balance = 10'd0;
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
module find_avg(
    input [9:0] tot_cost_cons,
    input [4:0] date,
    output reg [9:0] avg_per_day
);
    always @(*) begin
        if (date != 5'd0)
            avg_per_day = tot_cost_cons / date;
        else
            avg_per_day = tot_cost_cons;
    end
endmodule

//approximately how many more days will the plan last
module days_lasting(
    input [9:0] balance,
    input [9:0] avg_per_day,
    output reg [9:0] days_lasting
);
    always @(*) begin
        if (avg_per_day != 10'd0)
            days_lasting = balance / avg_per_day;
        else
            days_lasting = 10'd999; // Arbitrary large number to indicate "many days"
    end
endmodule

//MAIN MODULE
module main(
    input sensor, date_1, reset,
    input [9:0] prepaid,
    output wire [9:0] balance, avg_per_day, days_lasting, units_cons,
    output wire alert1, alert2,
    output[4:0] date
);
    wire F;
    wire next1, next2;
    wire [9:0] units_aft_fl, units_out1, units_out2, units_out3;
    wire [9:0] cost_cons_in_r2, cost_cons_in_r3, tot_cost_cons;
    wire [4:0] date;

    date_counter dut_date(date_1, reset, date);
    Mod256Counter dut1(sensor, date_1, reset, units_cons);
    comparator1 dut2(units_cons, F);
    subtractor_10bit dut3(units_cons, F, units_aft_fl);
    range1 dut4(units_aft_fl, units_out1, next1);
    range2 dut5(units_aft_fl, next1, units_out2, next2);
    range3 dut6(units_aft_fl, next2, units_out3);
    mul2 dut7(units_out2, cost_cons_in_r2);
    mul3 dut8(units_out3, cost_cons_in_r3);
    price_adder dut9(units_out1, cost_cons_in_r2, cost_cons_in_r3, tot_cost_cons);
    subtractor_balance dut10(prepaid, tot_cost_cons, balance);
    alert dut11(balance, alert1, alert2);
    find_avg dut12(tot_cost_cons, date, avg_per_day);
    days_lasting dut13(balance, avg_per_day, days_lasting);
endmodule
```
### Test Bench
```
module tb;
    reg sensor, date_1, reset;
    reg [9:0] prepaid;
    wire [9:0] balance, avg_per_day, days_lasting, units_cons;
    wire alert1, alert2;
    wire [4:0] date;

    // Instantiate the main module
    main dut(sensor, date_1, reset, prepaid, balance, avg_per_day, days_lasting, units_cons, alert1, alert2, date);

    initial begin
        // Initial conditions
        sensor = 0;
        date_1 = 0;
        reset = 1;
        prepaid = 300;
        
        #10 reset = 0;  // Deactivate reset after 10 time units
        
        // Simulate sensor toggling and date incrementing
        repeat(800) begin
            #10 sensor = ~sensor;  // Toggle sensor every 10 time units (simulate consumption)
            if ($time % 100 == 0) 
                date_1 = ~date_1;  // Toggle date_1 every 100 time units (positive edge triggers date increment)
        end
        
        // End simulation after sufficient time
        #100 $finish;
    end

    // Monitor signals and values throughout the simulation
    initial begin
        $monitor("Time=%0d sensor=%b date_1=%b date=%d reset=%b prepaid=%d balance=%d avg_per_day=%d days_lasting=%d units_cons=%d alert1=%b alert2=%b",
                 $time, sensor, date_1, date, reset, prepaid, balance, avg_per_day, days_lasting, units_cons, alert1, alert2);
    end
endmodule
```
</details>

## References
<details>
  <summary>Detail</summary>
