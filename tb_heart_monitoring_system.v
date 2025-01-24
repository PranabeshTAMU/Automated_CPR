module tb_heart_monitoring_system;

    // Inputs
    reg clk;
    reg rst;
    reg [7:0] heart_rate;
    reg [7:0] oxygen_level;
    reg [7:0] patient_weight;
    reg [7:0] patient_age;

    // Outputs
    wire cpr_activate;
    wire drug_delivery_activate;
    wire [7:0] drug_dosage;

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

        // Test 1: Bradycardia (heart rate < 50)
        $display("Test 1: Bradycardia (heart rate < 50)");
        heart_rate = 45;
        patient_weight = 70;
        patient_age = 30;
        #100;
        if (cpr_activate && !drug_delivery_activate) 
            $display("Pass: CPR activated, no drug delivered.");
        else
            $display("Fail: CPR not activated correctly.");

        // Test 2: Normal range (50 <= heart_rate <= 120)
        $display("Test 2: Normal range (50 <= heart_rate <= 120)");
        heart_rate = 80;
        #100;
        if (!cpr_activate && !drug_delivery_activate) 
            $display("Pass: No action for normal heart rate.");
        else
            $display("Fail: Incorrect activation during normal heart rate.");

        // Test 3: Tachycardia (heart rate > 120, drug delivery sequence)
        $display("Test 3: Tachycardia (heart rate > 120, drug delivery)");
        heart_rate = 130;
        patient_weight = 60;
        patient_age = 40;
        #500; // Wait for drug delivery to complete
        if (!cpr_activate && drug_delivery_activate) 
            $display("Pass: Drug delivery sequence initiated.");
        else
            $display("Fail: Drug delivery sequence failed.");

        // Test 4: Extreme bradycardia (heart rate < 30)
        $display("Test 4: Extreme bradycardia (heart rate < 30)");
        heart_rate = 30;
        #100;
        if (cpr_activate && !drug_delivery_activate) 
            $display("Pass: CPR activated for extreme bradycardia.");
        else
            $display("Fail: CPR activation failed for extreme bradycardia.");

        // Test 5: Extreme tachycardia (heart rate = 150, heavy patient)
        $display("Test 5: Extreme tachycardia (heart rate > 150, heavy patient)");
        heart_rate = 150;
        patient_weight = 100; // High weight
        patient_age = 65; // Older patient
        #500;
        if (!cpr_activate && drug_delivery_activate && drug_dosage == 12) 
            $display("Pass: Correct drug dosage delivered for extreme tachycardia.");
        else
            $display("Fail: Incorrect drug dosage or sequence.");

        // Test 6: Edge case (heart rate = 50)
        $display("Test 6: Edge case (heart rate = 50)");
        heart_rate = 50;
        #100;
        if (!cpr_activate && !drug_delivery_activate) 
            $display("Pass: No action for edge case heart rate = 50.");
        else
            $display("Fail: Incorrect action for edge case heart rate = 50.");

        // Test 7: Edge case (heart rate = 120)
        $display("Test 7: Edge case (heart rate = 120)");
        heart_rate = 120;
        #100;
        if (!cpr_activate && !drug_delivery_activate) 
            $display("Pass: No action for edge case heart rate = 120.");
        else
            $display("Fail: Incorrect action for edge case heart rate = 120.");

        // Test 8: Rapid state transition
        $display("Test 8: Rapid transition from bradycardia to tachycardia");
        heart_rate = 40; // Bradycardia
        #50;
        heart_rate = 130; // Tachycardia
        #500;
        if (drug_delivery_activate && !cpr_activate) 
            $display("Pass: Correct handling of rapid transition.");
        else
            $display("Fail: Incorrect handling of rapid transition.");

        // Test 9: Patient with low weight and age
        $display("Test 9: Tachycardia with low-weight, young patient");
        heart_rate = 130;
        patient_weight = 40;
        patient_age = 25;
        #500;
        if (drug_dosage == 6) 
            $display("Pass: Correct dosage for low-weight young patient.");
        else
            $display("Fail: Incorrect dosage.");

        // End of simulation
        $display("Simulation completed.");
        $stop;
    end
endmodule
