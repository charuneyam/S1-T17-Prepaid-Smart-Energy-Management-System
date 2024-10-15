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