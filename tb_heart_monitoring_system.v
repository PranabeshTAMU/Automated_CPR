module heart_monitoring_system_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [7:0] heart_rate;
    reg [7:0] oxygen_level;
    reg ecg_signal_valid;

    // Outputs
    wire cpr_activate;
    wire drug_delivery_activate;
    wire [3:0] drug_dosage;
    wire iv_line_setup;
    wire saline_flush;

    // Instantiate the Unit Under Test (UUT)
    heart_monitoring_system uut (
        .clk(clk),
        .rst(rst),
        .heart_rate(heart_rate),
        .oxygen_level(oxygen_level),
        .ecg_signal_valid(ecg_signal_valid),
        .cpr_activate(cpr_activate),
        .drug_delivery_activate(drug_delivery_activate),
        .drug_dosage(drug_dosage),
        .iv_line_setup(iv_line_setup),
        .saline_flush(saline_flush)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test cases based on Table 4
    initial begin
        // Initialize inputs
        rst = 1;
        heart_rate = 0;
        oxygen_level = 0;
        ecg_signal_valid = 0;

        // Reset the system
        #10 rst = 0;

        // Test case 1: Bradycardia detected; CPR activated
        #50 heart_rate = 40; oxygen_level = 85; ecg_signal_valid = 1;

        // Test case 2: Tachycardia detected; drug delivered
        #50 heart_rate = 130; oxygen_level = 98; ecg_signal_valid = 1;
        #10 if (iv_line_setup) $display("IV line setup activated");
        #10 if (saline_flush) $display("Saline flush administered");

        // Test case 3: Normal range; no action required
        #50 heart_rate = 70; oxygen_level = 98; ecg_signal_valid = 1;

        // Test case 4: Edge case - No action required
        #50 heart_rate = 50; oxygen_level = 95; ecg_signal_valid = 1;

        // Test case 5: Severe tachycardia; higher dosage
        #50 heart_rate = 160; oxygen_level = 96; ecg_signal_valid = 1;
        #10 if (iv_line_setup) $display("IV line setup activated");
        #10 if (saline_flush) $display("Saline flush administered");

        // Test case 6: Borderline Bradycardia; CPR activated
        #50 heart_rate = 45; oxygen_level = 85; ecg_signal_valid = 1;

        // Test case 7: Near normal condition; no action required
        #50 heart_rate = 120; oxygen_level = 92; ecg_signal_valid = 1;

        // Test case 8: Slightly low oxygen level
        #50 heart_rate = 55; oxygen_level = 88; ecg_signal_valid = 1;

        // End simulation at 400 ns
        #50 $finish;
    end

endmodule
