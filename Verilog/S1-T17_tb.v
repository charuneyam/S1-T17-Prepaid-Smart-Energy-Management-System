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

   