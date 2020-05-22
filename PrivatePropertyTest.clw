
  PROGRAM

  INCLUDE('JSPrivateClass.inc'),ONCE
  INCLUDE('ABPOPUP.INC'),ONCE  !There are private properties in the PopupClass, for use in this demo
  INCLUDE('ABUtil.inc'),ONCE
  INCLUDE('RTFCtl.inc'),ONCE

OMIT('***')
MIT License

Copyright (c) 2019 Jeff Slarve

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 ***

JSP         JSPrivateClass
LocalPopup  CLASS(PopupClass)
            end
MyPopup     LocalPopup
QueueRef    &QUEUE
MyThread    ANY

RTF                 RTFControlClass


Window WINDOW('Private Property Access Test'),AT(,,377,217),CENTER,GRAY, |
            FONT('Microsoft Sans Serif',8)
        PROMPT('A listbox utilizing a PRIVATE queue from the PopupClass'), |
                AT(6,5,182,12),USE(?PROMPT1)
        LIST,AT(4,17,369,71),USE(?PrivateQueueList),VSCROLL,FORMAT('66L(2)|M~Nam' & |
                'e~C(2)@s60@#9#48L(2)|M~Text~C(2)@s60@')
        PROMPT('An enumeration of the RTFControlClass properties'),AT(6,93), |
                USE(?PROMPT2)
        LIST,AT(4,104,369,94),USE(?EnumItemsList),VSCROLL,FORMAT('138L(2)|M~Labe' & |
                'l~C(0)@s60@54L(2)|M~Data Type~C(0)@s60@38R(2)|M~Size~C(0)@n20@4' & |
                '8R(2)|M~Address~C(0)@n20@25C(2)|M~NULL~C(0)@n1@20C(2)|M~Referen' & |
                'ce~C(0)@n1@')
        BUTTON('&Close'),AT(331,201,42,14),USE(?CloseButton),STD(STD:Close)
    END

  MAP
  END

  CODE

  OPEN(Window)

  MyPopup.Init()
  MyPopup.AddItem('Menu Item 1','Cowabunga') !Adding some random popup items
  MyPopup.AddItem('Menu Item 2')
  MyPopup.AddItem('Menu Item 3')
  MyPopup.AddItem('Menu Item 4')

!NOTE:
!IMPORTANT: In the following code, notice that it's using MyPopup, which is a declaration of LocalPopup.
!A locally defined class (LocalPopup) cannot be passed as a *GROUP, but re-declaring the class as MyPopup DOES work.
!Keep that in mind if your code won't compile.
  QueueRef  &=  JSP.GetFieldAddress(MyPopup,'PopupItems') !Setting a local Queue Reference to the PRIVATE PopupItems Queue in the PopupClass
  MyThread  &=  JSP.GetSimpleFieldRef(MyPopup,'MyThread') !Setting a local reference to the PRIVATE MyThread property in the PopupClass

  ?EnumItemsList{PROP:From}  =  JSP.EnumQ !Setting the FROM of the listbox to the EnumQ of the JSPrivateClass.
  JSP.EnumMembers(RTF)                    !Enumerating the class properties (including PRIVATE) and filling the EnumQ.

  IF QueueRef &= NULL                     !Make sure we have a good reference before trying to use it.
    Message('PopupItems Class member not found')
  ELSE
    ?PrivateQueueList{PROP:From} = QueueRef !Setting the FROM of the listbox to a PRIVATE queue
    ACCEPT
    END
  END
  MyPopup.Kill
  CLOSE(Window)
