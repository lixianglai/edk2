#------------------------------------------------------------------------------
#
# Copyright (c) 2006, Intel Corporation
# All rights reserved. This program and the accompanying materials
# are licensed and made available under the terms and conditions of the BSD License
# which accompanies this distribution.  The full text of the license may be found at
# http://opensource.org/licenses/bsd-license.php
#
# THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
# WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
#
# Module Name:
#
#   DivU64x64Remainder.asm
#
# Abstract:
#
#   Calculate the quotient of a 64-bit integer by a 64-bit integer and returns
#   both the quotient and the remainder
#
#------------------------------------------------------------------------------



     

.extern _InternalMathDivRemU64x32

.global _InternalMathDivRemU64x64
_InternalMathDivRemU64x64: 
    movl    16(%esp),%ecx
    testl   %ecx,%ecx
    jnz     _DivRemU64x64
    movl    20(%esp),%ecx
    jecxz   L1
    and     $0,4(%ecx)
    movl    %ecx,16(%esp)
L1: 
    jmp     _InternalMathDivRemU64x32


.global DivRemU64x64
DivRemU64x64:
# MISMATCH: "DivRemU64x64:    USES    ebx esi edi"
    push   %ebx                                                                             
    push   %esi                                                                             
    push   %edi                                        
    mov     20(%esp), %edx
    mov     16(%esp), %eax
    movl    %edx,%edi
    movl    %eax,%esi
    mov     24(%esp), %ebx
L2: 
    shrl    %edx
    rcrl    $1,%eax
    shrdl   $1,%ecx,%ebx
    shrl    %ecx
    jnz     L2
    divl    %ebx
    movl    %eax,%ebx
    movl    28(%esp),%ecx
    mull    24(%esp)
    imull   %ebx,%ecx
    addl    %ecx,%edx
    mov     32(%esp), %ecx
    jc      TooLarge
    cmpl    %edx,%edi
    ja      Correct
    jb      TooLarge
    cmpl    %eax,%esi
    jae     Correct
TooLarge: 
    decl    %ebx
    jecxz   Return
    sub     24(%esp), %eax
    sbb     28(%esp), %edx
Correct: 
    jecxz   Return
    subl    %eax,%esi
    sbbl    %edx,%edi
    movl    %esi,(%ecx)
    movl    %edi,4(%ecx)
Return: 
    movl    %ebx,%eax
    xorl    %edx,%edx
    push   %edi                                        
    push   %esi                                                                             
    push   %ebx                                                                             
    ret
