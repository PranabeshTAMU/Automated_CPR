module heart_monitoring_system (
    input wire clk,
    input wire rst,
    input wire [7:0] heart_rate,       // Heart rate in bpm
    input wire [7:0] oxygen_level,    // Oxygen level in percentage
    input wire [7:0] patient_weight,  // Weight in kg
    input wire [7:0] patient_age,     // Age in years
    output reg cpr_activate,          // CPR activation signal
    output reg drug_delivery_activate, // Drug delivery activation signal
    output reg [7:0] drug_dosage      // Dosage in mg or mL
);

    // Define states for drug delivery
    localparam IDLE         = 2'b00;
    localparam FIRST_DOSE   = 2'b01;
    localparam SALINE_FLUSH = 2'b10;
    localparam SECOND_DOSE  = 2'b11;

    reg [1:0] state;                  // Current state
    reg [31:0] delay_counter;         // Counter for delays

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset outputs and states
            cpr_activate <= 0;
            drug_delivery_activate <= 0;
            drug_dosage <= 0;
            state <= IDLE;
            delay_counter <= 0;
        end else begin
            // Bradycardia: Heart rate < 50 (CPR only)
            if (heart_rate < 50) begin
                cpr_activate <= 1;
                drug_delivery_activate <= 0;
                drug_dosage <= 0; // No drug dosage required for bradycardia
                state <= IDLE;    // Reset drug delivery state
                delay_counter <= 0;
            end 
            // Tachycardia: Heart rate > 120 (drug delivery sequence)
            else if (heart_rate > 120) begin
                cpr_activate <= 0;
                drug_delivery_activate <= 1;

                case (state)
                    IDLE: begin
                        drug_dosage <= 6; // 6 mg Adenosine (1st dose)
                        state <= FIRST_DOSE;
                        delay_counter <= 0;
                    end
                    FIRST_DOSE: begin
                        if (delay_counter >= 10) begin // 1-2 seconds delay
                            drug_dosage <= 20; // 10-20 mL Saline flush
                            state <= SALINE_FLUSH;
                            delay_counter <= 0;
                        end else begin
                            delay_counter <= delay_counter + 1;
                        end
                    end
                    SALINE_FLUSH: begin
                        if (delay_counter >= 120) begin // 1-2 minutes delay
                            drug_dosage <= 12; // 12 mg Adenosine (2nd dose)
                            state <= SECOND_DOSE;
                            delay_counter <= 0;
                        end else begin
                            delay_counter <= delay_counter + 1;
                        end
                    end
                    SECOND_DOSE: begin
                        if (delay_counter >= 10) begin // Final dose complete
                            drug_dosage <= 0;
                            state <= IDLE;
                            drug_delivery_activate <= 0; // End drug delivery
                        end else begin
                            delay_counter <= delay_counter + 1;
                        end
                    end
                endcase
            end 
            // Normal range: Heart rate between 50 and 120
            else begin
                cpr_activate <= 0;
                drug_delivery_activate <= 0;
                drug_dosage <= 0; // No action required
                state <= IDLE;    // Reset drug delivery state
                delay_counter <= 0;
            end
        end
    end
endmodule

