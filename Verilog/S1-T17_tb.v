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
