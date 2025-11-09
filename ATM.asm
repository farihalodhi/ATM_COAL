.386
.model flat, stdcall
.stack 4096
INCLUDE Irvine32.inc

.data

fileName BYTE "accounts.txt",0
fileHandle DWORD ?
msg BYTE "hello from atm",0Dh,0Ah,0
bytesWritten DWORD ?

Account STRUCT
    pin DWORD ?
    balance DWORD ?
Account ENDS

accounts Account 3 DUP(<>)
curr_acc_ind DWORD ?
userinput DWORD ?

welcomeMsg BYTE "WELCOME TO ATM",0
pinMsg BYTE "PLEASE ENTER YOUR PIN",0
invalidPin BYTE "INVALID PIN!",0
menuMsg BYTE "ATM MENU:",13,10,
             "1. CHECK BALANCE",13,10,
             "2. DEPOSIT",13,10,
             "3. WITHDRAW",13,10,
             "4. EXIT PROGRAM",13,10,
             "ENTER YOUR CHOICE: ",0
balanceMsg BYTE "YOUR CURRENT BALANCE IS: $",0
depositMsg BYTE "PLEASE ENTER DEPOSIT AMOUNT: $",0
withdrawMsg BYTE "PLEASE ENTER WITHDRAWAL AMOUNT: $",0
insufficientBal BYTE "INSUFFICIENT BALANCE.",0
invalidchoiceMsg BYTE "INVALID CHOICE, PLEASE TRY AGAIN.",0

.code
main PROC
    ; Initialize accounts
    mov accounts[0].pin, 1234
    mov accounts[0].balance, 5000
    mov accounts[1].pin, 5678
    mov accounts[1].balance, 7090
    mov accounts[2].pin, 9012
    mov accounts[2].balance, 10345


    mov edx, OFFSET welcomeMsg
    call WriteString
    call Crlf

    mov edx, OFFSET pinMsg
    call WriteString
    call Crlf
    call ReadInt
    mov userinput, eax
    call Crlf


    call Authenticate
    cmp eax, 1
    jne ExitProgram

    mov edx, OFFSET menuMsg
    call WriteString
    call Crlf

    mov edx, OFFSET fileName
    call CreateOutputFile
    mov fileHandle, eax

    mov eax, fileHandle
    mov edx, OFFSET msg
    mov ecx, LENGTHOF msg
    call WriteToFile
    mov bytesWritten, eax

    mov eax, fileHandle
    call CloseFile

ExitProgram:
    exit
main ENDP


Authenticate PROC
    mov ecx, 3             
    mov esi, OFFSET accounts
    mov eax, userinput
    mov ebx, 0

CheckPinLoop:
    cmp eax, (Account PTR [esi]).pin
    je FoundMatch

    add esi, SIZEOF Account
    inc ebx
    loop CheckPinLoop


    mov edx, OFFSET invalidPin
    call WriteString
    call Crlf
    mov eax, 0
    ret

FoundMatch:
    mov curr_acc_ind, ebx
    mov eax, 1
    ret
Authenticate ENDP

END main

