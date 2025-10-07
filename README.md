# FIFO-Memory-Buffer-project

## 2. Synchronous FIFO Memory Buffer

### Project Summary
This project is a Verilog implementation of a synchronous **FIFO (First-In, First-Out)** memory buffer. A FIFO is a crucial component in digital systems used to safely pass data between two modules that may operate at different speeds, preventing data loss. It acts like a pipeline, ensuring that the first piece of data written into the buffer is the first piece of data to be read out.

This project demonstrates an understanding of:
* Memory (register array) design.
* Read and write pointer management.
* Boundary condition logic (full and empty detection).
* Verifying memory systems with a robust testbench.

### Features
* **Depth:** 16 entries (configurable)
* **Data Width:** 8 bits (configurable)
* **Status Flags:** `o_full` and `o_empty` flags to signal the FIFO's state.
* **Verification:** The testbench verifies all key functionalities:
    * Simple write and read operations.
    * Correct assertion of the `o_empty` flag at the start and after being emptied.
    * Correct assertion of the `o_full` flag after being filled completely.
    * Prevention of writes when the FIFO is full.

### Simulation Waveform
This screenshot from the EPWave simulation shows the FIFO being filled. You can see the `r_wr_ptr` and `r_count` incrementing with each clock cycle until `r_count` reaches 16, at which point the `o_full` flag asserts.

<img width="1887" height="835" alt="Screenshot 2025-10-08 012812" src="https://github.com/user-attachments/assets/f123477b-c37e-46b2-99b2-c46e011ce643" />


*Note: To add the image, take a screenshot of your working waveform, upload it to a `fifo/` folder in your repository, and then update the file path above.*

### Live Simulation
 view the code and run the simulation live on EDA Playground using the following link:

https://www.edaplayground.com/x/Kkct

---
