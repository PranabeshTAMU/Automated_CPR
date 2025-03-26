module heart_monitoring_system (
    input wire clk,
    input wire rst,
    input wire [7:0] heart_rate,       // Heart rate in bpm
    input wire [7:0] oxygen_level,    // Oxygen level in percentage
    input wire ecg_signal_valid,      // Valid ECG signal flag (1 = valid, 0 = invalid)
    output reg cpr_activate,          // CPR activation signal
    output reg drug_delivery_activate,// Drug delivery activation signal
    output reg [3:0] drug_dosage,     // Dosage level
    output reg iv_line_setup,         // IV line setup signal
    output reg saline_flush           // Saline flush activation
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cpr_activate <= 0;
            drug_delivery_activate <= 0;
            drug_dosage <= 0;
            iv_line_setup <= 0;
            saline_flush <= 0;
        end else begin
            // Default state: No action required
            cpr_activate <= 0;
            drug_delivery_activate <= 0;
            drug_dosage <= 0;
            iv_line_setup <= 0;
            saline_flush <= 0;

            // Logic based on heart rate, oxygen level, and ECG signal validity
            if (heart_rate < 50 && ecg_signal_valid && oxygen_level < 95) begin
                cpr_activate <= 1; // Activate CPR for bradycardia with low oxygen
            end else if (heart_rate > 120 && ecg_signal_valid && oxygen_level >= 95) begin
                drug_delivery_activate <= 1; // Activate drug delivery for tachycardia
                iv_line_setup <= 1; // Setup IV line for drug administration
                drug_dosage <= 6; // Initial dose of 6 mg
            end
           
            // Simulate the one-shot adenosine injection and saline flush
            if (drug_delivery_activate) begin
                #10 saline_flush <= 1; // Administer saline flush after drug injection
                #10 saline_flush <= 0; // Reset saline flush after injection
                #20 iv_line_setup <= 0; // Close IV setup after one-shot injection
            end
        end
    end

endmodule
