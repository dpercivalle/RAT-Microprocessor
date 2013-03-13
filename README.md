RAT-Microprocessor
==================

RAT microprocessor implementation in VHDL for Spartan 3/3E FPGAs

This microprocessor was designed by previous students and current faculty at California Polytechnic University San Luis Obispo (Cal Poly).  Any use of the modules in this design must give credit to the university as well as the engineers listed in the headers of the source code.

This implementation of the RAT microprocessor was accomplished in the Winter quarter of 2013 (January 2013 - March 2013) as the main project of the CPE233 "Computer Design and Assembly Language Programming" course in the Computer Engineering Department at Cal Poly.

The RAT Microprocessor implements a Harvard Architecture and a hardware stack pointer.

This design of the RAT microprocessor was accomplished using a systematic approach to design the modules in an order that provided the shortest path to testing.  That is, the components were designed in the following order:
  
        1 - Program Counter  
        2 - Register File  
        4 - Scratch Pad  
        5 - ALU  
        6 - Control Unit  
        (at this point, minimal testing of the design could be accomplished)  
        7 - Stack Pointer  
        8 - Implementation of interrupts, altering control unit as necessary  

The VHDL sources provided in this repository are sufficient enough to drop the RAT_wrapper component in the top-level of a design requiring the use of the RAT microprocessor.

As a final note, if you are a student at Cal Poly SLO currently in CPE233, do not claim these sources as your own.  Not only is that plagerizing, but every professor implements the RAT design with their own modifications.  Using my soruces for your course section will most likely yield you an F.
