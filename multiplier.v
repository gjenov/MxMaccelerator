`timescale 1ns/10ps

// Add HOLD
module MAC4
(
    input  signed [7:0] dataa,
    input  signed [7:0] datab,
    input  clk, clr, hold,
    output reg signed [18:0] out
);

    wire signed [15:0] int_product = dataa * datab;

    always @(posedge clk) begin
        if (clr) begin
            out <= 19'd0;  
        end else if(!hold) begin
            out <= out + int_product;
        end
    end

endmodule


//RAM module
module RAM64x8_A_DUAL(
    input signed [7:0] data_in,
    input  [5:0] addr_a,
    input  [5:0] addr_b,
    input  write_enable,
    input  CLK,
    output reg [7:0] data_out_a, data_out_b
);

reg signed [7:0] memory [0:63];
initial begin
    $readmemb("ram_a_init.txt", memory);
end

always @ (posedge CLK) begin
    if (write_enable) memory[addr_a] <= data_in; //write mem
    data_out_a <= memory[addr_a]; // read mem
    data_out_b <= memory[addr_b]; // read mem
end

endmodule





module RAM64x8_B(
    input signed [7:0] data_in,
    input  [5:0] addr,
    input  write_enable,
    input  CLK,
    output reg [7:0] data_out


);

reg signed [7:0] memory [0:63];
initial begin
    $readmemb("ram_b_init.txt", memory);
end

always @ (posedge CLK) begin
    if (write_enable) memory[addr] <= data_in; //write mem
    data_out <= memory[addr]; // read mem
end

endmodule


module RAM_OUT(
    input  signed [18:0] data_in,
    input  [5:0] addr,
    input  write_enable,
    input  CLK,
    output reg signed [18:0] data_out
);

reg signed [18:0] mem [63:0];

always @ (posedge CLK) begin
    if (write_enable) mem[addr] <= data_in; //write mem
    data_out <= mem[addr]; // read mem
end


endmodule



module multiplier(
    input CLK, RST, START,
    output reg DONE,
    output reg [10:0] clock_count
);

    // Outputs from A&B RAM
    wire signed [7:0]  data_b, data_a_a, data_a_b, data_a_c, data_a_d, data_a_e, data_a_f, data_a_g, data_a_h;
    
    reg [5:0] addr_b, addr_a_a, addr_a_b, addr_a_c, addr_a_d, addr_a_e, addr_a_f, addr_a_g, addr_a_h;
    reg [5:0] addr_out;

    reg write_enable_out, write_enable_out_delayed;

    wire signed [18:0] mac_out1, mac_out2, mac_out3, mac_out4, mac_out5, mac_out6, mac_out7, mac_out8;
    reg signed [18:0] buffer;
    reg macc_clear, hold;
    
    RAM64x8_A_DUAL RAM_A1 (
        .data_in(8'd0),
        .addr_a(addr_a_a),
        .addr_b(addr_a_b),
        .write_enable(1'b0),
        .CLK(CLK),
        .data_out_a(data_a_a),
        .data_out_b(data_a_b)
    );
    RAM64x8_A_DUAL RAM_A2 (
        .data_in(8'd0),
        .addr_a(addr_a_c),
        .addr_b(addr_a_d),
        .write_enable(1'b0),
        .CLK(CLK),
        .data_out_a(data_a_c),
        .data_out_b(data_a_d)
    );
    RAM64x8_A_DUAL RAM_A3 (
        .data_in(8'd0),
        .addr_a(addr_a_e),
        .addr_b(addr_a_f),
        .write_enable(1'b0),
        .CLK(CLK),
        .data_out_a(data_a_e),
        .data_out_b(data_a_f)
    );
    RAM64x8_A_DUAL RAM_A4 (
        .data_in(8'd0),
        .addr_a(addr_a_g),
        .addr_b(addr_a_h),
        .write_enable(1'b0),
        .CLK(CLK),
        .data_out_a(data_a_g),
        .data_out_b(data_a_h)
    );
    
    
    RAM64x8_B RAM_B (
        .data_in(8'd0),
        .addr(addr_b),
        .write_enable(1'b0),
        .CLK(CLK),
        .data_out(data_b)
    );


    

    //delayed by one because dual ported
    RAM_OUT RAMOUTPUT (
        .data_in(buffer),
        .addr(addr_out),
        .write_enable(write_enable_out_delayed),
        .CLK(CLK),
        .data_out()
    );



    MAC4 Mac1 (
        .dataa(data_a_a),
        .datab(data_b),
        .clk(CLK),
        .hold(hold),
        .clr(macc_clear),
        .out(mac_out1)
    );
    MAC4 Mac2 (
        .dataa(data_a_b),
        .datab(data_b),
        .clk(CLK),
        .hold(hold),
        .clr(macc_clear),
        .out(mac_out2)
    );
    MAC4 Mac3 (
        .dataa(data_a_c),
        .datab(data_b),
        .clk(CLK),
        .hold(hold),
        .clr(macc_clear),
        .out(mac_out3)
    );
    MAC4 Mac4 (
        .dataa(data_a_d),
        .datab(data_b),
        .clk(CLK),
        .hold(hold),
        .clr(macc_clear),
        .out(mac_out4)
    );
    MAC4 Mac5 (
        .dataa(data_a_e),
        .datab(data_b),
        .clk(CLK),
        .hold(hold),
        .clr(macc_clear),
        .out(mac_out5)
    );
    MAC4 Mac6 (
        .dataa(data_a_f),
        .datab(data_b),
        .clk(CLK),
        .hold(hold),
        .clr(macc_clear),
        .out(mac_out6)
    );
    MAC4 Mac7 (
        .dataa(data_a_g),
        .datab(data_b),
        .clk(CLK),
        .hold(hold),
        .clr(macc_clear),
        .out(mac_out7)
    );
    MAC4 Mac8 (
        .dataa(data_a_h),
        .datab(data_b),
        .clk(CLK),
        .hold(hold),
        .clr(macc_clear),
        .out(mac_out8)
    );



    localparam LOAD = 4'd0,
               NEXT = 4'd1,
               DONE_STATE = 4'd2,
                WAIT = 4'd3,
               WRITE1 = 4'd4,
                WRITE2 = 4'd5,
                WRITE3 = 4'd6,
                WRITE4 = 4'd7,
                WRITE5 = 4'd8,
                WRITE6 = 4'd9,
                WRITE7 = 4'd10,
                WRITE8 = 4'd11;
 

    reg [3:0] state, next_state;
    reg [3:0] i, j, k;
    reg [3:0] next_i, next_j, next_k;


    always @(posedge CLK) begin
        write_enable_out_delayed <= write_enable_out;
    end


    always @(posedge CLK) begin
        if(DONE == 0) begin
            clock_count <= clock_count + 1;
        end
        
        //write_enable_out_delayed <= write_enable_out;
        if (RST) begin
            state <= LOAD;
            DONE <= 0;
            clock_count <= 0;
            i <= 0;
            j <= 0;
            k <= 0;
            write_enable_out <= 0;
            macc_clear <= 1;
            addr_a_a <= 0;
            addr_a_b <= 0;
            addr_a_c <= 0;
            addr_a_d <= 0;
            addr_a_e <= 0;
            addr_a_f <= 0;
            addr_a_g <= 0;
            addr_a_h <= 0;
            addr_b <= 0;
            addr_out <= 0;
            hold<=0;

        end else begin 
            case (state)
                LOAD: begin
                    //write_enable_out <= 0;
                    //mac clear
                    //write_enable_out <= 0;
                    macc_clear <= (k == 0) ? 1 : 0;

                    if (k < 8) begin
                        state <= LOAD;
                        addr_a_a <= 0 + k*8;
                        addr_a_b <= 1 + k*8;
                        addr_a_c <= 2 + k*8;
                        addr_a_d <= 3 + k*8;
                        addr_a_e <= 4 + k*8;
                        addr_a_f <= 5 + k*8;
                        addr_a_g <= 6 + k*8;
                        addr_a_h <= 7 + k*8;

                        addr_b <= k + j*8;
                        k <= k + 1;
                    end else begin
                        state <= WAIT;
                        addr_out <= 0 + j*8;
                        
                        k <= 0;
                    end
                end
                WAIT: begin
                    hold <= 1;
                    state <= WRITE1;
                    //addr_out <= i + j*8;
                    write_enable_out <= 1;
                end
                WRITE1: begin
                    buffer <= mac_out1;
                    addr_out <= addr_out;
                    state <= WRITE2;
                end
                WRITE2: begin
                    buffer <= mac_out2;
                    addr_out <= 1 + j*8;
                    state <= WRITE3;
                end
                WRITE3: begin
                    buffer <= mac_out3;
                    addr_out <= 2 + j*8;
                    state <= WRITE4;
                end
                WRITE4: begin
                    buffer <= mac_out4;
                    addr_out <= 3 + j*8;
                    state <= WRITE5;
                end
                WRITE5: begin
                    buffer <= mac_out5;
                    addr_out <= 4 + j*8;
                    state <= WRITE6;
                end
                WRITE6: begin
                    buffer <= mac_out6;
                    addr_out <= 5 + j*8;
                    state <= WRITE7;
                end
                WRITE7: begin
                    buffer <= mac_out7;
                    addr_out <= 6 + j*8;
                    state <= WRITE8;
                end
                WRITE8: begin
                    buffer <= mac_out8;
                    addr_out <= 7 + j*8;
                    state <= NEXT;
                    hold <= 0;
                    write_enable_out <= 0;
                end


                //add write and hold off on last
                NEXT: begin
                    
                    macc_clear <= 1;

                    if (j == 7) begin
                        state <= DONE_STATE;
                        DONE <= 1;

                    end else begin
                        j <= j + 1;
                        state <= LOAD;
                    end
                end
                DONE_STATE: begin
                    DONE <= 1;
                    write_enable_out <= 0;
                    macc_clear <= 1;
                    state <= DONE_STATE;
                    next_i <= 0;
                    next_j <= 0;
                    next_k <= 0;
                end
            endcase
        end
    end

always @(posedge CLK) begin

    $display("mac_out1: %d, mac_out2: %d, write_enable_out: %d, Buffer: %d, STATE: %d", mac_out1, mac_out2, write_enable_out, buffer, state);
    end


endmodule