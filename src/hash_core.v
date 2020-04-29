
`define SHA256_H0 32'h6a09e667
`define SHA256_H1 32'hbb67ae85
`define SHA256_H2 32'h3c6ef372
`define SHA256_H3 32'ha54ff53a
`define SHA256_H4 32'h510e527f
`define SHA256_H5 32'h9b05688c
`define SHA256_H6 32'h1f83d9ab
`define SHA256_H7 32'h5be0cd19

`define K00 32'h428a2f98
`define K01 32'h71374491
`define K02 32'hb5c0fbcf
`define K03 32'he9b5dba5
`define K04 32'h3956c25b
`define K05 32'h59f111f1
`define K06 32'h923f82a4
`define K07 32'hab1c5ed5
`define K08 32'hd807aa98
`define K09 32'h12835b01
`define K10 32'h243185be
`define K11 32'h550c7dc3
`define K12 32'h72be5d74
`define K13 32'h80deb1fe
`define K14 32'h9bdc06a7
`define K15 32'hc19bf174
`define K16 32'he49b69c1
`define K17 32'hefbe4786
`define K18 32'h0fc19dc6
`define K19 32'h240ca1cc
`define K20 32'h2de92c6f
`define K21 32'h4a7484aa
`define K22 32'h5cb0a9dc
`define K23 32'h76f988da
`define K24 32'h983e5152
`define K25 32'ha831c66d
`define K26 32'hb00327c8
`define K27 32'hbf597fc7
`define K28 32'hc6e00bf3
`define K29 32'hd5a79147
`define K30 32'h06ca6351
`define K31 32'h14292967
`define K32 32'h27b70a85
`define K33 32'h2e1b2138
`define K34 32'h4d2c6dfc
`define K35 32'h53380d13
`define K36 32'h650a7354
`define K37 32'h766a0abb
`define K38 32'h81c2c92e
`define K39 32'h92722c85
`define K40 32'ha2bfe8a1
`define K41 32'ha81a664b
`define K42 32'hc24b8b70
`define K43 32'hc76c51a3
`define K44 32'hd192e819
`define K45 32'hd6990624
`define K46 32'hf40e3585
`define K47 32'h106aa070
`define K48 32'h19a4c116
`define K49 32'h1e376c08
`define K50 32'h2748774c
`define K51 32'h34b0bcb5
`define K52 32'h391c0cb3
`define K53 32'h4ed8aa4a
`define K54 32'h5b9cca4f
`define K55 32'h682e6ff3
`define K56 32'h748f82ee
`define K57 32'h78a5636f
`define K58 32'h84c87814
`define K59 32'h8cc70208
`define K60 32'h90befffa
`define K61 32'ha4506ceb
`define K62 32'hbef9a3f7
`define K63 32'hc67178f2

module hash_core(
        input   wire           clk,
        input   wire           reset,
        input   wire [31:0]    Wt,
        input   wire           inner_busy,
        input   wire           first_block_core,
        input   wire           output_enable,
        output  reg [3:0]      digest,
        output  reg            output_valid
                );
        
        wire [2:0] cmd;  //2:output_enable  1:inner_busy    0:first round
        reg  [31:0] A,B,C,D,E,F,G,H;
        reg  [31:0] H0,H1,H2,H3,H4,H5,H6,H7;
        reg  [6:0] round;
        wire [6:0] round_plus_1;

        reg [5:0] read_counter;

        reg [31:0] Kt;

        wire [31:0] f1_EFG_32,f2_ABC_32,f3_A_32,f4_E_32,T1_32,T2_32;
        wire [31:0] next_E,next_A;
        wire [255:0] SHA256_result;
        
        assign f1_EFG_32 = (E & F) ^ (~E & G);  //CH(e,f,g)

        assign f2_ABC_32 = (A & B) ^ (B & C) ^ (A & C);  //MAJ(a,b,c)
        
        assign f3_A_32 = {A[1:0],A[31:2]} ^ {A[12:0],A[31:13]} ^ {A[21:0],A[31:22]};  //sigma0(a)
        
        assign f4_E_32 = {E[5:0],E[31:6]} ^ {E[10:0],E[31:11]} ^ {E[24:0],E[31:25]};  //sigma1(e)
         
        assign T1_32 = H[31:0] + f4_E_32 + f1_EFG_32 + Kt + Wt;
        
        assign T2_32 = f3_A_32 + f2_ABC_32;

        assign next_E = D[31:0] + T1_32;
        assign next_A = T1_32 + T2_32;
        
        assign SHA256_result = {A,B,C,D,E,F,G,H};

        assign cmd = {output_enable,inner_busy,first_block_core};
        
        assign round_plus_1 = (cmd[1]==1) ? (round + 1) : round;
        
        //------------------------------------------------------------------    
        // SHA round
        //------------------------------------------------------------------
        always @(posedge clk)
        begin
                if (reset == 1'b1 || (cmd[1] == 1'b0 && cmd[2] == 1'b0) )
                begin
                        round <= 'd0;
                        
                        A <= 32'b0;
                        B <= 32'b0;
                        C <= 32'b0;
                        D <= 32'b0;
                        E <= 32'b0;
                        F <= 32'b0;
                        G <= 32'b0;
                        H <= 32'b0;

                        H0 <= 32'b0;
                        H1 <= 32'b0;
                        H2 <= 32'b0;
                        H3 <= 32'b0;
                        H4 <= 32'b0;
                        H5 <= 32'b0;
                        H6 <= 32'b0;
                        H7 <= 32'b0;
                end
                else
                        if(cmd[2] == 1'b1)
                        begin
                                A <= A;
                                B <= B;
                                C <= C; 
                                D <= D;
                                E <= E;
                                F <= F;
                                G <= G;
                                H <= H;

                                H0 <= H0;
                                H1 <= H1;
                                H2 <= H2;
                                H3 <= H3;
                                H4 <= H4;
                                H5 <= H5;
                                H6 <= H6;
                                H7 <= H7;

                                round <= 'd0;                                                                                               
                        end
                        else
                        begin
                                case (round)
                        
                                'd0:
                                        begin            
                                                if(first_block_core==1'b1) // sha-256 first message
                                                begin
                                                        A <= `SHA256_H0;
                                                        B <= `SHA256_H1;
                                                        C <= `SHA256_H2;
                                                        D <= `SHA256_H3;
                                                        E <= `SHA256_H4;
                                                        F <= `SHA256_H5;
                                                        G <= `SHA256_H6;
                                                        H <= `SHA256_H7;

                                                        H0 <= `SHA256_H0;
                                                        H1 <= `SHA256_H1;
                                                        H2 <= `SHA256_H2;
                                                        H3 <= `SHA256_H3;
                                                        H4 <= `SHA256_H4;
                                                        H5 <= `SHA256_H5;
                                                        H6 <= `SHA256_H6;
                                                        H7 <= `SHA256_H7;

                                                        round <=round_plus_1;
                                                end
                                                else   // sha-256 internal message
                                                begin
                                                        A <= A;
                                                        B <= B;
                                                        C <= C; 
                                                        D <= D;
                                                        E <= E;
                                                        F <= F;
                                                        G <= G;
                                                        H <= H;

                                                        H0 <= A;
                                                        H1 <= B;
                                                        H2 <= C;
                                                        H3 <= D;
                                                        H4 <= E;
                                                        H5 <= F;
                                                        H6 <= G;
                                                        H7 <= H;

                                                        round <=round_plus_1;
                                                end
                                        end
                                        
                                'd1,
                                'd2,
                                'd3,
                                'd4,
                                'd5,
                                'd6,
                                'd7,
                                'd8,
                                'd9,
                                'd10,
                                'd11,
                                'd12,
                                'd13,
                                'd14,
                                'd15,
                                'd16,
                                'd17,
                                'd18,
                                'd19,
                                'd20,
                                'd21,
                                'd22,
                                'd23,
                                'd24,
                                'd25,
                                'd26,
                                'd27,
                                'd28,
                                'd29,
                                'd30,
                                'd31,
                                'd32,
                                'd33,
                                'd34,
                                'd35,
                                'd36,
                                'd37,
                                'd38,
                                'd39,
                                'd40,
                                'd41,
                                'd42,
                                'd43,
                                'd44,
                                'd45,
                                'd46,
                                'd47,
                                'd48,
                                'd49,
                                'd50,
                                'd51,
                                'd52,
                                'd53,
                                'd54,
                                'd55,
                                'd56,
                                'd57,
                                'd58,
                                'd59,
                                'd60,
                                'd61,
                                'd62,
                                'd63:
                                        begin
                                                
                                                H <= G;
                                                G <= F;
                                                F <= E;
                                                E <= next_E;
                                                D <= C;
                                                C <= B;
                                                B <= A;
                                                A <= next_A;

                                                H0 <= H0;
                                                H1 <= H1;
                                                H2 <= H2;
                                                H3 <= H3;
                                                H4 <= H4;
                                                H5 <= H5;
                                                H6 <= H6;
                                                H7 <= H7;
                                                
                                                round <= round_plus_1;
                                        end
                                'd64:
                                        begin   //update hash_val 
                                                A <= next_A + H0;
                                                B <= A + H1;
                                                C <= B + H2;
                                                D <= C + H3;
                                                E <= next_E + H4;
                                                F <= E + H5;
                                                G <= F + H6;
                                                H <= G + H7;

                                                H0 <= H0;
                                                H1 <= H1;
                                                H2 <= H2;
                                                H3 <= H3;
                                                H4 <= H4;
                                                H5 <= H5;
                                                H6 <= H6;
                                                H7 <= H7;

                                                round <= 'd0;
                                        
                                        end
                                default:
                                        begin
                                                A <= 'b0;
                                                B <= 'b0;
                                                C <= 'b0;
                                                D <= 'b0;
                                                E <= 'b0;
                                                F <= 'b0;
                                                G <= 'b0;
                                                H <= 'b0;

                                                H0 <= 'b0;
                                                H1 <= 'b0;
                                                H2 <= 'b0;
                                                H3 <= 'b0;
                                                H4 <= 'b0;
                                                H5 <= 'b0;
                                                H6 <= 'b0;
                                                H7 <= 'b0;

                                                round <= 'd0;
                                        end
                                endcase
                        end     
        end 
        
        
        //------------------------------------------------------------------    
        // Kt generator
        //------------------------------------------------------------------    
        always @ (posedge clk)
        begin
                if (reset)
                begin
                        Kt <= 'b0;
                end
                else
                begin
                if(cmd[1]==1'b1)
                begin
                        case (round)
                                'd00:   Kt <= `K00;
                                'd01:   Kt <= `K01;
                                'd02:   Kt <= `K02;
                                'd03:   Kt <= `K03;
                                'd04:   Kt <= `K04;
                                'd05:   Kt <= `K05;
                                'd06:   Kt <= `K06;
                                'd07:   Kt <= `K07;
                                'd08:   Kt <= `K08;
                                'd09:   Kt <= `K09;
                                'd10:   Kt <= `K10;
                                'd11:   Kt <= `K11;
                                'd12:   Kt <= `K12;
                                'd13:   Kt <= `K13;
                                'd14:   Kt <= `K14;
                                'd15:   Kt <= `K15;
                                'd16:   Kt <= `K16;
                                'd17:   Kt <= `K17;
                                'd18:   Kt <= `K18;
                                'd19:   Kt <= `K19;
                                'd20:   Kt <= `K20;
                                'd21:   Kt <= `K21;
                                'd22:   Kt <= `K22;
                                'd23:   Kt <= `K23;
                                'd24:   Kt <= `K24;
                                'd25:   Kt <= `K25;
                                'd26:   Kt <= `K26;
                                'd27:   Kt <= `K27;
                                'd28:   Kt <= `K28;
                                'd29:   Kt <= `K29;
                                'd30:   Kt <= `K30;
                                'd31:   Kt <= `K31;
                                'd32:   Kt <= `K32;
                                'd33:   Kt <= `K33;
                                'd34:   Kt <= `K34;
                                'd35:   Kt <= `K35;
                                'd36:   Kt <= `K36;
                                'd37:   Kt <= `K37;
                                'd38:   Kt <= `K38;
                                'd39:   Kt <= `K39;
                                'd40:   Kt <= `K40;
                                'd41:   Kt <= `K41;
                                'd42:   Kt <= `K42;
                                'd43:   Kt <= `K43;
                                'd44:   Kt <= `K44;
                                'd45:   Kt <= `K45;
                                'd46:   Kt <= `K46;
                                'd47:   Kt <= `K47;
                                'd48:   Kt <= `K48;
                                'd49:   Kt <= `K49;
                                'd50:   Kt <= `K50;
                                'd51:   Kt <= `K51;
                                'd52:   Kt <= `K52;
                                'd53:   Kt <= `K53;
                                'd54:   Kt <= `K54;
                                'd55:   Kt <= `K55;
                                'd56:   Kt <= `K56;
                                'd57:   Kt <= `K57;
                                'd58:   Kt <= `K58;
                                'd59:   Kt <= `K59;
                                'd60:   Kt <= `K60;
                                'd61:   Kt <= `K61;
                                'd62:   Kt <= `K62;
                                'd63:   Kt <= `K63;
                                default:Kt <= 'd0;
                        endcase
                end
                else
                begin
                        Kt <= 'd0;
                end
                end
        end

        //------------------------------------------------------------------    
        // read digest 
        //------------------------------------------------------------------    
        always @ (posedge clk)
        begin
                if (reset)
                begin
                        digest <= 'b0;
                        read_counter <= 'd63;
                        output_valid <= 1'b0;
                end
                else
                begin
                        if (cmd[2])
                        begin
                                output_valid <= 1'b1;
                                case (read_counter)
                                        'd63:    digest <= SHA256_result[64*4-1:63*4];
                                        'd62:    digest <= SHA256_result[63*4-1:62*4];
                                        'd61:    digest <= SHA256_result[62*4-1:61*4];
                                        'd60:    digest <= SHA256_result[61*4-1:60*4];
                                        'd59:    digest <= SHA256_result[60*4-1:59*4];
                                        'd58:    digest <= SHA256_result[59*4-1:58*4];
                                        'd57:    digest <= SHA256_result[58*4-1:57*4];
                                        'd56:    digest <= SHA256_result[57*4-1:56*4];
                                        'd55:    digest <= SHA256_result[56*4-1:55*4];
                                        'd54:    digest <= SHA256_result[55*4-1:54*4];
                                        'd53:    digest <= SHA256_result[54*4-1:53*4];
                                        'd52:    digest <= SHA256_result[53*4-1:52*4];
                                        'd51:    digest <= SHA256_result[52*4-1:51*4];
                                        'd50:    digest <= SHA256_result[51*4-1:50*4];
                                        'd49:    digest <= SHA256_result[50*4-1:49*4];
                                        'd48:    digest <= SHA256_result[49*4-1:48*4];
                                        'd47:    digest <= SHA256_result[48*4-1:47*4];
                                        'd46:    digest <= SHA256_result[47*4-1:46*4];
                                        'd45:    digest <= SHA256_result[46*4-1:45*4];
                                        'd44:    digest <= SHA256_result[45*4-1:44*4];
                                        'd43:    digest <= SHA256_result[44*4-1:43*4];
                                        'd42:    digest <= SHA256_result[43*4-1:42*4];
                                        'd41:    digest <= SHA256_result[42*4-1:41*4];
                                        'd40:    digest <= SHA256_result[41*4-1:40*4];
                                        'd39:    digest <= SHA256_result[40*4-1:39*4];
                                        'd38:    digest <= SHA256_result[39*4-1:38*4];
                                        'd37:    digest <= SHA256_result[38*4-1:37*4];
                                        'd36:    digest <= SHA256_result[37*4-1:36*4];
                                        'd35:    digest <= SHA256_result[36*4-1:35*4];
                                        'd34:    digest <= SHA256_result[35*4-1:34*4];
                                        'd33:    digest <= SHA256_result[34*4-1:33*4];
                                        'd32:    digest <= SHA256_result[33*4-1:32*4];
                                        'd31:    digest <= SHA256_result[32*4-1:31*4];
                                        'd30:    digest <= SHA256_result[31*4-1:30*4];
                                        'd29:    digest <= SHA256_result[30*4-1:29*4];
                                        'd28:    digest <= SHA256_result[29*4-1:28*4];
                                        'd27:    digest <= SHA256_result[28*4-1:27*4];
                                        'd26:    digest <= SHA256_result[27*4-1:26*4];
                                        'd25:    digest <= SHA256_result[26*4-1:25*4];
                                        'd24:    digest <= SHA256_result[25*4-1:24*4];
                                        'd23:    digest <= SHA256_result[24*4-1:23*4];
                                        'd22:    digest <= SHA256_result[23*4-1:22*4];
                                        'd21:    digest <= SHA256_result[22*4-1:21*4];
                                        'd20:    digest <= SHA256_result[21*4-1:20*4];
                                        'd19:    digest <= SHA256_result[20*4-1:19*4]; 
                                        'd18:    digest <= SHA256_result[19*4-1:18*4];
                                        'd17:    digest <= SHA256_result[18*4-1:17*4];
                                        'd16:    digest <= SHA256_result[17*4-1:16*4];
                                        'd15:    digest <= SHA256_result[16*4-1:15*4];
                                        'd14:    digest <= SHA256_result[15*4-1:14*4];
                                        'd13:    digest <= SHA256_result[14*4-1:13*4];
                                        'd12:    digest <= SHA256_result[13*4-1:12*4];
                                        'd11:    digest <= SHA256_result[12*4-1:11*4];
                                        'd10:    digest <= SHA256_result[11*4-1:10*4];
                                        'd9:    digest <= SHA256_result[10*4-1:9*4];
                                        'd8:    digest <= SHA256_result[9*4-1:8*4];
                                        'd7:    digest <= SHA256_result[8*4-1:7*4];
                                        'd6:    digest <= SHA256_result[7*4-1:6*4];
                                        'd5:    digest <= SHA256_result[6*4-1:5*4];
                                        'd4:    digest <= SHA256_result[5*4-1:4*4];
                                        'd3:    digest <= SHA256_result[4*4-1:3*4];
                                        'd2:    digest <= SHA256_result[3*4-1:2*4];
                                        'd1:    digest <= SHA256_result[2*4-1:1*4];
                                        'd0:    digest <= SHA256_result[1*4-1:0*4];
                                        default:digest <= 'b0;
                                endcase
                                if (read_counter != 'd0)
                                        read_counter <= read_counter - 'd1;
                                else
                                        read_counter <= 'd63;
                        end
                        else
                        begin
                                digest <= 'b0;
                                read_counter <= 'd63;
                                output_valid <= 1'b0;
                        end
                end
        end
        
endmodule
