subroutine as_msdjni(fid,lmname,ind,jname,des,dom,rmname,nstep,ncor,cret)
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
#include "med/msdjni.h"
    character(len=*) :: lmname,jname,des,rmname
    med_idt :: fid
    aster_int :: ind,dom,nstep,ncor,cret

#ifdef _DISABLE_MED
    call u2mess('F', 'FERMETUR_2')
#else

#ifdef _DEBUG_MED
    write(6,*) '=== as_msdjni fid=',fid
    write(6,*) '=== as_msdjni lmname=',lmname
    write(6,*) '=== as_msdjni ind=',ind
#endif

#if med_int_kind != aster_int_kind || med_idt_kind != aster_int_kind
    med_idt :: fid4
    med_int :: ind4,dom4,nstep4,ncor4,cret4
    fid4=to_med_idt(fid)
    ind4=to_med_int(ind)
    call msdjni(fid4,lmname,ind4,jname,des,dom4,rmname,nstep4,ncor4,cret4)
    dom=to_aster_int(dom4)
    nstep=to_aster_int(nstep4)
    ncor =to_aster_int(ncor4)
    cret =to_aster_int(cret4)
#else
    call msdjni(fid,lmname,ind,jname,des,dom,rmname,nstep,ncor,cret)
#endif

#ifdef _DEBUG_MED
    write(6,*) '=== as_msdjni jname=',jname
    write(6,*) '=== as_msdjni rmname=',rmname
    write(6,*) '=== as_msdjni des=',des
    write(6,*) '=== as_msdjni dom=',dom
    write(6,*) '=== as_msdjni nstep=',nstep
    write(6,*) '=== as_msdjni ncor=',ncor
    write(6,*) '=== as_msdjni cret=',cret
#endif

#endif
end subroutine
