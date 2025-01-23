module heart_monitoring_system (
    input wire clk,
    input wire rst,
    input wire [7:0] heart_rate,       // Heart rate in bpm
    input wire [7:0] oxygen_level,    // Oxygen level in percentage
    input wire [7:0] patient_weight,  // Weight in kg
    input wire [7:0] patient_age,     // Age in years
    output reg cpr_activate,          // CPR activation signal
    output reg drug_delivery_activate, // Drug delivery activation signal
    output reg [3:0] drug_dosage      // Dosage level
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cpr_activate <= 0;
            drug_delivery_activate <= 0;
            drug_dosage <= 0;
        end else begin
            // Bradycardia: Heart rate < 50
            if (heart_rate < 50) begin
                cpr_activate <= 1;
                drug_delivery_activate <= 0;
                drug_dosage <= 0; // No drug dosage required for bradycardia
            end 
            // Tachycardia: Heart rate > 120
            else if (heart_rate > 120) begin
                cpr_activate <= 0;
                drug_delivery_activate <= 1;
                // Calculate drug dosage based on weight and age
                if (patient_weight > 80 || patient_age > 60)
                    drug_dosage <= 4; // High dosage
                else if (patient_weight > 50)
                    drug_dosage <= 3; // Medium dosage
                else
                    drug_dosage <= 2; // Low dosage
            end 
            // Normal range: Heart rate between 50 and 120
            else begin
                cpr_activate <= 0;
                drug_delivery_activate <= 0;
                drug_dosage <= 0; // No action required
            end
        end
    end
endmodule
