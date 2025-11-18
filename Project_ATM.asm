.model flat, stdcall
.stack 4096
INCLUDE Irvine32.inc

.data

; standard cust -> only bronze,   5 transactions per day,  withdrawal limit = $30,000
; VIP cust      -> silver,        8 transactions pre day,  withdrawal limit = $50,000
; VIP cust      -> gold,          10 transactions per day, withdrawal limit = $75,000
; elite cust    -> only Platinum, 15 transactions per day, withdrawal limit = $120,000

Account STRUCT
    AccNum   DWORD ?
    pin      DWORD ?
    balance  DWORD ?
    cardType DWORD ?     ; 0 = bronze, 1 = silver, 2 = gold, 3 = Platinum
    customerType DWORD ? ;0 = Standard, 1 = VIP, 2 = Elite
Account ENDS

accounts Account 4 DUP(<>)
curr_acc_ind   DWORD ?
userAccNum     DWORD ?
userinput      DWORD ?
transLimit     DWORD 5,8,10,15
withdrawLimit  DWORD 30000,50000,75000,120000
currTransLimit DWORD ?
currWithdrawLimit DWORD ?

welcomeMsg BYTE 13,10,13,10,
                "           ========================================",13,10,
                "                      WELCOME TO ATM                 ",13,10,
                "           ========================================",13,10,0

accNumMsg BYTE     13,10,"           ENTER YOUR ACCOUNT NO.: ",0
pinMsg    BYTE     13,10,"           ENTER YOUR PIN: ",0

invalidPin BYTE 13,10,13,10,
                "           INVALID PIN!",13,10,0

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
invalidAccNum BYTE 13,10,13,10,"           INVALID ACCOUNT NUMBER",0
tooManyAttempts BYTE 13,10,13,10,"           TOO MANY ATTEMPTS. ACCESS DENIED",0
transLimitMsg  BYTE  13,10,13,10,"           YOU'VE REACHED YOUR TRANSACTION LIMIT",0
withdrawExceed BYTE  13,10,13,10,"           YOU'VE EXCEEDED YOUR WITHDRAWAL LIMIT",0

exitMsg BYTE    13,10,13,10,
                "           ========================================",13,10,
                "              THANK YOU FOR USING ATM            ",13,10,
                "           ========================================",13,10,0

.code

; --------------
; Authenticate
; ----------------
Authenticate PROC
    mov ecx, 4                    ; number of accounts
    mov esi, OFFSET accounts      ; pointer to accounts array
    mov eax, DWORD PTR userAccNum ; acc num in EAX
    xor ebx, ebx                  ; index = 0

    CheckAccNumLoop:
        ; load acc num to 
        mov edx, DWORD PTR [esi]
        cmp eax, edx
        je AccountFound

        add esi, SIZEOF Account
        inc ebx
        Loop CheckAccNumLoop

        call crlf
        mov edx, OFFSET invalidAccNum
        call writestring
        call crlf
        mov eax,0
        ret

    AccountFound:
        mov ecx, 3
    CheckPinLoop: ; 3 attempts to enter correct pin
        ; taking pin input & checking with the current account's pin
        mov edx, OFFSET pinMsg
        call WriteString
        call ReadInt

        mov edx, DWORD PTR [esi+4]   ; EDX = pin
        cmp eax, edx
        je FoundMatch

        ; no match found
        mov edx, OFFSET invalidPin
        call WriteString
        call Crlf
        Loop CheckPinLoop

        ; Too Many Attempts Msg
        mov edx, OFFSET tooManyAttempts
        call writestring
        call crlf
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

    mov eax, DWORD PTR [esi+12] ; balance is at offset 12

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
    cmp currTransLimit,0 ; return if transaction limit reached
    je Wapas

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
    add DWORD PTR [esi+12], eax

    mov edx, OFFSET depositSuccess
    call WriteString
    
    mov edx, OFFSET balanceMsg
    call WriteString
    mov eax, DWORD PTR [esi+12]
    call WriteDec
    mov edx, OFFSET neeche_ki_line
    call WriteString
    dec currTransLimit ; decreament the curr acc trans limit
Wapas:
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
    cmp currTransLimit,0 ; return if transaction limit reached
    je Wapas

    mov esi, OFFSET accounts
    mov eax, DWORD PTR curr_acc_ind
    imul eax, SIZEOF Account
    add esi, eax

    AskForMoney:
    mov edx, OFFSET withdrawPrompt
    call WriteString
    call ReadInt               ; value in EAX
    test eax, eax
    jle WithdrawInvalidAmount  ; don't accept <= 0 withdraws

    ; check if user exceeds limit
    cmp eax, currWithdrawLimit
    jge WithdrawLimitExceed

    mov ebx, DWORD PTR [esi+12] ; ebx = balance
    
    cmp ebx, eax
    jl NotEnoughFunds

    sub DWORD PTR [esi+12], eax
    
    mov edx, OFFSET withdrawSuccess
    call WriteString
    
    mov edx, OFFSET balanceMsg
    call WriteString
    mov eax, DWORD PTR [esi+12]
    call WriteDec
    mov edx, OFFSET neeche_ki_line
    call WriteString
    dec currTransLimit
Wapas:
    ret

WithdrawLimitExceed:
    mov edx, OFFSET withdrawExceed
    call writestring
    jmp AskForMoney  ; again ask for amount to withdraw

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
; MAIN: program entry
; -------------------------
main PROC
    ;---------------------------------
    ; Initialize accounts (4 accounts)
    ;---------------------------------

    mov esi, OFFSET accounts

    ; account 0
    mov DWORD PTR [esi+0], 123456789 ; acc num
    mov DWORD PTR [esi+4], 1234      ; pin
    mov DWORD PTR [esi+12], 5000     ; balance
    mov DWORD PTR [esi+16], 0        ; card type, Bronze
    mov DWORD PTR [esi+20], 0        ; customer type, Standard

    add esi, SIZEOF Account

    ; account 1
    mov DWORD PTR [esi+0], 987654321 ; acc num
    mov DWORD PTR [esi+4], 5678      ; pin
    mov DWORD PTR [esi+12], 7000     ; balance
    mov DWORD PTR [esi+16], 1        ; card type, silver
    mov DWORD PTR [esi+20], 1        ; customer type, VIP

    add esi, SIZEOF Account

    ; account 2
    mov DWORD PTR [esi+0], 111222333 ; acc num
    mov DWORD PTR [esi+4], 4321      ; pin
    mov DWORD PTR [esi+12], 50000    ; balance = 50,000
    mov DWORD PTR [esi+16], 1        ; card type, silver/gold=2
    mov DWORD PTR [esi+20], 1        ; customer type, VIP

    add esi, SIZEOF Account

    ; account 3
    mov DWORD PTR [esi+0], 333222111 ; acc num
    mov DWORD PTR [esi+4], 9012      ; pin
    mov DWORD PTR [esi+12], 200000   ; balance = 200,000
    mov DWORD PTR [esi+16], 3        ; card type, Platinum
    mov DWORD PTR [esi+20], 2        ; customer type, Elite

    ; show welcome and prompt for account num & PIN
    call ClrScr
    mov edx, OFFSET welcomeMsg
    call WriteString
    call Crlf

    mov edx, OFFSET accNumMsg
    call writestring
    call readdec
    call crlf
    call crlf
    mov DWORD PTR userAccNum, eax

    ; pin input taking moved in Authenticate PROC

    call Authenticate
    cmp eax, 1
    jne ExitLabel

    ; -----------------------------------------------------
    ; getting current account's withdraw & tranaction limit
    ; -----------------------------------------------------

    ; Offset uss account k hoga jis ka acc num enter hoga

    ; getting curr account offset
    mov esi, OFFSET accounts
    mov eax, DWORD PTR curr_acc_ind
    imul eax, SIZEOF Account
    add esi, eax

    ;load card type and getting trans limit
    mov eax, DWORD PTR [esi+16] ; get card type
    mov ebx, OFFSET transLimit  ; get offset of translimit array
    mov ecx, DWORD PTR [ebx + eax*4] ; ECX = no. of transactions

    mov currTransLimit, ecx
    
    ; getting withdraw limit
    mov ebx, OFFSET withdrawLimit ; get offset of withdrawlimit array
    mov ecx, DWORD PTR [ebx + eax*4] ; ECX = withdraw limit

    mov currWithdrawLimit, ecx

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
    cmp currTransLimit,0 ; checks if trans limit reached after this process
    je TransLimitReached
    jmp DoWhileLoop

WithdrawLabel:
    call withdrawMoney
    cmp currTransLimit,0 ; ; checks if trans limit reached after this process
    je TransLimitReached
    jmp DoWhileLoop

TransLimitReached:
    mov edx, OFFSET transLimitMsg
    call writestring

ExitLabel:
    mov edx, OFFSET exitMsg
    call WriteString
    jmp ExitProgram

ExitProgram:
    exit
main ENDP

END main