module tb_heart_monitoring_system();

    reg clk;
    reg rst;
    reg [7:0] heart_rate;
    reg [7:0] oxygen_level;
    reg [7:0] patient_weight;
    reg [7:0] patient_age;
    wire cpr_activate;
    wire drug_delivery_activate;
    wire [3:0] drug_dosage;

    // Instantiate the DUT (Device Under Test)
    heart_monitoring_system dut (
        .clk(clk),
        .rst(rst),
        .heart_rate(heart_rate),
        .oxygen_level(oxygen_level),
        .patient_weight(patient_weight),
        .patient_age(patient_age),
        .cpr_activate(cpr_activate),
        .drug_delivery_activate(drug_delivery_activate),
        .drug_dosage(drug_dosage)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        rst = 1;
        heart_rate = 0;
        oxygen_level = 0;
        patient_weight = 0;
        patient_age = 0;

        #10 rst = 0;

        // Test Case 1: Bradycardia (heart rate < 50)
        heart_rate = 45; // Below threshold
        patient_weight = 70;
        patient_age = 30;
        #50;

        // Test Case 2: Normal heart rate (50 <= heart_rate <= 120)
        heart_rate = 80; // Within range
        #50;

        // Test Case 3: Tachycardia (heart rate > 120, medium dosage)
        heart_rate = 130; // Above threshold
        patient_weight = 60; // Medium weight
        patient_age = 40; // Middle age
        #50;

        // Test Case 4: Tachycardia (heart rate > 120, high dosage)
        heart_rate = 125;
        patient_weight = 90; // High weight
        patient_age = 65; // Senior
        #50;

        // Test Case 5: Normal range again
        heart_rate = 75;
        #50;

        // Test Case 6: Edge case (heart rate = 50)
        heart_rate = 50;
        #50;

        // Test Case 7: Edge case (heart rate = 120)
        heart_rate = 120;
        #50;

        // Test Case 8: Extreme bradycardia (heart rate = 30)
        heart_rate = 30;
        #50;

        // Test Case 9: Extreme tachycardia (heart rate = 150)
        heart_rate = 150;
        patient_weight = 85;
        patient_age = 55;
        #50;

        // End simulation
        $stop;
    end

endmodule
