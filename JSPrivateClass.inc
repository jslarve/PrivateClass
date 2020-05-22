!ABCIncludeFile

!2020.05.21 Added equates for data types, and modified code to use them.

 OMIT('_EndOfInclude_',_JSPrivateClassPresent_)
_JSPrivateClassPresent_ EQUATE(1)

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

JSPC_MemberEnumQ       QUEUE,TYPE
Label                    STRING(60)
DataTypeDisplay          STRING(60)
Size                     LONG
Address                  LONG
IsNull                   BYTE
IsReference              BYTE
DataType                 BYTE
                       END

!Data Type Equates from Jeff Slarve and from Carl Barnes 2020.05.21
JSP:DataType:REFERENCE EQUATE(31)            ! 1Fh !From XMLType.inc (and Jeff Slarve<g>)
JSP:DataType:BSTRING   EQUATE(42)            ! 2Ah !From Carl Barnes
JSP:DataType:ASTRING   EQUATE(43)            ! 2Bh !From Carl Barnes
JSP:DataType:VARIANT   EQUATE(45)            ! 2Dh !From Carl Barnes

JSPrivateClass         CLASS,TYPE,MODULE('JSPrivateClass.clw'),LINK('JSPrivateClass.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
EnumQ                    &JSPC_MemberEnumQ
MaxLoop                  LONG                                         !Maximum number of fields to interrogate (defaults to 250)
Construct                PROCEDURE                                    !Constructor
Destruct                 PROCEDURE                                    !Destructor
EnumMembers              PROCEDURE(*GROUP pClass)                     !Fill enum queue with info about class members
GetAnyDataAddress        PROCEDURE(*? pWhat),LONG                     !Get the actual address of an ANY reference or of return value of WHAT()
GetAnyDataSize           PROCEDURE(*? pWhat),LONG                     !Get the data size referenced by an ANY
GetAnyDataType           PROCEDURE(*? pWhat),LONG                     !Get the data type referenced by an ANY
GetDataTypeName          PROCEDURE(LONG pDataType),STRING             !Get the name of a Clarion Data Type
GetSimpleFieldRef        PROCEDURE(*GROUP pClass,STRING pLabel),*?    !Assign simple non-reference data type to an ANY
GetFieldAddress          PROCEDURE(*GROUP pClass,STRING pLabel),LONG  !Get the address of any field in a class, including actual address of referenced objects
IsReference              PROCEDURE(*GROUP pClass,LONG pElement),LONG  !Is this a reference?
                       END

_EndOfInclude_
