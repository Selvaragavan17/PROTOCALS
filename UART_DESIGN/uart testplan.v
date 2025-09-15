TC1 – Reset Test

Feature: Reset functionality

Objective: Verify UART resets correctly.

Steps:

Apply reset (nUARTRST = 0).

Release reset (nUARTRST = 1).

Read all status registers (TX FIFO status, RX FIFO status, interrupt flags).

Expected Result:

TX FIFO empty.

RX FIFO empty.

All status flags cleared.

UART returns to default register values.

TC2 – Basic Transmit Test

Feature: Transmit path

Objective: Verify UART can transmit a single byte.

Steps:

Write 0x55 (or any byte) into TX FIFO via APB.

Monitor UARTTXD pin with a waveform analyzer.

Expected Result:

Serial waveform matches UART frame format (start bit, data, stop bit).

Data correctly transmitted.

TC3 – Basic Receive Test

Feature: Receive path

Objective: Verify UART receives data correctly.

Steps:

Drive a valid UART frame (start bit + 8 data bits + stop bit) on UARTRXD.

Read RX FIFO through APB.

Expected Result:

Received data in RX FIFO matches transmitted data.

Status flags show valid data received.

TC4 – Transmit FIFO Test

Feature: TX FIFO

Objective: Verify transmit FIFO buffering.

Steps:

Write 10 bytes sequentially into TX FIFO.

Monitor UARTTXD.

Expected Result:

All 10 bytes transmitted in correct order.

No data loss or corruption.

FIFO empty flag updates correctly after last byte.

TC5 – Receive FIFO Test

Feature: RX FIFO

Objective: Verify receive FIFO buffering.

Steps:

Send 10 UART frames into UARTRXD.

Read 10 bytes from RX FIFO via APB.

Expected Result:

Data read matches transmitted data.

FIFO depth decreases correctly as bytes are read.

TC6 – Baud Rate Test

Feature: Baud rate generator

Objective: Verify correct baud rate generation.

Steps:

Program divisor for 9600 baud.

Transmit a byte.

Measure bit period on UARTTXD with a timer.

Expected Result:

Bit period = ~104.16 µs (for 9600 baud).

Matches expected baud rate within tolerance.

TC7 – Interrupt Test

Feature: Interrupt generation

Objective: Verify interrupt signaling.

Steps:

Enable TX and RX interrupts in UART registers.

Fill RX FIFO until threshold is reached.

Let TX FIFO empty completely.

Expected Result:

RX interrupt triggered when FIFO reaches threshold.

TX interrupt triggered when FIFO becomes empty.

TC8 – Error Handling Test

Feature: Error detection

Objective: Verify UART error flags.

Steps:

Send a frame with incorrect parity.

Send a frame with missing stop bit (framing error).

Hold line low longer than a frame (break condition).

Expected Result:

Data stored in RX FIFO.

Parity error, framing error, and break error flags set correctly.

TC9 – Loopback Test

Feature: End-to-end validation

Objective: Verify TX→RX loop.

Steps:

Connect UARTTXD to UARTRXD.

Send 20 bytes through TX FIFO.

Read from RX FIFO.

Expected Result:

Data received matches transmitted data.

No corruption or loss.

TC10 – FIFO Overflow Test

Feature: RX FIFO overflow

Objective: Verify FIFO overrun handling.

Steps:

Continuously send 40 bytes into UARTRXD without reading.

Expected Result:

First 32 bytes stored in RX FIFO.

Remaining bytes discarded.

Overrun error flag set.

TC11 – FIFO Underflow Test

Feature: TX FIFO underflow

Objective: Verify behavior when FIFO is empty.

Steps:

Try to read from RX FIFO when empty.

Observe TX when FIFO has no data.

Expected Result:

RX returns no data, empty flag set.

TX line remains idle until new data written.

TC12 – Parity Enable Test

Feature: Parity control

Objective: Verify parity generation/check.

Steps:

Configure UART for even parity.

Transmit 8 bytes.

Receive with matching parity enabled.

Expected Result:

Data correct, no parity errors.

Changing to odd parity gives correct results.

TC13 – Stop Bit Test

Feature: Stop bit configuration

Objective: Verify stop bit handling.

Steps:

Configure for 1 stop bit. Send/receive data.

Reconfigure for 2 stop bits. Send/receive data.

Expected Result:

Waveform matches stop-bit configuration.

Data received correctly in both cases.

TC14 – DMA Request Test

Feature: DMA interface

Objective: Verify DMA handshake.

Steps:

Enable DMA request in UART.

Fill TX FIFO until threshold reached.

Monitor DMA request signal.

Expected Result:

DMA request asserted when threshold met.

DMA clears once FIFO serviced.

TC15 – Break Detection Test

Feature: Break detection

Objective: Verify UART break condition handling.

Steps:

Drive RX line low longer than 1 frame duration.

Read status register.

Expected Result:

Break flag asserted.

Normal operation resumes after break removed.

TC16 – False Start Bit Test

Feature: Noise filtering

Objective: Verify rejection of glitches.

Steps:

Drive a short low pulse (< 1 bit time) on RX.

Observe RX FIFO.

Expected Result:

Data not captured.

No error flagged.

TC17 – Modem Control Test

Feature: Flow control

Objective: Verify modem signals (RTS/CTS, DTR/DSR).

Steps:

Enable RTS/CTS flow control.

Drive CTS low (not ready).

Try transmitting data.

Release CTS high.

Expected Result:

Transmission pauses when CTS low.

Resumes when CTS high.
