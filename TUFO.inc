!From Mike Duglas on C.L.C. 2010-06-18 - in "Type of variable" thread. The interface was originally posted by Oleg Rudenko?

  COMPILE('***',_C70_)
iUFO                 INTERFACE,TYPE
_Type                  PROCEDURE(LONG _UfoAddr),LONG       !+00h Type of UFO
ToMem                  PROCEDURE                           !+04h
FromMem                PROCEDURE                           !+08h
OldFromMem             PROCEDURE                           !+0Ch
Pop                    PROCEDURE(LONG _UfoAddr)            !+10h Get a value from string stack
Push                   PROCEDURE(LONG _UfoAddr)            !+14h Put a vaule to string stack
DPop                   PROCEDURE(LONG _UfoAddr)            !+18h Get a value from DECIMAL stack
DPush                  PROCEDURE(LONG _UfoAddr)            !+1Ch Put a vaule to DECIMAL stack
_Real                  PROCEDURE(LONG _UfoAddr),REAL       !+20h Get a value as REAL
_Long                  PROCEDURE(LONG _UfoAddr),LONG       !+24h Get a value as LONG
_Free                  PROCEDURE(LONG _UfoAddr)            !+28h Disposes memory and frees a reference (sets it to NULL)
_Clear                 PROCEDURE                           !+2Ch Clears a variable
_Address               PROCEDURE(LONG _UfoAddr),LONG       !+30h Returns an address of a variable
AssignLong             PROCEDURE                           !+34h Assign LONG value
AssignReal             PROCEDURE                           !+38h Assign REAL value                               
AssignUFO              PROCEDURE                           !+3Ch Assign a value to another UFO object.           
AClone                 PROCEDURE(LONG _UfoAddr),LONG       !+40h Returns a clone of this UFO object.             
Select                 PROCEDURE                           !+44h For arrays and strings, _Var [Ptr] is equivalent
Slice                  PROCEDURE                           !+48h For strings, equivalent to _Var [Ptr1: Ptr2]    
Designate              PROCEDURE                           !+4Ch Returns group field as UFO object
_Max                   PROCEDURE(LONG _UfoAddr),LONG       !+50h Number of elements in first dimension of an array
_Size                  PROCEDURE(LONG _UfoAddr),LONG       !+54h Size of an object
BaseType               PROCEDURE(LONG _UfoAddr),LONG       !+58h
DistinctUpper          PROCEDURE                           !+5Ch
DistinctsUFO           PROCEDURE                           !+60h
DistinctsLong          PROCEDURE                           !+64h
Cleared                PROCEDURE(LONG _UfoAddr)            !+68h Destroyed?
IsNull                 PROCEDURE(LONG _UfoAddr),LONG       !+6Ch was an object disposed?
OEM2ANSI               PROCEDURE(LONG _UfoAddr)            !+70h
ANSI2OEM               PROCEDURE(LONG _UfoAddr)            !+74h
_Bind                  PROCEDURE(LONG _UfoAddr)            !+78h bind all fields of a group
_Add                   PROCEDURE                           !+7Ch
Divide                 PROCEDURE                           !+80h
Hash                   PROCEDURE(LONG _UfoAddr),LONG       !+84h Calc CRC
SetAddress             PROCEDURE                           !+88h sets the address of a variable
Match                  PROCEDURE                           !+8Ch compares the type and the size of a field with a field of ClassDesc structure
Identical              PROCEDURE                           !+90h
Store                  PROCEDURE                           !+94h Writes the value of an object into the memory address
                     END
  ***
