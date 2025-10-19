INCLUDE Irvine32.inc
.data
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
menuMsg BYTE " ATM MENU: ",13,10,
             "1. CHECK BALANCE",13,10,
             "2. DEPOSIT",13,10,
             "3. WITHDRAW",13,10,
             "4. EXIT program",13,10,
             "ENTER YOUR CHOICE ",0
balanceMsg BYTE "YOUR CURRENT BALANCE IS: $",0
depositMsg BYTE "PLEASE ENTER DEPOSIT AMOUNT: $",0
withdrawMsg BYTE "PLEASE ENTER WITHDRAWAL AMOUNT: $",0
insufficientBal BYTE "INSUFFICIENT BALANCE.",0
invalidchoiceMsg BYTE "INVALID CHOICE, PLEASE TRY AGAIN.",0

.code
main PROC
    ; ACCOUNT DETAILS
    mov accounts[0].pin, 1234
    mov accounts[0].balance, 5000
    mov accounts[SIZE Account].pin, 5678
    mov accounts[SIZE Account].balance, 7090
    mov accounts[SIZE Account*2].pin, 9012
    mov accounts[SIZE Account*2].balance, 10345

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

ExitProgram:
    exit
main ENDP

Authenticate PROC
    mov ecx, 3              ; total accounts
    mov esi, OFFSET accounts
    mov eax, userinput      ; entered PIN
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
    jmp AuthDone          

FoundMatch:
    mov curr_acc_ind, ebx
    mov eax, 1

AuthDone:
    ret
Authenticate ENDP

END main
