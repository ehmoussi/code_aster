subroutine as_msdnjn(fid,maa,n,cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
! COPYRIGHT (C) 1991 - 2019  EDF R&D                WWW.CODE-ASTER.ORG
!
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
! 1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
!
    implicit none
#include "asterf_config.h"
#include "asterf_types.h"
#include "med/msdnjn.h"
    character(len=*) :: maa
    aster_int :: fid, n, cret

#ifdef _DISABLE_MED
    call u2mess('F', 'FERMETUR_2')
#else

#ifdef _DEBUG_MED
    write(6,*) '=== as_msdnjn fid=',fid
    write(6,*) '=== as_msdnjn maa=',maa
#endif

#if med_int_kind != aster_int_kind || med_idt_kind != aster_int_kind
    med_idt :: fid4
    med_int :: n4, cret4
    fid4=to_med_idt(fid)
    call msdnjn(fid4,maa,n4,cret4)
    n=to_aster_int(n4)
    cret=to_aster_int(cret4)
#else
    call msdnjn(fid,maa,n,cret)
#endif

#ifdef _DEBUG_MED
    write(6,*) '=== as_msdnjn n4=',n4
    write(6,*) '=== as_msdnjn cret4=',cret4
#endif

#endif
end subroutine
