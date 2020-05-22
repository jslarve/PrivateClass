  MEMBER

!2020.05.21 Added equates for data types, and modified code to use them.

!MIT License
!
!Copyright (c) 2019 Jeff Slarve
!
!Permission is hereby granted, free of charge, to any person obtaining a copy
!of this software and associated documentation files (the "Software"), to deal
!in the Software without restriction, including without limitation the rights
!to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
!copies of the Software, and to permit persons to whom the Software is
!furnished to do so, subject to the following conditions:
!
!The above copyright notice and this permission notice shall be included in all
!copies or substantial portions of the Software.
!
!THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
!IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
!FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
!AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
!LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
!OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
!SOFTWARE.

  INCLUDE('JSPrivateClass.inc'),ONCE
  INCLUDE('TUFO.inc'),ONCE !(Found on the internet)

  MAP
  END

JSPrivateClass.Construct  PROCEDURE

  CODE

  SELF.MaxLoop = 250 
  SELF.EnumQ &= NEW JSPC_MemberEnumQ

JSPrivateClass.Destruct  PROCEDURE

  CODE

  DISPOSE(SELF.EnumQ)

JSPrivateClass.EnumMembers  PROCEDURE(*GROUP pClass)
Ndx LONG,AUTO

   CODE

  FREE(SELF.EnumQ)
  LOOP Ndx = 1 to SELF.MaxLoop
    IF NOT SELF.GetAnyDataType(WHAT(pClass,Ndx)) 
      BREAK
    END
    CLEAR(SELF.EnumQ)
    SELF.EnumQ.Label         =  WHO(pClass,Ndx)
    SELF.EnumQ.Address       =  SELF.GetFieldAddress(pClass,Ndx)
    SELF.EnumQ.DataType      =  SELF.GetAnyDataType(WHAT(pClass,Ndx))
    SELF.EnumQ.Size          =  SELF.GetAnyDataSize(WHAT(pClass,Ndx))
    IF SELF.EnumQ.DataType =  JSP:DataType:Reference
      SELF.EnumQ.IsReference =  TRUE
      IF NOT SELF.EnumQ.Address
        SELF.EnumQ.IsNull = TRUE
      END
    END
    SELF.EnumQ.DataTypeDisplay = SELF.GetDataTypeName(SELF.EnumQ.DataType) & CHOOSE(NOT InList(SELF.EnumQ.DataType,DataType:CSTRING,DataType:STRING,DataType:PSTRING,DataType:DECIMAL,DataType:PDECIMAL),'', '(' & SELF.EnumQ.Size & ')') 
    ADD(SELF.EnumQ)
  END

JSPrivateClass.GetAnyDataAddress  PROCEDURE(*? pWhat)!,LONG
UFO &iUfo

   CODE

  UFO &= ADDRESS(pWhat)
  IF UFO &= NULL
    RETURN 0
  END
  RETURN UFO._Address(Address(pWhat))

JSPrivateClass.GetAnyDataSize  PROCEDURE(*? pWhat)!,LONG
UFO &iUfo

   CODE

  UFO &= ADDRESS(pWhat)
  IF UFO &= NULL
    RETURN 0
  END
  RETURN UFO._Size(Address(pWhat))

JSPrivateClass.GetAnyDataType  PROCEDURE(*? pWhat)!,LONG
UFO &iUfo

   CODE

  UFO &= ADDRESS(pWhat)
  IF UFO &= NULL
    RETURN 0
  END
  RETURN UFO._Type(Address(pWhat))

JSPrivateClass.GetDataTypeName          PROCEDURE(LONG pDataType)!,STRING    
ReturnVal CSTRING(20)

  CODE

  ReturnVal = '(unknown ' & pDataType & ')'
    CASE pDataType
    OF DataType:ENDGROUP
        ReturnVal = 'ENDGROUP'
    OF DataType:BYTE
        ReturnVal = 'BYTE'
    OF DataType:SHORT
        ReturnVal = 'SHORT'
    OF DataType:USHORT
        ReturnVal = 'USHORT'
    OF DataType:DATE
        ReturnVal = 'DATE'
    OF DataType:TIME
        ReturnVal = 'TIME'
    OF DataType:LONG
        ReturnVal = 'LONG'
    OF DataType:ULONG
        ReturnVal = 'ULONG'
    OF DataType:SREAL
        ReturnVal = 'SREAL'
    OF DataType:REAL
        ReturnVal = 'REAL'
    OF DataType:DECIMAL
        ReturnVal = 'DECIMAL'
    OF DataType:PDECIMAL
        ReturnVal = 'PDECIMAL'
    OF DataType:BFLOAT4
        ReturnVal = 'BFLOAT4'
    OF DataType:BFLOAT8
        ReturnVal = 'BFLOAT8'
    OF DataType:STRING
        ReturnVal = 'STRING'
    OF DataType:CSTRING
        ReturnVal = 'CSTRING'
    OF DataType:PSTRING
        ReturnVal = 'PSTRING'
    OF DataType:MEMO
        ReturnVal = 'MEMO'
    OF DataType:GROUP
        ReturnVal = 'GROUP'
    OF DataType:CLASS
        ReturnVal = 'CLASS'
    OF DataType:QUEUE
        ReturnVal = 'QUEUE'
    OF DataType:BLOB
        ReturnVal = 'BLOB'
    OF JSP:DataType:REFERENCE 
        ReturnVal = 'REFERENCE'
    OF JSP:DataType:BSTRING   
        ReturnVal = 'BSTRING' !From Carl Barnes
    OF JSP:DataType:ASTRING   
        ReturnVal = 'ASTRING' !From Carl Barnes
    OF JSP:DataType:VARIANT   
        ReturnVal = 'VARIANT' !From Carl Barnes
    END
    RETURN ReturnVal

JSPrivateClass.GetFieldAddress PROCEDURE(*GROUP pClass,STRING pLabel)!,LONG
Ndx       LONG,AUTO      !a counter
WhichWhat LONG,AUTO      !which field to get a WHAT() from
S         STRING(4),AUTO !For casting the 4-character value of WHAT over ReturnVal
ReturnVal LONG,OVER(S)   !to a LONG

   CODE

 ReturnVal = 0
 WhichWhat = 0
 IF NUMERIC(pLabel)                     !Assumed to be a field number instead of a label, so we'll just use that                                  
   WhichWhat = INT(pLabel)
 ELSE
   LOOP Ndx = 1 to SELF.MaxLoop 
     IF UPPER(pLabel) = UPPER(WHO(pClass,Ndx)) !Looking for a match of the label
       WhichWhat = Ndx
       BREAK
     END
   END
 END
 IF WhichWhat
   IF SELF.IsReference(pClass,WhichWhat) !A Reference type
     S = WHAT(pCLass,WhichWhat) !For references, WHAT returns a 4 byte string, representing a 32 bit address
     !NOTE: ReturnVal is being implicitly set because it is OVER(S) in the above declaration.
   ELSE
     ReturnVal = SELF.GetAnyDataAddress(WHAT(pClass,WhichWhat)) !Gets the address of the actual variable referenced by the WHAT()
   END
 END
 RETURN ReturnVal

JSPrivateClass.GetSimpleFieldRef PROCEDURE(*GROUP pClass,STRING pLabel)!,*?
Ndx        LONG,AUTO
WhichWhat  LONG,AUTO
NullDummy &LONG
 
  CODE

 WhichWhat  = 0
 NullDummy &= NULL
 IF NUMERIC(pLabel) !Passed a field number instead of a label
   WhichWhat = INT(pLabel)
 ELSE
   LOOP Ndx = 1 to SELF.MaxLoop 
     IF UPPER(pLabel) = UPPER(WHO(pClass,Ndx))
        WhichWhat = Ndx
        BREAK
     END
   END
 END
 IF WhichWhat
   IF NOT SELF.IsReference(pClass,WhichWhat) !Not a Reference type
     RETURN WHAT(pCLass,WhichWhat)
   END
 END
 RETURN NullDummy

JSPrivateClass.IsReference PROCEDURE(*GROUP pClass,LONG pElement)!,LONG  !Is this a reference?
ReturnVal LONG,AUTO

  CODE

  RETURN CHOOSE(SELF.GetAnyDataType(WHAT(pClass,pElement)) = JSP:DataType:REFERENCE)
