.model flat, stdcall
.stack 4096
INCLUDE Irvine32.inc
.data
MAX_ACCOUNTS = 4
MAX_DAILY_WITHDRAWAL = 1000
MAX_SINGLE_WITHDRAWAL = 500

Account STRUCT
	accountNumber DWORD ?
	pin DWORD ?
	balance DWORD ?
	holderName BYTE 32 DUP(?)
	accountType BYTE ? ;checking=0/savings=1/current=2
	cardType BYTE ? ;silver=0/gold=1/platinum=2
	padding BYTE 2 DUP(?) ; Alignment padding
	dailyWithdrawn DWORD ?
	accountStatus BYTE ? ;0=active/1=locked
Account ENDS

accounts Account MAX_ACCOUNTS DUP(<>)
currentAccIdx DWORD ?
userAccNum DWORD ?
userPin DWORD ?
userChoice DWORD ?
withdrawAmount DWORD ?
depositAmount DWORD ?
transactionID DWORD 1000

welcomeMsg BYTE 13,10,
"           ========================================",13,10,
"                 WELCOME TO FAST NUCES ATM         ",13,10,
"           ========================================",13,10,0

startupMsg BYTE 13,10,"Initializing ATM System...",13,10,0
systemReady BYTE 13,10,"System Ready.",13,10,0

insertCardMsg BYTE 13,10,13,10,
    "    Please insert your card...",13,10,13,10,0

readingCardMsg BYTE "    Reading card",0
dot BYTE ".",0

cardReadMsg BYTE 13,10,13,10,
    "    Card accepted.",13,10,13,10,0

enterAccNumMsg BYTE "    Enter Account Number: ",0

invalidAccMsg BYTE 13,10,13,10,
    "    ERROR: Invalid account number!",13,10,
    "    Please try again.",13,10,0

accountFoundMsg BYTE 13,10,
    "    Account found. Please wait...",13,10,0

accountLockedMsg BYTE 13,10,13,10,
    "    ERROR: This account is locked!",13,10,
    "    Please contact the bank.",13,10,0

enterPinMsg BYTE 13,10,"Enter Pin: ",0
wrongPinMsg BYTE 13,10,"    ERROR: Incorrect PIN.",13,10,0
attemptsLeftMsg BYTE "    Attempts left: ",0
cardRetainedMsg BYTE 13,10,"    CARD RETAINED. Account locked. Please contact bank.",13,10,0
pinSuccessMsg BYTE 13,10,"    PIN accepted. Logging in...",13,10,0

bankNameBanner BYTE 13,10,
"           ========================================",13,10,
"                        FAST NUCES ATM         ",13,10,
"           ========================================",13,10,0
menuOptions BYTE 13,10,
        "           1. Balance Inquiry",13,10,
        "           2. Cash Withdrawal",13,10,
        "           3. Cash Deposit",13,10,
        "           4. Change Pin",13,10,
        "           5. Mini Statement",13,10,
        "           6. Exit",13,10,0

menuPrompt BYTE 13,10,
        "           Enter Your Choice: ",0

invalidChoice BYTE 13,10,
        "           Invalid Choice!",13,10,
        "           Please select from 1-6!",13,10,0

processingMsg BYTE 13,10,"          Processing...",13,10,0
accountInfoMsg BYTE 13,10,
    "    Logged in as Account: ",0

anotherTransMsg BYTE 13,10,13,10,
    "    Would you like another transaction? (Y/N): ",0

thankYouMsg BYTE 13,10,13,10,
    "    Thank you for using our ATM!",13,10,0

; Balance inquiry messages
balanceHeader BYTE 13,10,13,10,
    "           ************BALANCE  INQUIRY************",13,10,0

checkingBalMsg BYTE 13,10,
    "           Account Type: ",0

currentBalMsg BYTE 13,10,13,10,
    "           Current Balance: $",0

dailyWithdrawnMsg BYTE 13,10,
    "           Withdrawn Today: $",0

dailyLimitMsg BYTE 13,10,
    "           Daily Limit Remaining: $",0

checkingType BYTE "Checking",0
savingsType BYTE "Savings",0
currentType BYTE "Current",0

; Card type labels
bronzeCard BYTE "Bronze Card",0
silverCard BYTE "Silver Card",0
goldCard BYTE "Gold Card",0
platinumCard BYTE "Platinum Card",0

; Withdrawal messages
withdrawHeader BYTE 13,10,13,10,
    "              ************CASH WITHDRAWAL************",13,10,0

fastCashMenu BYTE 13,10,
    "    FAST CASH OPTIONS:",13,10,13,10,
    "    1. $20",13,10,
    "    2. $50",13,10,
    "    3. $100",13,10,
    "    4. $200",13,10,
    "    5. $500",13,10,
    "    6. Other Amount",13,10,
    "    7. Cancel",13,10,13,10,0

fastCashPrompt BYTE "    Select option: ",0

enterAmountMsg BYTE 13,10,13,10,
    "    Enter withdrawal amount: $",0

insufficientFundsMsg BYTE 13,10,13,10,
    "    ERROR: Insufficient funds!",13,10,
    "    Your balance: $",0

invalidAmountMsg BYTE 13,10,13,10,
    "    ERROR: Invalid amount!",13,10,
    "    Amount must be positive and multiple of $10",13,10,0

dailyLimitExceeded BYTE 13,10,13,10,
    "    ERROR: Daily withdrawal limit exceeded!",13,10,
    "    Daily limit: $",0
    
remainingDaily BYTE 13,10,
    "    Remaining today: $",0

singleLimitExceeded BYTE 13,10,13,10,
    "    ERROR: Single transaction limit exceeded!",13,10,
    "    Maximum per transaction: $",0

dispensingMsg BYTE 13,10,13,10,
    "    Processing withdrawal...",13,10,0

countingMsg BYTE "    Counting cash",0

dispensedMsg BYTE 13,10,13,10,
    "    Please take your cash.",13,10,0

denominationHeader BYTE 13,10,
    "    DISPENSING:",13,10,0

bills100 BYTE "    $100 bills: ",0
bills50 BYTE "    $50 bills: ",0
bills20 BYTE "    $20 bills: ",0
bills10 BYTE "    $10 bills: ",0

newBalanceMsg BYTE 13,10,13,10,
    "    New Balance: $",0

withdrawSuccessMsg BYTE 13,10,
    "    Transaction Successful!",13,10,0

receiptPrompt BYTE 13,10,13,10,
    "    Would you like a receipt? (Y/N): ",0

receiptHeader BYTE 13,10,13,10,
    "    ========================================",13,10,
    "              TRANSACTION RECEIPT           ",13,10,
    "    ========================================",13,10,0

receiptBankName BYTE 13,10,
    "              FAST NUCES ATM                ",13,10,0

receiptLine BYTE "    ----------------------------------------",13,10,0

receiptDate BYTE "    Date: November 22, 2025",13,10,0
receiptTime BYTE "    Time: 14:30:45",13,10,0

receiptAccLabel BYTE "    Account Number: ",0
receiptCardLabel BYTE "    Card Type: ",0
receiptTransIDLabel BYTE "    Transaction ID: TXN",0
receiptTypeLabel BYTE "    Transaction: Withdrawal",13,10,0
receiptAmountLabel BYTE "    Amount: $",0
receiptBalLabel BYTE "    Balance: $",0

receiptFooter BYTE 13,10,
    "         Thank you for banking with us!     ",13,10,
    "    ========================================",13,10,0

printingMsg BYTE 13,10,
    "    Printing receipt",0

; Deposit messages
depositHeader BYTE 13,10,13,10,
    "************CASH DEPOSIT************",13,10,0

depositInstructions BYTE 13,10,
    "    Please prepare your cash for deposit.",13,10,13,10,0

enterDepositMsg BYTE "    Enter deposit amount: $",0

invalidDepositMsg BYTE 13,10,13,10,
    "    ERROR: Invalid amount!",13,10,
    "    Amount must be positive.",13,10,0

insertEnvelopeMsg BYTE 13,10,13,10,
    "    Please insert your deposit cash...",13,10,0

envelopeInserted BYTE 13,10,
    "    cash received.",13,10,0

processingDepositMsg BYTE 13,10,
    "    Processing deposit",0

depositPendingMsg BYTE 13,10,13,10,
    "    IMPORTANT NOTICE:",13,10,
    "    Your deposit will be verified within 24 hours.",13,10,
    "    Funds will be available after verification.",13,10,0

depositSuccessMsg BYTE 13,10,
    "    Deposit transaction recorded!",13,10,0

depositReceiptType BYTE "    Transaction: Deposit",13,10,0

depositCreditedMsg BYTE 13,10,13,10,
    "    Deposit credited to your account.",13,10,0

newBalanceAfterDeposit BYTE 13,10,
    "    New Balance: $",0

enterCurrPin BYTE 13,10,"           Please enter your current pin: ",0
enterNewPin BYTE 13,10,"           Enter the new pin: ",0
confirmNewPin BYTE 13,10,"           Confirm the new pin: ",0
invalidPin BYTE 13,10,"             pin Incorrect! pin change cancelled!"

pinMismatchMsg BYTE 13,10,13,10,
    "    ERROR: PINs do not match!",13,10,
    "    Please try again.",13,10,0

pinTooShortMsg BYTE 13,10,13,10,
    "    ERROR: PIN must be exactly 4 digits!",13,10,0

samePinMsg BYTE 13,10,13,10,
    "    ERROR: New PIN cannot be same as old PIN!",13,10,0

pinChangeSuccessMsg BYTE 13,10,13,10,
    "    SUCCESS: Your PIN has been changed!",13,10,
    "    Please remember your new PIN.",13,10,0

pinChangeInstructions BYTE 13,10,
    "    PIN Requirements:",13,10,
    "    - Must be exactly 4 digits",13,10,
    "    - Cannot be same as current PIN",13,10,13,10,0
.code
;---------------------------PROCEDURES---------------------------------
;------welcome display---------
welcomeDisplay PROC
	call clrscr
	mov edx, OFFSET startupMsg
	call writestring
	mov eax,1500
	call delay
	mov edx, OFFSET systemReady
	call writestring
	mov eax, 800
	call delay
	call clrscr
	mov edx, OFFSET welcomeMsg
	call writestring
	call crlf
	ret
welcomeDisplay ENDP

;--------Insert Card------------
InsertCard PROC
    push ebx
    push esi
    
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET insertCardMsg
    call WriteString
    
    mov edx, OFFSET readingCardMsg
    call WriteString
    
    mov ecx, 4
    
DotLoop:
    mov edx, OFFSET dot
    call WriteString
    mov eax, 500
    call Delay
    loop DotLoop
    
    call Crlf
    call Crlf
    
    mov eax, 10
    call SetTextColor
    mov edx, OFFSET cardReadMsg
    call WriteString
    mov eax, 800
    call Delay
    
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET enterAccNumMsg
    call WriteString
    call ReadInt
    mov userAccNum, eax
    
    mov ecx, MAX_ACCOUNTS
    mov esi, OFFSET accounts
    mov eax, userAccNum
    mov ebx, 0
    
SearchLoop:
    cmp eax, DWORD PTR [esi+0]
    je AccountFound
    
    add esi, SIZEOF Account
    inc ebx
    loop SearchLoop
    
    mov eax, 12
    call SetTextColor
    mov edx, OFFSET invalidAccMsg
    call WriteString
    mov eax, 0
    jmp EndProc
    
AccountFound:
    mov al, BYTE PTR [esi+52]
    cmp al, 1
    je AccountLocked
    
    mov currentAccIdx, ebx
    mov eax, 10
    call SetTextColor
    mov edx, OFFSET accountFoundMsg
    call WriteString
    mov eax, 1000
    call Delay
    mov eax, 1
    jmp EndProc

AccountLocked:
    mov eax, 12
    call SetTextColor
    mov edx, OFFSET accountLockedMsg
    call WriteString
    mov eax, 0
    
EndProc:
    pop esi
    pop ebx
    ret
InsertCard ENDP

;---------------Enter Pin-----------------
EnterPinProc PROC
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    mov ecx, 3

TryAttemptFinal:
    push ecx
    
    mov edx, OFFSET enterPinMsg
    call WriteString

    mov eax, currentAccIdx
    mov ebx, SIZEOF Account
    imul eax, ebx
    mov esi, OFFSET accounts
    add esi, eax

    xor ebx, ebx
    mov edi, 4

ReadDigitLoopFinal:
    call ReadChar
    
    cmp al, 13
    je DigitsDone
    
    push eax
    
    mov al, '*'
    call WriteChar
    
    pop eax
    
    cmp al, '0'
    jb InvalidDigit
    cmp al, '9'
    ja InvalidDigit
    
    sub al, '0'
    movzx eax, al
    
    push edx
    mov edx, ebx
    imul edx, 10
    add edx, eax
    mov ebx, edx
    pop edx
    
    dec edi
    jnz ReadDigitLoopFinal
    jmp DigitsDone

InvalidDigit:
    jmp ReadDigitLoopFinal

DigitsDone:
    call Crlf

    mov eax, DWORD PTR [esi+4]
    cmp ebx, eax
    je PinAcceptedFinal

    mov edx, OFFSET wrongPinMsg
    call WriteString

    pop ecx
    dec ecx
    cmp ecx, 0
    je LockAccountFinal

    mov edx, OFFSET attemptsLeftMsg
    call WriteString
    mov eax, ecx
    call WriteInt
    call Crlf

    mov eax, 500
    call Delay
    jmp TryAttemptFinal

LockAccountFinal:
    mov BYTE PTR [esi+52], 1
    mov edx, OFFSET cardRetainedMsg
    call WriteString
    mov eax, 0
    jmp EnterPinEnd

PinAcceptedFinal:
    pop ecx
    mov edx, OFFSET pinSuccessMsg
    call WriteString
    mov eax, 1

EnterPinEnd:
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret
EnterPinProc ENDP

;------------Display main menu------------------
DisplayMenu PROC
    call clrscr
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET bankNameBanner
    call writestring
    mov eax, 14
    call SetTextColor
    mov edx, OFFSET accountInfoMsg
    call WriteString
    
    mov esi, OFFSET accounts
    mov eax, currentAccIdx
    imul eax, SIZEOF Account
    add esi, eax
    mov eax, DWORD PTR [esi+0]
    call WriteDec
    call Crlf
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET menuOptions
    call writestring
    mov edx, OFFSET menuPrompt
    call writestring
    call readint
    mov userChoice, eax
    ret
DisplayMenu ENDP

;-------------ANOTHER TRANSACTION?------------
AnotherTransaction PROC
    mov eax, 14
    call SetTextColor
    mov edx, OFFSET anotherTransMsg
    call WriteString
    
    call ReadChar
    call WriteChar
    call Crlf
    
    cmp al, 'Y'
    je YesResponse
    cmp al, 'y'
    je YesResponse
    
    mov eax, 0
    jmp EndProc
    
YesResponse:
    mov eax, 1
    
EndProc:
    ret
AnotherTransaction ENDP

;------------check Balance---------------
CheckBalance PROC
    call Clrscr
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET bankNameBanner
    call writestring
    mov edx, OFFSET balanceHeader
    call WriteString
    
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET processingMsg
    call WriteString
    mov eax, 1500
    call Delay
    
    mov esi, OFFSET accounts
    mov eax, currentAccIdx
    imul eax, SIZEOF Account
    add esi, eax
    
    mov eax, 14
    call SetTextColor
    mov edx, OFFSET checkingBalMsg
    call WriteString
    
    mov al, BYTE PTR [esi+44]
    cmp al, 0
    je ShowChecking
    cmp al, 1
    je ShowSavings
    cmp al, 2
    je ShowCurrent
    
ShowChecking:
    mov edx, OFFSET checkingType
    call WriteString
    jmp ShowBalance
    
ShowSavings:
    mov edx, OFFSET savingsType
    call WriteString
    jmp ShowBalance
    
ShowCurrent:
    mov edx, OFFSET currentType
    call WriteString
    jmp ShowBalance
    
ShowBalance:
    mov eax, 10
    call SetTextColor
    mov edx, OFFSET currentBalMsg
    call WriteString
    
    mov eax, DWORD PTR [esi+8]
    call WriteDec
    call Crlf
    
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET dailyWithdrawnMsg
    call WriteString
    
    mov eax, DWORD PTR [esi+48]
    call WriteDec
    call Crlf
    
    mov edx, OFFSET dailyLimitMsg
    call WriteString
    
    mov eax, MAX_DAILY_WITHDRAWAL
    sub eax, DWORD PTR [esi+48]
    call WriteDec
    call Crlf
    call Crlf
    
    ret
CheckBalance ENDP
   
;------------------CASH WITHDRAWAL--------------
WithdrawCash PROC
    call Clrscr
     mov eax, 15
    call SetTextColor
    mov edx, OFFSET bankNameBanner
    call writestring
    mov eax, 11
    call SetTextColor
    mov edx, OFFSET withdrawHeader
    call WriteString
    
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET fastCashMenu
    call WriteString
    
    mov eax, 14
    call SetTextColor
    mov edx, OFFSET fastCashPrompt
    call WriteString
    call ReadInt
    
    cmp eax, 1
    je Amount20
    cmp eax, 2
    je Amount50
    cmp eax, 3
    je Amount100
    cmp eax, 4
    je Amount200
    cmp eax, 5
    je Amount500
    cmp eax, 6
    je CustomAmount
    cmp eax, 7
    je CancelWithdraw
    
    mov eax, 12
    call SetTextColor
    mov edx, OFFSET invalidChoice
    call WriteString
    mov eax, 2000
    call Delay
    jmp EndWithdraw
    
Amount20:
    mov eax, 20
    jmp ProcessWithdrawal
    
Amount50:
    mov eax, 50
    jmp ProcessWithdrawal
    
Amount100:
    mov eax, 100
    jmp ProcessWithdrawal
    
Amount200:
    mov eax, 200
    jmp ProcessWithdrawal
    
Amount500:
    mov eax, 500
    jmp ProcessWithdrawal
    
CustomAmount:
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET enterAmountMsg
    call WriteString
    call ReadInt
    jmp ProcessWithdrawal
    
CancelWithdraw:
    jmp EndWithdraw
    
ProcessWithdrawal:
    mov withdrawAmount, eax
    
    cmp eax, 0
    jle InvalidAmount
    
    mov edx, 0
    mov ebx, 10
    div ebx
    cmp edx, 0
    jne InvalidAmount
    
    mov eax, withdrawAmount
    
    cmp eax, MAX_SINGLE_WITHDRAWAL
    jg SingleLimitError
    
    mov esi, OFFSET accounts
    mov ebx, currentAccIdx
    imul ebx, SIZEOF Account
    add esi, ebx
    
    mov ebx, DWORD PTR [esi+8]
    cmp eax, ebx
    jg InsufficientFunds
    
    mov ebx, DWORD PTR [esi+48]
    add ebx, eax
    cmp ebx, MAX_DAILY_WITHDRAWAL
    jg DailyLimitError
    
    jmp PerformWithdrawal

InvalidAmount:
    mov eax, 12
    call SetTextColor
    mov edx, OFFSET invalidAmountMsg
    call WriteString
    mov eax, 2500
    call Delay
    jmp EndWithdraw

SingleLimitError:
    mov eax, 12
    call SetTextColor
    mov edx, OFFSET singleLimitExceeded
    call WriteString
    mov eax, MAX_SINGLE_WITHDRAWAL
    call WriteDec
    call Crlf
    mov eax, 2500
    call Delay
    jmp EndWithdraw

InsufficientFunds:
    mov eax, 12
    call SetTextColor
    mov edx, OFFSET insufficientFundsMsg
    call WriteString
    mov eax, DWORD PTR [esi+8]
    call WriteDec
    call Crlf
    mov eax, 2500
    call Delay
    jmp EndWithdraw

DailyLimitError:
    mov eax, 12
    call SetTextColor
    mov edx, OFFSET dailyLimitExceeded
    call WriteString
    mov eax, MAX_DAILY_WITHDRAWAL
    call WriteDec
    mov edx, OFFSET remainingDaily
    call WriteString
    mov eax, MAX_DAILY_WITHDRAWAL
    sub eax, DWORD PTR [esi+48]
    call WriteDec
    call Crlf
    mov eax, 2500
    call Delay
    jmp EndWithdraw
    
PerformWithdrawal:
    mov eax, withdrawAmount
    
    sub DWORD PTR [esi+8], eax
    
    add DWORD PTR [esi+48], eax
    
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET dispensingMsg
    call WriteString
    mov eax, 1000
    call Delay
    
    mov edx, OFFSET countingMsg
    call WriteString
    
    mov ecx, 5
DotLoop:
    mov edx, OFFSET dot
    call WriteString
    mov eax, 400
    call Delay
    loop DotLoop
    
    call Crlf
    
    call ShowDenominations
    
    mov eax, 10
    call SetTextColor
    mov edx, OFFSET dispensedMsg
    call WriteString
    mov eax, 1000
    call Delay
    
    mov eax, 14
    call SetTextColor
    mov edx, OFFSET newBalanceMsg
    call WriteString
    mov eax, DWORD PTR [esi+8]
    call WriteDec
    call Crlf
    
    mov eax, 10
    call SetTextColor
    mov edx, OFFSET withdrawSuccessMsg
    call WriteString
    
    mov eax, 14
    call SetTextColor
    mov edx, OFFSET receiptPrompt
    call WriteString
    
    call ReadChar
    call WriteChar
    call Crlf
    
    cmp al, 'Y'
    je PrintReceiptNow
    cmp al, 'y'
    je PrintReceiptNow
    
    jmp SkipReceipt
    
PrintReceiptNow:
    call ShowReceipt
    
SkipReceipt:
    jmp EndWithdraw
    
EndWithdraw:
    ret
WithdrawCash ENDP

;-------------------DENOMINATIONS-----------------
ShowDenominations PROC
    mov eax, 11
    call SetTextColor
    mov edx, OFFSET denominationHeader
    call WriteString
    
    mov eax, 15
    call SetTextColor
    
    mov eax, withdrawAmount
    mov ebx, 100
    mov edx, 0
    div ebx
    
    cmp eax, 0
    je Skip100
    push edx
    mov edx, OFFSET bills100
    call WriteString
    call WriteDec
    call Crlf
    pop edx
    
Skip100:
    mov eax, edx
    mov ebx, 50
    mov edx, 0
    div ebx
    
    cmp eax, 0
    je Skip50
    push edx
    mov edx, OFFSET bills50
    call WriteString
    call WriteDec
    call Crlf
    pop edx
    
Skip50:
    mov eax, edx
    mov ebx, 20
    mov edx, 0
    div ebx
    
    cmp eax, 0
    je Skip20
    push edx
    mov edx, OFFSET bills20
    call WriteString
    call WriteDec
    call Crlf
    pop edx
    
Skip20:
    mov eax, edx
    mov ebx, 10
    mov edx, 0
    div ebx
    
    cmp eax, 0
    je Skip10
    mov edx, OFFSET bills10
    call WriteString
    call WriteDec
    call Crlf
    
Skip10:
    ret
ShowDenominations ENDP

;--------------RECEIPT------------------
ShowReceipt PROC
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET printingMsg
    call WriteString
    
    mov ecx, 4
PrintDotLoop:
    mov edx, OFFSET dot
    call WriteString
    mov eax, 400
    call Delay
    loop PrintDotLoop
    
    call Crlf
    call Crlf
    
    mov eax, 14
    call SetTextColor
    mov edx, OFFSET receiptHeader
    call WriteString
    
    mov eax, 11
    call SetTextColor
    mov edx, OFFSET receiptBankName
    call WriteString
    
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET receiptLine
    call WriteString
    
    mov edx, OFFSET receiptDate
    call WriteString
    mov edx, OFFSET receiptTime
    call WriteString
    
    mov edx, OFFSET receiptLine
    call WriteString
    
    mov edx, OFFSET receiptAccLabel
    call WriteString
    
    mov esi, OFFSET accounts
    mov eax, currentAccIdx
    imul eax, SIZEOF Account
    add esi, eax
    
    mov eax, DWORD PTR [esi+0]
    call WriteDec
    call Crlf
    
    mov edx, OFFSET receiptCardLabel
    call WriteString
    
    mov al, BYTE PTR [esi+45]
    cmp al, 0
    je RecBronze
    cmp al, 1
    je RecSilver
    cmp al, 2
    je RecGold
    
RecBronze:
    mov edx, OFFSET bronzeCard
    jmp RecCardDone
RecSilver:
    mov edx, OFFSET silverCard
    jmp RecCardDone
RecGold:
    mov edx, OFFSET goldCard
    
RecCardDone:
    call WriteString
    call Crlf
    
    mov edx, OFFSET receiptTransIDLabel
    call WriteString
    mov eax, transactionID
    call WriteDec
    call Crlf
    inc transactionID
    
    mov edx, OFFSET receiptTypeLabel
    call WriteString
    
    mov edx, OFFSET receiptAmountLabel
    call WriteString
    mov eax, withdrawAmount
    call WriteDec
    call Crlf
    
    call Crlf
    call ShowDenominations
    
    mov edx, OFFSET receiptLine
    call WriteString
    
    mov edx, OFFSET receiptBalLabel
    call WriteString
    mov eax, DWORD PTR [esi+8]
    call WriteDec
    call Crlf
    
    mov eax, 11
    call SetTextColor
    mov edx, OFFSET receiptFooter
    call WriteString
    
    mov eax, 15
    call SetTextColor
    
    ret
ShowReceipt ENDP

;--------------DEPOSIT CASH-----------------
DepositCash PROC
    call Clrscr
     mov eax, 15
    call SetTextColor
    mov edx, OFFSET bankNameBanner
    call writestring
    mov eax, 11
    call SetTextColor
    mov edx, OFFSET depositHeader
    call WriteString
    
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET depositInstructions
    call WriteString
    
    mov eax, 14
    call SetTextColor
    mov edx, OFFSET enterDepositMsg
    call WriteString
    
    call ReadInt
    
    cmp eax, 0
    jle InvalidDeposit
    
    mov depositAmount, eax
    
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET insertEnvelopeMsg
    call WriteString
    
    mov eax, 2000
    call Delay
    
    mov eax, 10
    call SetTextColor
    mov edx, OFFSET envelopeInserted
    call WriteString
    mov eax, 800
    call Delay
    
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET processingDepositMsg
    call WriteString
    
    mov ecx, 5
DepositDotLoop:
    mov edx, OFFSET dot
    call WriteString
    mov eax, 500
    call Delay
    loop DepositDotLoop
    
    call Crlf
    
    mov esi, OFFSET accounts
    mov eax, currentAccIdx
    imul eax, SIZEOF Account
    add esi, eax
    
    mov eax, depositAmount
    add DWORD PTR [esi+8], eax
    
    mov eax, 10
    call SetTextColor
    mov edx, OFFSET depositCreditedMsg
    call WriteString
    
    mov eax, 14
    call SetTextColor
    mov edx, OFFSET newBalanceAfterDeposit
    call WriteString
    mov eax, DWORD PTR [esi+8]
    call WriteDec
    call Crlf
    
    mov eax, 12
    call SetTextColor
    mov edx, OFFSET depositPendingMsg
    call WriteString
    
    mov eax, 10
    call SetTextColor
    mov edx, OFFSET depositSuccessMsg
    call WriteString
    
    call AskForDepositReceipt
    
    jmp EndDeposit

InvalidDeposit:
    mov eax, 12
    call SetTextColor
    mov edx, OFFSET invalidDepositMsg
    call WriteString
    mov eax, 2500
    call Delay
    jmp EndDeposit

EndDeposit:
    ret
DepositCash ENDP

;--------------ASK FOR DEPOSIT RECEIPT-----------------
AskForDepositReceipt PROC
    mov eax, 14
    call SetTextColor
    mov edx, OFFSET receiptPrompt
    call WriteString
    
    call ReadChar
    call WriteChar
    call Crlf
    
    cmp al, 'Y'
    je ShowDepositReceipt
    cmp al, 'y'
    je ShowDepositReceipt
    
    jmp SkipDepositReceipt

ShowDepositReceipt:
    call ShowDepositReceiptDetails
    
SkipDepositReceipt:
    ret
AskForDepositReceipt ENDP

;--------------DEPOSIT RECEIPT DETAILS-----------------
ShowDepositReceiptDetails PROC
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET printingMsg
    call WriteString
    
    mov ecx, 4
PrintDepositDotLoop:
    mov edx, OFFSET dot
    call WriteString
    mov eax, 400
    call Delay
    loop PrintDepositDotLoop
    
    call Crlf
    call Crlf
    
    mov eax, 14
    call SetTextColor
    mov edx, OFFSET receiptHeader
    call WriteString
    
    mov eax, 11
    call SetTextColor
    mov edx, OFFSET receiptBankName
    call WriteString
    
    mov eax, 15
    call SetTextColor
    mov edx, OFFSET receiptLine
    call WriteString
    
    mov edx, OFFSET receiptDate
    call WriteString
    mov edx, OFFSET receiptTime
    call WriteString
    
    mov edx, OFFSET receiptLine
    call WriteString
    
    mov edx, OFFSET receiptAccLabel
    call WriteString
    
    mov esi, OFFSET accounts
    mov eax, currentAccIdx
    imul eax, SIZEOF Account
    add esi, eax
    
    mov eax, DWORD PTR [esi+0]
    call WriteDec
    call Crlf
    
    mov edx, OFFSET receiptCardLabel
    call WriteString
    
    mov al, BYTE PTR [esi+45]
    cmp al, 0
    je DepBronze
    cmp al, 1
    je DepSilver
    cmp al, 2
    je DepGold
    
DepBronze:
    mov edx, OFFSET bronzeCard
    jmp DepCardDone
DepSilver:
    mov edx, OFFSET silverCard
    jmp DepCardDone
DepGold:
    mov edx, OFFSET goldCard
    
DepCardDone:
    call WriteString
    call Crlf
    
    mov edx, OFFSET receiptTransIDLabel
    call WriteString
    mov eax, transactionID
    call WriteDec
    call Crlf
    inc transactionID
    
    mov edx, OFFSET depositReceiptType
    call WriteString
    
    mov edx, OFFSET receiptAmountLabel
    call WriteString
    mov eax, depositAmount
    call WriteDec
    call Crlf
    
    mov edx, OFFSET receiptLine
    call WriteString
    
    mov edx, OFFSET receiptBalLabel
    call WriteString
    mov eax, DWORD PTR [esi+8]
    call WriteDec
    call Crlf
    
    call Crlf
    mov eax, 12
    call SetTextColor
    mov edx, OFFSET depositPendingMsg
    call WriteString
    
    mov eax, 11
    call SetTextColor
    mov edx, OFFSET receiptFooter
    call WriteString
    
    mov eax, 15
    call SetTextColor
    
    ret
ShowDepositReceiptDetails ENDP


pinChange PROC
    push ebx
    push esi
    push edi
    call clrscr
    mov edx, OFFSET bankNameBanner
    call writestring
    mov edx, OFFSET pinChangeInstructions
    call WriteString
    mov esi, OFFSET accounts
    mov eax, currentAccIdx
    imul eax, SIZEOF accounts
    add esi, eax
    mov edx, OFFSET enterCurrPin
    call WriteString
    call ReadPINMasked
    mov ebx, eax
    mov eax, DWORD PTR [esi+4]           
    cmp ebx, eax
    jne CurrentPINWrong
    call crlf

GetNewPIN:
    mov eax, 14
    call SetTextColor
    mov edx, OFFSET enterNewPin
    call WriteString
    
    call ReadPINMasked                   ; returns new PIN in EAX
    mov edi, eax                         ; save new PIN in EDI
    call Crlf
    
    ; Check if same as old PIN
    mov eax, DWORD PTR [esi+4]
    cmp edi, eax
    je SamePINError
    
    ; Step 3: Confirm new PIN
    mov eax, 14
    call SetTextColor
    mov edx, OFFSET confirmNewPin
    call WriteString
    
    call ReadPINMasked                   ; returns confirmed PIN in EAX
    call Crlf
    
    ; Check if PINs match
    cmp eax, edi
    jne PINMismatch
    
    ; All validations passed - update PIN
    mov DWORD PTR [esi+4], edi           ; store new PIN
    
    ; Show success message
    mov eax, 10                          ; green
    call SetTextColor
    mov edx, OFFSET pinChangeSuccessMsg
    call WriteString
    
    mov eax, 2000
    call Delay
    
    jmp EndPINChange

CurrentPINWrong:
    mov eax, 12                         
    call SetTextColor
    mov edx, OFFSET invalidPin
    call WriteString
    mov eax, 2500
    call Delay
    jmp EndPINChange

PINMismatch:
    mov eax, 12
    call SetTextColor
    mov edx, OFFSET pinMismatchMsg
    call WriteString
    mov eax, 2000
    call Delay
    jmp GetNewPIN                     

SamePINError:
    mov eax, 12
    call SetTextColor
    mov edx, OFFSET samePinMsg
    call WriteString
    mov eax, 2000
    call Delay
    jmp GetNewPIN                        ; try again

EndPINChange:
    pop edi
    pop esi
    pop ebx
    ret
pinChange ENDP

ReadPINMasked PROC
    ; Reads exactly 4 digits and returns as number in EAX
    ; Displays asterisks instead of actual digits
    
    push ebx
    push ecx
    push edi
    
    xor ebx, ebx                         ; EBX will accumulate the PIN
    mov ecx, 4                           ; need exactly 4 digits
    
ReadDigitLoop:
    call ReadChar                        ; read one character
    
    ; Check if it's a valid digit
    cmp al, '0'
    jb InvalidChar
    cmp al, '9'
    ja InvalidChar
    
    ; Valid digit - echo asterisk
    push eax
    mov al, '*'
    call WriteChar
    pop eax
    
    ; Convert character to number and add to PIN
    sub al, '0'                          ; convert to digit
    movzx eax, al
    
    ; EBX = EBX * 10 + digit
    push edx
    mov edx, ebx
    imul edx, 10
    add edx, eax
    mov ebx, edx
    pop edx
    
    dec ecx
    jnz ReadDigitLoop
    
    ; Return PIN in EAX
    mov eax, ebx
    jmp ExitReadPIN

InvalidChar:
    ; Ignore invalid characters, don't count them
    jmp ReadDigitLoop

ExitReadPIN:
    pop edi
    pop ecx
    pop ebx
    ret
ReadPINMasked ENDP
;----------------------------MAIN--------------------------------------
main PROC
    mov esi, OFFSET accounts
    
    ;1st account
    mov DWORD PTR [esi+0], 1001      ; accountNumber
    mov DWORD PTR [esi+4], 1234      ; pin
    mov DWORD PTR [esi+8], 5000      ; balance
    mov BYTE PTR [esi+44], 0         ; accountType
    mov BYTE PTR [esi+45], 0         ; cardType
    mov DWORD PTR [esi+48], 0        ; dailyWithdrawn
    mov BYTE PTR [esi+52], 0         ; accountStatus
    
    ;2nd account
    add esi, SIZEOF Account
    mov DWORD PTR [esi+0], 1002
    mov DWORD PTR [esi+4], 5678
    mov DWORD PTR [esi+8], 10000
    mov BYTE PTR [esi+44], 1
    mov BYTE PTR [esi+45], 1
    mov DWORD PTR [esi+48], 0
    mov BYTE PTR [esi+52], 0
    
    ;3rd account
    add esi, SIZEOF Account
    mov DWORD PTR [esi+0], 1003
    mov DWORD PTR [esi+4], 9090
    mov DWORD PTR [esi+8], 15000
    mov BYTE PTR [esi+44], 2
    mov BYTE PTR [esi+45], 2
    mov DWORD PTR [esi+48], 0
    mov BYTE PTR [esi+52], 0
    
    ;4th account
    add esi, SIZEOF Account
    mov DWORD PTR [esi+0], 1004
    mov DWORD PTR [esi+4], 4040
    mov DWORD PTR [esi+8], 20000
    mov BYTE PTR [esi+44], 0
    mov BYTE PTR [esi+45], 1
    mov DWORD PTR [esi+48], 0
    mov BYTE PTR [esi+52], 0

    call welcomeDisplay

    call InsertCard
    cmp eax, 1
    jne ExitProgram
    
    call EnterPinProc
    cmp eax, 1
    jne ExitProgram

MenuLoop: 
    call displayMenu
    mov eax, userChoice
    cmp eax, 1
    je balanceInquiry
    cmp eax, 2
    je cashWithdrawal
    cmp eax, 3
    je cashDeposit
    cmp eax, 4
    je changePin
    cmp eax, 5
    je miniStatement
    cmp eax, 6
    je ExitOption
    
    ; Invalid choice handler
    mov eax, 12
    call SetTextColor
    mov edx, OFFSET invalidChoice
    call WriteString
    mov eax, 2000
    call Delay
    jmp MenuLoop

balanceInquiry:
    call CheckBalance
    call WaitMsg
    call AnotherTransaction
    cmp eax, 1
    je MenuLoop
    jmp ExitOption

cashWithdrawal:
    call WithdrawCash
    call WaitMsg
    call AnotherTransaction
    cmp eax, 1
    je MenuLoop
    jmp ExitOption

cashDeposit:
    call DepositCash
    call WaitMsg
    call AnotherTransaction
    cmp eax, 1
    je MenuLoop
    jmp ExitOption

changePin:
    call pinChange
    call WaitMsg
    call AnotherTransaction
    cmp eax, 1
    je MenuLoop
    jmp ExitOption

miniStatement:
    mov edx, OFFSET processingMsg
    call WriteString
    call WaitMsg
    call AnotherTransaction
    cmp eax, 1
    je MenuLoop
    jmp ExitOption

ExitOption:
    call Clrscr
    mov eax, 11
    call SetTextColor
    mov edx, OFFSET thankYouMsg
    call WriteString
    mov eax, 2000
    call Delay
    jmp ExitProgram

ExitProgram:
    exit
main ENDP
END main
