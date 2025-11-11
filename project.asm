
.model flat, stdcall
.stack 4096
INCLUDE Irvine32.inc

.data

Account STRUCT
    pin DWORD ?
    balance DWORD ?
Account ENDS

accounts Account 3 DUP(<>)
curr_acc_ind DWORD ?
userinput DWORD ?

welcomeMsg BYTE 13,10,13,10,
                "           ========================================",13,10,
                "                      WELCOME TO ATM                 ",13,10,
                "           ========================================",13,10,0

pinMsg BYTE     13,10,"           ENTER YOUR PIN: ",0

invalidPin BYTE 13,10,13,10,
                "           INVALID PIN! ACCESS DENIED.",13,10,0

menuMsg BYTE    13,10,13,10,
                "           ATM MENU",13,10,
                "           --------",13,10,
                "           1. Check Balance",13,10,
                "           2. Deposit",13,10,
                "           3. Withdraw",13,10,
                "           4. Exit",13,10,13,10,
                "           Enter choice: ",0

balanceMsg BYTE 13,10,13,10,
                "           CURRENT BALANCE",13,10,
                "           ---------------",13,10,
                "           $",0
neeche_ki_line BYTE 13,10,0

depositPrompt BYTE 13,10,13,10,"           ENTER DEPOSIT AMOUNT: $",0
depositSuccess BYTE 13,10,13,10,"           DEPOSIT SUCCESSFUL!",0

withdrawPrompt BYTE 13,10,13,10,"           ENTER WITHDRAWAL AMOUNT: $",0
withdrawSuccess BYTE 13,10,13,10,"           WITHDRAWAL SUCCESSFUL!",0

insufficientBal BYTE 13,10,13,10,"           INSUFFICIENT FUNDS.",0

invalidchoiceMsg BYTE 13,10,13,10,"           INVALID CHOICE. TRY AGAIN.",0
invalidAmount BYTE 13,10,13,10,"           INVALID AMOUNT. MUST BE GREATER THAN ZERO.",0

exitMsg BYTE    13,10,13,10,
                "           ========================================",13,10,
                "              THANK YOU FOR USING ATM            ",13,10,
                "           ========================================",13,10,0

.code

; --------------
; Authenticate
; ----------------
Authenticate PROC
    mov ecx, 3                 ; number of accounts
    mov esi, OFFSET accounts   ; pointer to accounts array
    mov eax, DWORD PTR userinput
    xor ebx, ebx               ; index = 0

CheckPinLoop:
    ; load pin from current account (pin is at offset 0)
    mov edx, DWORD PTR [esi]   ; EDX = pin
    cmp eax, edx
    je FoundMatch

    add esi, SIZEOF Account    ; advance to next struct
    inc ebx
    loop CheckPinLoop

    ; no match found
    call Crlf
    mov edx, OFFSET invalidPin
    call WriteString
    call Crlf
    mov eax, 0                 ; return 0 = fail
    ret

FoundMatch:
    mov DWORD PTR curr_acc_ind, ebx
    mov eax, 1                 ; return 1 = success
    ret
Authenticate ENDP

; ------------
; showBalance
; --------------
showBalance PROC
    mov esi, OFFSET accounts
    mov eax, DWORD PTR curr_acc_ind
    imul eax, SIZEOF Account   ; EAX = index * struct size
    add esi, eax               ; ESI points to selected account struct

    mov eax, DWORD PTR [esi+4] ; balance is at offset 4

    mov edx, OFFSET balanceMsg
    call WriteString

    call WriteDec             ; prints EAX (balance)

    mov edx, OFFSET neeche_ki_line
    call WriteString
    ret
showBalance ENDP

; ------------
; depositMoney
; ------------
depositMoney PROC
    mov esi, OFFSET accounts
    mov eax, DWORD PTR curr_acc_ind
    imul eax, SIZEOF Account
    add esi, eax

    mov edx, OFFSET depositPrompt
    call WriteString
    call ReadInt               ; value in EAX
    test eax, eax
    jle DepositInvalidAmount   ; don't accept <= 0 deposits

    ; add deposit to current balance
    add DWORD PTR [esi+4], eax

    mov edx, OFFSET depositSuccess
    call WriteString
    
    mov edx, OFFSET balanceMsg
    call WriteString
    mov eax, DWORD PTR [esi+4]
    call WriteDec
    mov edx, OFFSET neeche_ki_line
    call WriteString
    ret

DepositInvalidAmount:
    mov edx, OFFSET invalidAmount
    call WriteString
    ret
depositMoney ENDP

; -------------------------
; withdrawMoney: prompt and subtract from balance if enough funds
; -------------------------
withdrawMoney PROC
    mov esi, OFFSET accounts
    mov eax, DWORD PTR curr_acc_ind
    imul eax, SIZEOF Account
    add esi, eax

    mov edx, OFFSET withdrawPrompt
    call WriteString
    call ReadInt               ; value in EAX
    test eax, eax
    jle WithdrawInvalidAmount  ; don't accept <= 0 withdraws

    mov ebx, DWORD PTR [esi+4] ; ebx = balance
    
    cmp ebx, eax
    jl NotEnoughFunds

    sub DWORD PTR [esi+4], eax
    
    mov edx, OFFSET withdrawSuccess
    call WriteString
    
    mov edx, OFFSET balanceMsg
    call WriteString
    mov eax, DWORD PTR [esi+4]
    call WriteDec
    mov edx, OFFSET neeche_ki_line
    call WriteString
    ret

WithdrawInvalidAmount:
    mov edx, OFFSET invalidAmount
    call WriteString
    ret

NotEnoughFunds:
    mov edx, OFFSET insufficientBal
    call WriteString
    ret
withdrawMoney ENDP

; -------------------------
; main: program entry
; -------------------------
main PROC

    ; Initialize accounts (3 accounts)
    mov esi, OFFSET accounts

    ; account 0
    mov DWORD PTR [esi+0], 1234    ; pin
    mov DWORD PTR [esi+4], 5000    ; balance

    add esi, SIZEOF Account

    ; account 1
    mov DWORD PTR [esi+0], 5678
    mov DWORD PTR [esi+4], 7000

    add esi, SIZEOF Account

    ; account 2
    mov DWORD PTR [esi+0], 9012
    mov DWORD PTR [esi+4], 10345

    ; show welcome and prompt for PIN
    call ClrScr
    mov edx, OFFSET welcomeMsg
    call WriteString
    call Crlf

    mov edx, OFFSET pinMsg
    call WriteString
    call ReadInt
    mov DWORD PTR userinput, eax

    call Authenticate
    cmp eax, 1
    jne ExitProgram

    ; Main menu loop
DoWhileLoop:
    call Crlf
    mov edx, OFFSET menuMsg
    call WriteString
    call ReadInt       ; choice in EAX

    cmp eax, 1
    je ShowBalanceLabel
    cmp eax, 2
    je DepositLabel
    cmp eax, 3
    je WithdrawLabel
    cmp eax, 4
    je ExitLabel

    ; invalid choice
    mov edx, OFFSET invalidchoiceMsg
    call WriteString
    call Crlf
    jmp DoWhileLoop

ShowBalanceLabel:
    call showBalance
    jmp DoWhileLoop

DepositLabel:
    call depositMoney
    jmp DoWhileLoop

WithdrawLabel:
    call withdrawMoney
    jmp DoWhileLoop

ExitLabel:
    mov edx, OFFSET exitMsg
    call WriteString
    jmp ExitProgram

ExitProgram:
    exit
main ENDP

END main