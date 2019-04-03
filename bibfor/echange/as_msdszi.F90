subroutine as_msdszi(fid,mname,jname,numdt,numit,it,letype,lgtype,&
                     retype,rgtype,ncor,cret)
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
#include "med/msdszi.h"
    character(len=*) :: mname,jname
    aster_int :: fid,numdt,numit,it,letype,lgtype,retype,rgtype,ncor,cret

#ifdef _DISABLE_MED
    call u2mess('F', 'FERMETUR_2')
#else

#ifdef _DEBUG_MED
    write(6,*) '=== as_msdszi fid=',fid
    write(6,*) '=== as_msdszi mname=',mname
    write(6,*) '=== as_msdszi jname=',jname
    write(6,*) '=== as_msdszi numdt=',numdt
    write(6,*) '=== as_msdszi numit=',numit
    write(6,*) '=== as_msdszi it=',it
#endif

#if med_int_kind != aster_int_kind || med_idt_kind != aster_int_kind
    med_idt :: fid4
    med_int :: numdt4,numit4,it4,letype4,lgtype4,&
               retype4,rgtype4,ncor4,cret4
    fid4=to_med_idt(fid)
    numdt4=to_med_int(numdt)
    numit4=to_med_int(numit)
    it4=to_med_int(it)

    call msdszi(fid4,mname,jname,numdt4,numit4,it4,letype4,&
                lgtype4,retype4,rgtype4,ncor4,cret4)

    letype=to_aster_int(letype4)
    lgtype=to_aster_int(lgtype4)
    retype=to_aster_int(retype4)
    ncor=to_aster_int(ncor4)
    cret=to_aster_int(cret4)

#else
    call msdszi(fid,mname,jname,numdt,numit,it,letype,lgtype,&
                retype,rgtype,ncor,cret)
#endif

#ifdef _DEBUG_MED
    write(6,*) '=== as_msdszi letype=',letype
    write(6,*) '=== as_msdszi lgtype=',lgtype
    write(6,*) '=== as_msdszi retype=',retype
    write(6,*) '=== as_msdszi ncor=',ncor
    write(6,*) '=== as_msdszi cret=',cret
#endif

#endif
end subroutine
