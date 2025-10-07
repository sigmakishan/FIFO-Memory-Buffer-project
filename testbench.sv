
module tb_fifo;

    // Parameters
    localparam CLOCK_PERIOD = 10;
    localparam DATA_WIDTH   = 8;
    localparam DEPTH        = 16;
    localparam ADDR_WIDTH   = 4;

    // Testbench Signals
    reg                  i_clk;
    reg                  i_rst;
    reg                  i_wr_en;
    reg  [DATA_WIDTH-1:0] i_wr_data;
    reg                  i_rd_en;

    wire [DATA_WIDTH-1:0] o_rd_data;
    wire                  o_full;
    wire                  o_empty;

    // Instantiate the FIFO
    fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_wr_en(i_wr_en),
        .i_wr_data(i_wr_data),
        .i_rd_en(i_rd_en),
        .o_rd_data(o_rd_data),
        .o_full(o_full),
        .o_empty(o_empty)
    );

    // Clock Generation
    initial begin
        i_clk = 0;
        forever #(CLOCK_PERIOD / 2) i_clk = ~i_clk;
    end
    
    // Test Sequence
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_fifo);
        
        // 1. Reset the system
        i_rst = 1;
        i_wr_en = 0;
        i_rd_en = 0;
        i_wr_data = 8'h00;
        # (CLOCK_PERIOD * 5);
        i_rst = 0;
        $display("Time: %0t | --- FIFO Test Start ---", $time);
        
        // At start, FIFO should be empty
        #CLOCK_PERIOD;
        if (o_empty) $display("SUCCESS: FIFO is empty at start.");
        else $display("ERROR: FIFO is not empty at start.");
        
        // 2. Write 3 values
        $display("INFO: Writing 3 values...");
        i_wr_en = 1;
        for (int i = 0; i < 3; i++) begin
            i_wr_data = $random;
            #CLOCK_PERIOD;
        end
        i_wr_en = 0;

        // 3. Read 3 values and check them
        $display("INFO: Reading 3 values...");
        i_rd_en = 1;
        #CLOCK_PERIOD; // Wait one cycle for first data to appear
        for (int i = 0; i < 3; i++) begin
            $display("INFO: Read data 0x%h", o_rd_data);
            #CLOCK_PERIOD;
        end
        i_rd_en = 0;
        
        #CLOCK_PERIOD;
        if (o_empty) $display("SUCCESS: FIFO is empty after reading all values.");
        else $display("ERROR: FIFO is not empty after reading all values.");

        // 4. Fill the FIFO completely
        $display("INFO: Filling the FIFO...");
        i_wr_en = 1;
        for (int i = 0; i < DEPTH; i++) begin
            i_wr_data = i;
            #CLOCK_PERIOD;
        end
        i_wr_en = 0;
        
        #CLOCK_PERIOD;
        if (o_full) $display("SUCCESS: FIFO is full after writing 16 values.");
        else $display("ERROR: FIFO is not full after writing 16 values.");
        
        // 5. Try to write when full (should not work)
        $display("INFO: Attempting to write to a full FIFO...");
        i_wr_en = 1;
        i_wr_data = 8'hFF;
        #CLOCK_PERIOD;
        i_wr_en = 0;

        // 6. Read one value to make space
        $display("INFO: Reading one value to make space...");
        i_rd_en = 1;
        #CLOCK_PERIOD;
        $display("INFO: Read data 0x%h", o_rd_data); // Should be 0x00
        i_rd_en = 0;
        
        #CLOCK_PERIOD;
        if (!o_full) $display("SUCCESS: FIFO is no longer full.");
        else $display("ERROR: FIFO is still full.");
        
        $display("--- FIFO Test Complete ---");
        $finish;
    end

endmodule
