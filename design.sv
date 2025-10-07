// Code your design here
// Synchronous 16x8 FIFO (First-In, First-Out) Buffer
module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 16,
    parameter ADDR_WIDTH = 4  // 2^4 = 16
) (
    input  wire                  i_clk,
    input  wire                  i_rst,
    // Write Port
    input  wire                  i_wr_en,   // Write Enable
    input  wire [DATA_WIDTH-1:0] i_wr_data,
    // Read Port
    input  wire                  i_rd_en,   // Read Enable
    // Status Flags
    output wire [DATA_WIDTH-1:0] o_rd_data,
    output wire                  o_full,
    output wire                  o_empty
);

    // 1. The Memory
    reg [DATA_WIDTH-1:0] r_memory [DEPTH-1:0];

    // 2. The Pointers
    reg [ADDR_WIDTH-1:0] r_wr_ptr;
    reg [ADDR_WIDTH-1:0] r_rd_ptr;

    // 3. Counter to track occupancy
    reg [ADDR_WIDTH:0]   r_count; // One extra bit to differentiate full from empty

    // Write Logic
    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            r_wr_ptr <= 0;
        end else if (i_wr_en && !o_full) begin // Only write if enabled and not full
            r_memory[r_wr_ptr] <= i_wr_data;
            r_wr_ptr           <= r_wr_ptr + 1;
        end
    end

    // Read Logic
    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            r_rd_ptr <= 0;
        end else if (i_rd_en && !o_empty) begin // Only read if enabled and not empty
            r_rd_ptr <= r_rd_ptr + 1;
        end
    end

    // Counter Logic (to generate full/empty)
    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            r_count <= 0;
        end else begin
            // Conditions for counting:
            // 1. Write but don't read: Increment
            // 2. Read but don't write: Decrement
            // 3. Write and Read simultaneously: No change
            // 4. Neither Write nor Read: No change
            if (i_wr_en && !o_full && !i_rd_en) begin
                r_count <= r_count + 1;
            end else if (!i_wr_en && i_rd_en && !o_empty) begin
                r_count <= r_count - 1;
            end
        end
    end

    // Assign Outputs
    assign o_rd_data = r_memory[r_rd_ptr];
    assign o_full    = (r_count == DEPTH);
    assign o_empty   = (r_count == 0);

endmodule
