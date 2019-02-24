TITLE Programming Assignment #2     (Program02.asm)

; Author: Jordan Hamilton
; Last Modified: 01/27/2019
; OSU email address: hamiltj2@oregonstate.edu
; Course number/section: CS271-400
; Project Number: 2               Due Date: 01/27/2019
; Description: This program will introduce the programmer, prompt the user to enter his or her name,
; then greet the user. Then, the user is prompted to enter an integer between 1 and 46 representing 
; then number of Fibonacci numbers they'd like to display. The prompt is repeated until a valid
; entry is detected. The requested number of Fibonacci numbers is then output to the screen.

INCLUDE Irvine32.inc

LOWERLIMIT          EQU       1
UPPERLIMIT          EQU       46
NAMELENGTH          EQU       48
NUMBERSPERLINE      EQU       5

.data

intro               BYTE      "Programming assignment #2 by Jordan Hamilton",0
nameGreeting        BYTE      "Hey there, ",0
nameIn              BYTE      NAMELENGTH+1 DUP (?)
namePrompt          BYTE      "What's your name? ",0

fibonacciInfo       BYTE      "Enter the number of Fibonacci terms you'd like to display below.",0
fibonacciNote       BYTE      "Note: You must enter an integer greater than 0 and less than 47 to display the results.",0
fibonacciPrompt     BYTE      "How many Fibonacci terms would you like to display? ",0
fibonacciRetry      BYTE      "Your entry wasn't valid. Please try again: ",0

outputSpacing       BYTE      "     ",0
numbersPrinted      DWORD     0

fibonacciNumbers    DWORD     ?
prevNumber          DWORD     0
nextNumber          DWORD     0

farewellMessage     BYTE      "Take care, ",0

.code

main PROC

; Display an introduction

     ; Introduce the programmer
     mov       edx, OFFSET intro
     call      WriteString
     call      Crlf
     
     ; Prompt the user to enter the name, then store it in nameIn
     mov       edx, OFFSET namePrompt
     call      WriteString
     mov       edx, OFFSET nameIn
     mov       ecx, NAMELENGTH
     call      ReadString
     
     ; Greet the user
     mov       edx, OFFSET nameGreeting
     call      WriteString
     mov       edx, OFFSET nameIn
     call      WriteString
     call      Crlf

; Display instructions to the user on valid data input
     mov       edx, OFFSET fibonacciInfo
     call      WriteString
     call      Crlf
     mov       edx, OFFSET fibonacciNote
     call      WriteString
     call      Crlf

; Get an integer from the user
     
     ; Prompt for a number then verify that number is in the valid range. Jump to badInput if out of range, or goodInput when in range
     mov       edx, OFFSET fibonacciPrompt
     call      WriteString
     call      ReadDec
     cmp       eax, LOWERLIMIT
     jl        badInput
     cmp       eax, UPPERLIMIT
     jg        badInput
     jmp       goodInput

     ; Inform the user if the entered number wasn't in range, then continue prompting until the entry is in range
     badInput:
          mov       edx, OFFSET fibonacciRetry
          call      WriteString
          call      ReadDec
          cmp       eax, LOWERLIMIT
          jl       badInput
          cmp       eax, UPPERLIMIT
          jg        badInput
     
     ; Store the user's number in fibonacciNumber once it's in the correct range
     goodInput:
          mov       fibonacciNumbers, eax

; Display Fibonacci numbers in a loop

     ; Set the  loop counter to the user's entered number
     mov       ecx, fibonacciNumbers
     mov       eax, 1

     
     displayResults:

          ; Output the number in eax to the screen, then increment the variable for the number of Fiboncci numbers we've printed while looping
          call      WriteDec
          inc       numbersPrinted

          ; Move the previous Fibonacci number to the ebx register
          ; Set the previous number to the number that's currently in eax
          ; Add the previous number to the current number to get the next Fibonacci number in the eax register
          ; Store the next Fibonacci number in the nextNumber variable temporarily so we can perform division operations
          mov       ebx, prevNumber
          mov       prevNumber, eax
          add       eax, ebx
          mov       nextNumber, eax

          ; Move the nymber of lines we've printed to the eax register, then divide by the number of Fibonacci numbers per line
          ; If there's no remainder, print a new line, otherwise, print spacing
          mov       eax, numbersPrinted
          mov       ebx, NUMBERSPERLINE
          mov       edx, 0
          div       ebx
          cmp       edx, 0
          jne       spacing
          
          ; If we just printed the 5th number on a line, only move to a new line without printing spaces
          call      Crlf
          jmp       endFormatting
          
          ; Print the output spacing after printing the Fibonacci number, only if we haven't moved to a new line
          spacing:
               mov       edx, OFFSET outputSpacing
               call      WriteString

          ; Move the next Fibonacci number into the eax register so it's ready to be printed if the loop counter is not 0
          endFormatting:
               mov       eax, nextNumber

          loop      displayResults

; Display a farewell message
     call      Crlf
     mov       edx, OFFSET farewellMessage
     call      WriteString
     mov       edx, OFFSET nameIn
     call      WriteString
               
; Exit to the operating system
	INVOKE    ExitProcess,0

main ENDP

END main
